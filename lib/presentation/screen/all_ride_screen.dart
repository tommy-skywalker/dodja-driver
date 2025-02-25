import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dodjaerrands_driver/core/route/route.dart';
import 'package:dodjaerrands_driver/core/utils/my_color.dart';
import 'package:dodjaerrands_driver/core/utils/my_strings.dart';
import 'package:dodjaerrands_driver/core/utils/style.dart';
import 'package:dodjaerrands_driver/presentation/components/will_pop_widget.dart';
import 'package:dodjaerrands_driver/presentation/screens/ride_history/complete_ride/complete_ride_section.dart';

class AllRideScreen extends StatefulWidget {
  const AllRideScreen({super.key});

  @override
  State<AllRideScreen> createState() => _AllRideScreenState();
}

class _AllRideScreenState extends State<AllRideScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: RouteHelper.dashboard,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primaryColor,
          title: Text(MyStrings.allRide, style: boldLarge.copyWith(color: MyColor.colorWhite)),
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed(RouteHelper.dashboard);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: MyColor.colorWhite,
              )),
        ),
        body: AllRideSection(isInterCity: false),
      ),
    );
  }
}
