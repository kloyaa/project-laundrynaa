import 'package:app/common/formatPrint.dart';
import 'package:app/const/kUrl.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class PreferencesController extends GetxController {
  Future<dynamic> createPreference(data) async {
    final response = await Dio().post("$baseUrl/preference", data: data);
    return response.statusCode;
  }

  Future<dynamic> getPreferences(query) async {
    final response = await Dio().get(
      "$baseUrl/preference",
      queryParameters: query,
    );
    // formatPrint("getPreferences", response.data);
    return response.data;
  }

  Future<dynamic> updatePreference(data) async {
    final response = await Dio().put("$baseUrl/preference", data: data);
    formatPrint("updatePreference", response.data);
  }

  Future<dynamic> deletePreference(String id) async {
    await Dio().delete("$baseUrl/preference/$id");
  }
}
