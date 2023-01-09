import 'package:flutter/material.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';

class GCWMainMenuEntryStub extends StatefulWidget {
  final Widget content;

  const GCWMainMenuEntryStub({Key key, this.content}) : super(key: key);

  @override
  GCWMainMenuEntryStubState createState() => GCWMainMenuEntryStubState();
}

class GCWMainMenuEntryStubState extends State<GCWMainMenuEntryStub> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logo/circle_border_128.png',
                width: 100.0,
                height: 100.0,
              ),
            ),
            Container(
              width: 350,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: themeColors().accent(), width: 2),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(ROUNDED_BORDER_RADIUS),
                  ),
                  child: widget.content ?? Container(),
                  padding: EdgeInsets.all(10)),
              padding: EdgeInsets.only(top: 50),
            )
          ],
        )
    );
  }
}
