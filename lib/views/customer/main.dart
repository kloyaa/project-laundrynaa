import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/services/open_map.dart';
import 'package:app/views/customer/preview/preview_laundry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:map_launcher/map_launcher.dart';

class ViewCustomerMain extends StatefulWidget {
  const ViewCustomerMain({Key? key}) : super(key: key);

  @override
  State<ViewCustomerMain> createState() => _ViewCustomerMainState();
}

class _ViewCustomerMainState extends State<ViewCustomerMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profileCtrl = Get.put(ProfileController());
  final _userCtrl = Get.put(UserController());

  late Future _laundries;

  Future<void> refresh() async {
    setState(() {
      _laundries = _profileCtrl.getLaundryShops();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _laundries = _profileCtrl.getLaundryShops();
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () => Get.toNamed("/view-customer-orders"),
            leading: Icon(
              MaterialIcons.local_laundry_service,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Orders",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-customer-billing-history"),
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
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: _laundries,
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
              onRefresh: () async => {},
              child: ListView.builder(
                itemCount: snapshot.data.length,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemBuilder: (context, int index) {
                  final data = snapshot.data[index];
                  final firstName = data["name"]["first"];
                  final address = data["address"]["name"];
                  final coordinates = data["address"]["coordinates"];
                  final distance = data["distance"];
                  //final avatar = data["avatar"];

                  return ListTile(
                    onTap: () {
                      Get.put(GlobalController()).selectedLaundry = data;
                      Get.to(() => const PreviewLaundry());
                    },
                    trailing: IconButton(
                      onPressed: () async => await findInMap(
                        Coords(
                          double.parse(coordinates["latitude"]),
                          double.parse(coordinates["longitude"]),
                        ),
                        title: "$firstName's Laundry",
                        description: "",
                      ),
                      icon: const Icon(
                        MaterialCommunityIcons.map_search_outline,
                        color: kDark,
                      ),
                    ),
                    title: Text(
                      "$firstName's Laundry",
                      style: GoogleFonts.roboto(fontSize: 14.0),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return const Icon(
                                  Entypo.star,
                                  color: Colors.orange,
                                  size: 8,
                                );
                              }),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              distance,
                              style: GoogleFonts.roboto(
                                fontSize: 10.0,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          address,
                          style: GoogleFonts.roboto(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
