import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/permissions/user_location.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_export_dialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/gpx_kml_import.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/persistence/mapview_persistence_adapter.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/mappoint_editor.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/mappolyline_editor.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:prefs/prefs.dart';

enum _LayerType { OPENSTREETMAP_MAPNIK, MAPBOX_SATELLITE }

const _OSM_TEXT = 'coords_mapview_osm';
const _OSM_URL = 'coords_mapview_osm_url';
const _MAPBOX_SATELLITE_TEXT = 'coords_mapview_mapbox_satellite';
const _MAPBOX_SATELLITE_URL = 'coords_mapview_mapbox_satellite_url';

final _DEFAULT_BOUNDS = LatLngBounds(LatLng(51.5, 12.9), LatLng(53.5, 13.9));
const _POLYGON_STROKEWIDTH = 3.0;
const _BUTTONGROUP_MARGIN = 30.0;

class GCWMapView extends StatefulWidget {
  List<GCWMapPoint> points;
  late List<GCWMapPolyline> polylines;
  final bool isEditable;

  GCWMapView({Key? key, required this.points, List<GCWMapPolyline>? polylines, this.isEditable = false})
      : super(key: key) {
    this.polylines = polylines ?? [];
  }

  @override
  _GCWMapViewState createState() => _GCWMapViewState();
}

class _GCWMapViewState extends State<GCWMapView> {
  final MapController _mapController = MapController();
  final _GCWMapPopupController _popupLayerController = _GCWMapPopupController();

  _LayerType _currentLayer = _LayerType.OPENSTREETMAP_MAPNIK;
  String? _mapBoxToken;

  bool? _currentLocationPermissionGranted;
  StreamSubscription<LocationData>? _locationSubscription;
  final Location _location = Location();
  LatLng? _currentPosition;
  double? _currentAccuracy;
  bool _manuallyToggledPosition = false;

  var _isPolylineDrawing = false;
  var _isPointsHidden = false;

  MapViewPersistenceAdapter? _persistanceAdapter;

  late Length defaultLengthUnitGCWMapView;

  LatLngBounds _getBounds() {
    if (widget.points.isEmpty) return _DEFAULT_BOUNDS;

    var _bounds = LatLngBounds(widget.points.first.point, widget.points.first.point);
    for (var point in widget.points.skip(1)) {
      _bounds.extend(point.point);
    }

    return _bounds;
  }

  Future<String> _loadToken(String tokenName) async {
    return await rootBundle.loadString('assets/tokens/$tokenName');
  }

  @override
  void initState() {
    super.initState();
    _popupLayerController.mapController = _mapController;

    if (widget.isEditable) _persistanceAdapter = MapViewPersistenceAdapter(widget);

    defaultLengthUnitGCWMapView = defaultLengthUnit;
  }

  @override
  void dispose() {
    _cancelLocationSubscription();

    super.dispose();
  }

  void _cancelLocationSubscription() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
      _locationSubscription = null;
      _currentPosition = null;
    }
  }

  void _toggleLocationListening() {
    if (_currentLocationPermissionGranted == false) return;

    if (_locationSubscription == null) {
      _locationSubscription = _location.onLocationChanged.handleError((error) {
        _cancelLocationSubscription();
      }).listen((LocationData currentLocation) {
        setState(() {
          LatLng? newPosition;
          if (currentLocation.latitude != null && currentLocation.longitude != null) {
            newPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          }

          if (_currentPosition == null && (_manuallyToggledPosition || widget.points.isEmpty)) {
            _mapController.move(newPosition!, _mapController.zoom);
          }
          _manuallyToggledPosition = false;

          _currentPosition = newPosition;
          _currentAccuracy = currentLocation.accuracy;
        });
      });

      _locationSubscription!.pause();
    }

    setState(() {
      if (_locationSubscription!.isPaused) {
        _locationSubscription!.resume();
      } else {
        _locationSubscription!.pause();
        _currentPosition = null;
      }
    });
  }

  String _formatLengthOutput(double length) {
    return NumberFormat('0.00').format(defaultLengthUnitGCWMapView.fromMeter(length)) +
        ' ' +
        defaultLengthUnitGCWMapView.symbol;
  }

  String _formatBearingOutput(double bearing) {
    return NumberFormat('0.00').format(bearing) + ' °';
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocationPermissionGranted == null) {
      checkLocationPermission(_location).then((value) {
        _currentLocationPermissionGranted = value;
        _toggleLocationListening();
      });
    }

    var tileLayer = _currentLayer == _LayerType.MAPBOX_SATELLITE && _mapBoxToken != null && _mapBoxToken!.isNotEmpty
        ? TileLayer(
            urlTemplate: 'https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}@2x.jpg90?access_token={accessToken}',
            additionalOptions: {'accessToken': _mapBoxToken!},
            tileProvider: CachedNetworkTileProvider())
        : TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            tileProvider: CachedNetworkTileProvider());

    var layers = <Widget>[tileLayer];
    layers.addAll(_buildLinesAndMarkersLayers());

    return Listener(
        onPointerSignal: handleSignal,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                  absorbPanEventsOnScrollables: false,

                  /// IMPORTANT for dragging
                  bounds: _getBounds(),
                  boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(30.0)),
                  minZoom: 1.0,
                  maxZoom: 18.0,
                  interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate, // suppress rotation
                  onTap: (_, __) => _popupLayerController.hidePopup(),
                  onLongPress: widget.isEditable && !_isPointsHidden // == _persistanceAdapter is set
                      ? (_, LatLng coordinate) {
                          setState(() {
                            if (_persistanceAdapter != null) {
                              var newPoint = _persistanceAdapter!.addMapPoint(coordinate);

                              if (_isPolylineDrawing) {
                                if (widget.polylines.isEmpty) _persistanceAdapter!.createMapPolyline();

                                _persistanceAdapter!.addMapPointIntoPolyline(newPoint, widget.polylines.last);
                              }
                            }
                          });
                        }
                      : null),
              children: layers,
            ),
            Positioned(top: 15.0, right: 15.0, child: Column(children: _buildLayerButtons())),
            widget.isEditable
                ? Positioned(top: 15.0, left: 15.0, child: Column(children: _buildEditButtons()))
                : Container(),
            Positioned(
              bottom: 5.0,
              left: 5.0,
              child: InkWell(
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                      color: COLOR_MAP_LICENSETEXT_BACKGROUND,
                      child: Text(
                          i18n(context,
                              _currentLayer == _LayerType.OPENSTREETMAP_MAPNIK ? _OSM_TEXT : _MAPBOX_SATELLITE_TEXT),
                          style: TextStyle(
                              color: COLOR_MAP_LICENSETEXT,
                              fontSize: fontSizeSmall(),
                              decoration: TextDecoration.underline))),
                ),
                onTap: () {
                  launchUrl(Uri.parse(i18n(
                      context, _currentLayer == _LayerType.OPENSTREETMAP_MAPNIK ? _OSM_URL : _MAPBOX_SATELLITE_URL)));
                },
              ),
            )
          ],
        ));
  }

  List<Widget> _buildLinesAndMarkersLayers() {
    var layers = <Widget>[];

    // build accuracy circle for user position
    if (_locationSubscription != null &&
        !_locationSubscription!.isPaused &&
        _currentAccuracy != null &&
        _currentPosition != null) {
      var filled = Prefs.getBool(PREFERENCE_MAPVIEW_CIRCLE_COLORFILLED);
      var circleColor = COLOR_MAP_USERPOSITION.withOpacity(filled ? 0.3 : 0.0);

      layers.add(CircleLayer(circles: [
        CircleMarker(
          point: _currentPosition!,
          borderStrokeWidth: 1,
          useRadiusInMeter: true,
          radius: _currentAccuracy!,
          color: circleColor,
          borderColor: COLOR_MAP_USERPOSITION,
        )
      ]));
    }

    List<Marker> _markers = _buildMarkers();

    List<Polyline> _polylines = _addPolylines();
    List<Polyline> _circlePolylines = _addCircles();
    _polylines.addAll(_circlePolylines);

    layers.addAll([
      TappablePolylineLayer(
        polylineCulling: true,
        polylines: _polylines as List<TaggedPolyline>,
        onTap: (polylines, details) {
          if (polylines.isEmpty) {
            return;
          }

          _showPolylineDialog(polylines.first as _GCWTappablePolyline);
        },
      ),
      PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
        markers: _markers,
        popupSnap: PopupSnap.markerTop,
        popupController: _popupLayerController.popupController,
        popupBuilder: (BuildContext _, Marker marker) => _buildPopup(marker),
        markerCenterAnimation: const MarkerCenterAnimation(duration: Duration.zero)
      )),
    ]);

    return layers;
  }

  void _showPolylineDialog(_GCWTappablePolyline polyline) {
    List<Widget> output = [];

    var child = polyline.child;
    if (child is GCWMapLine) {
      var data = <DoubleText>[
        DoubleText(
            i18n(context, 'unitconverter_category_length') + ': ${_formatLengthOutput(child.length)}', child.length),
        DoubleText(
            i18n(context, 'unitconverter_category_length') + ': ${_formatLengthOutput(child.length)}', child.length),
        DoubleText(
            i18n(context, 'coords_map_view_linedialog_section_bearing_ab') +
                ': ${_formatBearingOutput(child.bearingAB)}',
            child.bearingAB),
        DoubleText(
            i18n(context, 'coords_map_view_linedialog_section_bearing_ba') +
                ': ${_formatBearingOutput(child.bearingBA)}',
            child.bearingBA)
      ];

      if (child.parent.lines.length > 1) {
        data.add(DoubleText(
            i18n(context, 'unitconverter_category_length') + ': ${_formatLengthOutput(child.parent.length)}',
            child.parent.length));
      }

      List<Widget> children = data
          .map<Widget>((elem) => GCWOutputText(
                text: elem.text,
                copyText: elem.value.toString(),
                style: gcwDialogTextStyle(),
              ))
          .toList();

      if (child.parent.lines.length > 1) {
        children.insert(
            0,
            GCWTextDivider(
              text: i18n(context, 'coords_map_view_linedialog_section'),
              style: gcwDialogTextStyle(),
              suppressTopSpace: true,
            ));

        children.insert(
            4,
            GCWTextDivider(
              text: i18n(context, 'coords_map_view_linedialog_path'),
              style: gcwDialogTextStyle(),
            ));
      }

      output = children;
    } else if (child is GCWMapCircle) {
      output = [
        GCWOutputText(
          text: i18n(context, 'common_radius') + ': ${_formatLengthOutput(child.radius)}',
          style: gcwDialogTextStyle(),
          copyText: child.radius.toString(),
        )
      ];
    }

    var dialogButtons = <Widget>[];
    if (widget.isEditable) {
      dialogButtons.addAll([
        GCWIconButton(
            icon: Icons.edit,
            iconColor: themeColors().dialogText(),
            onPressed: () {
              if (child is GCWMapLine) {
                Navigator.push(
                    context,
                    NoAnimationMaterialPageRoute<GCWTool>(
                        builder: (context) => GCWTool(
                            tool: MapPolylineEditor(polyline: child.parent),
                            id: 'coords_openmap_lineeditor'))).whenComplete(() {
                  setState(() {
                    Navigator.pop(context);
                    if (_persistanceAdapter != null) {
                      _persistanceAdapter!.updateMapPolyline(child.parent);
                    }
                  });
                });
              } else if (child is GCWMapCircle) {
                var mapPoint = widget.points.firstWhere((element) => element.circle == child);
                Navigator.push(
                    context,
                    NoAnimationMaterialPageRoute<GCWTool>(
                        builder: (context) => GCWTool(
                            tool: MapPointEditor(mapPoint: mapPoint, lengthUnit: defaultLengthUnitGCWMapView),
                            id: 'coords_openmap_lineeditor'))).whenComplete(() {
                  setState(() {
                    if (_persistanceAdapter != null) {
                      _persistanceAdapter!.updateMapPoint(mapPoint);
                    }
                    _mapController.move(mapPoint.point, _mapController.zoom);
                  });
                });
              }
            }),
        GCWIconButton(
            icon: Icons.delete,
            iconColor: themeColors().dialogText(),
            onPressed: () {
              Navigator.pop(context);

              if (child is GCWMapLine) {
                showGCWDialog(
                    context,
                    i18n(context, 'coords_openmap_lineremove_dialog_title'),
                    SizedBox(
                      width: 250,
                      height: 100,
                      child: GCWText(
                          text: i18n(context, 'coords_openmap_lineremove_dialog_text'), style: gcwDialogTextStyle()),
                    ),
                    [
                      GCWDialogButton(
                          text: i18n(context, 'coords_openmap_lineremove_dialog_keeppoints'),
                          onPressed: () {
                            setState(() {
                              if (_persistanceAdapter != null) {
                                _persistanceAdapter!.removeMapPolyline(child.parent);
                              }
                            });
                          }),
                      GCWDialogButton(
                          text: i18n(context, 'coords_openmap_lineremove_dialog_removepoints'),
                          onPressed: () {
                            setState(() {
                              if (_persistanceAdapter != null) {
                                _persistanceAdapter!.removeMapPolyline(child.parent, removePoints: true);
                              }
                            });
                          }),
                    ]);
              } else if (child is GCWMapCircle) {
                setState(() {
                  var mapPoint = widget.points.firstWhere((element) => element.circle == child);
                  mapPoint.circle = null;
                  if (_persistanceAdapter != null) {
                    _persistanceAdapter!.updateMapPoint(mapPoint);
                  }
                });
              }
            }),
      ]);
    }

    showGCWDialog(
        context,
        '',
        SizedBox(
          width: 250,
          height: output.length * 50.0,
          child: Column(
            children: output,
          ),
        ),
        dialogButtons,
        closeOnOutsideTouch: true);
  }

  bool _isOwnPosition(GCWMapPoint point) {
    return point is _GCWOwnLocationMapPoint;
  }

  List<_GCWMarker> _buildMarkers() {
    if (_isPointsHidden) {
      return <_GCWMarker>[];
    }

    var points = List<GCWMapPoint>.from(widget.points.where((point) => point.isVisible));

    // Add User Position
    if (_locationSubscription != null && !_locationSubscription!.isPaused && _currentPosition != null) {
      points.add(_GCWOwnLocationMapPoint(point: _currentPosition!, context: context));
    }

    return points.map((_point) {
      var icon = Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.my_location,
            size: 28.3,
            color: COLOR_MAP_POINT_OUTLINE,
          ),
          Icon(
            Icons.my_location,
            size: 25.0,
            color: _point.color,
          )
        ],
      );

      var marker = _point.isEditable ? _createDragableIcon(_point, icon) : icon;

      return _GCWMarker(
          coordinateDescription: _buildPopupCoordinateDescription(_point),
          coordinateText: _buildPopupCoordinateText(_point),
          width: 28.3,
          height: 28.3,
          mapPoint: _point,
          builder: (context) => marker);
    }).toList();
  }

  Widget _createDragableIcon(GCWMapPoint point, Widget icon) {
    return GestureDetector(
      onPanUpdate: (details) {
        _popupLayerController.hidePopup();

        CustomPoint position = const Epsg3857().latLngToPoint(point.point, _mapController.zoom);
        Offset delta = details.delta;
        LatLng pointToLatLng =
            const Epsg3857().pointToLatLng(position + CustomPoint(delta.dx, delta.dy), _mapController.zoom)!;

        point.point = pointToLatLng;

        setState(() {
          if (_persistanceAdapter != null) {
            _persistanceAdapter!.updateMapPoint(point);
          }
        });
      },
      child: icon,
    );
  }

  Widget _createIconButtonIcons(IconData iconData, {IconData? stacked, Color? color}) {
    var icon = Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          iconData,
          size: 30.0,
          color: COLOR_MAP_POINT_OUTLINE,
        ),
        Icon(
          iconData,
          size: 25.0,
          color: color ?? COLOR_MAP_POINT,
        )
      ],
    );

    if (stacked == null) return icon;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        icon,
        Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.circle,
              size: 17.0,
              color: COLOR_MAP_POINT_OUTLINE,
            ),
            Icon(
              stacked,
              size: 14.0,
              color: COLOR_MAP_POINT,
            )
          ],
        ),
      ],
    );
  }

  List<Widget> _buildEditButtons() {
    var buttons = [
      GCWIconButton(
        backgroundColor: COLOR_MAP_ICONBUTTONS,
        customIcon: _createIconButtonIcons(Icons.my_location, stacked: Icons.add),
        onPressed: () {
          if (_isPointsHidden) {
            return;
          }

          setState(() {
            if (_persistanceAdapter != null) {
              _persistanceAdapter!.addMapPoint(_mapController.center);
            }
          });
        },
      ),
      GCWIconButton(
        backgroundColor: _isPolylineDrawing ? COLOR_MAP_ACTIVATED_ICONBUTTON : COLOR_MAP_ICONBUTTONS,
        customIcon: _isPolylineDrawing
            ? _createIconButtonIcons(Icons.timeline, stacked: Icons.priority_high)
            : _createIconButtonIcons(Icons.timeline, stacked: Icons.add),
        onPressed: () {
          setState(() {
            if (_isPolylineDrawing) {
              _isPolylineDrawing = false;
            } else {
              _isPolylineDrawing = true;

              if (_persistanceAdapter != null) {
                _persistanceAdapter!.createMapPolyline();
              }
            }
          });
        },
      ),
      GCWIconButton(
        backgroundColor: _isPointsHidden ? COLOR_MAP_ACTIVATED_ICONBUTTON : COLOR_MAP_ICONBUTTONS,
        customIcon: _createIconButtonIcons(Icons.location_disabled),
        onPressed: () {
          setState(() {
            _isPointsHidden = !_isPointsHidden;
          });
        },
      ),
      GCWIconButton(
        backgroundColor: COLOR_MAP_ICONBUTTONS,
        customIcon: _createIconButtonIcons(Icons.delete),
        onPressed: () {
          showGCWDialog(
              context,
              i18n(context, 'coords_openmap_removeeverything_title'),
              SizedBox(
                width: 250,
                height: 100,
                child: GCWText(
                  text: i18n(context, 'coords_openmap_removeeverything_text'),
                  style: gcwDialogTextStyle(),
                ),
              ),
              [
                GCWDialogButton(
                    text: i18n(context, 'common_ok'),
                    onPressed: () {
                      setState(() {
                        if (_persistanceAdapter != null) {
                          _persistanceAdapter!.clearMapView();
                        }
                      });
                    }),
              ]);
        },
      ),
      Container(
          padding: const EdgeInsets.only(top: _BUTTONGROUP_MARGIN),
          child: GCWPasteButton(
            backgroundColor: COLOR_MAP_ICONBUTTONS,
            customIcon: _createIconButtonIcons(Icons.content_paste),
            onSelected: (text) {
              if (_importGpxKml(text) ||
                  (_persistanceAdapter != null && _persistanceAdapter!.setJsonMapViewData(text))) {
                setState(() {
                  _mapController.fitBounds(_getBounds());
                });
              } else {
                var pastedCoordinate = _parseCoords(text);
                if (pastedCoordinate == null || pastedCoordinate.isEmpty || pastedCoordinate.first.toLatLng() == null) {
                  return;
                }
                setState(() {
                  if (_persistanceAdapter != null) {
                    _persistanceAdapter!.addMapPoint(pastedCoordinate.first.toLatLng()!,
                        coordinateFormat: pastedCoordinate.first.format);
                  }
                  _mapController.move(pastedCoordinate.first.toLatLng()!, _mapController.zoom);
                });
              }
            },
          )),
      GCWIconButton(
        backgroundColor: COLOR_MAP_ICONBUTTONS,
        customIcon: _createIconButtonIcons(Icons.drive_folder_upload),
        onPressed: () {
          setState(() {
            showOpenFileDialog(context, [FileType.GPX, FileType.KML, FileType.KMZ], _loadCoordinatesFile);
          });
        },
      ),
      GCWIconButton(
        backgroundColor: COLOR_MAP_ICONBUTTONS,
        customIcon: _createIconButtonIcons(Icons.save),
        onPressed: () {
          if (_persistanceAdapter != null) {
            showCoordinatesExportDialog(context, widget.points, widget.polylines,
                json: _persistanceAdapter!.getJsonMapViewData());
          }
        },
      ),
    ];

    return buttons;
  }

  List<GCWIconButton> _buildLayerButtons() {
    var buttons = [
      GCWIconButton(
          backgroundColor: COLOR_MAP_ICONBUTTONS,
          customIcon: _createIconButtonIcons(Icons.layers),
          onPressed: () {
            _currentLayer = _currentLayer == _LayerType.OPENSTREETMAP_MAPNIK
                ? _LayerType.MAPBOX_SATELLITE
                : _LayerType.OPENSTREETMAP_MAPNIK;

            if (_currentLayer == _LayerType.MAPBOX_SATELLITE && (_mapBoxToken == null || _mapBoxToken!.isEmpty)) {
              _loadToken('mapbox').then((token) {
                setState(() {
                  _mapBoxToken = token;
                });
              });
            } else {
              setState(() {});
            }
          }),
    ];

    if (_currentLocationPermissionGranted != null &&
        _currentLocationPermissionGranted! &&
        _locationSubscription != null) {
      buttons.add(GCWIconButton(
          backgroundColor: COLOR_MAP_ICONBUTTONS,
          customIcon: _createIconButtonIcons(_locationSubscription!.isPaused ? Icons.location_off : Icons.location_on),
          onPressed: () {
            _popupLayerController.hidePopup();
            _toggleLocationListening();
            if (!_locationSubscription!.isPaused) _manuallyToggledPosition = true;
          }));
    }

    return buttons;
  }

  // handle mouse wheel on web
  void handleSignal(PointerSignalEvent e) {
    if (e is PointerScrollEvent) {
      var delta = e.scrollDelta.direction;
      _mapController.move(_mapController.center, _mapController.zoom + (delta > 0 ? -0.2 : 0.2));
    }
  }

  String? _buildPopupCoordinateText(GCWMapPoint point) {
    var coordinateFormat = defaultCoordinateFormat;
    if (point.coordinateFormat != null) coordinateFormat = point.coordinateFormat!;

    return formatCoordOutput(point.point, coordinateFormat, getEllipsoidByName(ELLIPSOID_NAME_WGS84)!);
  }

  String? _buildPopupCoordinateDescription(GCWMapPoint point) {
    if (point.markerText == null || point.markerText!.isEmpty) return null;

    String text;
    if (point.markerText!.length > 50) {
      text = point.markerText!.substring(0, 47) + '...';
    } else {
      text = point.markerText!;
    }

    return text;
  }

  Widget _buildPopup(Marker marker) {
    ThemeColors colors = themeColors();
    _GCWMarker gcwMarker = marker as _GCWMarker;

    var height = 100.0;
    if (widget.isEditable) height += 50; // for FROM/TO Line Buttons
    if (gcwMarker.mapPoint.isEditable) height += 50; // for Edit Buttons

    var containerHeightMultiplier = 2;
    if (gcwMarker.mapPoint.hasCircle()) containerHeightMultiplier += 1;

    height += defaultFontSize() * containerHeightMultiplier;

    return Container(
        width: 250,
        height: height,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: ShapeDecoration(
          color: colors.dialog(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ROUNDED_BORDER_RADIUS),
            side: BorderSide(
              width: 1,
              color: colors.dialogText(),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                widget.isEditable && !_isOwnPosition(gcwMarker.mapPoint)
                    ? Container(
                        transform: Matrix4.translationValues(-8.0, -4.0, 0.0),
                        child: GCWIconButton(
                          icon: gcwMarker.mapPoint.isEditable ? Icons.lock_open_outlined : Icons.lock,
                          iconColor: colors.dialogText(),
                          onPressed: () {
                            setState(() {
                              gcwMarker.mapPoint.isEditable = !gcwMarker.mapPoint.isEditable;
                              _updateMapPoint(gcwMarker);
                            });
                          },
                        ),
                      )
                    : Container(),
                gcwMarker.coordinateDescription == null
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        transform: widget.isEditable && !_isOwnPosition(gcwMarker.mapPoint)
                            ? Matrix4.translationValues(-10.0, 0.0, 0.0)
                            : null,
                        child: GCWText(
                            text: gcwMarker.coordinateDescription!,
                            style: gcwDialogTextStyle().copyWith(fontWeight: FontWeight.bold)),
                      ),
              ],
            ),
            Container(margin: const EdgeInsets.only(bottom: 5)),
            GCWOutputText(text: gcwMarker.coordinateText, style: gcwDialogTextStyle()),
            gcwMarker.mapPoint.hasCircle()
                ? GCWOutputText(
                    text:
                        i18n(context, 'common_radius') + ': ' + _formatLengthOutput(gcwMarker.mapPoint.circle!.radius),
                    style: gcwDialogTextStyle(),
                    copyText: gcwMarker.mapPoint.circle!.radius.toString(),
                  )
                : Container(),
            gcwMarker.mapPoint.isEditable
                ? Column(children: [
                    Row(children: [
                      const Spacer(),
                      GCWIconButton(
                          icon: Icons.edit,
                          iconColor: colors.dialogText(),
                          onPressed: () {
                            Navigator.push(
                                context,
                                NoAnimationMaterialPageRoute<GCWTool>(
                                    builder: (context) => GCWTool(
                                        tool: MapPointEditor(
                                            mapPoint: gcwMarker.mapPoint, lengthUnit: defaultLengthUnitGCWMapView),
                                        id: 'coords_openmap_pointeditor'))).whenComplete(() {
                              setState(() {
                                _updateMapPoint(gcwMarker);
                                _popupLayerController.hidePopup();
                              });
                            });
                          }),
                      const Spacer(),
                      GCWIconButton(
                        icon: Icons.delete,
                        iconColor: colors.dialogText(),
                        onPressed: () {
                          setState(() {
                            if (_persistanceAdapter != null) {
                              _persistanceAdapter!.removeMapPoint(gcwMarker.mapPoint);
                            }
                            _popupLayerController.hidePopup();
                          });
                        },
                      ),
                      const Spacer()
                    ]),
                  ])
                : Container(),
            _isOwnPosition(gcwMarker.mapPoint) || !widget.isEditable
                ? Container()
                : _isPolylineDrawing
                    ? GCWDialogButton(
                        text: i18n(context, 'coords_openmap_linetohere'),
                        suppressClose: true,
                        onPressed: () {
                          setState(() {
                            var polyline = widget.polylines.last;
                            if (_persistanceAdapter != null) {
                              _persistanceAdapter!.addMapPointIntoPolyline(gcwMarker.mapPoint, polyline);
                            }

                            _popupLayerController.hidePopup();
                          });
                        })
                    : GCWDialogButton(
                        text: i18n(context, 'coords_openmap_linefromhere'),
                        suppressClose: true,
                        onPressed: () {
                          setState(() {
                            _isPolylineDrawing = true;

                            if (_persistanceAdapter != null) {
                              var newPolyline = _persistanceAdapter!.createMapPolyline();
                              _persistanceAdapter!.addMapPointIntoPolyline(gcwMarker.mapPoint, newPolyline);
                            }

                            _popupLayerController.hidePopup();
                          });
                        }),
          ],
        ));
  }

  void _updateMapPoint(_GCWMarker gcwMarker) {
    if (_persistanceAdapter != null) {
      _persistanceAdapter!.updateMapPoint(gcwMarker.mapPoint);
    }
    _mapController.move(gcwMarker.mapPoint.point, _mapController.zoom);
  }

  List<Polyline> _addPolylines() {
    var _polylines = <TaggedPolyline>[];

    for (var polyline in widget.polylines) {
      for (var line in polyline.lines) {
        _polylines.add(_GCWTappablePolyline(
            points: line.shape, strokeWidth: _POLYGON_STROKEWIDTH, color: polyline.color, child: line));
      }
    }

    return _polylines;
  }

  List<Polyline> _addCircles() {
    List<Polyline> _polylines = widget.points.where((point) => point.circle != null).map((point) {
      return _GCWTappablePolyline(
          points: point.circle!.shape,
          strokeWidth: _POLYGON_STROKEWIDTH,
          color: point.circle!.color,
          child: point.circle!);
    }).toList();

    return _polylines;
  }

  List<BaseCoordinate>? _parseCoords(String text) {
    var parsed = parseCoordinates(text);
    if (parsed.isEmpty) {
      showSnackBar(i18n(context, 'coords_common_clipboard_nocoordsfound'), context);
      return null;
    }

    return parsed;
  }

  bool _importGpxKml(String xml) {
    var viewData = parseCoordinatesFile(xml);
    viewData ??= parseCoordinatesFile(xml, kmlFormat: true);

    if (viewData != null) {
      setState(() {
        if (_persistanceAdapter != null) {
          _persistanceAdapter!.addViewData(viewData!);
        }
      });
    }

    return (viewData != null);
  }

  void _loadCoordinatesFile(GCWFile? file) async {
    if (file == null) return;

    try {
      await importCoordinatesFile(file).then((viewData) {
        if (viewData == null) return false;

        setState(() {
          _isPolylineDrawing = false;
          if (_persistanceAdapter != null) {
            _persistanceAdapter!.addViewData(viewData);
          }
          _mapController.fitBounds(_getBounds());
        });
      });
    } catch (exception) {}
  }
}

class _GCWMarker extends Marker {
  final String? coordinateText;
  final String? coordinateDescription;
  final GCWMapPoint mapPoint;

  _GCWMarker({
    this.coordinateText,
    this.coordinateDescription,
    required this.mapPoint,
    required WidgetBuilder builder,
    required double width,
    required double height,
  }) : super(point: mapPoint.point, builder: builder, width: width, height: height);
}

class _GCWTappablePolyline extends TaggedPolyline {
  GCWMapSimpleGeometry child;

  _GCWTappablePolyline(
      {required List<LatLng> points, required double strokeWidth, required Color color, required this.child})
      : super(
          points: points,
          strokeWidth: strokeWidth,
          color: color,
        );
}

class _GCWMapPopupController {
  MapController? mapController;
  PopupController popupController = PopupController();

  _GCWMapPopupController();

  void hidePopup({bool disableAnimation = false}) {
    popupController.hideAllPopups(disableAnimation: disableAnimation);
  }
}

class _GCWOwnLocationMapPoint extends GCWMapPoint {
  _GCWOwnLocationMapPoint({required super.point, required BuildContext context})
      : super(
            markerText: i18n(context, 'common_userposition'),
            color: COLOR_MAP_USERPOSITION,
            coordinateFormat: defaultCoordinateFormat);
}

class CachedNetworkTileProvider extends TileProvider {
  @override
  ImageProvider getImage(Coords<num> coords, TileLayer options) {
    return CachedNetworkImageProvider(getTileUrl(coords, options));
  }
}

void openInMap(BuildContext context, List<GCWMapPoint> mapPoints,
    {List<GCWMapPolyline>? mapPolylines, bool freeMap = false}) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) => GCWTool(
              tool: GCWMapView(
                points: List<GCWMapPoint>.from(mapPoints),
                polylines: mapPolylines == null ? null : List<GCWMapPolyline>.from(mapPolylines),
                isEditable: freeMap,
              ),
              id: freeMap ? 'coords_openmap' : 'coords_map_view',
              autoScroll: false,
              suppressToolMargin: true)));
}
