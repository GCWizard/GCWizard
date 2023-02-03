import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/main_menu/mainmenuentry_stub.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:intl/intl.dart';

final CHANGELOG = {
  '2.3.1': DateTime(2022, 12, 25),
  '2.3.0': DateTime(2022, 11, 30),
  '2.2.1': DateTime(2022, 04, 15),
  '2.2.0': DateTime(2022, 03, 31),
  '2.1.0': DateTime(2021, 12, 22),
  '2.0.1': DateTime(2021, 10, 21),
  '2.0.0': DateTime(2021, 10, 15),
  '1.5.1': DateTime(2021, 05, 10),
  '1.5.0': DateTime(2021, 04, 14),
  '1.4.1': DateTime(2021, 02, 10),
  '1.4.0': DateTime(2021, 02, 3),
  '1.3.0': DateTime(2021, 01, 7),
  '1.2.0': DateTime(2020, 11, 4),
  '1.1.0': DateTime(2020, 9, 8),
  '1.0.0': DateTime(2020, 7, 21),
  '0.8.1': DateTime(2020, 6, 4),
  '0.8.0': DateTime(2020, 5, 28),
  '0.7.1': DateTime(2020, 4, 30),
  '0.7.0': DateTime(2020, 4, 27),
  '0.6.2': DateTime(2020, 4, 9),
  '0.6.1': DateTime(2020, 4, 8),
  '0.6.0': DateTime(2020, 4, 1),
  '0.5.1': DateTime(2020, 3, 20),
  '0.5.0': DateTime(2020, 3, 19),
  '0.4.0': DateTime(2020, 3, 7),
  '0.3.2': DateTime(2020, 2, 18),
  '0.3.0': DateTime(2020, 1, 9),
  '0.0.4': DateTime(2020, 1, 4),
  '0.0.1': DateTime(2019, 12, 28)
};

class Changelog extends StatefulWidget {
  @override
  ChangelogState createState() => ChangelogState();
}

class ChangelogState extends State<Changelog> {
  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('yMd', Localizations.localeOf(context).toString());

    var index = 0;
    var content = Column(
        children: CHANGELOG.entries.map((changelog) {
      return Column(
        children: <Widget>[
          GCWExpandableTextDivider(
            text: '${changelog.key} (${dateFormat.format(changelog.value)})',
            expanded: index++ == 0,
            child: GCWText(text: i18n(context, 'changelog_' + changelog.key)),
          )
        ],
      );
    }).toList());

    return MainMenuEntryStub(content: content);
  }
}
