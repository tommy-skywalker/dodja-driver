import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/utils/util.dart';
import 'package:dodjaerrands_driver/presentation/components/divider/custom_spacer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_images.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/data/controller/auth/auth/sms_verification_controler.dart';
import 'package:dodjaerrands_driver/data/repo/auth/sms_email_verification_repo.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';
import 'package:dodjaerrands_driver/presentation/components/buttons/rounded_button.dart';
import 'package:dodjaerrands_driver/presentation/components/will_pop_widget.dart';

import '../../../../core/utils/my_icons.dart';

class SmsVerificationScreen extends StatefulWidget {
  const SmsVerificationScreen({super.key});

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SmsEmailVerificationRepo(apiClient: Get.find()));
    final controller = Get.put(SmsVerificationController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.intData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopWidget(
        nextRoute: RouteHelper.loginScreen,
        child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: GetBuilder<SmsVerificationController>(
            builder: (controller) => controller.isLoading
                ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                : SafeArea(
                    child: SingleChildScrollView(
                        padding: Dimensions.screenPaddingHV,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            spaceDown(Dimensions.space15),
                            Image.asset(
                              MyImages.appLogoWhite,
                              width: MediaQuery.of(context).size.width / 3,
                            ),
                            SvgPicture.asset(MyIcons.bg),
                            Container(
                              margin: EdgeInsetsDirectional.only(top: context.height * .05, bottom: Dimensions.space50 * 1),
                              padding: const EdgeInsetsDirectional.only(top: Dimensions.space20, bottom: Dimensions.space20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  spaceDown(Dimensions.space20),
                                  Align(alignment: Alignment.center, child: Text(MyStrings.verifyYourPhone.tr, style: boldExtraLarge.copyWith(fontSize: Dimensions.fontExtraLarge + 5))),
                                  const SizedBox(height: Dimensions.space5),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('${MyStrings.codeHasBeenSendTo.tr} ${MyUtils.maskSensitiveInformation(controller.userPhone)}'.tr, style: regularDefault.copyWith(color: MyColor.getBodyTextColor(), fontSize: Dimensions.fontLarge)),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * .04),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                                    child: PinCodeTextField(
                                      appContext: context,
                                      pastedTextStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor()),
                                      length: 6,
                                      textStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor()),
                                      obscureText: false,
                                      obscuringCharacter: '*',
                                      blinkWhenObscuring: false,
                                      animationType: AnimationType.slide,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        borderRadius: BorderRadius.circular(8),
                                        borderWidth: 1,
                                        fieldHeight: 40,
                                        fieldWidth: 40,
                                        inactiveColor: MyColor.getTextFieldDisableBorder(),
                                        inactiveFillColor: MyColor.getScreenBgColor(),
                                        activeFillColor: MyColor.getScreenBgColor(),
                                        activeColor: MyColor.getPrimaryColor(),
                                        selectedFillColor: MyColor.getScreenBgColor(),
                                        selectedColor: MyColor.getPrimaryColor(),
                                      ),
                                      cursorColor: MyColor.getTextColor(),
                                      animationDuration: const Duration(milliseconds: 100),
                                      enableActiveFill: true,
                                      keyboardType: TextInputType.number,
                                      beforeTextPaste: (text) {
                                        return true;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          controller.currentText = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.space30),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      start: Dimensions.space20,
                                      end: Dimensions.space20,
                                    ),
                                    child: RoundedButton(
                                      isLoading: controller.submitLoading,
                                      text: MyStrings.verify.tr,
                                      press: () {
                                        controller.verifyYourSms(controller.currentText);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.space30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(MyStrings.didNotReceiveCode.tr, style: regularDefault.copyWith(color: MyColor.getLabelTextColor())),
                                      const SizedBox(width: Dimensions.space10),
                                      controller.resendLoading
                                          ? Container(
                                              margin: const EdgeInsets.all(5),
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: MyColor.getPrimaryColor(),
                                              ))
                                          : GestureDetector(
                                              onTap: () {
                                                controller.sendCodeAgain();
                                              },
                                              child: Text(
                                                MyStrings.resendCode.tr,
                                                style: regularDefault.copyWith(
                                                  decoration: TextDecoration.underline,
                                                  color: MyColor.getPrimaryColor(),
                                                  decorationColor: MyColor.primaryColor,
                                                ),
                                              ),
                                            ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
          ),
        ),
      ),
    );
  }
}
