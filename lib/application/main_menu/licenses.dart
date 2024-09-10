import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/mainmenuentry_stub.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/tools/tool_licenses/widget/tool_license_types.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';

class Licenses extends StatefulWidget {
  const Licenses({Key? key}) : super(key: key);

  @override
  _LicensesState createState() => _LicensesState();
}

Column _licenseContent(Map<String, List<ToolLicenseEntry>> licenses) {
  return Column(
    children: licenses.entries.map((entry) {
      return Column(
          children: [
            GCWTextDivider(text: entry.key),
            Container(
              padding: const EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN),
              child: GCWColumnedMultilineOutput(
                data: entry.value.map((ToolLicenseEntry license) {
                  return [
                    toolLicenseEntry(license.toRow())
                  ];
                }).toList(),
              ),
            )
          ]
      );
    }).toList()
  );
}

class _LicensesState extends State<Licenses> {
  @override
  Widget build(BuildContext context) {

    var tools = registeredTools
      .where((GCWTool tool) => tool.licenses != null && tool.licenses!.isNotEmpty)
      .toList();

    var _contentOfflineBook = SplayTreeMap<String, List<ToolLicenseEntry>>();
    var _contentOnlineBook = SplayTreeMap<String, List<ToolLicenseEntry>>();
    var _contentOfflineArticle = SplayTreeMap<String, List<ToolLicenseEntry>>();
    var _contentOnlineArticle = SplayTreeMap<String, List<ToolLicenseEntry>>();
    var _contentPortedCode = SplayTreeMap<String, List<ToolLicenseEntry>>();
    var _contentCodeLibrary = SplayTreeMap<String, List<ToolLicenseEntry>>();
    var _contentImage = SplayTreeMap<String, List<ToolLicenseEntry>>();
    var _contentFont = SplayTreeMap<String, List<ToolLicenseEntry>>();
    var _contentAPI = SplayTreeMap<String, List<ToolLicenseEntry>>();

    for (var tool in tools) {
      var name = toolName(context, tool);
      for (var license in tool.licenses!) {
        if (license is ToolLicenseOfflineBook) {
          if (_contentOfflineBook.containsKey(name)) {
            _contentOfflineBook[name]!.add(license);
          } else {
            _contentOfflineBook.putIfAbsent(name, () => [license]);
          }
          continue;
        }

        if (license is ToolLicenseOnlineBook) {
          if (_contentOnlineBook.containsKey(name)) {
            _contentOnlineBook[name]!.add(license);
          } else {
            _contentOnlineBook.putIfAbsent(name, () => [license]);
          }
          continue;
        }

        if (license is ToolLicenseOfflineArticle) {
          if (_contentOfflineArticle.containsKey(name)) {
            _contentOfflineArticle[name]!.add(license);
          } else {
            _contentOfflineArticle.putIfAbsent(name, () => [license]);
          }
          continue;
        }

        if (license is ToolLicenseOnlineArticle) {
          if (_contentOnlineArticle.containsKey(name)) {
            _contentOnlineArticle[name]!.add(license);
          } else {
            _contentOnlineArticle.putIfAbsent(name, () => [license]);
          }
          continue;
        }

        if (license is ToolLicenseCodeLibrary) {
          if (_contentCodeLibrary.containsKey(name)) {
            _contentCodeLibrary[name]!.add(license);
          } else {
            _contentCodeLibrary.putIfAbsent(name, () => [license]);
          }
          continue;
        }

        if (license is ToolLicensePortedCode) {
          if (_contentPortedCode.containsKey(name)) {
            _contentPortedCode[name]!.add(license);
          } else {
            _contentPortedCode.putIfAbsent(name, () => [license]);
          }
          continue;
        }

        if (license is ToolLicenseImage) {
          if (_contentImage.containsKey(name)) {
            _contentImage[name]!.add(license);
          } else {
            _contentImage.putIfAbsent(name, () => [license]);
          }
          continue;
        }

        if (license is ToolLicenseFont) {
          if (_contentFont.containsKey(name)) {
            _contentFont[name]!.add(license);
          } else {
            _contentFont.putIfAbsent(name, () => [license]);
          }
          continue;
        }

        if (license is ToolLicenseAPI) {
          if (_contentAPI.containsKey(name)) {
            _contentAPI[name]!.add(license);
          } else {
            _contentAPI.putIfAbsent(name, () => [license]);
          }
          continue;
        }
      }
    }

    var content = <Widget>[];
    if (_contentCodeLibrary.isNotEmpty) {
      var common = i18n(context, 'common_common');
      _contentCodeLibrary.putIfAbsent(common, () =>
          [
            ToolLicenseCodeLibrary(context: context, author: 'loki3d.com', title: 'Flutter Library: archive',
              sourceUrl: 'https://web.archive.org/web/20240510080116/https://pub.dev/packages/archive',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240723102619/https://pub.dev/packages/archive/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'blue-fire.xyz', title: 'Flutter Library: audioplayers',
              sourceUrl: 'https://web.archive.org/web/20240531121621/https://pub.dev/packages/audioplayers',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240531121707/https://pub.dev/packages/audioplayers/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'simc.dev', title: 'Flutter Library: auto_size_text',
              sourceUrl: 'https://web.archive.org/web/20240626175457/https://pub.dev/packages/auto_size_text',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240617114646/https://pub.dev/packages/auto_size_text/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'baseflow.com', title: 'Flutter Library: cached_network_image',
              sourceUrl: 'https://web.archive.org/web/20240706134343/https://pub.dev/packages/cached_network_image',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240616042637/https://pub.dev/packages/cached_network_image/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@BertrandBev (GitHub)', title: 'Flutter Library: code_text_field',
              sourceUrl: 'https://web.archive.org/web/20230331140622/https://pub.dev/packages/code_text_field',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20221203134431/https://pub.dev/packages/code_text_field/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'dart.dev', title: 'Flutter Library: collection',
              sourceUrl: 'https://web.archive.org/web/20240710230349/https://pub.dev/packages/collection',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240512042724/https://pub.dev/packages/collection/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'fluttercommunity.dev', title: 'Flutter Library: device_info_plus',
              sourceUrl: 'https://web.archive.org/web/20240717112621/https://pub.dev/packages/device_info_plus',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20231227005521/https://pub.dev/packages/device_info_plus/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'agilord.com', title: 'Flutter Library: diacritic',
              sourceUrl: 'https://web.archive.org/web/20240402144558/https://pub.dev/packages/diacritic',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20231003194728/https://pub.dev/packages/diacritic/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@leocavalcante (GitHub)', title: 'Flutter Library: encrypt',
              sourceUrl: 'https://web.archive.org/web/20240621090542/https://pub.dev/packages/encrypt',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20220625065953/https://pub.dev/packages/encrypt/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'miguelruivo.com', title: 'Flutter Library: file_picker',
              sourceUrl: 'https://web.archive.org/web/20240627151130/https://pub.dev/packages/file_picker',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240512010848/https://pub.dev/packages/file_picker/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'codeux.design', title: 'Flutter Library: file_picker_writable',
              sourceUrl: 'https://web.archive.org/web/20240723104746/https://pub.dev/packages/file_picker_writable',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240723104942/https://pub.dev/packages/file_picker_writable/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@flutter (GitHub, Google Inc.)', title: 'Flutter',
              sourceUrl: 'https://github.com/S-Man42/flutter/tree/ed470fd1017fd904ad34530f732dee56ab536965',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://github.com/S-Man42/flutter/blob/ed470fd1017fd904ad34530f732dee56ab536965/LICENSE'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@GitTouch (GitHub)', title: 'Flutter Library: flutter_highlight',
              sourceUrl: 'https://web.archive.org/web/20240109182902/https://pub.dev/packages/flutter_highlight',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20230208081256/https://pub.dev/packages/flutter_highlight/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@flutter (GitHub, Google Inc.)', title: 'Flutter Library: flutter_localizations',
              sourceUrl: 'https://web.archive.org/web/20240418002509/https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://github.com/S-Man42/flutter/blob/ed470fd1017fd904ad34530f732dee56ab536965/LICENSE'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'fleaflet.dev', title: 'Flutter Library: flutter_map',
              sourceUrl: 'https://web.archive.org/web/20240606210131/https://pub.dev/packages/flutter_map',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240606210131/https://pub.dev/packages/flutter_map/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'balanci.ng', title: 'Flutter Library: flutter_map_marker_popup',
              sourceUrl: 'https://web.archive.org/web/20240222173114/https://pub.dev/packages/flutter_map_marker_popup',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240723144921/https://pub.dev/packages/flutter_map_marker_popup/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'ownweb.fr', title: 'Flutter Library: flutter_map_tappable_polyline',
              sourceUrl: 'https://web.archive.org/web/20230927164717/https://pub.dev/packages/flutter_map_tappable_polyline',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240723145110/https://pub.dev/packages/flutter_map_tappable_polyline/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'dart.dev', title: 'Flutter Library: fixnum',
                sourceUrl: 'https://web.archive.org/web/20240609183042/https://pub.dev/packages/fixnum',
                licenseType: ToolLicenseType.BSD3,
                licenseUrl: 'https://web.archive.org/web/20230310201533/https://pub.dev/packages/fixnum/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@GitTouch (GitHub)', title: 'Flutter Library: highlight',
              sourceUrl: 'https://web.archive.org/web/20231103183350/https://pub.dev/packages/highlight',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240723145359/https://pub.dev/packages/highlight/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'dart.dev', title: 'Flutter Library: http',
              sourceUrl: 'https://web.archive.org/web/20240708062104/https://pub.dev/packages/http',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240513101105/https://pub.dev/packages/http/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'dart.dev', title: 'Flutter Library: http_parser',
              sourceUrl: 'https://web.archive.org/web/20240714172550/https://pub.dev/packages/http_parser',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20230530135251/https://pub.dev/packages/http_parser/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'loki3d.com', title: 'Flutter Library: image',
              sourceUrl: 'https://web.archive.org/web/20240609215904/https://pub.dev/packages/image',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20230202095625/https://pub.dev/packages/image/License'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'dart.dev', title: 'Flutter Library: intl',
              sourceUrl: 'https://web.archive.org/web/20240627151129/https://pub.dev/packages/intl',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240606033135/https://pub.dev/packages/intl/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'defylogic.dev', title: 'Flutter Library: latlong2',
              sourceUrl: 'https://web.archive.org/web/20240517114556/https://pub.dev/packages/latlong2',
              licenseType: ToolLicenseType.APACHE2,
              licenseUrl: 'http://web.archive.org/web/20240725225604/https://pub.dev/packages/latlong2/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'bernos.dev', title: 'Flutter Library: location',
              sourceUrl: 'https://web.archive.org/web/20240716152026/https://pub.dev/packages/location',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240609105940/https://pub.dev/packages/location/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@siqwin (GitHub)', title: 'Flutter Library: mask_text_input_formatter',
              sourceUrl: 'http://web.archive.org/web/20240118011919/https://pub.dev/packages/mask_text_input_formatter',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'http://web.archive.org/web/20240724134116/https://pub.dev/packages/mask_text_input_formatter/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'leonhardt.co.nz', title: 'Flutter Library: math_expressions',
              sourceUrl: 'http://web.archive.org/web/20240724134322/https://pub.dev/packages/math_expressions',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'http://web.archive.org/web/20240724134612/https://pub.dev/packages/math_expressions/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'fluttercommunity.dev', title: 'Flutter Library: package_info_plus',
              sourceUrl: 'https://web.archive.org/web/20240525065942/https://pub.dev/packages/package_info_plus',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240706192742/https://pub.dev/packages/package_info_plus/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'dart.dev', title: 'Flutter Library: path',
              sourceUrl: 'https://web.archive.org/web/20240615030026/https://pub.dev/packages/path',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240615225506/https://pub.dev/packages/path/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'flutter.dev', title: 'Flutter Library: path_provider',
              sourceUrl: 'https://web.archive.org/web/20240608170145/https://pub.dev/packages/path_provider',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20231227010215/https://pub.dev/packages/path_provider/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'baseflow.com', title: 'Flutter Library: permission_handler',
              sourceUrl: 'https://web.archive.org/web/20240627151125/https://pub.dev/packages/permission_handler',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240616020712/https://pub.dev/packages/permission_handler/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'blue-fire.xyz', title: 'Flutter Library: photo_view',
              sourceUrl: 'https://web.archive.org/web/20240524134826/https://pub.dev/packages/photo_view',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240709210414/http://pub.dev/packages/photo_view/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'andrioussolutions.com', title: 'Flutter Library: prefs',
              sourceUrl: 'https://web.archive.org/web/20240211025140/https://pub.dev/packages/prefs',
              licenseType: ToolLicenseType.APACHE2,
              licenseUrl: 'https://web.archive.org/web/20240724135847/https://pub.dev/packages/prefs/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'dash-overflow.net', title: 'Flutter Library: provider',
              sourceUrl: 'https://web.archive.org/web/20240712231208/https://pub.dev/packages/provider',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240616125445/https://pub.dev/packages/provider/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'google.dev', title: 'Flutter Library: scrollable_positioned_list',
              sourceUrl: 'https://web.archive.org/web/20240713040313/https://pub.dev/packages/scrollable_positioned_list',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240511195114/https://pub.dev/packages/scrollable_positioned_list/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'flutter.dev', title: 'Flutter Library: shared_preferences',
              sourceUrl: 'https://web.archive.org/web/20240608181609/https://pub.dev/packages/shared_preferences',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240606110107/https://pub.dev/packages/shared_preferences/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'Ammar \'ammaratef45\' Hussein (GitHub)', title: 'Flutter Library: stack',
              sourceUrl: 'https://web.archive.org/web/20240301052612/https://pub.dev/packages/stack',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240511195114/https://pub.dev/packages/scrollable_positioned_list/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'Natesh \'nateshmbhat\' Bhat (GitHub)', title: 'Flutter Library: touchable',
              sourceUrl: 'https://web.archive.org/web/20231103182722/https://pub.dev/packages/touchable',
              licenseType: ToolLicenseType.MPL2,
              licenseUrl: 'https://web.archive.org/web/20240724144914/https://pub.dev/packages/touchable/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'dint.dev', title: 'Flutter Library: universal_html',
              sourceUrl: 'https://web.archive.org/web/20240215182450/https://pub.dev/packages/universal_html',
              licenseType: ToolLicenseType.APACHE2,
              licenseUrl: 'https://web.archive.org/web/20210620015603/https://pub.dev/packages/universal_html/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@syedecryptr (GitHub)', title: 'Flutter Library: unrar_file',
              sourceUrl: 'https://web.archive.org/web/20240724145340/https://pub.dev/packages/unrar_file',
              licenseType: ToolLicenseType.APACHE2,
              licenseUrl: 'https://web.archive.org/web/20240724145538/https://pub.dev/packages/unrar_file/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'flutter.dev', title: 'Flutter Library: url_launcher',
              sourceUrl: 'https://web.archive.org/web/20240711202509/https://pub.dev/packages/url_launcher',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20231227004216/https://pub.dev/packages/url_launcher/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'justkawal.dev', title: 'Flutter Library: utility',
              sourceUrl: 'https://web.archive.org/web/20240724150148/https://pub.dev/packages/utility',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240724150243/https://pub.dev/packages/utility/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'lukas-renggli.ch', title: 'Flutter Library: xml',
              sourceUrl: 'https://web.archive.org/web/20240530021526/https://pub.dev/packages/xml',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20231227004048/https://pub.dev/packages/xml/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: '@flutter (GitHub, Google Inc.)', title: 'Flutter Library: flutter_test',
              sourceUrl: 'https://web.archive.org/web/20240723054155/https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://github.com/S-Man42/flutter/blob/ed470fd1017fd904ad34530f732dee56ab536965/LICENSE'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'fluttercommunity.dev', title: 'Flutter Library: flutter_launcher_icons',
              sourceUrl: 'https://web.archive.org/web/20240713040303/https://pub.dev/packages/flutter_launcher_icons',
              licenseType: ToolLicenseType.MIT,
              licenseUrl: 'https://web.archive.org/web/20240220231946/https://pub.dev/packages/flutter_launcher_icons/license'
            ),
            ToolLicenseCodeLibrary(context: context, author: 'flutter.dev', title: 'Flutter Library: flutter_lints',
              sourceUrl: 'https://web.archive.org/web/20240627151128/https://pub.dev/packages/flutter_lints',
              licenseType: ToolLicenseType.BSD3,
              licenseUrl: 'https://web.archive.org/web/20240510075912/https://pub.dev/packages/flutter_lints/license'
            ),
      ]);

      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_codelibrary'),
          child: _licenseContent(_contentCodeLibrary)
      ));
    }
    if (_contentPortedCode.isNotEmpty) {
      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_portedcode'),
          child: _licenseContent(_contentPortedCode)
      ));
    }
    if (_contentImage.isNotEmpty) {
      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_image'),
          child: _licenseContent(_contentImage)
      ));
    }
    if (_contentFont.isNotEmpty) {
      var common = i18n(context, 'common_common');
      _contentFont.putIfAbsent(common, () => [
        ToolLicenseFont(
            context: context,
            title: 'CourierPrime',
            author: 'Quote-Unquote Apps (Github)',
            licenseType: ToolLicenseType.SIL_OFL11,
            licenseUrl: 'http://web.archive.org/web/20240831133744/https://github.com/quoteunquoteapps/CourierPrime/blob/master/OFL.txt',
            sourceUrl: 'http://web.archive.org/web/20220103114221/https://github.com/quoteunquoteapps/CourierPrime'
        ),
        ToolLicenseFont(
            context: context,
            title: 'Roboto',
            author: 'Christian Robertson (Google Fonts)',
            licenseType: ToolLicenseType.APACHE2,
            licenseUrl: 'https://fonts.google.com/specimen/Roboto',
            sourceUrl: 'https://github.com/S-Man42/GCWizard/blob/master/lib/application/_common/assets/fonts/Roboto/LICENSE.txt'
        ),
      ]);

      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_font'),
          child: _licenseContent(_contentFont)
      ));
    }
    if (_contentAPI.isNotEmpty) {
      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_api'),
          child: _licenseContent(_contentAPI)
      ));
    }
    if (_contentOnlineArticle.isNotEmpty) {
      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_onlinearticle'),
          child: _licenseContent(_contentOnlineArticle)
      ));
    }
    if (_contentOnlineBook.isNotEmpty) {
      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_onlinebook'),
          child: _licenseContent(_contentOnlineBook)
      ));
    }
    if (_contentOfflineArticle.isNotEmpty) {
      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_offlinearticle'),
          child: _licenseContent(_contentOfflineArticle)
      ));
    }
    if (_contentOfflineBook.isNotEmpty) {
      content.add(GCWExpandableTextDivider(
          expanded: false,
          text: i18n(context, 'toollicenses_offlinebook'),
          child: _licenseContent(_contentOfflineBook)
      ));
    }

    return MainMenuEntryStub(content: Column(
      children: content
    ));
  }
}
