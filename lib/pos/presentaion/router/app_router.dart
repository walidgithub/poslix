import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poslix_app/pos/presentaion/ui/intro/intro.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';
import '../../shared/constant/strings_manager.dart';
import '../ui/login_view/login_view.dart';
import '../ui/main_view/main_view.dart';
import '../ui/register_pos_view/register_pos_view.dart';

class Routes {
  static const String mainRoute = "/home";
  static const String orderRoute = "/order";
  static const String thermalPrint = "/thermalPrint";
  static const String loginRoute = "/login";
  static const String registerPosRoute = "/registerPos";
  static const String introRoute = "/intro";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainRoute:
        return isApple() ? CupertinoPageRoute(builder: (_) => MainView()) : MaterialPageRoute(builder: (_) => MainView());
      // case Routes.thermalPrint:
      //   return isApple() ? CupertinoPageRoute(builder: (_) => ThermalPrint(arguments: settings.arguments as GoToThermal)) : MaterialPageRoute(builder: (_) => ThermalPrint(arguments: settings.arguments as GoToThermal));
      case Routes.loginRoute:
        return isApple() ? CupertinoPageRoute(builder: (_) => const LoginView()) : MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.registerPosRoute:
        return isApple() ? CupertinoPageRoute(builder: (_) => const RegisterPosView()) : MaterialPageRoute(builder: (_) => const RegisterPosView());
      case Routes.introRoute:
        return isApple() ? CupertinoPageRoute(builder: (_) => const IntroView()) : MaterialPageRoute(builder: (_) => const IntroView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return isApple() ? CupertinoPageRoute(
      builder: (_) => Scaffold(
          body: Container()),
    ) : MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Container()),
            );
  }
}
