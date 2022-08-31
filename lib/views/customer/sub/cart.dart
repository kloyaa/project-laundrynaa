import 'package:app/common/destroyFocus.dart';
import 'package:app/common/format.dart';
import 'package:app/common/formatPrint.dart';
import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/cartController.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/widget/bottomsheets.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewCustomerCart extends StatefulWidget {
  const ViewCustomerCart({Key? key}) : super(key: key);

  @override
  State<ViewCustomerCart> createState() => _ViewCustomerCartState();
}

class _ViewCustomerCartState extends State<ViewCustomerCart> {
  final _cartCtrl = Get.put(CartController());
  final _orderCtrl = Get.put(OrderController());

  final _profileCtrl = Get.put(ProfileController());

  final _kgCtrl = MaskedTextController(mask: '00');
  final _kgFocus = FocusNode();

  final _noteCtrl = TextEditingController();
  final _noteFocus = FocusNode();

  bool isForDelivery = false;

  Future<void> placeOrder() async {
    final kilo = _kgCtrl.text;

    if (kilo.isEmpty || kilo == "0") {
      return _kgFocus.requestFocus();
    }

    final customer = _profileCtrl.profile;
    final laundry = _profileCtrl.laundryProfile;
    final laundrySubProfile = _profileCtrl.laundryProfile["laundryProfile"];
    final deliveryFee = formatPrice(laundrySubProfile["deliveryFee"]);
    final note = _noteCtrl.text;

    formatPrint("customer", _profileCtrl.profile);
    formatPrint("laundry", _profileCtrl.laundryProfile);

    await orderConfirmation(
      context: context,
      noteCtrl: _noteCtrl,
      noteFocus: _noteFocus,
      data: {
        "header": {
          "customer": {
            "accountId": customer["accountId"],
            "name": customer["name"],
            "contactNumber": customer["contact"]["number"],
            "address": customer["address"],
            "avatar": customer["avatar"]
          },
          "laundry": {
            "accountId": laundry["accountId"],
            "name": laundry["name"],
            "contactNumber": laundry["contact"]["number"],
            "address": laundry["address"],
            "avatar": laundry["avatar"]
          }
        },
        "content": {
          "preferences": _cartCtrl.cart.toList(),
          "totalOfKg": int.parse(_kgCtrl.text),
          "description": "",
          "delivery": {
            "type": isForDelivery ? "deliver" : "pickup",
            "fee": isForDelivery ? deliveryFee : 0,
          },
          "total": _cartCtrl.total.value,
          "paymentMethod": "e-wallet",
          "paymentStatus": "unpaid",
          "orderStatus": "pending"
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cartCtrl.calculateTotal();
  }

  @override
  Widget build(BuildContext context) {
    final laundry = _profileCtrl.laundryProfile;
    final deliveryFee = formatPrice(laundry["laundryProfile"]["deliveryFee"]);
    final pricePerKg = formatPrice(laundry["laundryProfile"]["pricePerKg"]);

    final appBar = AppBar(
      backgroundColor: kDark,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kWhite,
        ),
      ),
      title: Text(
        "ORDER SUMMARY",
        style: kAppBarStyle,
      ),
      actions: [],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          color: kLight,
          child: inputNumberField(
            controller: _kgCtrl,
            focusNode: _kgFocus,
            onEditingComplete: () {
              _cartCtrl.calculateTotal();
              _cartCtrl.total + (pricePerKg * int.parse(_kgCtrl.text));
              destroyFormFocus(context);
            },
            labelText: "Enter Laundry Kilogram",
            textFieldStyle: GoogleFonts.roboto(
              color: kDark,
              fontSize: 9.0,
            ),
            suffixIcon: const Icon(
              MaterialCommunityIcons.weight_kilogram,
              color: kDark,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            color: kWhite,
            obscureText: false,
          ),
        ),
      ),
    );

    return Obx(() => GestureDetector(
          onTap: () => destroyFormFocus(context),
          child: Scaffold(
            backgroundColor: kLight,
            appBar: appBar,
            body: ListView.builder(
              itemCount: _cartCtrl.cart.length,
              itemBuilder: (_, int index) {
                final data = _cartCtrl.cart[index];

                String price = data["price"].toString();
                int quantity = data["quantity"];
                int subTotal = formatPrice(price) * quantity;

                return Container(
                  // padding: EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(top: 5),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 25.0,
                    ),
                    tileColor: kWhite,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IgnorePointer(
                          ignoring: data["quantity"] == 1,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: data["quantity"] == 1 ? 0.3 : 1,
                            child: IconButton(
                              splashRadius: 25,
                              icon: const Icon(AntDesign.minuscircle,
                                  color: kDark),
                              onPressed: () {
                                _kgCtrl.clear();
                                _cartCtrl.updateCartitemQuantity(
                                  data["_id"],
                                  "minus",
                                );
                              },
                            ),
                          ),
                        ),
                        Text(
                          "${data["quantity"]}",
                          style: GoogleFonts.roboto(
                            color: kDark,
                            fontSize: 12.0,
                          ),
                        ),
                        IconButton(
                          splashRadius: 25,
                          icon: const Icon(AntDesign.pluscircle, color: kDark),
                          onPressed: () {
                            _kgCtrl.clear();
                            _cartCtrl.updateCartitemQuantity(
                              data["_id"],
                              "add",
                            );
                          },
                        ),
                        // IconButton(
                        //   splashRadius: 25,
                        //   icon: const Icon(AntDesign.close, color: kDark),
                        //   onPressed: () => _cartCtrl.removeFromCart(data["_id"]),
                        // ),
                      ],
                    ),
                    title: Text(
                      data["title"],
                      style: GoogleFonts.roboto(
                        color: kDark,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price,
                          style: GoogleFonts.roboto(
                            color: kDark,
                            fontSize: 12.0,
                          ),
                        ),
                        const Divider(color: kDark),
                        Text(
                          "Subtotal",
                          style: GoogleFonts.roboto(
                            color: kDark,
                            fontSize: 9.0,
                          ),
                        ),
                        Text(
                          priceInCurrency.format(subTotal),
                          style: GoogleFonts.robotoMono(
                            color: kDark,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                height: 130.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "VAT 0%",
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade300,
                              fontSize: 9.0,
                            ),
                          ),
                          Text(
                            priceInCurrency.format(0),
                            style: GoogleFonts.robotoMono(
                              color: Colors.grey.shade300,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "Amount to PAY",
                            style: GoogleFonts.roboto(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.0,
                            ),
                          ),
                          Text(
                            priceInCurrency.format(_cartCtrl.total.value),
                            style: GoogleFonts.robotoMono(
                              color: kDanger,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Deliver to my address \n(Delivery Fee ${priceInCurrency.format(deliveryFee)})",
                          style: GoogleFonts.roboto(
                            color: kDark,
                            fontSize: 9.0,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        FlutterSwitch(
                          width: 70.0,
                          height: 20.0,
                          valueFontSize: 25.0,
                          toggleSize: 45.0,
                          value: isForDelivery,
                          borderRadius: 30.0,
                          padding: 5.0,
                          showOnOff: false,
                          activeColor: kDark,
                          inactiveColor: Colors.grey.shade200,
                          onToggle: (val) {
                            setState(() {
                              isForDelivery = val;
                            });

                            if (isForDelivery) {
                              _cartCtrl.total += deliveryFee;
                              return;
                            }
                            _cartCtrl.total -= deliveryFee;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 40.0,
                          width: 150.0,
                          child: elevatedButton(
                            label: "PLACE ORDER",
                            function: () async => placeOrder(),
                            btnColor: kDark,
                            labelColor: kWhite,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
