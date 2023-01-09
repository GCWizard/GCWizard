import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/favorites.dart';
import 'package:gc_wizard/widgets/main_view.dart';
import 'package:gc_wizard/widgets/utils/app_builder.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';
import 'package:prefs/prefs.dart';

class GCWToolList extends StatefulWidget {
  final toolList;
  final Function onChangedFavorite;

  const GCWToolList({Key key, this.toolList, this.onChangedFavorite}) : super(key: key);

  _GCWToolListState createState() => _GCWToolListState();
}

class _GCWToolListState extends State<GCWToolList> {
  @override
  Widget build(BuildContext context) {

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse
        },
      ),
      child: _buildItems(),
    );
  }

  Widget _buildItems() {
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: widget.toolList.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int i) {
        return _buildRow(context, widget.toolList[i]);
      },
    );
  }

  Widget _buildRow(BuildContext context, GCWTool tool) {
    Future _navigateToSubPage(context) async {
      Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => tool));
    }

    return ListTile(
      title: Row(
        children: [
          if (tool.isBeta)
            Container(
              child: Text(
                'BETA',
                style: gcwBetaStyle(),
              ),
              padding: EdgeInsets.symmetric(horizontal: DEFAULT_MARGIN),
              margin: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
              color: themeColors().accent(),
            ),
          Expanded(
            child: Text(
              tool.toolName,
              style: gcwTextStyle(),
            ),
          )
        ],
      ),
      subtitle: _buildSubtitle(context, tool),
      onTap: () {
        setState(() {
          _navigateToSubPage(context);
          refreshToolLists();
          AppBuilder.of(context).rebuild();
        });
      },
      leading: tool.icon,
      trailing: IconButton(
        icon: tool.isFavorite ?? false ? Icon(Icons.star) : Icon(Icons.star_border),
        color: themeColors().mainFont(),
        onPressed: () {
          if (tool.isFavorite) {
            showDeleteAlertDialog(context, tool.toolName, () {
              Favorites.update(tool.id, FavoriteChangeStatus.REMOVE);

              setState(() {
                AppBuilder.of(context).rebuild();
              });
            });
          } else {
            setState(() {
              Favorites.update(tool.id, FavoriteChangeStatus.ADD);

              AppBuilder.of(context).rebuild();
            });
          }
        },
      ),
    );
  }

  _buildSubtitle(BuildContext context, GCWTool tool) {
    var descriptionText;
    if (Prefs.getBool(PREFERENCE_TOOLLIST_SHOW_DESCRIPTIONS) &&
        tool.description != null &&
        tool.description.length > 0) {
      descriptionText = IgnorePointer(
          child: GCWText(
        text: tool.description,
        style: gcwDescriptionTextStyle(),
      ));
    }

    var exampleText;
    if (Prefs.getBool(PREFERENCE_TOOLLIST_SHOW_EXAMPLES) && tool.example != null && tool.example.length > 0) {
      exampleText = IgnorePointer(child: GCWText(text: tool.example, style: gcwDescriptionTextStyle()));
    }

    var content;
    if (exampleText != null && descriptionText != null) {
      content = Column(
        children: [
          descriptionText,
          Container(child: exampleText, padding: EdgeInsets.only(top: DEFAULT_DESCRIPTION_MARGIN))
        ],
      );
    } else if (exampleText != null) {
      content = exampleText;
    } else if (descriptionText != null) {
      content = descriptionText;
    }

    return (exampleText ?? descriptionText) != null
        ? Container(
            child: content,
            padding: EdgeInsets.only(left: 10.0),
          )
        : null;
  }
}
