import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/data/controller/account/profile_controller.dart';
import 'package:dodjaerrands_driver/data/repo/account/profile_repo.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';
import 'package:dodjaerrands_driver/presentation/components/custom_loader/custom_loader.dart';
import 'package:dodjaerrands_driver/presentation/components/divider/custom_spacer.dart';

import '../../../core/utils/style.dart';
import '../../components/card/app_body_card.dart';
import '../../components/divider/custom_divider.dart';
import '../../components/image/my_network_image_widget.dart';
import 'widget/card_column.dart';
import 'widget/profile_view_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProfileRepo(apiClient: Get.find()));
    final controller = Get.put(ProfileController(profileRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProfileInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: MyColor.screenBgColor,
          appBar: AppBar(
            backgroundColor: MyColor.primaryColor,
            title: Text(MyStrings.profile.tr, style: boldLarge.copyWith(color: MyColor.getAppBarContentColor())),
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: MyColor.colorWhite,
                )),
          ),
          body: controller.isLoading
              ? const CustomLoader()
              : SingleChildScrollView(
                  padding: Dimensions.screenPaddingHV,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(top: Dimensions.space50),
                              child: AppBodyWidgetCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    spaceDown(Dimensions.space50),
                                    ProfileCardColumn(header: MyStrings.username.tr.toUpperCase(), body: controller.model.data?.driver?.username?.toUpperCase() ?? ""),
                                    CustomDivider(space: Dimensions.space15, color: MyColor.primaryColor.withOpacity(0.3)),
                                    ProfileCardColumn(header: MyStrings.fullName.tr.toUpperCase(), body: "${controller.model.data?.driver?.firstname} ${controller.model.data?.driver?.lastname}"),
                                    CustomDivider(space: Dimensions.space15, color: MyColor.primaryColor.withOpacity(0.3)),
                                    ProfileCardColumn(header: MyStrings.email.tr.toUpperCase(), body: controller.model.data?.driver?.email?.toLowerCase() ?? ""),
                                    CustomDivider(space: Dimensions.space15, color: MyColor.primaryColor.withOpacity(0.3)),
                                    ProfileCardColumn(header: MyStrings.phone.tr.toUpperCase(), body: controller.model.data?.driver?.mobile?.toLowerCase() ?? ""),
                                    CustomDivider(space: Dimensions.space15, color: MyColor.primaryColor.withOpacity(0.3)),
                                    ProfileCardColumn(header: MyStrings.country.tr.toUpperCase(), body: controller.model.data?.driver?.countryName?.toLowerCase() ?? "")
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: MyColor.screenBgColor, width: Dimensions.mediumRadius), shape: BoxShape.circle),
                                  height: Dimensions.space50 + 60,
                                  width: Dimensions.space50 + 60,
                                  child: ClipOval(child: MyImageWidget(imageUrl: controller.imageUrl, boxFit: BoxFit.cover, height: Dimensions.space50 + 60, width: Dimensions.space50 + 60, isProfile: true)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        spaceDown(Dimensions.space25),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: const ProfileViewBottomNavBar(),
        );
      },
    );
  }
}
