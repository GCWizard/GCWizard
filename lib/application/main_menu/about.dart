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

const _ABOUT_MAINTAINER = 'Mark \'S-Man42\' Lorenz';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  late GCWPackageInfo _packageInfo;

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
      padding: const EdgeInsets.only(top: 15, bottom: 10),
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
        const GCWDivider(),
        Container(
            padding: const EdgeInsets.only(top: 15),
            child: Row(children: <Widget>[
              Expanded(flex: 2, child: GCWText(text: i18n(context, 'about_version'))),
              Expanded(flex: 3, child: GCWText(text: '${_packageInfo.version} (Build: ${_packageInfo.buildNumber})'))
            ])),
        Container(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: Row(children: <Widget>[
              Expanded(flex: 2, child: GCWText(text: i18n(context, 'about_creator'))),
              const Expanded(flex: 3, child: GCWText(text: _ABOUT_MAINTAINER))
            ])),
        const GCWDivider(),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: i18n(context, 'about_team') + '\n', style: gcwBoldTextStyle()),
          ], style: gcwTextStyle()),
        ),
        Container(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: Column(
              children: [
                _buildTeamEntries('about_projectlead', PROJECTLEAD),
                _buildTeamEntries('about_development', DEVELOPMENT),
                _buildTeamEntries('about_tests', TESTS),
                _buildTeamEntries('about_manualcreators', MANUALCREATORS),
                _buildTeamEntries('about_misc', MISC),
              ],
            )),
        const GCWDivider(),
        _buildUrl('contact_email'),
        _buildUrl('manual'),
        _buildUrl('faq'),
        _buildUrl('blog'),
        _buildUrl('mastodon'),
        _buildUrl('webversion'),
        const GCWDivider(),
        _buildUrl('license'),
        _buildUrl('github'),
        _buildUrl('crowdin'),
        const GCWDivider(),
        _buildUrl('privacypolicy'),
        const GCWDivider(),
        InkWell(
          child: Container(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
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
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child: Column(
            children: <Widget>[
              _buildOthersEntries('about_specialthanks', SPECIALTHANKS, '\n'),
              _buildOthersEntries('about_contributors', CONTRIBUTORS, '\n'),
              _buildOthersEntries('about_translators', TRANSLATORS, ', '),
              _buildOthersEntries('about_testers', TESTER, ', '),
            ],
          ),
        ),
        const GCWDivider(),
        Container(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child:
              GCWText(align: Alignment.center, textAlign: TextAlign.center, text: '🏳️‍🌈  ' + i18n(context, 'about_notfornazis') + '  🏳️‍🌈'),
        )
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
