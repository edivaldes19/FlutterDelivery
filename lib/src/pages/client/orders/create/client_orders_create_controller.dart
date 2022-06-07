import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientOrdersCreateController extends GetxController {
  List<Product> selectedProducts = <Product>[].obs;
  var total = 0.0.obs;
  ClientProductsListController productsListController = Get.find();
  ClientOrdersCreateController() {
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        var result = GetStorage().read('shopping_bag');
        selectedProducts.clear();
        selectedProducts.addAll(result);
      } else {
        var result = Product.fromJsonList(GetStorage().read('shopping_bag'));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
      getTotal();
    }
  }
  void addItem(Product product) {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.remove(product);
    product.quantity = product.quantity! + 1;
    selectedProducts.insert(index, product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
    productsListController.items.value = 0;
    for (var p in selectedProducts) {
      productsListController.items.value += p.quantity!;
    }
  }

  void deleteItem(Product product) {
    selectedProducts.remove(product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
    productsListController.items.value = 0;
    if (selectedProducts.isEmpty) {
      productsListController.items.value = 0;
    } else {
      for (var p in selectedProducts) {
        productsListController.items.value += p.quantity!;
      }
    }
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in selectedProducts) {
      total.value += (product.quantity! * product.price!);
    }
  }

  void goToAddressList() {
    Get.toNamed('/client/address/list');
  }

  void removeItem(Product product) {
    if (product.quantity! > 1) {
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      selectedProducts.remove(product);
      product.quantity = product.quantity! - 1;
      selectedProducts.insert(index, product);
      GetStorage().write('shopping_bag', selectedProducts);
      getTotal();
      productsListController.items.value = 0;
      for (var p in selectedProducts) {
        productsListController.items.value += p.quantity!;
      }
    }
  }
}
