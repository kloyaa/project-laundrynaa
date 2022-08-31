import 'dart:io';

import 'package:app/common/destroyFocus.dart';
import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ViewLaundrySettings extends StatefulWidget {
  const ViewLaundrySettings({Key? key}) : super(key: key);

  @override
  State<ViewLaundrySettings> createState() => _ViewLaundrySettingsState();
}

class _ViewLaundrySettingsState extends State<ViewLaundrySettings> {
  final _userCtrl = Get.put(UserController());
  final _profileCtrl = Get.put(ProfileController());
  final _picker = ImagePicker();

  final _pricePerKgCtrl = MoneyMaskedTextController(
    leftSymbol: 'PHP ',
    thousandSeparator: ",",
    decimalSeparator: ".",
  );
  final _pricePerKgFocus = FocusNode();

  final _deliveryFeeCtrl = MoneyMaskedTextController(
    leftSymbol: 'PHP ',
    thousandSeparator: ",",
    decimalSeparator: ".",
  );
  final _deliveryFeeFocus = FocusNode();

  final _serviceHrsCtrl = TextEditingController();
  final _serviceHrsFocus = FocusNode();

  String _img1Path = "";
  String _img1Name = "";

  Future<void> onSelectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
      await _profileCtrl.updateQr({
        "accountId": _userCtrl.loginData["accountId"],
        "img": {"name": image.name, "path": image.path}
      });
    }
  }

  Future<void> updateSubProfile() async {
    Get.snackbar(
      "Laundrynaa says",
      "Updated Successfully",
      margin: const EdgeInsets.only(),
      borderRadius: 0,
      backgroundColor: kDark,
      colorText: kWhite,
      overlayBlur: 2,
      //  overlayColor: Colors.black38,
      snackPosition: SnackPosition.TOP,
    );

    await _profileCtrl.updateSubProfile({
      "accountId": _userCtrl.loginData["accountId"],
      "pricePerKg": _pricePerKgCtrl.text,
      "deliveryFee": _deliveryFeeCtrl.text,
      "serviceHrs": _serviceHrsCtrl.text
    });

    await _profileCtrl.getProfile(_userCtrl.loginData["accountId"]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final subProfile = _profileCtrl.profile["laundryProfile"];

    _pricePerKgCtrl.text = subProfile["pricePerKg"] == null
        ? "00"
        : subProfile["pricePerKg"].toString();
    _deliveryFeeCtrl.text = subProfile["deliveryFee"] == null
        ? "00"
        : subProfile["deliveryFee"].toString();

    _serviceHrsCtrl.text = subProfile["serviceHrs"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final subProfile = _profileCtrl.profile["laundryProfile"];

    final appBar = AppBar(
      backgroundColor: kDark,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kWhite,
        ),
      ),
      title: Text("LAUNDRY SETTINGS", style: kAppBarStyle),
    );

    return GestureDetector(
      onTap: () => destroyFormFocus(context),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: kLight,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 30.0,
            top: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  subProfile["paymentQrCode"] == null
                      ? _img1Path != ""
                          ? GestureDetector(
                              onTap: () async => await onSelectImage(),
                              child: Image.file(
                                File(_img1Path),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            )
                          : GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async => await onSelectImage(),
                              child: DottedBorder(
                                borderType: BorderType.Rect,
                                dashPattern: const [10, 10],
                                color: kDark,
                                strokeWidth: 2,
                                child: Stack(
                                  children: const [
                                    SizedBox(
                                      height: 120,
                                      width: 120,
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          AntDesign.qrcode,
                                          color: kDark,
                                          size: 100.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                      : GestureDetector(
                          onTap: () async => await onSelectImage(),
                          child: CachedNetworkImage(
                            imageUrl: subProfile["paymentQrCode"],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      children: [
                        inputNumberField(
                          controller: _pricePerKgCtrl,
                          focusNode: _pricePerKgFocus,
                          labelText: "Price per Kilo",
                          textFieldStyle: GoogleFonts.roboto(
                            color: kDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                          color: kWhite,
                          obscureText: false,
                          suffixIcon: const Icon(
                            MaterialCommunityIcons.weight_kilogram,
                            color: kDark,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        inputNumberField(
                          controller: _deliveryFeeCtrl,
                          focusNode: _deliveryFeeFocus,
                          labelText: "Delivery Fee",
                          textFieldStyle: GoogleFonts.roboto(
                            color: kDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                          color: kWhite,
                          obscureText: false,
                          suffixIcon: const Icon(
                            MaterialCommunityIcons.truck_delivery,
                            color: kDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              inputTextField(
                controller: _serviceHrsCtrl,
                focusNode: _serviceHrsFocus,
                labelText: "Service Hours",
                textFieldStyle: GoogleFonts.roboto(
                  color: kDark,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
                color: kWhite,
                obscureText: false,
                suffixIcon: const Icon(
                  MaterialCommunityIcons.clock_time_four,
                  color: kDark,
                ),
              ),
              const Spacer(),
              elevatedButton(
                btnColor: kDark,
                labelColor: kWhite,
                label: "SAVE CHANGES",
                function: () async => await updateSubProfile(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
