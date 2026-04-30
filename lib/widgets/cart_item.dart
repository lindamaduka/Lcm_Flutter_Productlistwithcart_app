import 'package:my_app/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Calculate total price for this cart item
  double get totalPrice => product.price * quantity;

  // Increment quantity
  void increment() {
    quantity++;
  }

  // Decrement quantity
  void decrement() {
    if (quantity > 0) {
      quantity--;
    }
  }
}
