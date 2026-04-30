import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/cart_item.dart';
import 'cart_item_widget.dart';

class CartWidget extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(String) onIncrement;
  final Function(String) onDecrement;
  final Function(String) onRemove;
  final VoidCallback onConfirmOrder;

  const CartWidget({
    super.key,
    required this.cartItems,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onConfirmOrder,
  });

  double get totalAmount =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    // ── Read from theme once ───────────────────────────────────
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cart Header ──────────────────────────────────────
          Row(
            children: [
              Icon(Icons.shopping_cart, color: primary), // ← from theme
              const SizedBox(width: 8),
              Text(
                'Your Cart ($totalItems)',
                style: textTheme.headlineSmall?.copyWith(
                  color: primary, // ← from theme
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Cart Items or Empty State ─────────────────────
          Expanded(
            child: cartItems.isEmpty
                ? _buildEmptyCart(textTheme)
                : _buildCartItems(),
          ),

          // ── Summary (only when cart has items) ────────────
          if (cartItems.isNotEmpty) ...[
            const Divider(height: 32),
            _buildCartSummary(context, primary, textTheme),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyCart(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/illustration-empty-cart.svg',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 16),
          Text(
            'Your added items will appear here',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ), // ← from theme
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartItems[index];
        return CartItemWidget(
          cartItem: cartItem,
          onIncrement: () => onIncrement(cartItem.product.id),
          onDecrement: () => onDecrement(cartItem.product.id),
          onRemove: () => onRemove(cartItem.product.id),
        );
      },
    );
  }

  Widget _buildCartSummary(
    BuildContext context,
    Color primary,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        // Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Total',
              style: textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ), // ← from theme
            ),
            Text(
              '\$${totalAmount.toStringAsFixed(2)}',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: primary, // ← from theme (replaces Colors.orange)
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Confirm Order Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onConfirmOrder,
            // ← Inherits style from theme — no local override needed
            child: const Text(
              'Confirm Order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
