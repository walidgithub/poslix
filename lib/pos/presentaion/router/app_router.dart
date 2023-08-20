import 'package:flutter/material.dart';
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
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => MainView());
      // case Routes.thermalPrint:
      //   return MaterialPageRoute(builder: (_) => ThermalPrint(arguments: settings.arguments as GoToThermal));
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.registerPosRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPosView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Container()),
            );
  }
}
