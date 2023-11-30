import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/shared/style/styles_manager.dart';
import '../constant/padding_margin_values_manager.dart';
import 'colors_manager.dart';
import 'font_manager.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorManager.primary,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(
            backgroundColor: ColorManager.delete,
          foregroundColor: Colors.white
        ),
    // elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s5),side: BorderSide(color: ColorManager.primary, width: 2) )),

          backgroundColor:
              MaterialStateProperty.all<Color>(ColorManager.white)),

    ),
    // text
    textTheme: TextTheme(
      headline1: TextStyle(
          color: ColorManager.primary,
          fontWeight: FontWeight.bold,
          fontSize: AppSize.s35.sp),
      headline2: TextStyle(
          color: ColorManager.white,
          fontWeight: FontWeight.w700,
          fontSize: AppSize.s35.sp,
          fontFamily: FontConstants.fontFamily),
      headline4:
          TextStyle(color: ColorManager.white, fontWeight: FontWeight.bold),
    ),
    // input
  inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.white,

      // content padding
      contentPadding: const EdgeInsets.fromLTRB(AppPadding.p15,AppPadding.p0,AppPadding.p5,AppPadding.p0),
      prefixIconColor: ColorManager.primary,
      // hint style
      hintStyle:
      getRegularStyle(color: ColorManager.primary, fontSize: FontSize.s12),
      labelStyle:
      getMediumStyle(color: ColorManager.primary, fontSize: FontSize.s12),
      errorStyle: getRegularStyle(color: ColorManager.delete),

      // enabled border style
      enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s5))),
      //

      // // focused border style
      focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s5))),

      // // error border style
      errorBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.delete, width: AppSize.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s5))),
      // // focused border style
      focusedErrorBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.white, width: AppSize.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s5)))),
    // done
    );

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: ColorManager.primary,
  floatingActionButtonTheme:
  FloatingActionButtonThemeData(backgroundColor: ColorManager.delete,foregroundColor: Colors.white),
  // elevated button
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s5),side: BorderSide(color: ColorManager.primary, width: 2) )),

        backgroundColor:
        MaterialStateProperty.all<Color>(ColorManager.white)),

  ),
  // text
  textTheme: TextTheme(
    headline1: TextStyle(
        color: ColorManager.primary,
        fontWeight: FontWeight.bold,
        fontSize: 24),
    headline2: TextStyle(
        color: ColorManager.white,
        fontWeight: FontWeight.w700,
        fontSize: 30,
        fontFamily: FontConstants.fontFamily),
    headline4:
    TextStyle(color: ColorManager.white, fontWeight: FontWeight.bold),
  ),
  // input
  inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.white,
      // content padding
      contentPadding: const EdgeInsets.fromLTRB(15,25,10,25),
      // hint style
      hintStyle:
      getRegularStyle(color: ColorManager.primary, fontSize: FontSize.s18),
      labelStyle:
      getMediumStyle(color: ColorManager.primary, fontSize: FontSize.s18),
      errorStyle: getRegularStyle(color: ColorManager.delete),

      // enabled border style
      enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.secondary, width: AppSize.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s5))),
      //

      // // focused border style
      focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s5))),

      // // error border style
      errorBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.delete, width: AppSize.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s5))),
      // // focused border style
      focusedErrorBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.white, width: AppSize.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSize.s5)))),
  // done
);
