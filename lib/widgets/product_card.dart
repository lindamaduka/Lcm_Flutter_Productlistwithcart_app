import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/models/product.dart';
import 'package:my_app/utils/breakpoints.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int cartQuantity;
  final VoidCallback onAddToCart;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductCard({
    super.key,
    required this.product,
    required this.cartQuantity,
    required this.onAddToCart,
    required this.onIncrement,
    required this.onDecrement,
  });

  bool get _inCart => cartQuantity > 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Orange border appears when item is in cart — matches design
        border: _inCart
            ? Border.all(color: AppColors.red, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImageArea(
            imageUrl: product.imageUrl,
            inCart: _inCart,
            cartQuantity: cartQuantity,
            onAddToCart: onAddToCart,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF87635A),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBrown,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red,
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

// ─────────────────────────────────────────────────────────────────────────────
// Image + overlaid button at bottom edge of photo
// ─────────────────────────────────────────────────────────────────────────────
class _ProductImageArea extends StatelessWidget {
  final String imageUrl;
  final bool inCart;
  final int cartQuantity;
  final VoidCallback onAddToCart;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _ProductImageArea({
    required this.imageUrl,
    required this.inCart,
    required this.cartQuantity,
    required this.onAddToCart,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Product photo
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: AspectRatio(
            aspectRatio: 1.05,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFFF5E6D3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.red,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFF5E6D3),
                child: const Icon(
                  Icons.bakery_dining,
                  size: 40,
                  color: AppColors.red,
                ),
              ),
            ),
          ),
        ),

        // Button overlaid on bottom edge of image
        Positioned(
          bottom: -18,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: inCart
                  ? _QuantityStepper(
                      key: const ValueKey('stepper'),
                      quantity: cartQuantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    )
                  : _AddToCartButton(
                      key: const ValueKey('add'),
                      onPressed: onAddToCart,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// White pill "Add to Cart"
// Uses: assets/images/icon-add-to-cart.svg
// ─────────────────────────────────────────────────────────────────────────────
class _AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddToCartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFFADADAD), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ icon-add-to-cart.svg
            SvgPicture.asset(
              'assets/images/icon-add-to-cart.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Red pill stepper  [ − qty + ]
// Uses: assets/images/icon-decrement-quantity.svg
//       assets/images/icon-increment-quantity.svg
// ─────────────────────────────────────────────────────────────────────────────
class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ icon-decrement-quantity.svg
          _SvgCircleButton(
            assetPath: 'assets/images/icon-decrement-quantity.svg',
            onTap: onDecrement,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          // ✅ icon-increment-quantity.svg
          _SvgCircleButton(
            assetPath: 'assets/images/icon-increment-quantity.svg',
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

/// Circle button with an SVG icon inside — used for stepper +/−
class _SvgCircleButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _SvgCircleButton({required this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white70, width: 1.5),
        ),
        child: Center(
          child: SvgPicture.asset(assetPath, width: 10, height: 10),
        ),
      ),
    );
  }
}
