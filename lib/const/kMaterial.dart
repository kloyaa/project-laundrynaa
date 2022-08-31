import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kDefaultRadius = BorderRadius.all(Radius.circular(5.0));
const kDefaultBodyPadding = EdgeInsets.only(left: 20, right: 20.0);
const kDefaultBodyMargin = EdgeInsets.only(left: 20, right: 20.0);

// Colors
const kPrimary = Color(0xFF00FFFF);
const kSecondary = Color(0xFF00E5E5);
const kDark = Color(0xFF00B2B3);
const kLight = Color.fromARGB(255, 250, 250, 250);
const kWhite = Colors.white;
const kDanger = Colors.red;

// Appbar
final kAppBarStyle = GoogleFonts.roboto(
  color: kWhite,
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
);
