import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:prefs/prefs.dart';

enum FavoriteChangeStatus { ADD, REMOVE }

class Favorites {
  static List<String> _favoritedToolList = [];

  static void update(String toolId, FavoriteChangeStatus change) {
    var changed = false;
    switch (change) {
      case FavoriteChangeStatus.ADD:
        if (!_favoritedToolList.contains(toolId)) {
          _favoritedToolList.add(toolId);
          changed = true;
        }
        break;
      case FavoriteChangeStatus.REMOVE:
        while (_favoritedToolList.contains(toolId)) {
          _favoritedToolList.remove(toolId);
          changed = true;
        }
        break;
    }

    if (changed) Prefs.setStringList(PREFERENCE_FAVORITES, _favoritedToolList);
  }

  static void initialize() {
    _favoritedToolList = Prefs.getStringList(PREFERENCE_FAVORITES);
  }

  static bool isFavorite(String toolId) {
    return _favoritedToolList.contains(toolId);
  }

  static List<GCWTool> favoritedGCWTools() {
    var gcwTools = registeredTools.where((tool) => _favoritedToolList.contains(tool.longId)).toList();
    gcwTools.sort((a, b) => sortToolList(a, b));

    return gcwTools;
  }
}
