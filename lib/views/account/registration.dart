import 'package:app/common/destroyFocus.dart';
import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewRegistration extends StatefulWidget {
  const ViewRegistration({Key? key}) : super(key: key);

  @override
  State<ViewRegistration> createState() => _ViewRegistrationState();
}

class _ViewRegistrationState extends State<ViewRegistration> {
  bool errorRegistration = false;
  final _userCtrl = Get.put(UserController());
  final _profileCtrl = Get.put(ProfileController());

  final _emailCtrl = TextEditingController();
  final _emailFocus = FocusNode();

  final _passwordCtrl = TextEditingController();
  final _passwordFocus = FocusNode();

  final _passwordRepeatCtrl = TextEditingController();
  final _passwordRepeatFocus = FocusNode();

  Future _register() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final password2 = _passwordRepeatCtrl.text.trim();

    if (email.isEmpty) {
      return _emailFocus.requestFocus();
    } else if (!email.isEmail) {
      return _emailFocus.requestFocus();
    } else if (password.isEmpty) {
      return _passwordFocus.requestFocus();
    } else if (password2.isEmpty) {
      return _passwordRepeatFocus.requestFocus();
    }

    if (password.isNotEmpty && password2.isNotEmpty && password != password2) {
      return _passwordRepeatFocus.requestFocus();
    }
    Get.toNamed("/loading");
    final response = await _userCtrl.register(email: email, password: password);

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
        return Get.toNamed("/create-profile");
      });
    }
    if (response == 400) {
      setState(() {
        errorRegistration = true;
      });
      Get.back();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _emailCtrl.text = "customer@gmail.com";
    // _passwordCtrl.text = "password";
    // _passwordRepeatCtrl.text = "password";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => destroyFormFocus(context),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: kLight,
          resizeToAvoidBottomInset: false,
          body: Container(
            padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  "LAUNDRYNAA",
                  style: GoogleFonts.tenorSans(
                    color: kDark,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Account Registration",
                  style: GoogleFonts.roboto(
                    color: kDark,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 30.0),
                inputTextField(
                  controller: _emailCtrl,
                  focusNode: _emailFocus,
                  color: kWhite,
                  labelText: "Email",
                  textFieldStyle: GoogleFonts.roboto(
                    color: kDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 10.0),
                inputTextField(
                  controller: _passwordCtrl,
                  focusNode: _passwordFocus,
                  color: kWhite,
                  labelText: "Password",
                  textFieldStyle: GoogleFonts.roboto(
                    color: kDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10.0),
                inputTextField(
                  controller: _passwordRepeatCtrl,
                  focusNode: _passwordRepeatFocus,
                  color: kWhite,
                  labelText: "Confirm Password",
                  textFieldStyle: GoogleFonts.roboto(
                    color: kDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                  obscureText: true,
                ),
                errorRegistration
                    ? GestureDetector(
                        onTap: () => Get.toNamed("/login"),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: kDanger,
                            borderRadius: kDefaultRadius,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                AntDesign.warning,
                                color: kWhite,
                                size: 26.0,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  "The email you entered is already connected\nto an account. Login to Lareservv account.",
                                  style: GoogleFonts.roboto(
                                    color: kWhite,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                const Spacer(flex: 5),
                elevatedButton(
                  btnColor: kDark,
                  labelColor: kWhite,
                  label: "CREATE ACCOUNT",
                  function: () async => await _register(),
                ),
                const SizedBox(height: 10.0),
                elevatedButton(
                  btnColor: kLight,
                  labelColor: kDark,
                  label: "ALREADY REGISTERED?",
                  function: () => Get.toNamed("/login"),
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

    // dispose email
    _emailCtrl.dispose();
    _emailFocus.dispose();

    // dispose password
    _passwordCtrl.dispose();
    _passwordFocus.dispose();
  }
}
