import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:poslix_app/pos/presentaion/ui/login_view/widgets/email_text.dart';
import 'package:poslix_app/pos/presentaion/ui/login_view/widgets/left_part.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/tailor_dialog.dart';

import '../../../domain/requests/user_model.dart';
import '../../../shared/constant/assets_manager.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/language_manager.dart';
import '../../../shared/constant/padding_margin_values_manager.dart';
import '../../../shared/constant/strings_manager.dart';
import '../../../shared/preferences/app_pref.dart';
import '../../../shared/style/colors_manager.dart';
import '../../di/di.dart';
import '../../router/app_router.dart';
import '../components/container_component.dart';
import '../popup_dialogs/custom_dialog.dart';
import '../popup_dialogs/loading_dialog.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_state.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _loginEmailEditingController =
      TextEditingController();
  final TextEditingController _loginPassEditingController =
      TextEditingController();

  final FocusNode _loginEmailFN = FocusNode();
  final FocusNode _loginPassFN = FocusNode();

  RegExp regexMail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  GlobalKey<FormState> _loginFormKey = GlobalKey();
  GlobalKey<FormState> _regitserFormKey = GlobalKey();

  final AppPreferences _appPreferences = sl<AppPreferences>();

  bool? login;

  bool openedRegister = false;

  goNext() {
    _appPreferences.isUserOpenedRegister().then((isUserOpenedRegister) => {
          if (isUserOpenedRegister)
            {openedRegister = true}
          else
            {openedRegister = false}
        });
  }

  @override
  void dispose() {
    _loginEmailEditingController.dispose();
    _loginPassEditingController.dispose();
    super.dispose();
  }

  bool showPass = false;

  @override
  void initState() {
    login = true;
    goNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorManager.secondary,
      body: bodyContent(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _changeLanguage();
          });
        },
        backgroundColor: ColorManager.primary,
        child: SvgPicture.asset(
          ImageAssets.language,
          width: AppSize.s25,
          color: ColorManager.white,
        ),
      ),
    ));
  }

  Widget bodyContent(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginNoInternetState) {
            CustomDialog.show(
                context,
                AppStrings.noInternet.tr(),
                const Icon(Icons.wifi),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          }

          if (state is LoginLoading) {
            LoadingDialog.show(context);
          } else if (state is LoginSucceed) {
            _appPreferences.setUserLoggedIn();
            await _appPreferences.setToken(LOGGED_IN_TOKEN, state.token);

            LoadingDialog.hide(context);

            await Future.delayed(const Duration(seconds: 2));

            Navigator.of(context).pushReplacementNamed(
                openedRegister ? Routes.mainRoute : Routes.registerPosRoute);
          } else if (state is WrongEmailOrPass) {
            LoadingDialog.hide(context);
            CustomDialog.show(
                context,
                AppStrings.wrongEmailOrPassword.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          } else if (state is LoginFailed) {
            LoadingDialog.hide(context);
            CustomDialog.show(
                context,
                AppStrings.errorTryAgain.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        leftPart(context),
                        SizedBox(
                          width: AppConstants.smallDistance,
                        ),
                        rightPart(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          // --------------------------------------------------------------------------------------------------
        },
      ),
    );
  }

  // right part ------------------------------------------------------
  Widget rightPart(BuildContext context) {
    return Expanded(
        flex: 1,
        child: containerComponent(
            context,
            Column(
              children: [
                SizedBox(
                  height: AppConstants.heightBetweenElements,
                ),
                Image.asset(
                  ImageAssets.logo,
                  width: 60.w,
                  height: 60.h,
                ),
                SizedBox(
                  height: AppConstants.bigHeightBetweenElements,
                ),
                Text(
                  AppStrings.welcomeBack.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.s20.sp,
                      color: ColorManager.black),
                ),
                SizedBox(
                  height: AppConstants.smallDistance,
                ),
                Text(
                  AppStrings.toStartWorkingFirstLogin.tr(),
                  style: TextStyle(
                      fontSize: AppSize.s14.sp, color: ColorManager.black),
                ),
                SizedBox(
                  height: AppConstants.heightBetweenElements,
                ),
                login!
                    ? SizedBox(
                        height: 120.h,
                        child: Form(
                          key: _loginFormKey,
                          child: Column(
                            children: [
                              emailText(context, regexMail, _loginPassFN,
                                  _loginEmailFN, _loginEmailEditingController),
                              SizedBox(
                                height: AppConstants.smallDistance,
                              ),
                              passText(context)
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: AppConstants.heightBetweenElements,
                ),

                // sign in
                buttons(context)
              ],
            ),
            padding: const EdgeInsets.all(AppPadding.p20),
            height: MediaQuery.of(context).size.height - 40.h,
            color: ColorManager.white,
            borderRadius: AppSize.s5,
            borderColor: ColorManager.white,
            borderWidth: 0));
  }

  Widget passText(BuildContext context) {
    return Expanded(
      flex: 1,
      child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return AppStrings.passwordFieldIsRequired.tr();
            }
          },
          focusNode: _loginPassFN,
          autofocus: false,
          keyboardType: TextInputType.visiblePassword,
          controller: _loginPassEditingController,
          obscureText: !showPass,
          decoration: InputDecoration(
              errorStyle: const TextStyle(
                height: AppSize.s16,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showPass = !showPass;
                  });
                },
                icon: Icon(
                  showPass ? Icons.visibility : Icons.visibility_off,
                  size: AppSize.s25,
                  color: ColorManager.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorManager.grayText, width: AppSize.s1_5),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppSize.s5))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorManager.grayText, width: AppSize.s1_5),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppSize.s5))),
              hintText: AppStrings.enterPassword.tr(),
              hintStyle: TextStyle(fontSize: AppSize.s12.sp),
              labelText: AppStrings.enterPassword.tr(),
              labelStyle:
                  TextStyle(fontSize: AppSize.s15.sp, color: ColorManager.gray),
              border: InputBorder.none)),
    );
  }

  Widget buttons(BuildContext context) {
    return Bounceable(
      duration: const Duration(milliseconds: 300),
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 200));

        // TailorDialog.show(context, '44', 2, [], 'ccc', ['length', 'shoulder', 'chest', 'west'], [
        //   {'name': 'fabric one', 'image': 'n'},
        //   {'name': 'fabric two', 'image': 'n'},
        //   {'name': 'fabric three', 'image': 'n'},
        // ], 'ffff', 1);

        if (_loginFormKey.currentState!.validate()) {
          UserRequest userRequest = UserRequest(
              email: _loginEmailEditingController.text,
              password: _loginPassEditingController.text);

          await _appPreferences.setUserName(
              USER_NAME, _loginEmailEditingController.text);
          await _appPreferences.setPassword(
              PASS, _loginPassEditingController.text);

          LoginCubit.get(context).login(userRequest);
        }
      },
      child: containerComponent(
          context,
          Center(
              child: Text(
            login! ? AppStrings.signIn.tr() : AppStrings.signUp.tr(),
            style:
                TextStyle(fontSize: AppSize.s20.sp, color: ColorManager.white),
            textAlign: TextAlign.center,
          )),
          height: 50.h,
          color: ColorManager.primary,
          borderRadius: AppSize.s5,
          borderColor: ColorManager.primary,
          borderWidth: 1.w),
    );
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }
}
