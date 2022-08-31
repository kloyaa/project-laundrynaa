import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/cartController.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/preferenceController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/services/open_map.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_badged/flutter_badge.dart';

class PreviewLaundry extends StatefulWidget {
  const PreviewLaundry({Key? key}) : super(key: key);

  @override
  State<PreviewLaundry> createState() => _PreviewLaundryState();
}

class _PreviewLaundryState extends State<PreviewLaundry> {
  final _globalCtrl = Get.put(GlobalController());
  final _profileCtrl = Get.put(ProfileController());
  final _cartCtrl = Get.put(CartController());

  final _preferenceController = Get.put(PreferencesController());

  late Future _preferences;
  late Future _profile;

  Future<void> refresh() async {
    setState(() {
      _preferences = _preferenceController.getPreferences({
        "accountId": _globalCtrl.selectedLaundry["accountId"],
        "availability": true,
      });
    });
  }

  void addToCart(Map data) {
    Get.snackbar(
      "Laundrynaa says",
      "Added to cart Successfully",
      margin: const EdgeInsets.only(),
      borderRadius: 0,
      backgroundColor: kDark,
      colorText: kWhite,
      overlayBlur: 2,
      duration: const Duration(seconds: 1),

      icon: const Icon(
        AntDesign.check,
        color: kWhite,
      ),
      //  overlayColor: Colors.black38,
      snackPosition: SnackPosition.TOP,
    );
    _cartCtrl.addToCart(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _preferences = _preferenceController.getPreferences({
      "accountId": _globalCtrl.selectedLaundry["accountId"],
      "availability": true,
    });
    _profile = _profileCtrl.getLaundryProfile(
      _globalCtrl.selectedLaundry["accountId"],
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstName = _globalCtrl.selectedLaundry["name"]["first"];
    final address = _globalCtrl.selectedLaundry["address"]["name"];
    final coordinates = _globalCtrl.selectedLaundry["address"]["coordinates"];
    final avatar = _globalCtrl.selectedLaundry["avatar"];

    final appBar = AppBar(
      backgroundColor: kDark,
      leadingWidth: 89.0,
      leading: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Ionicons.arrow_back,
              color: kWhite,
            ),
          ),
          SizedBox(
            height: 40.0,
            width: 40.0,
            child: CircularProfileAvatar(avatar),
          )
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$firstName's Laundry",
            style: kAppBarStyle,
          ),
          Text(
            address,
            style: GoogleFonts.roboto(
              color: kWhite,
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        Obx(() => IconButton(
              onPressed: () => Get.toNamed("/view-customer-cart"),
              icon: FlutterBadge(
                icon: const Icon(
                  MaterialCommunityIcons.cart,
                  color: kWhite,
                ),
                borderRadius: 20.0,
                itemCount: _cartCtrl.cart.length,
              ),
            ))
      ],
    );

    return Scaffold(
      backgroundColor: kLight,
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: () async => refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 150.0,
              backgroundColor: kDark,
              leading: const SizedBox(),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  avatar,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: _profile,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const SizedBox();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    // return SizedBox();
                  }

                  final deliveryFee =
                      snapshot.data["laundryProfile"]["deliveryFee"];
                  final pricePerKg =
                      snapshot.data["laundryProfile"]["pricePerKg"];
                  final serviceHrs =
                      snapshot.data["laundryProfile"]["serviceHrs"];

                  return Container(
                    color: kWhite,
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        IconButton(
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
                        const Spacer(),
                        Container(
                          width: 2,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: kDark,
                            borderRadius: kDefaultRadius,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  MaterialCommunityIcons.truck_delivery,
                                  color: kDark,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Delivery fee $deliveryFee",
                                  style: GoogleFonts.roboto(
                                    color: kDark,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  MaterialCommunityIcons.weight_kilogram,
                                  color: kDark,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Price per Kilo $pricePerKg",
                                  style: GoogleFonts.roboto(
                                    color: kDark,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  MaterialCommunityIcons.clock_time_four,
                                  color: kDark,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Open from $serviceHrs",
                                  style: GoogleFonts.roboto(
                                    color: kDark,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: kWhite,
                padding: const EdgeInsets.all(25.0),
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Preferences",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    color: kDark,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: FutureBuilder(
                future: _preferences,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const SizedBox();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    // return SizedBox();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, int index) {
                      final data = snapshot.data[index];

                      return Container(
                        decoration: const BoxDecoration(color: kWhite),
                        padding: const EdgeInsets.all(5.0),
                        margin: const EdgeInsets.only(top: 5.0),
                        child: ListTile(
                          onTap: () => {},
                          trailing: IconButton(
                            onPressed: () => addToCart(data),
                            icon: const Icon(
                              AntDesign.plus,
                              color: kDark,
                            ),
                          ),
                          title: Text(
                            data["title"],
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: kDark,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data["description"]}",
                                style: GoogleFonts.roboto(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  color: kDark,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                "${data["price"]}",
                                style: GoogleFonts.robotoMono(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: kDark.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
