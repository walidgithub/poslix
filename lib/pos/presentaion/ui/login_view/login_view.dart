import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:poslix_app/pos/presentaion/ui/login_view/widgets/email_text_field.dart';
import 'package:poslix_app/pos/presentaion/ui/login_view/widgets/left_part.dart';
import 'package:poslix_app/pos/presentaion/ui/login_view/widgets/login_button.dart';
import 'package:poslix_app/pos/presentaion/ui/login_view/widgets/pass_text_field.dart';

import '../../../domain/requests/user_model.dart';
import '../../../shared/constant/assets_manager.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/language_manager.dart';
import '../../../shared/constant/padding_margin_values_manager.dart';
import '../../../shared/constant/strings_manager.dart';
import '../../../shared/preferences/app_pref.dart';
import '../../../shared/style/colors_manager.dart';
import '../../../shared/utils/utils.dart';
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

  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  final AppPreferences _appPreferences = sl<AppPreferences>();

  bool? login;

  bool openedRegister = false;

  bool keyPadOn = false;

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

  double? deviceWidth;

  bool showPass = false;

  @override
  void initState() {
    login = true;
    goNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = getDeviceWidth(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorManager.secondary,
        body: KeyboardVisibility(
            onChanged: (bool visible) {
              setState(() {
                keyPadOn = visible;
              });
            },
            child: bodyContent(context)),
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
      )),
    );
  }

  Widget bodyContent(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginNoInternetState) {
            showNoInternet(context);
          }

          if (state is LoginLoading) {
            LoadingDialog.show(context);
          } else if (state is LoginSucceed) {
            _appPreferences.setUserLoggedIn();
            await _appPreferences.setToken(LOGGED_IN_TOKEN, state.token);

            LoadingDialog.hide(context);

            await Future.delayed(const Duration(seconds: 2));

            Navigator.of(context).pushReplacementNamed(
                openedRegister ? Routes.mainRoute : Routes.introRoute);
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
            tryAgainLater(context);
          }
        },
        builder: (context, state) {
          return OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              if (deviceWidth! < 600) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              }
            } else if (orientation == Orientation.landscape) {
              if (deviceWidth! < 800) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              }
            }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p20),
              child: Column(
                children: [
                  Row(
                    children: [
                      deviceWidth! <= 600 ? Container() : leftPart(context),
                      deviceWidth! <= 600
                          ? Container()
                          : SizedBox(
                              width: AppConstants.smallDistance,
                            ),
                      rightPart(context),
                    ],
                  ),
                ],
              ),
            ),
          );
    });
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
            SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  SizedBox(
                    height: AppConstants.heightBetweenElements,
                  ),
                  Image.asset(
                    ImageAssets.logo,
                    width: deviceWidth! <= 600 ? 150.w : 60.w,
                    height: deviceWidth! <= 600 ? 150.h : 60.h,
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
                                emailText(
                                    context,
                                    regexMail,
                                    _loginPassFN,
                                    _loginEmailFN,
                                    _loginEmailEditingController),
                                SizedBox(
                                  height: AppConstants.smallDistance,
                                ),
                                passText(
                                    context,
                                    _loginPassFN,
                                    _loginPassEditingController,
                                    showPass,
                                    toggleEye)
                              ],
                            ),
                          ),
                        )
                      : Container(),

                  SizedBox(
                    height: AppConstants.heightBetweenElements,
                  ),
                  // sign in
                  loginButton(context, loginAction, login!),

                  keyPadOn
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  300))
                      : SizedBox(
                          height: AppConstants.loginHeight,
                        ),
                ],
              ),
            ),
            padding: const EdgeInsets.all(AppPadding.p20),
            height: MediaQuery.of(context).size.height - 40.h,
            color: ColorManager.white,
            borderRadius: AppSize.s5,
            borderColor: ColorManager.white,
            borderWidth: 0));
  }

  void toggleEye() {
    setState(() {
      showPass = !showPass;
    });
  }

  Future<void> loginAction(BuildContext context) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));

    if (_loginFormKey.currentState!.validate()) {
      UserRequest userRequest = UserRequest(
          email: _loginEmailEditingController.text,
          password: _loginPassEditingController.text);

      await _appPreferences.setUserName(
          USER_NAME, _loginEmailEditingController.text);
      await _appPreferences.setPassword(PASS, _loginPassEditingController.text);

      LoginCubit.get(context).login(userRequest);
    }
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }
}
