import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_images.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/data/controller/auth/social_login_controller.dart';
import 'package:dodjaerrands_driver/data/repo/auth/social_login_repo.dart';
import 'package:dodjaerrands_driver/presentation/components/divider/custom_spacer.dart';
import 'package:dodjaerrands_driver/presentation/components/image/my_local_image_widget.dart';
import 'package:dodjaerrands_driver/presentation/screens/auth/login/widgets/login_or_bar.dart';

class SocialAuthSection extends StatefulWidget {
  final String googleAuthTitle;
  const SocialAuthSection({super.key, this.googleAuthTitle = MyStrings.google});

  @override
  State<SocialAuthSection> createState() => _SocialAuthSectionState();
}

class _SocialAuthSectionState extends State<SocialAuthSection> {
  @override
  void initState() {
    Get.put(SocialLoginRepo(apiClient: Get.find()));
    Get.put(SocialLoginController(repo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLoginController>(builder: (controller) {
      return (controller.repo.apiClient.isGoogleLoginEnable() == true)
          ? Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                    border: Border.all(color: MyColor.borderColor, width: .5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space15),
                  child: GestureDetector(
                    onTap: () {
                      if (!controller.isGoogleSignInLoading) {
                        controller.signInWithGoogle();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        controller.isGoogleSignInLoading ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: MyColor.primaryColor)) : MyLocalImageWidget(imagePath: MyImages.google, height: 25, width: 25, boxFit: BoxFit.contain),
                        SizedBox(width: Dimensions.space10),
                        Text((widget.googleAuthTitle).tr, style: regularDefault.copyWith(fontWeight: FontWeight.w500, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                spaceDown(Dimensions.space20),
                const LoginOrBar(stock: 0.8),
              ],
            )
          : SizedBox.shrink();
    });
  }
}
