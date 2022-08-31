import 'package:app/common/format.dart';
import 'package:app/common/formatPrint.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxList cart = [].obs;
  RxInt total = 0.obs;

  void addToCart(data) {
    final duplicate = cart.where((el) => el["_id"] == data["_id"]);
    if (duplicate.isEmpty) {
      data["quantity"] = 1; // Overwrite value by default
      cart.add(data);
      cart.refresh();
      calculateTotal();
      return;
    }
    cart[cart.indexWhere((el) => el["_id"] == data["_id"])]["quantity"] += 1;
    cart.refresh();
    calculateTotal();
    formatPrint("cart", cart);
  }

  void removeFromCart(id) {
    cart.removeWhere((el) => el["_id"] == id);
    cart.refresh();
    calculateTotal();
    formatPrint("cart", cart);
  }

  void updateCartitemQuantity(id, type) {
    if (type == "add") {
      cart[cart.indexWhere((el) => el["_id"] == id)]["quantity"] += 1;
      cart.refresh();
    }
    if (type == "minus") {
      cart[cart.indexWhere((el) => el["_id"] == id)]["quantity"] -= 1;
      cart.refresh();
    }
    calculateTotal();
  }

  void calculateTotal() {
    total.value = 0; //reset
    for (var item in cart) {
      final qty = item["quantity"];
      final price = formatPrice(item["price"]);
      final sum = qty * price;
      total += sum;
    }
  }
}
