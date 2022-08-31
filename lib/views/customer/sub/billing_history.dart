import 'package:app/const/kMaterial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ViewCustomerBillingHistory extends StatefulWidget {
  const ViewCustomerBillingHistory({Key? key}) : super(key: key);

  @override
  State<ViewCustomerBillingHistory> createState() =>
      _ViewCustomerBillingHistoryState();
}

class _ViewCustomerBillingHistoryState
    extends State<ViewCustomerBillingHistory> {
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
