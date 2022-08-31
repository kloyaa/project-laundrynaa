import 'package:app/common/formatPrint.dart';
import 'package:app/const/kUrl.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Future<dynamic> createOrder(data) async {
    final response = await Dio().post("$baseUrl/order", data: data);
    formatPrint("createOrder", response.data);
    return response.statusCode;
  }

  Future<dynamic> getCustomerOrders(query) async {
    final response = await Dio().get(
      "$baseUrl/order/get-by-customer",
      queryParameters: query,
    );
    formatPrint("getCustomerOrders", response.data);
    return response.data;
  }

  Future<dynamic> getLaundryOrders(query) async {
    final response = await Dio().get(
      "$baseUrl/order/get-by-laundry",
      queryParameters: query,
    );
    formatPrint("getLaundryOrders", response.data);
    return response.data;
  }

  Future<dynamic> updateOrderStatus(data) async {
    final response = await Dio().put(
      "$baseUrl/order/update/order-status",
      data: data,
    );
    formatPrint("updateOrderStatus", response.data);
    return response.data;
  }
}
