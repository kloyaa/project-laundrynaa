import 'package:app/const/kMaterial.dart';
import 'package:flutter/material.dart';

TextField inputTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextEditingController controller,
  required Color color,
  required bool obscureText,
  required FocusNode focusNode,
  suffixIcon = const SizedBox(),
  floatingLabelBehavior = FloatingLabelBehavior.auto,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    obscureText: obscureText,
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
      labelStyle: textFieldStyle,
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: floatingLabelBehavior,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle,
    ),
  );
}

TextField inputNumberField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextEditingController controller,
  required Color color,
  required bool obscureText,
  required FocusNode focusNode,
  suffixIcon = const SizedBox(),
  floatingLabelBehavior = FloatingLabelBehavior.auto,
  Function(String)? onChanged,
  Function()? onEditingComplete,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.number,
    obscureText: obscureText,
    onChanged: onChanged,
    onEditingComplete: onEditingComplete,
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
      labelStyle: textFieldStyle,
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: floatingLabelBehavior,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle,
    ),
  );
}

TextField inputPhoneTextField({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextEditingController controller,
  required Color color,
  required FocusNode focusNode,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
      labelStyle: textFieldStyle,
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle,
    ),
  );
}

TextField inputTextArea({
  required String labelText,
  required TextStyle textFieldStyle,
  required TextEditingController controller,
  required color,
  required focusNode,
  maxLines = 4,
  Function(String)? onChanged,
  Function()? onEditingComplete,
  TextInputAction textInputAction = TextInputAction.newline,
}) {
  return TextField(
    style: textFieldStyle.copyWith(
      fontWeight: FontWeight.bold,
    ),
    controller: controller,
    focusNode: focusNode,
    maxLines: maxLines,
    keyboardType: TextInputType.multiline,
    textInputAction: textInputAction,
    onChanged: onChanged,
    onEditingComplete: onEditingComplete,
    decoration: InputDecoration(
      labelStyle: textFieldStyle,
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: color,
      labelText: labelText,
      alignLabelWithHint: true,
      focusedBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: kDefaultRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.8,
        ),
      ),
      floatingLabelStyle: textFieldStyle.copyWith(
        height: 5,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: textFieldStyle,
    ),
  );
}
