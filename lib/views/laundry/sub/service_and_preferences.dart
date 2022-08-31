import 'package:app/common/destroyFocus.dart';
import 'package:app/common/formatPrint.dart';
import 'package:app/const/kMaterial.dart';
import 'package:app/controllers/preferenceController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/dialog.dart';
import 'package:app/widget/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewServiceAndPreferences extends StatefulWidget {
  const ViewServiceAndPreferences({Key? key}) : super(key: key);

  @override
  State<ViewServiceAndPreferences> createState() =>
      _ViewServiceAndPreferencesState();
}

class _ViewServiceAndPreferencesState extends State<ViewServiceAndPreferences> {
  final _preferenceController = Get.put(PreferencesController());
  final _userCtrl = Get.put(UserController());

  final _titleCtrl = TextEditingController();
  final _titleFocus = FocusNode();

  final _stocksCtrl = TextEditingController();
  final _stocksFocus = FocusNode();

  final _descriptionCtrl = TextEditingController();
  final _descriptionFocus = FocusNode();

  final _priceCtrl = MoneyMaskedTextController(
    leftSymbol: 'PHP ',
    thousandSeparator: ",",
    decimalSeparator: ".",
  );
  final _priceFocus = FocusNode();

  var selectedPref;
  late Future _preferences;

  void _selectPref(data) {
    setState(() {
      selectedPref = data;
    });
    _titleCtrl.text = data["title"];
    _descriptionCtrl.text = data["description"];
    _priceCtrl.text = data["price"].toString();
    _stocksCtrl.text = data["quantity"].toString();
  }

  void _clearPref() {
    setState(() {
      selectedPref = null;
    });
    _titleCtrl.clear();
    _descriptionCtrl.clear();
    _priceCtrl.text = "00";
    _stocksCtrl.clear();
  }

  Future<void> refresh() async {
    setState(() {
      _preferences = _preferenceController.getPreferences({
        "accountId": _userCtrl.loginData["accountId"],
        "availability": true,
      });
    });
  }

  Future<void> deletePreference(String id) async {
    dialogWarning(
      context,
      action: () async {
        Get.back();
        await _preferenceController.deletePreference(id);
        await refresh();
      },
      message: "Do you wish to remove this preference?",
    );
  }

  Future<void> createPreference() async {
    final title = _titleCtrl.text.trim();
    final description = _descriptionCtrl.text.trim();
    final stocks = _stocksCtrl.text;
    final price = _priceCtrl.text;

    if (title.isEmpty) {
      return _titleFocus.requestFocus();
    } else if (description.isEmpty) {
      return _descriptionFocus.requestFocus();
    } else if (stocks.isEmpty) {
      return _stocksFocus.requestFocus();
    } else if (price == "PHP 0.00") {
      return _priceFocus.requestFocus();
    }
    await _preferenceController.createPreference({
      "accountId": _userCtrl.loginData["accountId"],
      "title": title,
      "description": description,
      "quantity": stocks,
      "price": price
    });
    await refresh();
  }

  Future<void> updatePreference(data) async {
    final title = _titleCtrl.text.trim();
    final description = _descriptionCtrl.text.trim();
    final stocks = _stocksCtrl.text;
    final price = _priceCtrl.text;

    await _preferenceController.updatePreference({
      "_id": data["_id"],
      "title": title,
      "description": description,
      "availability": true,
      "quantity": stocks,
      "price": price
    });
    Get.snackbar(
      "Laundrynaa says",
      "Updated Successfully",
      margin: const EdgeInsets.only(),
      borderRadius: 0,
      backgroundColor: kDark,
      colorText: kWhite,
      overlayBlur: 2,
      //  overlayColor: Colors.black38,
      snackPosition: SnackPosition.TOP,
    );
    await refresh();
    _clearPref();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _preferences = _preferenceController.getPreferences({
      "accountId": _userCtrl.loginData["accountId"],
      "availability": true,
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kDark,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kWhite,
        ),
      ),
      title: Text("PREFERENCES", style: kAppBarStyle),
      actions: [
        selectedPref == null
            ? const SizedBox()
            : IconButton(
                onPressed: () => _clearPref(),
                splashRadius: 25,
                icon: const Icon(
                  AntDesign.close,
                  color: kWhite,
                ),
              ),
      ],
    );

    return GestureDetector(
      onTap: () => destroyFormFocus(context),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: kLight,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            bottom: 30.0,
            top: 30.0,
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: kDefaultRadius,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      inputTextField(
                        controller: _titleCtrl,
                        focusNode: _titleFocus,
                        labelText: "Name",
                        textFieldStyle: GoogleFonts.roboto(
                          color: kDark,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                        color: kLight,
                        obscureText: false,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: inputNumberField(
                              controller: _stocksCtrl,
                              focusNode: _stocksFocus,
                              labelText: "Stocks",
                              textFieldStyle: GoogleFonts.roboto(
                                color: kDark,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                              color: kLight,
                              obscureText: false,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: inputNumberField(
                              controller: _priceCtrl,
                              focusNode: _priceFocus,
                              labelText: "Price",
                              textFieldStyle: GoogleFonts.roboto(
                                color: kDark,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                              color: kLight,
                              obscureText: false,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      inputTextArea(
                        controller: _descriptionCtrl,
                        focusNode: _descriptionFocus,
                        labelText: "Write something about this add-on...",
                        textFieldStyle: GoogleFonts.roboto(
                          color: kDark,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                        color: kLight,
                      ),
                      const SizedBox(height: 10.0),
                      selectedPref != null
                          ? elevatedButton(
                              btnColor: kDark,
                              labelColor: kWhite,
                              label: "SAVE CHANGES",
                              function: () async =>
                                  await updatePreference(selectedPref),
                            )
                          : elevatedButton(
                              btnColor: kDark,
                              labelColor: kWhite,
                              label: "ADD PREFERENCE",
                              function: () async => await createPreference(),
                            ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20.0)),
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
                          margin: EdgeInsets.only(top: index == 0 ? 0 : 20.0),
                          child: ListTile(
                            onTap: () => _selectPref(data),
                            trailing: IconButton(
                              onPressed: () async => deletePreference(
                                data["_id"],
                              ),
                              icon: const Icon(
                                AntDesign.delete,
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
                                    fontWeight: FontWeight.w500,
                                    color: kDark,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  "${data["price"]} | Stocks ${data["quantity"]}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 10.0,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
