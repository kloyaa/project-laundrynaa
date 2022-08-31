import 'package:app/const/kMaterial.dart';
import 'package:app/views/account/login.dart';
import 'package:app/views/account/registration.dart';
import 'package:app/views/customer/main.dart';
import 'package:app/views/customer/sub/billing_history.dart';
import 'package:app/views/customer/sub/cart.dart';
import 'package:app/views/customer/sub/orders.dart';
import 'package:app/views/laundry/main.dart';
import 'package:app/views/laundry/sub/billing_history.dart';
import 'package:app/views/laundry/sub/laundry_sales.dart';
import 'package:app/views/laundry/sub/laundry_settings.dart';
import 'package:app/views/laundry/sub/service_and_preferences.dart';
import 'package:app/views/loading.dart';
import 'package:app/views/profile/create_profile.dart';
import 'package:app/views/profile/update_profile.dart';
import 'package:app/views/terms_and_agreement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Laundrynaa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        unselectedWidgetColor: kDark,
      ),
      initialRoute: "/login",
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: "/loading",
          page: () => const Loading(),
        ),
        GetPage(
          name: "/terms-and-agreement",
          page: () => const TermsAndAgreement(),
        ),
        GetPage(
          name: "/create-profile",
          page: () => const ViewCreateProfile(),
        ),
        GetPage(
          name: "/update-profile",
          page: () => const ViewProfile(),
        ),
        GetPage(
          name: "/login",
          page: () => const ViewLogin(),
        ),
        GetPage(
          name: "/registration",
          page: () => const ViewRegistration(),
        ),

        // -- CUSTOMER ROUTE STARTS HERE --
        GetPage(
          name: "/view-customer-main",
          page: () => const ViewCustomerMain(),
        ),
        GetPage(
          name: "/view-customer-orders",
          page: () => const ViewCustomerOrders(),
        ),
        GetPage(
          name: "/view-customer-billing-history",
          page: () => const ViewCustomerBillingHistory(),
        ),
        GetPage(
          name: "/view-customer-cart",
          page: () => const ViewCustomerCart(),
        ),

        // -- CUSTOMER ROUTE ENDS HERE --

        // -- LAUNDRY ROUTE STARTS HERE --
        GetPage(
          name: "/view-laundry-main",
          page: () => const ViewLaundryMain(),
        ),
        GetPage(
          name: "/view-laundry-service-and-preferences",
          page: () => const ViewServiceAndPreferences(),
        ),
        GetPage(
          name: "/view-laundry-sales",
          page: () => const ViewLaundrySales(),
        ),
        GetPage(
          name: "/view-laundry-billing-history",
          page: () => const ViewLaundryBillingHistory(),
        ),
        GetPage(
          name: "/view-laundry-settings",
          page: () => const ViewLaundrySettings(),
        ),

        // -- LAUNDRY ROUTE ENDS HERE --
      ],
    );
  }
}
