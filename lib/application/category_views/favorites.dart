import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:prefs/prefs.dart';

enum FavoriteChangeStatus { ADD, REMOVE }

class Favorites {
  static List<String> favoritedToolList;

  static update(String toolId, FavoriteChangeStatus change) {
    var changed = false;
    switch (change) {
      case FavoriteChangeStatus.ADD:
        if (!favoritedToolList.contains(toolId)) {
          favoritedToolList.add(toolId);
          changed = true;
        }
        break;
      case FavoriteChangeStatus.REMOVE:
        while (favoritedToolList.contains(toolId)) {
          favoritedToolList.remove(toolId);
          changed = true;
        }
        break;
    }

    if (changed) Prefs.setStringList(PREFERENCE_FAVORITES, favoritedToolList);
  }

  static initialize() {
    favoritedToolList = Prefs.getStringList(PREFERENCE_FAVORITES);
  }

  static bool isFavorite(String toolId) {
    return favoritedToolList.contains(toolId);
  }

  static List<GCWTool> favoritedGCWTools() {
    var gcwTools = registeredTools.where((tool) => favoritedToolList.contains(tool.id)).toList();
    gcwTools.sort((a, b) => sortToolList(a, b));

    return gcwTools;
  }
}
