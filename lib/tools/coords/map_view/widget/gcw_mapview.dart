import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/permissions/user_location.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/gpx_kml_gpx_import.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_export_dialog.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/persistence/mapview_persistence_adapter.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/mappoint_editor.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/mappolyline_editor.dart';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/deeplink_utils.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:prefs/prefs.dart';

part 'package:gc_wizard/tools/coords/map_view/widget/scalebar/gcw_mapview_scalebar.dart';
part 'package:gc_wizard/tools/coords/map_view/widget/scalebar/gcw_mapview_scalebar_painter.dart';

enum MapMarkerIcon {CROSSLINES, LOCATION}

enum _LayerType { OPENSTREETMAP_MAPNIK, MAPBOX_SATELLITE }

const _OSM_TEXT = 'coords_mapview_osm';
const _OSM_URL = 'coords_mapview_osm_url';
const _MAPBOX_SATELLITE_TEXT = 'coords_mapview_mapbox_satellite';
const _MAPBOX_SATELLITE_URL = 'coords_mapview_mapbox_satellite_url';
const uriContent = 'content';
const _mapViewId = 'coords_openmap';

final _DEFAULT_BOUNDS = LatLngBounds(const LatLng(51.5, 12.9), const LatLng(53.5, 13.9));
const _POLYGON_STROKEWIDTH = 3.0;

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
  late MapMarkerIcon _markerIcon;

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
  var _isPolylineDrawingFirstPoint = true;
  var _isPointsHidden = false;

  MapViewPersistenceAdapter? _persistanceAdapter;

  late Length defaultLengthUnitGCWMapView;

  CameraFit _getBounds() {
    if (widget.points.isEmpty) return CameraFit.bounds(bounds: _DEFAULT_BOUNDS);

    var _bounds = LatLngBounds(widget.points.first.point, widget.points.first.point);
    for (var point in widget.points.skip(1)) {
      _bounds.extend(point.point);
    }

    return CameraFit.bounds(bounds: _bounds, padding: const EdgeInsets.all(30.0));
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
    _markerIcon = _mapMarkerIconFromString(Prefs.getString(PREFERENCE_MAPVIEW_MARKER_ICON));
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
            _mapController.move(newPosition!, _mapController.camera.zoom);
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
    var lengthUnit = defaultLengthUnitGCWMapView;
    var format = '0.00';
    if (lengthUnit.symbol == 'm' && length >= 10000) {
      lengthUnit = LENGTH_KM;
      if (length < 100000) {
        format = '0.000';
      }
    }

    return NumberFormat(format).format(lengthUnit.fromMeter(length)) + ' ' + lengthUnit.symbol;
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
          )
        : TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          );

    var layers = <Widget>[tileLayer];
    layers.addAll(_buildLinesAndMarkersLayers());

    return Listener(
        onPointerSignal: handleSignal,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCameraFit: _getBounds(),
                /// IMPORTANT for dragging
                minZoom: 1.0,
                maxZoom: 18.0,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate), // suppress rotation
                onTap: (_, __) => _popupLayerController.hidePopup(),
                onLongPress: widget.isEditable && !_isPointsHidden // == _persistanceAdapter is set
                  ? (_, LatLng coordinate) {
                      setState(() {
                        if (widget.isEditable && _persistanceAdapter != null) {
                          var newPoint = _persistanceAdapter!.addMapPoint(coordinate);

                          if (_isPolylineDrawing) {
                            if (widget.polylines.isEmpty) _persistanceAdapter!.createMapPolyline();

                            _persistanceAdapter!.addMapPointIntoPolyline(newPoint, widget.polylines.last);
                            _isPolylineDrawingFirstPoint = false;
                          }
                        }
                      });
                    }
                  : null),
              children: layers,
            ),
            Positioned(top: 15.0, right: 15.0, child: Column(children: _buildLayerButtons())),
            Positioned(
              bottom: 15.0, right: 15.0, child: GCWPopupMenu(
                customIcon: _createIconButtonIcons(Icons.more_vert),
                backgroundColor: COLOR_MAP_ICONBUTTONS,
                menuItemBuilder: (context) => _buildPopupMenuButtons(),
              )
            ),
            Positioned(top: 15.0, left: 15.0, child: Column(children: _buildAddButtons())),
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
        _currentPosition != null &&
        _isPointsHidden == false) {
      var circleColor = COLOR_MAP_USERPOSITION.withOpacity(0.0);

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
        MouseRegion(
          hitTestBehavior: HitTestBehavior.deferToChild,
          cursor: SystemMouseCursors.click, // Use a special cursor to indicate interactivity
          child: GestureDetector(
          onTap: () {
            _polylineHitNotifier();
          },
          child: PolylineLayer(
            simplificationTolerance: 0,
            polylines: _polylines,
            hitNotifier: _hitNotifier,
          ),
        )
      ),
      const GCWMapViewScalebar(
        alignment: Alignment.bottomLeft,
      ),
      PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            markers: _markers,

            popupController: _popupLayerController.popupController,
            markerCenterAnimation: const MarkerCenterAnimation(duration: Duration.zero),
            popupDisplayOptions: PopupDisplayOptions(
              builder: (BuildContext _, Marker marker) => _buildPopup(marker),
              snap: PopupSnap.markerTop,
            ),
      )),
  ]);
    return layers;
  }

  final LayerHitNotifier<Object> _hitNotifier = ValueNotifier(null);

  void _polylineHitNotifier() {
    if (_hitNotifier.value?.hitValues.first is GCWMapLine) {
      var line = _hitNotifier.value?.hitValues.first as GCWMapLine;
      var _line = _GCWTappablePolyline(
          points: line.shape, strokeWidth: _POLYGON_STROKEWIDTH, color: line.parent.color, child: line);

      _showPolylineDialog(_line);
    }
  }

  void _showPolylineDialog(_GCWTappablePolyline polyline) {
    List<Widget> output = [];

    var child = polyline.child;
    if (child is GCWMapLine) {
      var data = <DoubleText>[
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
                            toolName: i18n(context, 'coords_openmap_title') + ': ' + i18n(context, 'coords_openmap_lineeditor_title'),
                            id: 'coords_openmap_lineeditor'))).whenComplete(() {
                  setState(() {
                    Navigator.pop(context);
                    if (widget.isEditable && _persistanceAdapter != null) {
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
                            toolName: i18n(context, 'coords_openmap_title') + ': ' + i18n(context, 'coords_openmap_pointeditor_title'),
                            id: 'coords_openmap_pointeditor'))).whenComplete(() {
                  setState(() {
                    if (widget.isEditable && _persistanceAdapter != null) {
                      _persistanceAdapter!.updateMapPoint(mapPoint);
                    }
                    _mapController.move(mapPoint.point, _mapController.camera.zoom);
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
                              if (widget.isEditable && _persistanceAdapter != null) {
                                _persistanceAdapter!.removeMapPolyline(child.parent);
                              }
                              _isPolylineDrawing = false;
                            });
                          }),
                      GCWDialogButton(
                          text: i18n(context, 'coords_openmap_lineremove_dialog_removepoints'),
                          onPressed: () {
                            setState(() {
                              if (widget.isEditable && _persistanceAdapter != null) {
                                _persistanceAdapter!.removeMapPolyline(child.parent, removePoints: true);
                              }
                              _isPolylineDrawing = false;
                            });
                          }),
                    ]);
              } else if (child is GCWMapCircle) {
                setState(() {
                  var mapPoint = widget.points.firstWhere((element) => element.circle == child);
                  mapPoint.circle = null;
                  if (widget.isEditable && _persistanceAdapter != null) {
                    _persistanceAdapter!.updateMapPoint(mapPoint);
                  }
                  _isPolylineDrawing = false;
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
      points.add(_GCWOwnLocationMapPoint(
        point: _currentPosition!,
        context: context
      ));
    }

    return points.map((_point) {
      var icon = Icon(
        iconFromMapMarkerValues(_markerIcon),
        size: 25.0,
        color: _point.color,
        shadows: const [
          Shadow(
            color: COLOR_MAP_POINT_OUTLINE,
            blurRadius: 5.0,
          ),
        ]
      );

      var marker = widget.isEditable && _point.isEditable ? _createDragableIcon(_point, icon) : icon;

      return _GCWMarker(
          coordinateDescription: _buildPopupCoordinateDescription(_point),
          width: 25,
          height: _markerIcon == MapMarkerIcon.CROSSLINES ? 24.5 : 23,
          mapPoint: _point,
          child: marker,
          alignment: _mapMarkerAlignment(_markerIcon)
      );
    }).toList();
  }

  Widget _createDragableIcon(GCWMapPoint point, Widget icon) {
    return GestureDetector(
      onVerticalDragStart: (details) => _onPanStart(details, point),
      onVerticalDragUpdate: (details) => _onPanUpdate(details, point),
      onHorizontalDragStart: (details) => _onPanStart(details, point),
      onHorizontalDragUpdate: (details) => _onPanUpdate(details, point),
      child: icon,
    );
  }

  late Point<double> _markerPointStart;

  void _onPanStart(DragStartDetails details, GCWMapPoint point) {
    _markerPointStart = const Epsg3857().latLngToPoint(point.point, _mapController.camera.zoom);

    _markerPointStart -= details.localPosition.toPoint();
  }

  void _onPanUpdate(DragUpdateDetails details, GCWMapPoint point) {
    _popupLayerController.hidePopup();

    LatLng pointToLatLng =
        const Epsg3857().pointToLatLng(_markerPointStart + details.localPosition.toPoint(), _mapController.camera.zoom);

    point.point = pointToLatLng;

    setState(() {
      if (widget.isEditable && _persistanceAdapter != null) {
        _persistanceAdapter!.updateMapPoint(point);
      }
    });
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
          backgroundColor: _locationSubscription!.isPaused ? COLOR_MAP_ACTIVATED_ICONBUTTON : COLOR_MAP_ICONBUTTONS,
          customIcon: _createIconButtonIcons(Icons.person_off),
          onPressed: () {
            _popupLayerController.hidePopup();
            _toggleLocationListening();
            if (!_locationSubscription!.isPaused) _manuallyToggledPosition = true;
          }));
    }

    return buttons;
  }

  List<Widget> _buildAddButtons() {
    var buttons = [
      widget.isEditable ? GCWIconButton(
        backgroundColor: COLOR_MAP_ICONBUTTONS,
        customIcon: _createIconButtonIcons(iconFromMapMarkerValues(_markerIcon), stacked: Icons.add),
        onPressed: () {
          if (_isPointsHidden) {
            return;
          }

          if (widget.isEditable && _persistanceAdapter != null) {
            var mapPoint = _persistanceAdapter!.addMapPoint(_mapController.camera.center);

            Navigator.push(
              context,
              NoAnimationMaterialPageRoute<GCWTool>(
                  builder: (context) => GCWTool(
                      tool: MapPointEditor(
                          mapPoint: mapPoint, lengthUnit: defaultLengthUnitGCWMapView),
                      toolName: i18n(context, 'coords_openmap_title') + ': ' + i18n(context, 'coords_openmap_pointeditor_title'),
                      id: 'coords_openmap_pointeditor'))).whenComplete(() {
                setState(() {
                  _updateMapPoint(mapPoint);
                  _popupLayerController.hidePopup();
                });
              });
          }
        },
      ) : Container(),
      widget.isEditable ? GCWIconButton(
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

              if (widget.isEditable && _persistanceAdapter != null) {
                _persistanceAdapter!.createMapPolyline();
              }
            }
            _isPolylineDrawingFirstPoint = true;
          });
        },
      ) : Container(),
      GCWIconButton(
        backgroundColor: _isPointsHidden ? COLOR_MAP_ACTIVATED_ICONBUTTON : COLOR_MAP_ICONBUTTONS,
        customIcon: _createIconButtonIcons(_negativeIconFromMapMarkerValues(_markerIcon)),
        onPressed: () {
          setState(() {
            _isPointsHidden = !_isPointsHidden;
          });
        },
      )
    ];

    return buttons;
  }

  List<GCWPopupMenuItem> _buildPopupMenuButtons() {
    var buttons = [
      if (widget.isEditable) GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.delete, i18n(context, 'coords_openmap_deletealldata')),
        action: (index) {
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
                        if (widget.isEditable && _persistanceAdapter != null) {
                          _persistanceAdapter!.clearMapView();
                        }
                        _isPolylineDrawing = false;
                      });
                    }),
              ]);
        },
      ),
      GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context,
          _isPointsHidden ? iconFromMapMarkerValues(_markerIcon) : _negativeIconFromMapMarkerValues(_markerIcon),
          _isPointsHidden ?  i18n(context, 'coords_openmap_showpoints') : i18n(context, 'coords_openmap_hidepoints'),
        ),
        action: (index) {
          setState(() {
            _isPointsHidden = !_isPointsHidden;
          });
        }
      ),
      if (widget.isEditable) GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.merge_type, i18n(context, 'coords_openmap_mergepoints'), rotateDegrees: 180),
        action: (index) {
          setState(() {
            _persistanceAdapter!.mergePoints();
          });
        },
      ),
      GCWPopupMenuItem(
        isDivider: true,
        action: (index) {},
      ),
      if (widget.isEditable) GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.content_paste, i18n(context, 'coords_openmap_pastedata')),
        action: (index) {
          onPasteMenuButtonPressed(context,
            (text) {
              if (_importGpxKml(text) ||
                  (widget.isEditable && _persistanceAdapter != null && _persistanceAdapter!.setJsonMapViewData(text))) {
                setState(() {
                  _mapController.fitCamera(_getBounds());
                });
              } else if(_mapViewUriContent(text).isNotEmpty) {
                if (_importJsonContent(_mapViewUriContent(text))) {
                  setState(() {
                    _mapController.fitCamera(_getBounds());
                  });
                }
              } else {
                var pastedCoordinate = _parseCoords(text);
                if (pastedCoordinate == null || pastedCoordinate.isEmpty || pastedCoordinate.first.toLatLng() == null) {
                  return;
                }
                setState(() {
                  if (widget.isEditable && _persistanceAdapter != null) {
                    _persistanceAdapter!.addMapPoint(pastedCoordinate.first.toLatLng()!,
                        coordinateFormat: pastedCoordinate.first.format);
                  }
                  _mapController.move(pastedCoordinate.first.toLatLng()!, _mapController.camera.zoom);
                });
              }
            },
          );
        },
      ),
      if (widget.isEditable) GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.drive_folder_upload, i18n(context, 'coords_openmap_loaddata')),
        action: (index) {
          setState(() {
            showOpenFileDialog(context, [FileType.GPX, FileType.KML, FileType.KMZ, FileType.JSON], _loadCoordinatesFile);
          });
        },
      ),
      GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.save, i18n(context, 'coords_openmap_savedata')),
        action: (index) {
          showCoordinatesExportDialog(context, widget.points, widget.polylines, json: _jsonDataFromMapView());
        },
      ),
      GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.link, i18n(context, 'coords_openmap_weblinkview')),
        action: (index) {
          var content = _jsonDataFromMapView();
          var uri = deepLinkUriWithParameter(GCWTool(tool: Container(), id: _mapViewId),
              {uriContent: compressString(content)
                  .replaceAll('/', '_')
                  .replaceAll('+', '-')
                  .replaceAll('=', '~')
              });
          if (kIsWeb) {
            launchUrl(uri);
          } else {
            insertIntoGCWClipboard(context, uri.toString());
          }
        },
      ),
      GCWPopupMenuItem(
        isDivider: true,
        action: (index) {}
      ),
      GCWPopupMenuItem(
          child: iconedGCWPopupMenuItem(context, Icons.layers,
              _currentLayer == _LayerType.OPENSTREETMAP_MAPNIK
                ? i18n(context, 'coords_openmap_showsatellite')
                : i18n(context, 'coords_openmap_showmap')
          ),
          action: (index){
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
      buttons.add(GCWPopupMenuItem(
          child: iconedGCWPopupMenuItem(context,
              _locationSubscription!.isPaused ? Icons.person : Icons.person_off,
              _locationSubscription!.isPaused ?  i18n(context, 'coords_openmap_showownposition') : i18n(context, 'coords_openmap_hideownposition'),

          ),
          action: (index) {
            _popupLayerController.hidePopup();
            _toggleLocationListening();
            if (!_locationSubscription!.isPaused) _manuallyToggledPosition = true;
          }));
    }

    buttons.addAll([
      GCWPopupMenuItem(
        isDivider: true,
        action: (index) {}
      ),
      GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, _otherMapMarkerIcon(_markerIcon), i18n(context, 'coords_openmap_usethismarkericon')),
        action: (index){
          setState(() {
            _markerIcon = _markerIcon == MapMarkerIcon.LOCATION ? MapMarkerIcon.CROSSLINES : MapMarkerIcon.LOCATION;
            Prefs.setString(PREFERENCE_MAPVIEW_MARKER_ICON, _markerIcon.name);
          });
        }),
    ]);

    return buttons;
  }

  String _jsonDataFromMapView() {
    if (widget.isEditable && _persistanceAdapter != null) {
      return _persistanceAdapter!.getJsonMapViewData();
    } else {
      return MapViewPersistenceAdapter.readJsonMapViewData(MapViewPersistenceAdapter.mapViewDAOfromMapWidget(widget));
    }
  }

  // handle mouse wheel on web
  void handleSignal(PointerSignalEvent e) {
    if (e is PointerScrollEvent) {
      var delta = e.scrollDelta.direction;
      _mapController.move(_mapController.camera.center, _mapController.camera.zoom + (delta > 0 ? -0.2 : 0.2));
    }
  }

  String _buildPopupCoordinateText(GCWMapPoint point, {required bool rounded}) {
    var coordinateFormat = defaultCoordinateFormat;
    if (point.coordinateFormat != null) coordinateFormat = point.coordinateFormat!;

    return formatCoordOutput(point.point, coordinateFormat, Ellipsoid.WGS84, rounded);
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

  String _mapViewUriContent(String text) {
    var uri = Uri.parse(text.replaceFirst('/#/', '/')); // remove /#/ -> Uri.parse not ok on App Version
    if (uri.hasEmptyPath) return '';
    if (!uri.toString().contains(_mapViewId)) return '';
    var parameter = uri.queryParameters;
    if (!parameter.keys.contains(uriContent)) return '';
    try {
      return decompressString(parameter[uriContent]!);
    } catch (e) {
      return '';
    }
  }

  bool _importJsonContent(String json) {
    return widget.isEditable && _persistanceAdapter != null && _persistanceAdapter!.setJsonMapViewData(json);
  }


  Widget _buildPopup(Marker marker) {
    ThemeColors colors = themeColors();
    _GCWMarker gcwMarker = marker as _GCWMarker;

    var height = 100.0;
    if (widget.isEditable) height += 50; // for FROM/TO Line Buttons
    if (gcwMarker.mapPoint.isEditable) height += 50; // for Edit Buttons

    var containerHeightMultiplier = 2;
    if (gcwMarker.mapPoint.hasCircle() || _isOwnPosition(gcwMarker.mapPoint)) containerHeightMultiplier += 1;

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
                              _updateMapPoint(gcwMarker.mapPoint);
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
            GCWOutputText(
              text: _buildPopupCoordinateText(gcwMarker.mapPoint, rounded: true),
              copyText: _buildPopupCoordinateText(gcwMarker.mapPoint, rounded: false).replaceAll('\n', ' '),
              style: gcwDialogTextStyle()
            ),
            gcwMarker.mapPoint.hasCircle()
              ? GCWOutputText(
                  text:
                      i18n(context, 'common_radius') + ': ' + _formatLengthOutput(gcwMarker.mapPoint.circle!.radius),
                  style: gcwDialogTextStyle(),
                  copyText: gcwMarker.mapPoint.circle!.radius.toString(),
                )
              : Container(),
            _isOwnPosition(gcwMarker.mapPoint)
              ? GCWOutputText(
                  text: i18n(context, 'common_accuracy') + ': ' + _formatLengthOutput(_currentAccuracy!),
                  style: gcwDialogTextStyle(),
                  copyText: _currentAccuracy!.toString(),
                )
              : Container(),
            gcwMarker.mapPoint.isEditable && widget.isEditable
                ? Column(children: [
                    Row(children: [
                      const Spacer(),
                      GCWIconButton(
                          icon: Icons.edit,
                          iconColor: colors.dialogText(),
                          onPressed: () {
                            var point = gcwMarker.mapPoint;

                            Navigator.push(
                                context,
                                NoAnimationMaterialPageRoute<GCWTool>(
                                    builder: (context) => GCWTool(
                                        tool: MapPointEditor(
                                            mapPoint: point, lengthUnit: defaultLengthUnitGCWMapView),
                                        toolName: i18n(context, 'coords_openmap_title') + ': ' + i18n(context, 'coords_openmap_pointeditor_title'),
                                        id: 'coords_openmap_pointeditor'))).whenComplete(() {
                              setState(() {
                                _updateMapPoint(point);
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
                            if (widget.isEditable && _persistanceAdapter != null) {
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
                : _isPolylineDrawing && widget.polylines.isNotEmpty && !_isPolylineDrawingFirstPoint
                    ? GCWDialogButton(
                        text: i18n(context, 'coords_openmap_linetohere'),
                        suppressClose: true,
                        onPressed: () {
                          setState(() {
                            var polyline = widget.polylines.last;
                            if (widget.isEditable && _persistanceAdapter != null) {
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
                            _isPolylineDrawingFirstPoint = false;

                            if (widget.isEditable && _persistanceAdapter != null) {
                              var newPolyline = _persistanceAdapter!.createMapPolyline();
                              _persistanceAdapter!.addMapPointIntoPolyline(gcwMarker.mapPoint, newPolyline);
                            }

                            _popupLayerController.hidePopup();
                          });
                        }),
          ],
        ));
  }

  void _updateMapPoint(GCWMapPoint mapPoint) {
    if (widget.isEditable && _persistanceAdapter != null) {
      _persistanceAdapter!.updateMapPoint(mapPoint);
    }
    _mapController.move(mapPoint.point, _mapController.camera.zoom);
  }

  List<Polyline> _addPolylines() {
    var _polylines = <Polyline>[];

    for (var polyline in widget.polylines) {
      for (var line in polyline.lines) {
        _polylines.add(Polyline(points: line.shape, strokeWidth: _POLYGON_STROKEWIDTH,
            color: polyline.color, hitValue: line));
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
        if (widget.isEditable && _persistanceAdapter != null) {
          _persistanceAdapter!.addViewData(viewData!);
        }
      });
    }

    return (viewData != null);
  }

  void _loadCoordinatesFile(GCWFile? file) async {
    if (file == null) return;

    try {
      var type = fileTypeByFilename(file.name!);
      switch (type) {
        case FileType.JSON:
          var json = convertBytesToString(file.bytes);
          setState(() {
            if (!(_persistanceAdapter?.setJsonMapViewData(json) ?? false)) return;
            _mapController.fitCamera(_getBounds());
          });
          break;
        default:
          await importCoordinatesFile(file).then((viewData) {
            if (viewData == null) return false;
            setState(() {
              _isPolylineDrawing = false;
              _persistanceAdapter?.addViewData(viewData);
              _mapController.fitCamera(_getBounds());
            });
          });
      }
    } catch (exception) {}
  }

  IconData _negativeIconFromMapMarkerValues(MapMarkerIcon markerValue) {
    switch (markerValue) {
      case MapMarkerIcon.CROSSLINES: return Icons.location_disabled;
      case MapMarkerIcon.LOCATION: return Icons.location_off;
    }
  }

  IconData _otherMapMarkerIcon(MapMarkerIcon markerValue) {
    switch (markerValue) {
      case MapMarkerIcon.CROSSLINES: return Icons.location_on;
      case MapMarkerIcon.LOCATION: return Icons.my_location;
    }
  }

  Alignment _mapMarkerAlignment(MapMarkerIcon markerValue) {
    switch (markerValue) {
      case MapMarkerIcon.CROSSLINES: return Alignment.center;
      case MapMarkerIcon.LOCATION: return Alignment.topCenter;
    }
  }
}

class _GCWMarker extends Marker {
  final String? coordinateDescription;
  final GCWMapPoint mapPoint;

  _GCWMarker({
    this.coordinateDescription,
    required this.mapPoint,
    required Widget child,
    required double width,
    required double height,
    required Alignment alignment
  }) : super(point: mapPoint.point, child: child, width: width, height: height, alignment: alignment);
}

class _GCWTappablePolyline extends Polyline {
  GCWMapSimpleGeometry child;

  _GCWTappablePolyline(
      {required List<LatLng> points, required double strokeWidth, required Color color, required this.child,
        Object? hitValue})
      : super(
          points: points,
          strokeWidth: strokeWidth,
          color: color,
          hitValue: hitValue
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

IconData iconFromMapMarkerValues(MapMarkerIcon markerValue) {
  switch (markerValue) {
    case MapMarkerIcon.CROSSLINES: return Icons.my_location;
    case MapMarkerIcon.LOCATION: return Icons.location_on;
  }
}

MapMarkerIcon _mapMarkerIconFromString(String name) {
  var enumName = MapMarkerIcon.LOCATION.toString().split('.').first + '.';

  return MapMarkerIcon.values.firstWhereOrNull(
        (e) => e.toString() == enumName + Prefs.getString(PREFERENCE_MAPVIEW_MARKER_ICON),
  ) ?? MapMarkerIcon.CROSSLINES;
}

IconData mapIconFromPreference() {
  var pref = _mapMarkerIconFromString(Prefs.getString(PREFERENCE_MAPVIEW_MARKER_ICON));
  return iconFromMapMarkerValues(pref);
}

void openInMap(BuildContext context, List<GCWMapPoint> mapPoints,
    {List<GCWMapPolyline>? mapPolylines, bool isCommonMap = false}) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) => GCWTool(
              tool: GCWMapView(
                points: List<GCWMapPoint>.from(mapPoints),
                polylines: mapPolylines == null ? null : List<GCWMapPolyline>.from(mapPolylines),
                isEditable: isCommonMap,
              ),
              id: 'coords_openmap',
              autoScroll: false,
              suppressToolMargin: true)));
}
