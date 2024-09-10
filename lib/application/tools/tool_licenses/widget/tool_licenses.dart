import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/tools/tool_licenses/widget/tool_license_types.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';

class ToolLicenses extends StatefulWidget {
  final List<ToolLicenseEntry> licenses;
  const ToolLicenses({Key? key, required this.licenses}) : super(key: key);

  @override
  _ToolLicensesState createState() => _ToolLicensesState();
}

class _ToolLicensesState extends State<ToolLicenses> {
  @override
  Widget build(BuildContext context) {
    return GCWColumnedMultilineOutput(
      data: widget.licenses.map((ToolLicenseEntry license) {
        return [
          Column(
            children: [
              GCWText(text: toolLicenseTypeString(context, license)),
              Container(
                padding: const EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN),
                child: toolLicenseEntry(license.toRow()),
              )
            ],
          ),
        ];
      }).toList(),
    );
  }
}