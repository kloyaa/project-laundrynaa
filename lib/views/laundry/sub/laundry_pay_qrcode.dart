import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/profileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LaundryPaymentQRCode extends StatefulWidget {
  const LaundryPaymentQRCode({Key? key}) : super(key: key);

  @override
  State<LaundryPaymentQRCode> createState() => _LaundryPaymentQRCodeState();
}

class _LaundryPaymentQRCodeState extends State<LaundryPaymentQRCode> {
  final profileCtrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        "Payment QR Code",
        style: GoogleFonts.roboto(
          fontSize: 14.0,
          color: kDark,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        splashRadius: 20.0,
        icon: const Icon(
          AntDesign.arrowleft,
          color: kDark,
        ),
      ),
      backgroundColor: kWhite,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: kDark.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: kWhite,
      appBar: appBar,
      body: Center(
        child: Image.network(
          profileCtrl.profile["laundryProfile"]["paymentQrCode"],
        ),
      ),
    );
  }
}
