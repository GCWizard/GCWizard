import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';

class MainMenuEntryStub extends StatefulWidget {
  final Widget content;

  const MainMenuEntryStub({Key? key, required this.content}) : super(key: key);

  @override
  _MainMenuEntryStubState createState() => _MainMenuEntryStubState();
}

class _MainMenuEntryStubState extends State<MainMenuEntryStub> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                applogoFilename(),
                width: 100.0,
                height: 100.0,
              ),
            ),
            Container(
              width: 350,
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: themeColors().secondary(), width: 2),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(ROUNDED_BORDER_RADIUS),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: widget.content),
            )
          ],
        ));
  }
}
