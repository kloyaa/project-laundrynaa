import 'package:app/const/kMaterial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ViewLaundrySales extends StatefulWidget {
  const ViewLaundrySales({Key? key}) : super(key: key);

  @override
  State<ViewLaundrySales> createState() => _ViewLaundrySalesState();
}

class _ViewLaundrySalesState extends State<ViewLaundrySales> {
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
      title: Text("LAUNDRY SALES", style: kAppBarStyle),
    );
    return Scaffold(
      appBar: appBar,
      backgroundColor: kLight,
    );
  }
}
