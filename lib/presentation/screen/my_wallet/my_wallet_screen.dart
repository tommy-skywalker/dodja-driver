import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/helper/string_format_helper.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/my_icons.dart';
import 'package:dodjaerrands_driver/data/controller/transaction/transactions_controller.dart';
import 'package:dodjaerrands_driver/data/repo/transaction/transaction_repo.dart';
import 'package:dodjaerrands_driver/data/services/api_service.dart';
import 'package:dodjaerrands_driver/presentation/components/no_data.dart';
import 'package:dodjaerrands_driver/presentation/components/shimmer/transaction_card_shimmer.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_strings.dart';
import '../../../core/utils/style.dart';
import '../../../core/utils/util.dart';
import '../../components/buttons/icon_button.dart';
import '../../components/divider/custom_spacer.dart';
import '../../components/text/header_text.dart';
import 'widgets/transaction_card.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  final ScrollController scrollController = ScrollController();

  fetchData() {
    Get.find<TransactionsController>().loadTransaction();
  }

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<TransactionsController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TransactionRepo(apiClient: Get.find()));
    final controller = Get.put(TransactionsController(transactionRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialSelectedValue();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: Text(MyStrings.myWallet.tr, style: boldLarge.copyWith(color: MyColor.getAppBarContentColor())),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColor.colorWhite,
            )),
      ),
      body: GetBuilder<TransactionsController>(builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            if (controller.isLoading == false) {
              controller.loadTransaction(p: 1);
            }
          },
          child: SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getCardShadow()),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HeaderText(text: MyStrings.totalBalance, textStyle: regularLarge.copyWith(color: MyColor.bodyText)),
                              spaceDown(Dimensions.space8),
                              HeaderText(text: controller.isLoading ? '${controller.currencySym}0.0' : '${controller.currencySym}${StringConverter.formatNumber(controller.driver.balance ?? '0')}', textStyle: boldExtraLarge.copyWith(color: MyColor.colorBlack)),
                            ],
                          ),
                        ),
                        Flexible(
                          child: CustomIconButton(
                            iconSize: Dimensions.space15 + 1,
                            name: MyStrings.withdrawalTitle.tr,
                            icon: MyIcons.wallet,
                            style: boldDefault.copyWith(fontSize: Dimensions.fontSmall, fontWeight: FontWeight.w700, color: MyColor.colorWhite),
                            isSvg: true,
                            press: () {
                              Get.toNamed(RouteHelper.withdrawScreen);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getCardShadow()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderText(text: MyStrings.recentTransactions.tr, textStyle: mediumOverLarge.copyWith(fontSize: Dimensions.fontOverLarge, fontWeight: FontWeight.w500, color: MyColor.colorBlack)),
                        spaceDown(Dimensions.space15),
                        if (controller.isLoading) ...[
                          Column(
                            children: List.generate(10, (index) {
                              return const TransactionCardShimmer();
                            }),
                          )
                        ] else if (controller.isLoading == false && controller.transactionList.isEmpty) ...[
                          NoDataWidget(text: 'Sorry There is No Transaction'.tr)
                        ] else ...[
                          Column(
                            children: List.generate(controller.transactionList.length, (index) => TransactionCard(index: index, press: () {}, currency: controller.currencySym, transaction: controller.transactionList[index])),
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              )),
        );
      }),
    );
  }
}
