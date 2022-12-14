import 'package:app/const/kMaterial.dart';
import 'package:app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndAgreement extends StatefulWidget {
  const TermsAndAgreement({Key? key}) : super(key: key);

  @override
  State<TermsAndAgreement> createState() => _TermsAndAgreementState();
}

class _TermsAndAgreementState extends State<TermsAndAgreement> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kLight,
        body: Scrollbar(
          child: Container(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                RichText(
                  text: TextSpan(
                    text: '1. AGREEMENT TO TERMS',
                    style: GoogleFonts.roboto(
                      color: kDark,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '\n\n        These Terms of Use constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you”) and Event Booking Application ("Company," “we," “us," or “our”), concerning your access to and use of the website as well as any other media form, media channel, mobile website or mobile application related, linked, or otherwise connected thereto (collectively, the “Site”). We are registered in the Philippines and have our registered office at Carmen, Cagayan De Oro City, Misamis Oriental 9000. You agree that by accessing the Site, you have read, understood, and agreed to be bound by all of these Terms of Use. IF YOU DO NOT AGREE WITH ALL OF THESE TERMS OF USE, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SITE AND YOU MUST DISCONTINUE USE IMMEDIATELY. Supplemental terms and conditions or documents that may be posted on the Site from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms of Use at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of these Terms of Use, and you waive any right to receive specific notice of each such change. Please ensure that you check the applicable Terms every time you use our Site so that you understand which Terms apply. You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised Terms of Use by your continued use of the Site after the date such revised Terms of Use are posted. The information provided on the Site is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Site from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable. The Site is intended for users who are at least 13 years of age. All users who are minors in the jurisdiction in which they reside (generally under the age of 18) must have the permission of, and be directly supervised by, their parent or guardian to use the Site. If you are a minor, you must have your parent or guardian read and agree to these Terms of Use prior to you using the Site.',
                        style: GoogleFonts.roboto(
                          color: kDark,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                RichText(
                  text: TextSpan(
                    text: '2. PROHIBITED ACTIVITIES',
                    style: GoogleFonts.roboto(
                      color: kDark,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '\n\n      You may not access or use the Site for any purpose other than that for which we make the Site available. The Site may not be used in connection with any commercial endeavors except those that are specifically endorsed or approved by us. \n \n •	As a user of the Site, you agree not to: Systematically retrieve data or other content from the Site to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us. \n \n •	Trick, defraud, or mislead us and other users, especially in any attempt to learn sensitive account information such as user passwords. •	Circumvent, disable, or otherwise interfere with security-related features of the Site, including features that prevent or restrict the use or copying of any Content or enforce limitations on the use of the Site and/or the Content contained therein. \n \n •	Disparage, tarnish, or otherwise harm, in our opinion, us and/or the Site. \n \n •	Use any information obtained from the Site in order to harass, abuse, or harm another person. \n \n •	Make improper use of our support services or submit false reports of abuse or misconduct. \n \n •	Use the Site in a manner inconsistent with any applicable laws or regulations. Engage in unauthorized framing of or linking to the Site. \n \n •	Upload or transmit (or attempt to upload or to transmit) viruses, Trojan horses, or other material, including excessive use of capital letters and spamming (continuous posting of repetitive text), that interferes with any party’s uninterrupted use and enjoyment of the Site or modifies, impairs, disrupts, alters, or interferes with the use, features, functions, operation, or maintenance of the Site. \n \n •	Engage in any automated use of the system, such as using scripts to send comments or messages, or using any data mining, robots, or similar data gathering and extraction tools. \n \n •	Delete the copyright or other proprietary rights notice from any Content. \n \n •	Attempt to impersonate another user or person or use the username of another user. \n \n •	Upload or transmit (or attempt to upload or to transmit) any material that acts as a passive or active information collection or transmission mechanism, including without limitation, clear graphics interchange formats (“gifs”), 1×1 pixels, web bugs, cookies, or other similar devices (sometimes referred to as “spyware” or “passive collection mechanisms” or “pcms”). \n \n •	Interfere with, disrupt, or create an undue burden on the Site or the networks or services connected to the Site. \n \n •	Harass, annoy, intimidate, or threaten any of our employees or agents engaged in providing any portion of the Site to you. \n \n •	Attempt to bypass any measures of the Site designed to prevent or restrict access to the Site, or any portion of the Site. \n \n •	Copy or adapt the Site’s software, including but not limited to Flash, PHP, HTML, JavaScript, or other code. \n \n •	Except as permitted by applicable law, decipher, decompile, disassemble, or reverse engineer any of the software comprising or in any way making up a part of the Site. \n \n •	Except as may be the result of standard search engine or Internet browser usage, use, launch, develop, or distribute any automated system, including without limitation, any spider, robot, cheat utility, scraper, or offline reader that accesses the Site, or using or launching any unauthorized script or other software. \n \n •	Use a buying agent or purchasing agent to make purchases on the Site. \n \n •	Make any unauthorized use of the Site, including collecting usernames and/or email addresses of users by electronic or other means for the purpose of sending unsolicited email, or creating user accounts by automated means or under false pretenses. \n \n •	Use the Site as part of any effort to compete with us or otherwise use the Site and/or the Content for any revenue-generating endeavor or commercial enterprise. \n \n •	Use the Site to advertise or offer to sell goods and services.',
                        style: GoogleFonts.roboto(
                          color: kDark,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                Container(
                  margin: const EdgeInsets.only(top: 100.0, bottom: 50.0),
                  height: Get.height * 0.06,
                  width: Get.width,
                  child: elevatedButton(
                    btnColor: kDark,
                    labelColor: kWhite,
                    label: "YES, I AGREE AND UNDERSTAND",
                    function: () => Get.toNamed("/registration"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
