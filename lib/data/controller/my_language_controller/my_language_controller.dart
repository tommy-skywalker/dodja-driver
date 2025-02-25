import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/helper/shared_preference_helper.dart';

import '../../../core/utils/messages.dart';

import '../../../core/utils/url_container.dart';
import '../../model/global/response_model/response_model.dart';
import '../../model/language/language_model.dart';
import '../../model/language/main_language_response_model.dart';
import '../../repo/auth/general_setting_repo.dart';
import '../localization/localization_controller.dart';

class MyLanguageController extends GetxController {
  GeneralSettingRepo repo;
  LocalizationController localizationController;
  MyLanguageController({required this.repo, required this.localizationController});

  bool isLoading = true;
  String languageImagePath = "";
  List<MyLanguageModel> langList = [];

  void loadLanguage() {
    langList.clear();
    isLoading = true;

    SharedPreferences pref = repo.apiClient.sharedPreferences;
    String languageString = pref.getString(SharedPreferenceHelper.languageListKey) ?? '';

    var language = jsonDecode(languageString);

    MainLanguageResponseModel model = MainLanguageResponseModel.fromJson(language);
    languageImagePath = "${UrlContainer.domainUrl}/${model.data?.imagePath ?? ''}";

    if (model.data?.languages != null && model.data!.languages!.isNotEmpty) {
      for (var listItem in model.data!.languages!) {
        MyLanguageModel model = MyLanguageModel(languageCode: listItem.code ?? '', countryCode: listItem.name ?? '', languageName: listItem.name ?? '', imageUrl: listItem.image ?? '');
        langList.add(model);
      }
    }

    String languageCode = pref.getString(SharedPreferenceHelper.languageCode) ?? 'en';

    printx('current lang code: $languageCode');

    if (langList.isNotEmpty) {
      int index = langList.indexWhere((element) => element.languageCode.toLowerCase() == languageCode.toLowerCase());

      changeSelectedIndex(index);
    }

    isLoading = false;
    update();
  }

  String selectedLangCode = 'en';

  bool isChangeLangLoading = false;
  void changeLanguage(int index) async {
    isChangeLangLoading = true;
    update();

    MyLanguageModel selectedLangModel = langList[index];
    String languageCode = selectedLangModel.languageCode;
    try {
      ResponseModel response = await repo.getLanguage(languageCode);

      if (response.statusCode == 200) {
        try {
          Map<String, Map<String, String>> language = {};
          var resJson = jsonDecode(response.responseJson);
          await repo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.languageListKey, response.responseJson);
          var value = resJson['data']['file'].toString() == '[]' ? {} : resJson['data']['file'];

          Map<String, String> json = {};
          value.forEach((key, value) {
            json[key] = value.toString();
          });

          language['${langList[index].languageCode}_${'US'}'] = json;

          Get.clearTranslations();
          Get.addTranslations(Messages(languages: language).keys);

          Locale local = Locale(langList[index].languageCode, 'US');
          localizationController.setLanguage(local);

          Get.back();
        } catch (e) {
          CustomSnackBar.error(errorList: [e.toString()]);
          Get.back();
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
      }
    } catch (e) {
      printx(e.toString());
    }

    isChangeLangLoading = false;
    update();
  }

  int selectedIndex = 0;
  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }
}
