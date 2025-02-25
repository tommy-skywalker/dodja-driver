import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/dimensions.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_images.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/data/controller/dashboard/dashboard_controller.dart';
import 'package:dodjaerrands_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:dodjaerrands_driver/presentation/components/image/custom_svg_picture.dart';
import 'package:dodjaerrands_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:dodjaerrands_driver/presentation/components/no_data.dart';
import 'package:dodjaerrands_driver/presentation/components/shimmer/ride_shimmer.dart';
import 'package:dodjaerrands_driver/presentation/components/text/header_text.dart';
import 'package:dodjaerrands_driver/presentation/screens/dashboard/widgets/driver_kyc_warning_section.dart';
import 'package:dodjaerrands_driver/presentation/screens/dashboard/widgets/vahicle_kyc_warning_section.dart';
import 'package:dodjaerrands_driver/presentation/screens/rides/new_rides/widget/offer_bid_bottom_sheet.dart';
import 'package:dodjaerrands_driver/presentation/screens/rides/new_rides/widget/pending_ride_list.dart';

import '../../../../core/helper/string_format_helper.dart';
import '../../../components/switch/lite_rolling_switch.dart';
import 'widget/new_ride_card.dart';

class NewRidesScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? dashBoardScaffoldKey;
  const NewRidesScreen({super.key, this.dashBoardScaffoldKey});

  @override
  State<NewRidesScreen> createState() => _NewRidesScreenState();
}

class _NewRidesScreenState extends State<NewRidesScreen> {
  ScrollController? _scrollController;
  Color? _theme;

  @override
  void initState() {
    super.initState();
    checkAppBarExpanded();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<DashBoardController>().isLoading = true;
      Get.find<DashBoardController>().initialData(shouldLoad: true);
    });
  }

  checkAppBarExpanded() {
    _scrollController = ScrollController()
      ..addListener(
        () => _isAppBarExpanded
            ? _theme != MyColor.getHeaderBGColor()
                ? setState(
                    () {
                      _theme = MyColor.getHeaderBGColor();
                      printx('setState is called');
                    },
                  )
                : {}
            : _theme != Colors.transparent
                ? setState(() {
                    printx('setState is called');
                    _theme = Colors.transparent;
                  })
                : {},
      );
  }

  bool get _isAppBarExpanded {
    return _scrollController!.hasClients && _scrollController!.offset > (140 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (controller) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: MyColor.primaryColor,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: MyColor.screenBgColor,
          body: RefreshIndicator(
            edgeOffset: 80,
            backgroundColor: MyColor.colorWhite,
            color: MyColor.primaryColor,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh: () async {
              controller.loadData();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  surfaceTintColor: MyColor.transparentColor,
                  systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: MyColor.screenBgColor, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
                  toolbarHeight: 70,
                  pinned: true,
                  backgroundColor: MyColor.screenBgColor,
                  elevation: 1,
                  automaticallyImplyLeading: false,
                  actions: [
                    Container(
                      margin: const EdgeInsetsDirectional.only(end: 0, top: 8, bottom: 3, start: 12),
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.profileAndSettingsScreen);
                        },
                        child: MyImageWidget(imageUrl: controller.profileImageUrl ?? "", isProfile: true, height: 45, width: 45, radius: 50, errorWidget: Image.asset(MyImages.defaultAvatar, height: 50)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 13),
                          HeaderText(text: controller.repo.apiClient.getCurrencyOrUsername(isCurrency: false, isSymbol: false).toTitleCase(), textStyle: boldLarge.copyWith(color: MyColor.titleColor, fontSize: 16)),
                          Row(
                            children: [
                              CustomSvgPicture(image: MyImages.focus, width: 16, height: 16),
                              SizedBox(width: 5),
                              Expanded(child: Text(controller.currentAddress, style: regularDefault.copyWith(color: Color(0xff475569), fontSize: 12, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: Dimensions.space45,
                        child: Obx(
                          () => LiteRollingSwitch(
                            tValue: controller.userOnline.value,
                            width: Dimensions.space50 + 60,
                            textOn: MyStrings.onLine.tr,
                            textOnColor: MyColor.colorWhite,
                            textOff: MyStrings.offLine.tr,
                            colorOn: MyColor.colorGreen,
                            colorOff: MyColor.colorBlack.withOpacity(0.6),
                            iconOn: Icons.network_check,
                            iconOff: Icons.network_locked,
                            animationDuration: const Duration(milliseconds: 300),
                            onChanged: (bool state) {},
                            onTap: () {
                              controller.onlineStatus();
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      DriverKYCWarningSection(),
                      SizedBox(height: 2),
                      VehicleKYCWarningSection(),
                    ],
                  ),
                ),
                if (controller.isLoading) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top: Dimensions.space15, start: Dimensions.space15, end: Dimensions.space15),
                      child: Column(children: List.generate(10, (index) => const RideShimmer())),
                    ),
                  )
                ] else if (controller.isLoading == false && controller.rideList.isEmpty) ...[
                  SliverToBoxAdapter(
                    child: NoDataWidget(text: MyStrings.noRideFoundInYourArea.tr, isRide: true),
                  )
                ] else ...[
                  SliverToBoxAdapter(
                    child: Container(margin: const EdgeInsets.symmetric(horizontal: Dimensions.space10), padding: const EdgeInsets.only(bottom: 5), child: PendingRideList(controller: controller)),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: NewRideCardWidget(
                            isActive: true,
                            ride: controller.rideList[index],
                            currency: controller.currencySym,
                            driverImagePath: '${controller.userImagePath}/${controller.rideList[index].user?.avatar}',
                            press: () {
                              final ride = controller.rideList[index];
                              controller.updateMainAmount(StringConverter.formatDouble(ride.amount.toString()));
                              CustomBottomSheet(
                                child: OfferBidBottomSheet(ride: ride),
                              ).customBottomSheet(context);
                            },
                          ),
                        );
                      },
                      childCount: controller.rideList.length,
                    ),
                  ),
                  //   SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(bottom: context.width / 2)))
                ]
              ],
            ),
          ),
        ),
      );
    });
  }
}
