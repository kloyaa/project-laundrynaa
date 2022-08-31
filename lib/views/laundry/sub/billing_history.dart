import 'package:app/const/kMaterial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ViewLaundryBillingHistory extends StatefulWidget {
  const ViewLaundryBillingHistory({Key? key}) : super(key: key);

  @override
  State<ViewLaundryBillingHistory> createState() =>
      _ViewLaundryBillingHistoryState();
}

class _ViewLaundryBillingHistoryState extends State<ViewLaundryBillingHistory> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kDark,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kWhite,
        ),
      ),
      title: Text("BILLING", style: kAppBarStyle),
    );
    return Scaffold(
      appBar: appBar,
      backgroundColor: kLight,
    );
  }
}
