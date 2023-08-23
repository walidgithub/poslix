import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/di/di.dart';
import 'package:poslix_app/pos/presentaion/router/app_router.dart';
import 'package:poslix_app/pos/shared/constant/language_manager.dart';
import 'package:poslix_app/pos/shared/preferences/app_pref.dart';
import 'package:poslix_app/pos/shared/style/theme_constants.dart';
import 'package:poslix_app/pos/shared/style/theme_manager.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ServiceLocator().init();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: []
  );

  runApp(EasyLocalization(
      supportedLocales: const [ARABIC_LOCAL, ENGLISH_LOCAL],
      path: ASSET_PATH_LOCALISATIONS,
      child: Phoenix(child: const MyApp())));

  // ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
  //   body: Center(
  //     child: Text(AppStrings.price.tr(),style: TextStyle(color: ColorManager.primary),),
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = sl<AppPreferences>();
  final ThemeManager _themeManager = sl<ThemeManager>();

  bool loggedIn = false;
  bool openedRegister = false;

  goNext() {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) => {
      if (isUserLoggedIn)
        {loggedIn = true}
      else
        {loggedIn = false}
    });

    _appPreferences.isUserOpenedRegister().then((isUserOpenedRegister) => {
      if (isUserOpenedRegister)
        {openedRegister = true}
      else
        {openedRegister = false}
    });
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    goNext();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    _appPreferences.isThemeDark().then((value) => {_themeManager.toggleTheme(value)});
    super.didChangeDependencies();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return isApple() ? const CupertinoApp() : MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Poslix App',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeManager.themeMode,
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: loggedIn ? openedRegister ? Routes.mainRoute : Routes.registerPosRoute : Routes.loginRoute,
        );
      });
  }
}
