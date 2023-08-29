import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/response/products_model.dart';
import '../../../../shared/constant/assets_manager.dart';
import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../components/container_component.dart';

Widget brandItems(BuildContext context, Function addToTmp,
    List<ProductsResponse> listOfProducts, String businessType, double deviceWidth) {
  return Expanded(
      child: GridView.count(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: deviceWidth <= 800 ? 1 / 1.2 : 11 / 16,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: List.generate(listOfProducts.length, (index) {
            return Bounceable(
              duration:
                  Duration(milliseconds: AppConstants.durationOfBounceable),
              onTap: () async {
                await Future.delayed(
                    Duration(milliseconds: AppConstants.durationOfBounceable));

                addToTmp(index, context, false);
              },
              child: containerComponent(context,
                  itemContainer(index, context, listOfProducts, businessType, deviceWidth),
                  // height: 400.h,
                  // width: 200.w,
                  color: ColorManager.secondary,
                  borderColor: ColorManager.secondary,
                  borderWidth: 0.0.w,
                  borderRadius: AppSize.s5),
            );
          })));
}

Widget itemContainer(int index, BuildContext context,
    List<ProductsResponse> listOfProducts, String businessType, double deviceWidth) {
  return Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 200.w,
            height: deviceWidth <= 800 ? 125.h : 105.h,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: listOfProducts[index].image.toString() == "n"
                    ? const DecorationImage(
                        image: AssetImage(ImageAssets.noItem), fit: BoxFit.fill)
                    : DecorationImage(
                        image: CachedNetworkImageProvider(
                            listOfProducts[index].image.toString()),
                        fit: BoxFit.fill)),
          ),
          Container(
            width: deviceWidth <= 800 ? 155.w : 50.w,
            height: 40.h,
            decoration: BoxDecoration(
                color: ColorManager.badge,
                border: Border.all(color: ColorManager.badge, width: 1.5.w),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppSize.s5),
                    bottomRight: Radius.circular(AppSize.s5))),
            child: Center(
              child: Text(
                listOfProducts[index].name.toString(),
                style: TextStyle(
                    color: ColorManager.white, fontSize: AppSize.s14.sp),
              ),
            ),
          ),
        ],
      ),
      listOfProducts[index].stock == 0
          ? Positioned(
              top: 5,
              left: 5,
              child: businessType == 'Tailor'
                  ? listOfProducts[index].type != 'tailoring_package'
                      ? SvgPicture.asset(
                          ImageAssets.unavailable,
                          width: AppSize.s20,
                          color: ColorManager.delete,
                        )
                      : CircleAvatar(
                          radius: 12.h, //radius of avatar
                          backgroundColor: ColorManager.white, //color
                          child: Padding(
                            padding: const EdgeInsets.all(
                                AppPadding.p2), // Border radius
                            child: ClipOval(
                                child: Image.asset(ImageAssets.tailor)),
                          ))
                  : SvgPicture.asset(
                      ImageAssets.unavailable,
                      width: AppSize.s20,
                      color: ColorManager.delete,
                    ))
          : Container()
    ],
  );
}
