import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/tools/general_tools/gcwizardscript/logic/gcwizard_script.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class GCWizardScriptHelp extends StatefulWidget {
  const GCWizardScriptHelp({Key? key}) : super(key: key);

  @override
  _GCWizardScriptHelpState createState() => _GCWizardScriptHelpState();
}

class _GCWizardScriptHelpState extends State<GCWizardScriptHelp> {
  @override
  void initState() {
    super.initState();
  }

  Container _buildUrl(int key) {
    return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: InkWell(
                child: Text(
                  i18n(context, GCW_SKRIPT_HELP_URLS[key]![0]),
                  style: const TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                ),
                onTap: () {
                  launchUrl(Uri.parse(GCW_SKRIPT_HELP_URLS[key]![1]));
                },
              ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    var content = Column(
      children: <Widget>[
        _buildUrl(GCWIZARDSCRIPT_HELP_EXAMPLES),
        const GCWDivider(),
        _buildUrl(GCWIZARDSCRIPT_HELP_VARIABLE),
        _buildUrl(GCWIZARDSCRIPT_HELP_DATATYPES),
        _buildUrl(GCWIZARDSCRIPT_HELP_OPERATORS),
        _buildUrl(GCWIZARDSCRIPT_HELP_COMMANDS),
        _buildUrl(GCWIZARDSCRIPT_HELP_CONTROLS),
        _buildUrl(GCWIZARDSCRIPT_HELP_MATH),
        _buildUrl(GCWIZARDSCRIPT_HELP_STRINGS),
        _buildUrl(GCWIZARDSCRIPT_HELP_LISTS),
        _buildUrl(GCWIZARDSCRIPT_HELP_FILES),
        _buildUrl(GCWIZARDSCRIPT_HELP_DATE),
        _buildUrl(GCWIZARDSCRIPT_HELP_GRAPHIC),
        _buildUrl(GCWIZARDSCRIPT_HELP_WPTS),
        _buildUrl(GCWIZARDSCRIPT_HELP_COORD),
      ],
    );

    return content;
    //return MainMenuEntryStub(content: content);
  }
}
