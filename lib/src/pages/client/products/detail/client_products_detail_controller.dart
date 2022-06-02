import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProductsDetailController extends GetxController {
  List<Product> selectedProducts = [];
  ClientProductsListController productsListController = Get.find();
  void checkIfProductsWasAdded(Product product, var price, var counter) {
    price.value = product.price ?? 0.0;
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts =
            Product.fromJsonList(GetStorage().read('shopping_bag'));
      }
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        counter.value = selectedProducts[index].quantity!;
        price.value = product.price! * counter.value;
      }
    }
  }

  void addToBag(Product product, var price, var counter) {
    if (counter.value > 0) {
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      if (index == -1) {
        if (product.quantity == null) {
          if (counter.value > 0) {
            product.quantity = counter.value;
          } else {
            product.quantity = 1;
          }
        }
        selectedProducts.add(product);
      } else {
        selectedProducts[index].quantity = counter.value;
      }
      GetStorage().write('shopping_bag', selectedProducts);
      Fluttertoast.showToast(msg: 'Producto agregado a la bolsa de compras.');
      productsListController.items.value = 0;
      for (var p in selectedProducts) {
        productsListController.items.value += p.quantity!;
      }
    } else {
      Fluttertoast.showToast(
          msg:
              'Debe seleccionar al menos un producto para agregarlo a la bolsa.');
    }
  }

  void addItem(Product product, var price, var counter) {
    counter.value++;
    price.value = product.price! * counter.value;
  }

  void removeItem(Product product, var price, var counter) {
    if (counter.value > 0) {
      counter.value--;
      price.value = product.price! * counter.value;
    }
  }
}
