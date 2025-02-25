import 'package:dodjaerrands_driver/core/helper/shared_preference_helper.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/presentation/components/divider/custom_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_images.dart';
import '../../../core/utils/my_strings.dart';
import '../../../core/utils/style.dart';
import '../../../data/services/api_service.dart';
import '../../components/buttons/rounded_button.dart';

import 'intro-screen-widgets/onboard_body.dart';

class OnBoardIntroScreen extends StatefulWidget {
  const OnBoardIntroScreen({super.key});

  @override
  State<OnBoardIntroScreen> createState() => _OnBoardIntroScreenState();
}

class _OnBoardIntroScreenState extends State<OnBoardIntroScreen> {
  late PageController _pageController;
  var currentPageID = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    Get.put(ApiClient(sharedPreferences: Get.find()));
  }

  static const List<Map<String, String>> onboardText = [
    {
      "title": MyStrings.onboardTitle1,
      "body": MyStrings.onboardDescription1,
    },
    {
      "title": MyStrings.onboardTitle2,
      "body": MyStrings.onboardDescription2,
    },
    {
      "title": MyStrings.onboardTitle3,
      "body": MyStrings.onboardDescription3,
    },
  ];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      for (int i = 0; i < MyImages.onboardImages.length; i++) ...[
        OnboardingPage(
          imagePath: MyImages.onboardImages[i],
          index: i,
          title: onboardText[i]['title']!,
          description: onboardText[i]['body']!,
        ),
      ]
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: MyColor.colorWhite,
        body: SafeArea(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                currentPageID = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    pages[index],
                    spaceDown(Dimensions.space5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        spaceSide(Dimensions.space15),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < MyImages.onboardImages.length; i++) ...[
                              Container(
                                margin: const EdgeInsetsDirectional.only(end: Dimensions.space5),
                                decoration: BoxDecoration(
                                  color: currentPageID != i ? MyColor.colorGrey2 : MyColor.primaryColor,
                                  borderRadius: currentPageID == i ? const BorderRadius.horizontal(left: Radius.circular(Dimensions.space5), right: Radius.circular(Dimensions.space5)) : BorderRadius.circular(Dimensions.space10),
                                ),
                                width: currentPageID == i ? 30 : 10,
                                height: 10,
                              )
                            ]
                          ],
                        ),
                        spaceSide(Dimensions.space15),
                      ],
                    ),
                    spaceDown(Dimensions.space50 + Dimensions.space20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.space10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            RoundedButton(
                              text: MyStrings.signIn.tr,
                              verticalPadding: 18,
                              press: () {
                                Get.find<ApiClient>().sharedPreferences.setBool(SharedPreferenceHelper.onBoardKey, true);
                                Get.offAllNamed(RouteHelper.loginScreen);
                              },
                            ),
                            SizedBox(height: Dimensions.space20),
                            RoundedButton(
                              text: MyStrings.signUp.tr,
                              isOutlined: true,
                              textStyle: boldDefault.copyWith(color: MyColor.primaryColor),
                              verticalPadding: 18,
                              press: () {
                                Get.find<ApiClient>().sharedPreferences.setBool(SharedPreferenceHelper.onBoardKey, true);
                                Get.offAllNamed(RouteHelper.registrationScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    spaceDown(Dimensions.space15),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
