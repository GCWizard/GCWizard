import 'package:flutter/material.dart';
import 'package:gc_wizard/application/_common/gcw_package_info.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/licenses.dart';
import 'package:gc_wizard/application/main_menu/mainmenuentry_stub.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

const _ABOUT_MAINTAINER = 'Mark \'S-Man42\' Lorenz';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

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
              Expanded(flex: 2, child: GCWText(text: i18n(context, 'about_maintainer'))),
              const Expanded(flex: 3, child: GCWText(text: _ABOUT_MAINTAINER))
            ])),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: i18n(context, 'about_team') + '\n', style: gcwBoldTextStyle()),
            TextSpan(
                text: [
                  'Andy \'Puma66\' (Special Support)',
                  'Andreas \'TeamBirdy2404\'',
                  'Mike B. (Code)',
                  'Thomas \'TMZ\' Z. (Code & Manual)',
                  'Maria \'Nebelsturm\' (Test)',
                  'Henrike \'69and71\' (Translations)',
                  'Marcia \'Linsty\' (Test)',
                  'Olli \'Rinser\' (Code)',
                ].join('\n') +
                    '\n')
          ], style: gcwTextStyle()),
        ),
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
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_specialthanks') + '\n', style: gcwBoldTextStyle()),
                  const TextSpan(text: 'Daniel \'Eisbehr\' K. (Maintainer GCC)' '\n')
                ], style: gcwTextStyle()),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_contributors') + '\n', style: gcwBoldTextStyle()),
                  TextSpan(
                      text: [
                            '\xc4ggsb\xe4rde (Symbol Tables)',
                            'andre0707 (Day1976 Code)',
                            'capoaira (Code)',
                            'Dennis \'dennistreysa\' (Code)',
                            'Frank \'Wizardland\' (podKst.de) (Hardware)',
                            'Geo-Link (Hardware & Symbol Tables)',
                            'Karl B. (Coords Algorithms)',
                            'Ludovic \'LudoO\' Valente (Code & Translation FR)',
                            'Michael D. (Symbol Tables)',
                            'Nina \'nike1972\' G. (Nina\'s Schmierblo(g)ck) (Manual)',
                            'moenk (GK Coords)',
                            'radioscout (Research)',
                            'Schnatt (Symbol Tables)',
                            'Udo J. (Code)',
                            'wollpirat (Food, Tea & more)'
                          ].join('\n') +
                          '\n'),
                ], style: gcwTextStyle()),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_translators') + '\n', style: gcwBoldTextStyle()),
                  TextSpan(
                      text: [
                            'alantheandroid (IT)',
                            'alexgonc (PT, ES)',
                            'bimsor (DK)',
                            'Cavit A. (TR)',
                            'crazedllama (KO)',
                            'DrakeZero (ES)',
                            'drobec (SK)',
                            'emrszon (ES)',
                            'hakuchi (IT)',
                            '69and71 (NL, SV)',
                            'Igor Č. (SK)',
                            'j_janus (PL)',
                            'Joao F. (PT)',
                            'Johan-V (NL)',
                            'juroot (SK)',
                            'MAJ (ES)',
                            'Martanal (CZ)',
                            'n3oklan (CZ)',
                            'Paul Z. (NL)',
                            'Paweł B. (PL)',
                            'proXmiii (SK)',
                            'przematcr (PL)',
                            'QouiZ (EL)',
                            'S182 (IT)',
                            'Silvia O. (SK)',
                            'tkemer (EL)',
                            'Todclerc (NL)',
                            'verturin (FR, IT)',
                            'vike91 (FI)',
                            'Vojta_ (CZ)',
                            'Willa_Lecznica (PL)',
                            'Xoyn (RU)',
                          ].join(', ') +
                          '\n')
                ], style: gcwTextStyle()),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_testers') + '\n', style: gcwBoldTextStyle()),
                  TextSpan(
                      text: [
                    '4-Everus',
                    '83_Seth',
                    'Amelie2401',
                    'Andreas E.',
                    'Andreas L.',
                    'baer2006',
                    'Bleg1966',
                    'Cycle73',
                    'Dawn T.',
                    'Don Rodolphos',
                    'Headbanger-Berlin',
                    'Felix Z.',
                    'ferrrix',
                    'Filu \'Aye, Käppn!\' 43 & Stormi \'Aaarrh\' 2061',
                    'finding tresor',
                    'Flosphor',
                    'Franz K.',
                    'Freakyfinder',
                    'geo_aug',
                    'GrafZahl75',
                    'hwi',
                    'Isidore S.',
                    'JanRei',
                    'Johannes C.',
                    'Jonas M.',
                    'kinderarzt',
                    'Klumpenkukuk',
                    'Lue',
                    'LupiMus',
                    'Lutz \'DL3BZZ\'',
                    'mahoplus',
                    'Markus M.',
                    'Martin Sch.',
                    'Martina F.',
                    'mgo',
                    'MicDie',
                    'Michael St.',
                    'Mondlinger',
                    'MrDosinger & MsDosinger',
                    'musketon',
                    'Niki R.',
                    'Palk \'geogedoens.de\'',
                    'Pamakaru',
                    'Pascal M.',
                    'Peter S.-H.',
                    'radlerandi',
                    'Richard M.',
                    'schatzi-s',
                    'Sechsfüssler',
                    'Stefan J.',
                    'Stefan K.',
                    'Team kesteri',
                    'Thomas B.',
                    'tebarius',
                    'tomcat06',
                    'trekkiefreak76',
                    'Vlad_Tepes',
                    'Vyrembi',
                    'waldstadt',
                    'WeinWalker',
                    'WingsAndTales',
                    'zoRRo'
                  ].join(', '))
                ], style: gcwTextStyle()),
              ),
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
}
