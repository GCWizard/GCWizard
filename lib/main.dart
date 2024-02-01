import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gc_wizard/application/_common/gcw_package_info.dart';
import 'package:gc_wizard/application/app_builder.dart';
import 'package:gc_wizard/application/i18n/logic/app_language.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/i18n/logic/supported_locales.dart';
import 'package:gc_wizard/application/navigation/navigation_service.dart';
import 'package:gc_wizard/application/settings/logic/default_settings.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/webapi/deeplinks/deeplinks.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard_editor.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:prefs/prefs.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.init();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  initializePreferences();

  await GCWPackageInfo.init();

  runApp(App(
    appLanguage: appLanguage
  ));
}

class App extends StatelessWidget {
  final AppLanguage appLanguage;

  const App({Key? key, required this.appLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
        create: (_) => appLanguage,
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return AppBuilder(builder: (context) {
            return MaterialApp(
                title: GCWPackageInfo.getInstance().appName,
                supportedLocales: SUPPORTED_LOCALES.keys,
                locale: model.appLocal,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                theme: buildTheme(),
                debugShowCheckedModeBanner: false,
                navigatorKey: NavigationService.instance.navigationKey,
                routes: {
                  // Required extra way because normal Navigator.of(context) way
                  // crashes because of some NULL problems on TextSelectionControls menu
                  clipboard_editor: (BuildContext context) => GCWTool(
                      tool: const GCWClipboardEditor(), toolName: i18n(context, 'clipboardeditor_title'), id: ''),
                },
                onGenerateInitialRoutes: (route) => startMainView(context, route),
                onGenerateRoute: (RouteSettings settings) {
                  return createRoute(context, settings);
                });
          });
        }));
  }
}
