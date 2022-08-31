import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/widget/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future orderConfirmation({
  required BuildContext context,
  required TextEditingController noteCtrl,
  required FocusNode noteFocus,
  required Map data,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, StateSetter newState) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: kLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(17.0),
                topRight: Radius.circular(17.0),
              ),
            ),
            height: Get.height * 0.70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 3,
                      decoration: BoxDecoration(
                        color: kDark.withOpacity(0.5),
                        borderRadius: kDefaultRadius,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Entypo.warning,
                      size: 16,
                      color: kDark,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Order Confirmation",
                      style: GoogleFonts.roboto(
                        color: kDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "Before we place your order, please list all of your items if necessary to avoid confusion, forgetfulness, and other problems you may face after laundry.",
                  style: GoogleFonts.roboto(
                    color: kDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 15),
                inputTextArea(
                  controller: noteCtrl,
                  focusNode: noteFocus,
                  onEditingComplete: () async {
                    Get.toNamed("/loading");

                    data["content"]["description"] = noteCtrl.text;
                    await Get.put(OrderController()).createOrder(data);

                    Get.toNamed("/view-customer-orders");
                  },
                  textInputAction: TextInputAction.done,
                  labelText: "Write all your belongings here...",
                  textFieldStyle: GoogleFonts.roboto(
                    color: kDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                  color: kWhite,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
// Future orderConfirmation({
  // required TextEditingController noteCtrl,
  // required FocusNode noteFocus,
  // required Function() onEditingComplete,
// }) {
//   return Get.bottomSheet(
  //   Container(
  //     padding: const EdgeInsets.all(20.0),
  //     decoration: const BoxDecoration(
  //       color: kLight,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(17.0),
  //         topRight: Radius.circular(17.0),
  //       ),
  //     ),
  //     height: Get.height * 0.70,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: 50,
  //               height: 3,
  //               decoration: BoxDecoration(
  //                 color: kDark.withOpacity(0.5),
  //                 borderRadius: kDefaultRadius,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Row(
  //           children: [
  //             const Icon(
  //               Entypo.warning,
  //               size: 16,
  //               color: kDark,
  //             ),
  //             const SizedBox(width: 5),
  //             Text(
  //               "Order Confirmation",
  //               style: GoogleFonts.roboto(
  //                 color: kDark,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 14.0,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 15),
  //         Text(
  //           "Before we place your order, please list all of your items if necessary to avoid confusion, forgetfulness, and other problems you may face after laundry.",
  //           style: GoogleFonts.roboto(
  //             color: kDark,
  //             fontWeight: FontWeight.w400,
  //             fontSize: 12.0,
  //           ),
  //         ),
  //         const SizedBox(height: 15),
  //         inputTextArea(
  //           controller: noteCtrl,
  //           focusNode: noteFocus,
  //           onEditingComplete: onEditingComplete,
  //           textInputAction: TextInputAction.done,
  //           labelText: "Write all your belongings here...",
  //           textFieldStyle: GoogleFonts.roboto(
  //             color: kDark,
  //             fontWeight: FontWeight.w400,
  //             fontSize: 12.0,
  //           ),
  //           color: kWhite,
  //         ),
  //       ],
  //     ),
  //   ),
  // );
// }
