import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/about.dart';
import 'package:gc_wizard/application/main_menu/mainmenuentry_stub.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class CallForContribution extends StatefulWidget {
  @override
  CallForContributionState createState() => CallForContributionState();
}

class CallForContributionState extends State<CallForContribution> {
  @override
  Widget build(BuildContext context) {
    var boldTextStyle = gcwTextStyle().copyWith(fontWeight: FontWeight.bold);

    var content = RichText(
      text: TextSpan(children: [
        TextSpan(text: i18n(context, 'callforcontribution_1'), style: boldTextStyle),
        TextSpan(text: i18n(context, 'callforcontribution_2')),
        TextSpan(text: i18n(context, 'callforcontribution_3'), style: boldTextStyle),
        TextSpan(text: i18n(context, 'callforcontribution_4')),
        TextSpan(text: i18n(context, 'callforcontribution_5'), style: boldTextStyle),
        TextSpan(
          text: i18n(context, 'callforcontribution_6'),
        ),
        TextSpan(
            text: i18n(context, 'callforcontribution_7'),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri.parse('https://github.com/S-Man42/GCWizard'));
              },
            style: gcwHyperlinkTextStyle()),
        TextSpan(
          text: i18n(context, 'callforcontribution_8'),
        ),
        TextSpan(text: i18n(context, 'callforcontribution_9'), style: boldTextStyle),
        TextSpan(
          text: i18n(context, 'callforcontribution_10'),
        ),
        TextSpan(text: i18n(context, 'callforcontribution_11'), style: boldTextStyle),
        TextSpan(
          text: i18n(context, 'callforcontribution_12'),
        ),
        TextSpan(
          text: i18n(context, 'callforcontribution_13'),
        ),
        TextSpan(text: i18n(context, 'callforcontribution_14'), style: boldTextStyle),
        TextSpan(
          text: i18n(context, 'callforcontribution_15'),
        ),
        TextSpan(text: i18n(context, 'callforcontribution_16'), style: boldTextStyle),
        TextSpan(
          text: i18n(context, 'callforcontribution_17'),
        ),
        TextSpan(text: i18n(context, 'callforcontribution_18'), style: boldTextStyle),
        TextSpan(
          text: i18n(context, 'callforcontribution_19'),
        ),
        TextSpan(text: i18n(context, 'callforcontribution_20'), style: boldTextStyle),
        TextSpan(
          text: i18n(context, 'callforcontribution_21'),
        ),
        TextSpan(text: i18n(context, 'callforcontribution_22'), style: boldTextStyle),
        TextSpan(
          text: i18n(context, 'callforcontribution_23'),
        ),
        TextSpan(
            text: i18n(context, 'callforcontribution_24'),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(NoAnimationMaterialPageRoute(
                    builder: (context) =>
                        registeredTools.firstWhere((tool) => className(tool.tool) == className(About()))));
              },
            style: gcwHyperlinkTextStyle()),
        TextSpan(text: i18n(context, 'callforcontribution_25'), style: boldTextStyle),
      ], style: gcwTextStyle()),
    );

    return MainMenuEntryStub(
        content: Column(
      children: [
        InkWell(
          child: Text(
            i18n(context, 'callforcontribution_coffee'),
            style: gcwHyperlinkTextStyle().copyWith(fontSize: defaultFontSize() + 2),
          ),
          onTap: () {
            launchUrl(Uri.parse(i18n(context, 'common_support_link')));
          },
        ),
        GCWDivider(),
        content
      ],
    ));
  }
}
