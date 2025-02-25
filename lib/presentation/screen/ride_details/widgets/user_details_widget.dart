import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/app_status.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_icons.dart';
import 'package:dodjaerrands_driver/core/utils/my_images.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/core/utils/url_container.dart';
import 'package:dodjaerrands_driver/core/utils/util.dart';
import 'package:dodjaerrands_driver/data/model/global/ride/ride_model.dart';
import 'package:dodjaerrands_driver/presentation/components/column_widget/card_column.dart';
import 'package:dodjaerrands_driver/presentation/components/image/custom_svg_picture.dart';
import 'package:dodjaerrands_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:dodjaerrands_driver/presentation/screens/drawer/drawer_user_info_card.dart';

class UserDetailsWidget extends StatelessWidget {
  final RideModel ride;
  final String imageUrl;
  const UserDetailsWidget({super.key, required this.ride, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    printx("ride.user?.imageWithPath $imageUrl");
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DrawerUserCard(
            fullName: "${ride.user?.firstname} ${ride.user?.lastname}",
            username: "${ride.user?.username} ",
            subtitle: ride.status != "1" ? "+${ride.user?.mobile} " : "",
            imgWidget: Container(
              decoration: BoxDecoration(border: Border.all(color: MyColor.borderColor, width: 0.5), shape: BoxShape.circle),
              height: 50,
              width: 50,
              child: ClipOval(
                child: MyImageWidget(imageUrl: '${UrlContainer.domainUrl}/$imageUrl/${ride.user?.avatar}', boxFit: BoxFit.cover, isProfile: true),
              ),
            ),
            imgHeight: 40,
            imgWidth: 40,
          ),
        ),
        Expanded(
          flex: 2,
          child: ride.status == "1"
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ride.rideType == AppStatus.RIDE_TYPE_INTERCITY ? SvgPicture.asset(MyIcons.intercityCar) : Image.asset(MyImages.city, width: 30, height: 30),
                      const SizedBox(width: Dimensions.space10),
                      CardColumn(
                        header: ride.rideType == AppStatus.RIDE_TYPE_INTERCITY ? MyStrings.interCityRide : MyStrings.cityRide,
                        body: ride.service?.name ?? '',
                        headerTextStyle: boldExtraLarge.copyWith(color: MyColor.primaryColor),
                        bodyTextStyle: regularMediumLarge.copyWith(color: MyColor.bodyText),
                        alignmentCenter: true,
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(Dimensions.space15),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                    border: Border.all(color: MyColor.primaryColor, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (ride.status != "1") {
                            MyUtils.launchPhone('${ride.user?.mobile}');
                          }
                        },
                        child: const CustomSvgPicture(image: MyIcons.callIcon),
                      ),
                      Container(
                        height: Dimensions.space20,
                        width: Dimensions.space1,
                        color: MyColor.primaryColor,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.rideMessageScreen, arguments: ride.id.toString());
                        },
                        child: const CustomSvgPicture(image: MyIcons.messageIcon),
                      ),
                    ],
                  ),
                ),
        )
      ],
    );
  }
}
