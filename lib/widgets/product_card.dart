import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isInCart;
  final int quantity;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onIncrement,
    required this.onDecrement,
    required this.isInCart,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    // ── Read brand colour from theme once ──────────────────────
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Image + Button Overlay ───────────────────────────
          SizedBox(
            height: 180,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.asset(
                    product.image,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.cake,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: -18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: isInCart
                        ? _QuantityControl(
                            quantity: quantity,
                            onIncrement: onIncrement,
                            onDecrement: onDecrement,
                            primary: primary, // ← passed from theme
                          )
                        : _AddToCartButton(
                            onAddToCart: onAddToCart,
                            primary: primary, // ← passed from theme
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Product Details ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.category,
                  style: textTheme.bodySmall, // ← from theme
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  style: textTheme.titleMedium, // ← from theme
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: textTheme.labelLarge?.copyWith(
                    color: primary, // ← from theme
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private: "Add to Cart" button ───────────────────────────────
class _AddToCartButton extends StatelessWidget {
  final VoidCallback onAddToCart;
  final Color primary;

  const _AddToCartButton({required this.onAddToCart, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onAddToCart,
        icon: const Icon(Icons.add_shopping_cart, size: 14),
        label: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: primary, // ← from theme
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          side: BorderSide(color: primary, width: 1.5), // ← from theme
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

// ── Private: − quantity + control ───────────────────────────────
class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color primary;

  const _QuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primary, // ← from theme
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CircleIconButton(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          _CircleIconButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

// ── Private: Small circle icon button ───────────────────────────
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Icon(icon, color: Colors.white, size: 12),
      ),
    );
  }
}
