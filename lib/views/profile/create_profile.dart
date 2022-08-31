import 'package:app/common/destroyFocus.dart';
import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:app/services/location_name.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewCreateProfile extends StatefulWidget {
  const ViewCreateProfile({Key? key}) : super(key: key);

  @override
  State<ViewCreateProfile> createState() => _ViewCreateProfileState();
}

class _ViewCreateProfileState extends State<ViewCreateProfile>
    with WidgetsBindingObserver {
  final _userCtrl = Get.put(UserController());
  final _profileCtrl = Get.put(ProfileController());

  final _fNameCtrl = TextEditingController();
  final _lNameCtrl = TextEditingController();

  final _fNameFocus = FocusNode();
  final _lNameFocus = FocusNode();

  final _emailCtrl = TextEditingController();
  final _emailFocus = FocusNode();

  final _numberCtrl = MaskedTextController(mask: '00000 000 000');
  final _numberFocus = FocusNode();

  final _addressCtrl = TextEditingController();
  final _addressFocus = FocusNode();

  Map _addressCoord = {};
  String _role = "customer";

  Future<void> createProfile() async {
    final firstName = _fNameCtrl.text.trim();
    final lastName = _lNameCtrl.text.trim();
    final number = _numberCtrl.text;

    if (firstName.isEmpty) {
      return _fNameFocus.requestFocus();
    }
    if (lastName.isEmpty) {
      return _lNameFocus.requestFocus();
    }
    if (number.isEmpty) {
      return _numberFocus.requestFocus();
    }
    if (_addressCtrl.text.isEmpty) {
      return _addressFocus.requestFocus();
    }

    Get.toNamed("/loading");
    final response = await _profileCtrl.createProfile(
      {
        "accountId": _userCtrl.loginData["accountId"],
        "name": {
          "first": firstName,
          "last": lastName,
        },
        "address": {
          "name": _addressCtrl.text,
          "coordinates": _addressCoord,
        },
        "contact": {
          "email": _userCtrl.loginData["email"],
          "number": number.toString().replaceAll(" ", ""),
        },
        "role": _role
      },
    );

    if (response == 200) {
      await _profileCtrl
          .getProfile(_userCtrl.loginData["accountId"])
          .then((value) {
        if (value["role"] == "customer") {
          return Get.toNamed("/view-customer-main");
        }
        if (value["role"] == "laundry") {
          return Get.toNamed("/view-laundry-main");
        }
      }).catchError((err) {
        print("ERROR CREATING PROFILE");
      });
    }
  }

  Future<void> getLocationAutomatically() async {
    final locationCoord = await getLocation();
    final locationName = await getLocationName(
      lat: locationCoord!.latitude,
      long: locationCoord.longitude,
    );
    final String street = locationName[0].street.toString().contains("+")
        ? ""
        : "${locationName[0].street}, ";
    final String thoroughFare = locationName[0].thoroughfare.toString().isEmpty
        ? ""
        : "${locationName[0].thoroughfare}, ";
    final String locality = locationName[0].locality.toString().isEmpty
        ? ""
        : "${locationName[0].locality}";

    setState(() {
      _addressCoord = {
        "latitude": locationCoord.latitude,
        "longitude": locationCoord.longitude
      };
    });
    _addressCtrl.text = "$street$thoroughFare$locality";
  }

  void clearAllFields() {
    _fNameCtrl.clear();
    _lNameCtrl.clear();
    _numberCtrl.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationAutomatically();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        getLocationAutomatically();
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kDark,
      leading: const SizedBox(),
      leadingWidth: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("UPDATE PROFILE", style: kAppBarStyle),
          Text(
            _userCtrl.loginData["email"],
            style: GoogleFonts.roboto(
              color: kWhite,
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed("/login"),
          icon: const Icon(
            AntDesign.close,
            color: kWhite,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => destroyFormFocus(context),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: kLight,
          resizeToAvoidBottomInset: false,
          appBar: appBar,
          body: Container(
            padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: inputTextField(
                        controller: _fNameCtrl,
                        focusNode: _fNameFocus,
                        color: kWhite,
                        labelText: "First",
                        textFieldStyle: GoogleFonts.roboto(
                          color: kDark,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: inputTextField(
                        controller: _lNameCtrl,
                        focusNode: _lNameFocus,
                        color: kWhite,
                        labelText: "Last",
                        textFieldStyle: GoogleFonts.roboto(
                          color: kDark,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                inputPhoneTextField(
                  controller: _numberCtrl,
                  focusNode: _numberFocus,
                  color: kWhite,
                  labelText: "Contact Number",
                  textFieldStyle: GoogleFonts.roboto(
                    color: kDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                IgnorePointer(
                  ignoring: true,
                  child: inputTextField(
                    controller: _addressCtrl,
                    focusNode: _addressFocus,
                    color: kWhite,
                    labelText: "Home Address",
                    textFieldStyle: GoogleFonts.roboto(
                      color: kDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: kDefaultRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile(
                        activeColor: kDark,
                        title: Text(
                          "Customer",
                          style: GoogleFonts.roboto(
                            color: kDark,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                          ),
                        ),
                        value: "customer",
                        groupValue: _role,
                        onChanged: (value) {
                          setState(() {
                            _role = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        activeColor: kDark,
                        title: Text(
                          "Laundry",
                          style: GoogleFonts.roboto(
                            color: kDark,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                          ),
                        ),
                        value: "laundry",
                        groupValue: _role,
                        onChanged: (value) {
                          setState(() {
                            _role = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                elevatedButton(
                  btnColor: kDark,
                  labelColor: kWhite,
                  label: "SAVE AND CONTINUE",
                  function: () async => createProfile(),
                ),
                const SizedBox(height: 10.0),
                elevatedButton(
                  btnColor: kLight,
                  labelColor: kDark,
                  label: "CLEAR ALL FIELDS",
                  function: () => clearAllFields(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _emailCtrl.dispose();
    _emailFocus.dispose();

    _fNameCtrl.dispose();
    _fNameFocus.dispose();

    _lNameCtrl.dispose();
    _lNameFocus.dispose();

    _numberCtrl.dispose();
    _numberFocus.dispose();

    _addressCtrl.dispose();
    _addressFocus.dispose();
  }
}
