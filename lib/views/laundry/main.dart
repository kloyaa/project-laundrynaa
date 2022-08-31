import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:app/common/direct_call.dart';
import 'package:app/common/format.dart';
import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/views/laundry/sub/laundry_pay_qrcode.dart';
import 'package:app/views/laundry/sub/laundry_qrcode.dart';
import 'package:app/widget/button.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ViewLaundryMain extends StatefulWidget {
  const ViewLaundryMain({Key? key}) : super(key: key);

  @override
  State<ViewLaundryMain> createState() => _ViewLaundryMainState();
}

class _ViewLaundryMainState extends State<ViewLaundryMain>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profileCtrl = Get.put(ProfileController());
  final _userCtrl = Get.put(UserController());
  final _orderCtrl = Get.put(OrderController());

  TabController? _tabController;
  String _currentStatus = "pending";
  late Future _orders;

  Future<void> refresh() async {
    setState(() {
      _orders = _orderCtrl.getLaundryOrders({
        "accountId": _userCtrl.loginData["accountId"],
        "status": _currentStatus,
      });
    });
  }

  Future<void> updateOrderStatus(data) async {
    await _orderCtrl.updateOrderStatus(data);
    await refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _orders = _orderCtrl.getLaundryOrders({
      "accountId": _userCtrl.loginData["accountId"],
      "status": "pending",
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountId = _profileCtrl.profile["accountId"];
    final email = _userCtrl.loginData["email"];
    final firstName = _profileCtrl.profile["name"]["first"];
    final lastName = _profileCtrl.profile["name"]["last"];
    final avatar = _profileCtrl.profile["avatar"];

    final appBar = AppBar(
      backgroundColor: kDark,
      leading: const SizedBox(),
      leadingWidth: 0,
      title: Text(
        "Welcome Back, $firstName!",
        style: kAppBarStyle,
      ),
      actions: [
        IconButton(
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          icon: const Icon(
            Ionicons.menu,
            color: kWhite,
          ),
        ),
      ],
      bottom: TabBar(
        indicatorColor: kWhite, //Default Color of Indicator
        labelColor: kWhite, // Base color of texts
        labelStyle: GoogleFonts.roboto(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 10,
          fontWeight: FontWeight.w300,
        ),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        isScrollable: true,
        tabs: const [
          Tab(text: "Pending"),
          Tab(text: "In-progress"),
          Tab(text: "Completed"),
        ],
        onTap: (value) {
          if (value == 0) {
            setState(() {
              _orders = _orderCtrl.getLaundryOrders({
                "accountId": _userCtrl.loginData["accountId"],
                "status": "pending",
              });
              _currentStatus = "pending";
            });
          }
          if (value == 1) {
            setState(() {
              _orders = _orderCtrl.getLaundryOrders({
                "accountId": _userCtrl.loginData["accountId"],
                "status": "in-progress",
              });
              _currentStatus = "in-progress";
            });
          }
          if (value == 2) {
            setState(() {
              _orders = _orderCtrl.getLaundryOrders({
                "accountId": _userCtrl.loginData["accountId"],
                "status": "completed",
              });
              _currentStatus = "completed";
            });
          }
        },
        controller: _tabController,
      ),
    );
    final drawer = Drawer(
      backgroundColor: kWhite,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
              color: kDark,
            ),
            child: GestureDetector(
              onTap: () => Get.toNamed("/update-profile"),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.transparent),
                currentAccountPictureSize: const Size.square(70.0),
                margin: const EdgeInsets.all(0),
                currentAccountPicture: avatar == null
                    ? const SizedBox()
                    : CircularProfileAvatar(avatar),
                accountName: Text(
                  "$firstName $lastName",
                  style: GoogleFonts.roboto(
                    color: kWhite,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                accountEmail: Text(
                  email,
                  style: GoogleFonts.roboto(
                    color: kWhite,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          ListTile(
            onTap: () => Get.toNamed("/update-profile"),
            leading: Icon(
              AntDesign.user,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Profile and Settings",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-laundry-service-and-preferences"),
            leading: Icon(
              MaterialIcons.local_laundry_service,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Preferences",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-laundry-sales"),
            leading: Icon(
              Entypo.line_graph,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Laundry Sales",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-laundry-billing-history"),
            leading: Icon(
              FontAwesome.money,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Billing History",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          const Spacer(),
          ListTile(
            onTap: () => Get.toNamed("/view-laundry-settings"),
            leading: Icon(
              AntDesign.setting,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Laundry Settings",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.to(() => const LaundryPaymentQRCode()),
            leading: Icon(
              AntDesign.qrcode,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Payment QR Code",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.to(() => LaundryQRCode(code: accountId)),
            leading: Icon(
              FontAwesome.qrcode,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Rider QR Code",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => _userCtrl.logout(),
            leading: Icon(
              AntDesign.logout,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Log out",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kLight,
      appBar: appBar,
      drawer: drawer,
      body: FutureBuilder(
        future: _orders,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const SizedBox();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 45.0,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: [kDark],
                  strokeWidth: 3,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const SizedBox();
            }
            if (snapshot.data.length == 0) {
              return GestureDetector(
                onTap: () async => await refresh(),
                child: Scaffold(
                  body: Center(
                    child: Text(
                      "Oops! It's empty, \nPlease tap to refresh.",
                      style: GoogleFonts.roboto(
                        color: kDark.withOpacity(0.8),
                        fontSize: 11.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
          }

          return RefreshIndicator(
            onRefresh: () async => await refresh(),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                final data = snapshot.data[index];
                final customer = data["header"]["customer"];
                final preferences = data["content"]["preferences"];
                final content = data["content"];

                return Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: ListTile(
                    tileColor: kWhite,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    leading: IconButton(
                      onPressed: () async => await callNumber(
                        customer["contactNumber"],
                      ),
                      icon: const Icon(
                        Zocial.call,
                        color: kDark,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ORDER# ${data["refNumber"]}".toUpperCase(),
                          style: GoogleFonts.roboto(
                            fontSize: 10.0,
                            color: kDark.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          "${customer["name"]["first"]} ${customer["name"]["last"]}",
                          style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: kDark,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: const BoxDecoration(
                            color: kDark,
                            borderRadius: kDefaultRadius,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total of KG",
                                    style: GoogleFonts.roboto(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w300,
                                      color: kWhite,
                                    ),
                                  ),
                                  Text(
                                    "${content["totalOfKg"]}kg",
                                    style: GoogleFonts.roboto(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: kWhite,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Amount to PAY",
                                    style: GoogleFonts.roboto(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w300,
                                      color: kWhite,
                                    ),
                                  ),
                                  Text(
                                    priceInCurrency.format(content["total"]),
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: kWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          content["description"],
                          style: GoogleFonts.roboto(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: kDark,
                          ),
                        ),
                        ListView.builder(
                          itemCount: preferences.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, int index) {
                            return Container(
                              margin:
                                  EdgeInsets.only(top: index == 0 ? 15.0 : 5),
                              decoration: const BoxDecoration(
                                borderRadius: kDefaultRadius,
                              ),
                              child: ListTile(
                                tileColor: kLight,
                                title: Text(
                                  "${preferences[index]["title"]} x ${preferences[index]["quantity"]}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.0,
                                    color: kDark,
                                  ),
                                ),
                                subtitle: Text(
                                  preferences[index]["price"],
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: kDark,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 50.0),

                        //  DELIVERY TYPE
                        content["orderStatus"] == "in-progress"
                            ? content["delivery"]["type"] == "deliver"
                                ? Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: kDefaultRadius,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              MaterialCommunityIcons
                                                  .truck_delivery,
                                              color: kWhite,
                                              size: 14.0,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "Delivery Address",
                                              style: GoogleFonts.roboto(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400,
                                                color: kWhite,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          customer["address"]["name"],
                                          style: GoogleFonts.sora(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: kWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: kDefaultRadius,
                                    ),
                                    padding: const EdgeInsets.all(25.0),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: Text(
                                      "FOR PICK UP",
                                      style: GoogleFonts.sora(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: kWhite,
                                      ),
                                    ),
                                  )
                            : const SizedBox(),

                        //  PENDING
                        content["orderStatus"] == "pending"
                            ? Column(
                                children: [
                                  elevatedButton(
                                    label: "ACCEPT ORDER",
                                    function: () => updateOrderStatus({
                                      "_id": data["_id"],
                                      "status": "in-progress",
                                    }),
                                    btnColor: kDark,
                                    labelColor: kWhite,
                                  ),
                                  const SizedBox(height: 5.0),
                                  elevatedButton(
                                    label: "CANCEL ORDER",
                                    function: () => updateOrderStatus({
                                      "_id": data["_id"],
                                      "status": "cancelled",
                                    }),
                                    btnColor: kLight,
                                    labelColor: kDanger,
                                  ),
                                ],
                              )
                            : const SizedBox(),

                        //  PENDING
                        content["orderStatus"] == "in-progress"
                            ? Column(
                                children: [
                                  elevatedButton(
                                    label: "COMPLETED",
                                    function: () => updateOrderStatus({
                                      "_id": data["_id"],
                                      "status": "completed",
                                    }),
                                    btnColor: kDark,
                                    labelColor: kWhite,
                                  ),
                                  const SizedBox(height: 5.0),
                                  elevatedButton(
                                    label: "BACK TO PREVIOUS STATUS",
                                    function: () => updateOrderStatus({
                                      "_id": data["_id"],
                                      "status": "pending",
                                    }),
                                    btnColor: kLight,
                                    labelColor: kDanger,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
