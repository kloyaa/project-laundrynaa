import 'package:app/common/formatPrint.dart';
import 'package:app/const/kUrl.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileController extends GetxController {
  Map profile = {};
  Map laundryProfile = {};

  Future<dynamic> getProfile(String id) async {
    final response = await Dio().get("$baseUrl/profile/s/$id");
    formatPrint("getProfile", response.data);
    profile = response.data;
    return response.data;
  }

  Future<dynamic> getLaundryProfile(String id) async {
    final response = await Dio().get("$baseUrl/profile/s/$id");
    formatPrint("getLaundryProfile", response.data);
    laundryProfile = response.data;
    return response.data;
  }

  Future<dynamic> createProfile(data) async {
    final response = await Dio().post("$baseUrl/profile", data: data);
    formatPrint("createProfile", response.data);
    return response.statusCode;
  }

  Future<void> updateAvatar(data) async {
    final response = await Dio().put(
      "$baseUrl/profile/photo",
      data: http.FormData.fromMap({
        "accountId": data["accountId"],
        "type": "avatar",
        'img': await http.MultipartFile.fromFile(
          data["img"]["path"],
          filename: data["img"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      }),
    );
    formatPrint("updateAvatar", response.data);
  }

  Future<void> updateQr(data) async {
    final response = await Dio().put(
      "$baseUrl/profile/photo",
      data: http.FormData.fromMap({
        "accountId": data["accountId"],
        "type": "qr",
        'img': await http.MultipartFile.fromFile(
          data["img"]["path"],
          filename: data["img"]["name"],
          contentType: MediaType("image", "jpeg"), //important
        ),
      }),
    );
    formatPrint("updateAvatar", response.data);
  }

  Future<void> updateProfile(data) async {
    final response = await Dio().put("$baseUrl/profile", data: data);
    formatPrint("updateProfile", response.data);
  }

  Future<void> updateSubProfile(data) async {
    final response = await Dio().put("$baseUrl/profile/sub", data: data);
    formatPrint("updateSubProfile", response.data);
  }

  Future<void> updateProfileAddress(data) async {
    final response = await Dio().put("$baseUrl/profile/address", data: data);
    formatPrint("updateProfileAddress", response.data);
  }

  // *********** GALLERY ***********
  Future<dynamic> updateGallery(data) async {
    final userCtrl = Get.put(UserController());

    final response = await Dio().put(
      "$baseUrl/profile/gallery",
      data: http.FormData.fromMap(
        {
          "accountId": userCtrl.loginData["accountId"],
          "description": data["description"],
          "img": await http.MultipartFile.fromFile(
            data["img"]["path"],
            filename: data["img"]["name"],
            contentType: MediaType("image", "jpeg"), //important
          ),
        },
      ),
    );
    formatPrint("updateGallery", response.data);
    return response.statusCode;
  }

  Future<dynamic> getGallery(String id) async {
    final response = await Dio().get("$baseUrl/profile/s/$id");
    return response.data["gallery"].reversed.toList();
  }

  Future<dynamic> deleteFromGallery(jsonData) async {
    await Dio().put("$baseUrl/profile/gallery/remove", data: jsonData);
  }

  // *********** SOCIAL LINKS ***********
  Future<dynamic> updateLinks(jsonData) async {
    final response = await Dio().put("$baseUrl/profile/links", data: jsonData);
    return response.statusCode;
  }

  Future<dynamic> getLinks(String id) async {
    final response = await Dio().get("$baseUrl/profile/s/$id");
    return response.data["links"].reversed.toList();
  }

  Future<dynamic> deleteFromLinks(jsonData) async {
    await Dio().put("$baseUrl/profile/links/remove", data: jsonData);
  }

  // *********** LAUNDRY SHOPS ***********
  Future<dynamic> getLaundryShops() async {
    final locationCoord = await getLocation();
    final response = await Dio().get(
      "$baseUrl/profile/all",
      queryParameters: {
        "role": "laundry",
        "latitude": locationCoord!.latitude,
        "longitude": locationCoord.longitude,
        "sortBy": "asc"
      },
    );
    formatPrint("getLaundryShops", response.data);
    return response.data;
  }
}
