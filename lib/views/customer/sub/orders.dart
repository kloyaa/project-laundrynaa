import 'package:app/common/direct_call.dart';
import 'package:app/common/format.dart';
import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/orderController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/services/open_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:map_launcher/map_launcher.dart';

class ViewCustomerOrders extends StatefulWidget {
  const ViewCustomerOrders({Key? key}) : super(key: key);

  @override
  State<ViewCustomerOrders> createState() => _ViewCustomerOrdersState();
}

class _ViewCustomerOrdersState extends State<ViewCustomerOrders>
    with SingleTickerProviderStateMixin {
  final _orderCtrl = Get.put(OrderController());
  final _userCtrl = Get.put(UserController());

  TabController? _tabController;
  String _currentStatus = "pending";

  late Future _orders;

  Future<void> refresh() async {
    setState(() {
      _orders = _orderCtrl.getCustomerOrders({
        "accountId": _userCtrl.loginData["accountId"],
        "status": _currentStatus,
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _orders = _orderCtrl.getCustomerOrders({
      "accountId": _userCtrl.loginData["accountId"],
      "status": "pending",
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kDark,
      leading: IconButton(
        onPressed: () => Get.toNamed("/view-customer-main"),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kWhite,
        ),
      ),
      title: Text("ORDERS", style: kAppBarStyle),
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
              _orders = _orderCtrl.getCustomerOrders({
                "accountId": _userCtrl.loginData["accountId"],
                "status": "pending",
              });
              _currentStatus = "pending";
            });
          }
          if (value == 1) {
            setState(() {
              _orders = _orderCtrl.getCustomerOrders({
                "accountId": _userCtrl.loginData["accountId"],
                "status": "in-progress",
              });
              _currentStatus = "in-progress";
            });
          }
          if (value == 2) {
            setState(() {
              _orders = _orderCtrl.getCustomerOrders({
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

    return Scaffold(
      appBar: appBar,
      backgroundColor: kLight,
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
                final laundry = data["header"]["laundry"];
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
                      onPressed: () async => await findInMap(
                        Coords(
                          double.parse(
                            laundry["address"]["coordinates"]["latitude"],
                          ),
                          double.parse(
                            laundry["address"]["coordinates"]["longitude"],
                          ),
                        ),
                        title: "${laundry["name"]["first"]}'s Laundry",
                        description: "",
                      ),
                      icon: const Icon(
                        MaterialCommunityIcons.map_search_outline,
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
                          "${laundry["name"]["first"]}'s Laundry",
                          style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: kDark,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async => await callNumber(
                            laundry["contactNumber"],
                          ),
                          child: Text(
                            "${laundry["contactNumber"]}",
                            style: GoogleFonts.robotoMono(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kDark,
                            ),
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
