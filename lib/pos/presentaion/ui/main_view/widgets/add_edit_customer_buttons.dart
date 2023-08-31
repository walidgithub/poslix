import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/main_view_cubit/main_view_cubit.dart';

import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../di/di.dart';
import '../../components/container_component.dart';

Widget addAndEditCustomer(BuildContext context, Function getCustomer,
    Function addCustomer) {
  return Expanded(
      flex: 1,
      child: Column(
        children: [
          SizedBox(height: 7.h),
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Bounceable(
                      duration: Duration(
                          milliseconds:
                          AppConstants
                              .durationOfBounceable),
                      onTap: () async {
                        await Future.delayed(
                            Duration(
                                milliseconds:
                                AppConstants
                                    .durationOfBounceable));
                        getCustomer(context);
                      },
                      child:
                      containerComponent(
                          context,
                          Center(
                              child: Icon(
                                Icons.edit,
                                size:
                                AppSize.s20.sp,
                                color: ColorManager
                                    .white,
                              )),
                          height: 45.h,
                          margin:
                          const EdgeInsets
                              .only(
                              bottom:
                              AppMargin
                                  .m8),
                          padding:
                          const EdgeInsets
                              .all(
                              AppPadding
                                  .p08),
                          color: ColorManager.primary,
                          borderColor: ColorManager.primary,
                          borderWidth: 0.1.w,
                          borderRadius: AppSize.s5
                      )
                  )),
              SizedBox(
                width: AppConstants
                    .smallerDistance,
              ),
              Expanded(
                  flex: 5,
                  child: Bounceable(
                    duration: Duration(
                        milliseconds:
                        AppConstants
                            .durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(
                          Duration(
                              milliseconds:
                              AppConstants
                                  .durationOfBounceable));
                      addCustomer(context);
                    },
                    child:
                    containerComponent(
                        context,
                        Center(
                            child: Icon(
                              Icons
                                  .add_circle_outline,
                              size:
                              AppSize.s20.sp,
                              color: ColorManager
                                  .white,
                            )),
                        height: 45.h,
                        margin:
                        const EdgeInsets
                            .only(
                            bottom:
                            AppMargin
                                .m8),
                        padding:
                        const EdgeInsets
                            .all(
                            AppPadding
                                .p08),
                        color: ColorManager.primary,
                        borderColor: ColorManager.primary,
                        borderWidth: 0.0.w,
                        borderRadius: AppSize.s5
                    ),
                  )),
            ],
          )
        ],
      ));
}