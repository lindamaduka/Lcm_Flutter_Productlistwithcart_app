import 'package:flutter/material.dart';
import 'package:my_app/data/products.dart';
import 'package:my_app/widgets/cart_item.dart';
import 'package:my_app/utils/breakpoints.dart';
import 'package:my_app/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CartItem> _cartItems = [];
  int _cartQuantityFor(String productId) {
    try {
      return _cartItems
          .firstWhere((item) => item.product.id == productId)
          .quantity;
    } catch (_) {
      return 0; // Product not in cart
    }
  }

  void _addToCart(String productId) {
    setState(() {
      final existing = _cartItems
          .where((item) => item.product.id == productId)
          .firstOrNull;
      if (existing != null) {
        existing.quantity++;
      } else {
        final product = kProducts.firstWhere((p) => p.id == productId);
        _cartItems.add(CartItem(product: product));
      }
    });
    debugPrint(
      'Cart: ${_cartItems.map((i) => '${i.product.name}×${i.quantity}').join(' | ')}',
    );
  }

  void _incrementQuantity(String productId) {
    setState(() {
      _cartItems.firstWhere((item) => item.product.id == productId).quantity++;
    });
  }

  void _decrementQuantity(String productId) {
    setState(() {
      final item = _cartItems.firstWhere(
        (item) => item.product.id == productId,
      );
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        // Quantity → 0: remove from cart, card reverts to "Add to Cart" button
        _cartItems.removeWhere((i) => i.product.id == productId);
      }
    });
  }

  void _removeItem(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == productId);
    });
  }

  void _clearCart() {
    setState(() => _cartItems.clear());
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => OrderConfirmationDialog(
        cartItems: List.from(_cartItems),
        onStartNewOrder: _clearCart,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _ResponsiveLayout(
          cartItems: _cartItems,
          cartQuantityFor: _cartQuantityFor,
          onAddToCart: _addToCart,
          onIncrement: _incrementQuantity,
          onDecrement: _decrementQuantity,
          onRemove: _removeItem,
          onConfirmOrder: _showOrderConfirmation,
        ),
      ),
    );
  }
}

class _ResponsiveLayout extends StatelessWidget {
  final List<CartItem> cartItems;
  final int Function(String) cartQuantityFor;
  final Function(String) onAddToCart;
  final Function(String) onIncrement;
  final Function(String) onDecrement;
  final Function(String) onRemove;
  final VoidCallback onConfirmOrder;

  const _ResponsiveLayout({
    required this.cartItems,
    required this.cartQuantityFor,
    required this.onAddToCart,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onConfirmOrder,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < Breakpoints.mobile;

    final grid = _ProductGrid(
      cartQuantityFor: cartQuantityFor,
      onAddToCart: onAddToCart,
      onIncrement: onIncrement,
      onDecrement: onDecrement,
    );

    final cart = CartWidget(
      cartItems: cartItems,
      onRemove: onRemove,
      onConfirmOrder: onConfirmOrder,
    );

    if (isMobile) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_PageHeader(), grid, cart, const SizedBox(height: 32)],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_PageHeader(), grid, const SizedBox(height: 32)],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                cart,
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 4),
      child: Text(
        'Desserts',
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w800,
          color: AppColors.darkBrown,
          letterSpacing: -1,
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final int Function(String) cartQuantityFor;
  final Function(String) onAddToCart;
  final Function(String) onIncrement;
  final Function(String) onDecrement;

  const _ProductGrid({
    required this.cartQuantityFor,
    required this.onAddToCart,
    required this.onIncrement,
    required this.onDecrement,
  });

  int _columns(double width) {
    if (width < Breakpoints.mobile) return 1;
    if (width < Breakpoints.tablet) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = _columns(width);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 16,
          mainAxisSpacing: 32,
          childAspectRatio: cols == 1 ? 0.95 : 0.70,
        ),
        itemCount: kProducts.length,
        itemBuilder: (context, index) {
          final product = kProducts[index];
          final qty = cartQuantityFor(product.id);
          return ProductCard(
            product: product,
            cartQuantity: qty,
            onAddToCart: () => onAddToCart(product.id),
            onIncrement: () => onIncrement(product.id),
            onDecrement: () => onDecrement(product.id),
          );
        },
      ),
    );
  }
}
