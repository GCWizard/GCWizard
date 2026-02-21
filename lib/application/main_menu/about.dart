import 'package:flutter/material.dart';
import 'package:gc_wizard/application/_common/gcw_package_info.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/licenses.dart';
import 'package:gc_wizard/application/main_menu/mainmenuentry_stub.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

part 'about_data.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  late GCWPackageInfo _packageInfo;

  final _PADDING_CONTAINER = EdgeInsets.only(top: 15, bottom: 10);

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  void _initPackageInfo() {
    _packageInfo = GCWPackageInfo.getInstance();
  }

  Container _buildUrl(String key) {
    return Container(
      padding: _PADDING_CONTAINER,
      child: Row(children: <Widget>[
        Expanded(flex: 2, child: GCWText(text: i18n(context, 'about_$key'))),
        Expanded(
          flex: 3,
          child: buildUrl(
            i18n(context, 'about_${key}_url_text'),
            i18n(context, 'about_${key}_url')
          )
        )
      ]));
  }

  @override
  Widget build(BuildContext context) {
    var content = Column(
      children: <Widget>[
        Text(GCWPackageInfo.getInstance().appName, style: gcwTextStyle().copyWith(fontWeight: FontWeight.bold, fontSize: defaultFontSize() + 5)),
        const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
        Container(
            padding: _PADDING_CONTAINER,
            child: Row(children: <Widget>[
              Expanded(flex: 2, child: GCWText(text: i18n(context, 'about_version'))),
              Expanded(flex: 3, child: GCWText(text: '${_packageInfo.version} (Build: ${_packageInfo.buildNumber})'))
            ])),
        const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: i18n(context, 'about_team') + '\n', style: gcwBoldTextStyle()),
          ], style: gcwTextStyle()),
        ),
        Container(
            padding: _PADDING_CONTAINER,
            child: Column(
              children: [
                _buildTeamEntries('about_projectlead', _ABOUT_PROJECTLEAD),
                _buildTeamEntries('about_development', _ABOUT_DEVELOPMENT),
                _buildTeamEntries('about_tests', _ABOUT_TESTS),
                _buildTeamEntries('about_manualcreators', _ABOUT_MANUALCREATORS),
                _buildTeamEntries('about_misc', _ABOUT_MISC),
              ],
            )),
        const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
        Container(
          padding: _PADDING_CONTAINER,
          child: Column(
            children: <Widget>[
              _buildOthersEntries('about_creator', _ABOUT_CREATOR, '\n'),
            ]
          ),
        ),
        const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
        Container(
          padding: _PADDING_CONTAINER,
          child:
          GCWText(align: Alignment.center, textAlign: TextAlign.center, text: '🏳️‍🌈  ' + i18n(context, 'about_notfornazis') + '  🏳️‍🌈'),
        ),
        const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
        _buildUrl('contact_email'),
        _buildUrl('manual'),
        _buildUrl('faq'),
        _buildUrl('blog'),
        _buildUrl('mastodon'),
        _buildUrl('webversion'),
        const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
        _buildUrl('license'),
        _buildUrl('github'),
        _buildUrl('crowdin'),
        const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
        _buildUrl('privacypolicy'),
        const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
        InkWell(
          child: Container(
            padding: _PADDING_CONTAINER,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                i18n(context, 'about_thirdparty'),
                style: gcwHyperlinkTextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
                builder: (context) =>
                    registeredTools.firstWhere((tool) => className(tool.tool) == className(const Licenses()))));
          },
        ),
        const GCWDivider(),
        Container(
          padding: _PADDING_CONTAINER,
          child: Column(
            children: <Widget>[
              _buildOthersEntries('about_specialthanks', _ABOUT_SPECIALTHANKS, '\n'),
              _buildOthersEntries('about_contributors', _ABOUT_CONTRIBUTORS, '\n'),
              _buildOthersEntries('about_translators', _ABOUT_TRANSLATORS, ', '),
              _buildOthersEntries('about_testers', _ABOUT_TESTER, ', '),
            ],
          ),
        ),
      ],
    );

    return MainMenuEntryStub(content: content);
  }

  Widget _buildTeamEntries(String key, List<String> participants) {
    var spaceHeight = 25.0;

    return
      Column(
          children: [
            Row(children: <Widget>[
              Expanded(flex: 2, child: GCWText(text: i18n(context, key))),
              Expanded(flex: 3, child: GCWText(text: participants.join('\n'))),
            ]),
            key != 'about_misc' ? Container(height: spaceHeight) : Container()
          ]);
  }

  Widget _buildOthersEntries(String key, List<String> participants, String delimiter) {
    return
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(text: i18n(context, key) + '\n', style: gcwBoldTextStyle()),
          TextSpan(text: participants.join(delimiter) + '\n')
        ], style: gcwTextStyle()),
      );
  }
}
