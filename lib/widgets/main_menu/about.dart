import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_divider.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/main_menu/gcw_mainmenuentry_stub.dart';
import 'package:gc_wizard/widgets/main_menu/licenses.dart';
import 'package:gc_wizard/widgets/registry.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';
import 'package:package_info_plus/package_info_plus.dart';

final ABOUT_MAINTAINER = 'Mark \'S-Man42\' Lorenz';

class About extends StatefulWidget {
  @override
  AboutState createState() => AboutState();
}

class AboutState extends State<About> {
  var packageInfo = PackageInfo();

  var boldTextStyle = gcwTextStyle().copyWith(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  _buildUrl(String key) {
    return Container(
        child: Row(children: <Widget>[
          Expanded(child: GCWText(text: i18n(context, 'about_${key}')), flex: 2),
          Expanded(
              child: InkWell(
                child: Text(
                  i18n(context, 'about_${key}_url_text'),
                  style: gcwHyperlinkTextStyle(),
                ),
                onTap: () {
                  launchUrl(Uri.parse(i18n(context, 'about_${key}_url')));
                },
              ),
              flex: 3)
        ]),
        padding: EdgeInsets.only(top: 15, bottom: 10));
  }

  @override
  Widget build(BuildContext context) {
    var content = Column(
      children: <Widget>[
        Text('GC Wizard - Geocache Wizard', style: gcwTextStyle().copyWith(fontWeight: FontWeight.bold)),
        GCWDivider(),
        Container(
            child: Row(children: <Widget>[
              Expanded(child: GCWText(text: i18n(context, 'about_version')), flex: 2),
              Expanded(child: GCWText(text: '${packageInfo.version} (Build: ${packageInfo.buildNumber})'), flex: 3)
            ]),
            padding: EdgeInsets.only(top: 15)),
        Container(
            child: Row(children: <Widget>[
              Expanded(child: GCWText(text: i18n(context, 'about_maintainer')), flex: 2),
              Expanded(child: GCWText(text: ABOUT_MAINTAINER), flex: 3)
            ]),
            padding: EdgeInsets.only(top: 15, bottom: 10)),
        GCWDivider(),
        _buildUrl('contact_email'),
        _buildUrl('manual'),
        _buildUrl('faq'),
        _buildUrl('blog'),
        _buildUrl('twitter'),
        _buildUrl('facebook'),
        _buildUrl('webversion'),
        GCWDivider(),
        _buildUrl('license'),
        _buildUrl('github'),
        _buildUrl('crowdin'),
        GCWDivider(),
        _buildUrl('privacypolicy'),
        GCWDivider(),
        InkWell(
          child: Container(
            child: Align(
              child: Text(
                i18n(context, 'about_thirdparty'),
                style: gcwHyperlinkTextStyle(),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
            ),
            padding: EdgeInsets.only(top: 15, bottom: 10),
          ),
          onTap: () {
            Navigator.of(context).push(NoAnimationMaterialPageRoute(
                builder: (context) =>
                    registeredTools.firstWhere((tool) => className(tool.tool) == className(Licenses()))));
          },
        ),
        GCWDivider(),
        Container(
          child: Column(
            children: <Widget>[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_team') + '\n', style: boldTextStyle),
                  TextSpan(
                      text: [
                            'Andy \'Puma66\' (Special Support)',
                            'Andreas \'TeamBirdy2404\' (Manual & Symbol Tables)',
                            'Mike B. (Code & Symbol Tables)',
                            'Thomas \'TMZ\' Z. (Code & Symbol Tables)',
                          ].join('\n') +
                          '\n')
                ], style: gcwTextStyle()),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_specialthanks') + '\n', style: boldTextStyle),
                  TextSpan(text: 'Daniel \'Eisbehr\' K. (Maintainer GCC)' + '\n')
                ], style: gcwTextStyle()),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_contributors') + '\n', style: boldTextStyle),
                  TextSpan(
                      text: [
                            '\'\xc4ggsb\xe4rde\' (Symbol Tables)',
                            '\'andre0707\' (Day1976 Code)',
                            '\'capoaira\' (Code)',
                            'Dennis \'dennistreysa\' (Code)',
                            'Frank \'Wizardland\' (podKst.de) (Hardware)',
                            '\'Geo-Link\' (Hardware & Symbol Tables)',
                            'Karl B. (Coords Algorithms)',
                            'Ludovic Valente \'LudoO\' (Code & Translation FR)',
                            'Michael D. (Symbol Tables)',
                            'Nina \'nike1972\' G. (Nina\'s Schmierblo(g)ck) (Manual)',
                            '\'moenk\' (GK Coords)',
                            '\'radioscout\' (Research)',
                            '\'Schnatt\' (Symbol Tables)',
                            'Udo J. (Code)',
                            '\'wollpirat\' (Food, Tea & more)'
                          ].join('\n') +
                          '\n'),
                ], style: gcwTextStyle()),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_translators') + '\n', style: boldTextStyle),
                  TextSpan(
                      text: [
                            '\'alantheandroid\' (IT)',
                            '\'alexgonc\' (PT, ES)',
                            '\'bimsor\' (DK)',
                            'Cavit A. (TR)',
                            '\'crazedllama\' (KO)',
                            '\'drobec\' (SK)',
                            '\'emrszon\' (ES)',
                            '\'hakuchi\' (IT)',
                            '\'Henrike71\' (NL, SV)',
                            'Igor Č. (SK)',
                            '\'j_janus\' (PL)',
                            'Joao F. (PT)',
                            '\'Johan-V\' (NL)',
                            '\'juroot\' (SK)',
                            '\'MAJ\' (ES)',
                            '\'Martanal (CZ)\'',
                            '\'n3oklan\' (CZ)',
                            'Paul Z. (NL)',
                            'Paweł B. (PL)',
                            '\'QouiZ\' (EL)',
                            '\'proXmiii\' (SK)',
                            '\'S182\' (IT)',
                            'Silvia O. (SK)',
                            '\'tkemer\' (EL)',
                            '\'Todclerc\' (NL)',
                            '\'verturin\' (FR, IT)',
                            '\'vike91\' (FI)',
                            '\'Vojta_\' (CZ)',
                            '\'Willa_Lecznica\' (PL)',
                            '\'Xoyn\' (RU)',
                          ].join(', ') +
                          '\n')
                ], style: gcwTextStyle()),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: i18n(context, 'about_testers') + '\n', style: boldTextStyle),
                  TextSpan(
                      text: [
                    '\'4-Everus\'',
                    '\'83_Seth\'',
                    'Andreas E.',
                    '\'baer2006\'',
                    '\'Cycle73\'',
                    '\'Don Rodolphos\'',
                    '\'Headbanger-Berlin\'',
                    'Felix Z.',
                    '\'Filu - Aye, Käppn! - 43\' & \'Stormi - Aaarrh - 2061\'',
                    '\'finding tresor\'',
                    '\'Flosphor\'',
                    'Franz K.',
                    '\'Freakyfinder\'',
                    '\'GrafZahl75\'',
                    '\'hwi\'',
                    'Isidore S.',
                    'Johannes C.',
                    'Jonas M.',
                    '\'kinderarzt\'',
                    '\'Klumpenkukuk\'',
                    '\'LupiMus\'',
                    'Lutz \'DL3BZZ\'',
                    '\'mahoplus\'',
                    'Markus M.',
                    'Martin Sch.',
                    'Martina F.',
                    '\'mgo\'',
                    'Michael St.',
                    '\'Mondlinger\'',
                    '\'MrDosinger\' & \'MsDosinger\'',
                    '\'Nebelsturm\'',
                    'Niki R.',
                    'Palk \'geogedoens.de\'',
                    '\'Pamakaru\'',
                    'Pascal M.',
                    'Peter S.-H.',
                    '\'radlerandi\'',
                    'Richard M.',
                    '\'schatzi-s\'',
                    '\'Sechsfüssler\'',
                    'Stefan J.',
                    'Stefan K.',
                    'Team \'kesteri\'',
                    'Thomas B.',
                    '\'tebarius\'',
                    '\'tomcat06\'',
                    '\'Vyrembi\'',
                    '\'WeinWalker\'',
                    '\'zoRRo\''
                  ].join(', '))
                ], style: gcwTextStyle()),
              ),
            ],
          ),
          padding: EdgeInsets.only(top: 15, bottom: 10),
        ),
        GCWDivider(),
        Container(
          child:
              GCWText(align: Alignment.center, textAlign: TextAlign.center, text: i18n(context, 'about_notfornazis')),
          padding: EdgeInsets.only(top: 15, bottom: 10),
        )
      ],
    );

    return GCWMainMenuEntryStub(content: content);
  }
}
