import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';

/// Widget de carga con spinner personalizado
class LoadingSpinner extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const LoadingSpinner({
    super.key,
    this.message,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? DesignTokens.primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              message!,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget de carga para botones
class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? DesignTokens.primaryColor,
        foregroundColor: textColor ?? DesignTokens.textInverseColor,
        disabledBackgroundColor: DesignTokens.textSecondaryColor.withValues(alpha: 0.3),
        disabledForegroundColor: DesignTokens.textSecondaryColor,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(DesignTokens.textInverseColor),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: DesignTokens.spacingSm),
                ],
                Text(text),
              ],
            ),
    );
  }
}

/// Skeleton para tarjetas de productos
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Row(
              children: [
                // Avatar skeleton
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                // Text skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      Container(
                        height: 12,
                        width: 120,
                        decoration: BoxDecoration(
                          color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Status chip skeleton
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            // Content skeleton
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      Container(
                        height: 14,
                        width: 60,
                        decoration: BoxDecoration(
                          color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 16,
                      width: 40,
                      decoration: BoxDecoration(
                        color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXs),
                    Container(
                      height: 12,
                      width: 50,
                      decoration: BoxDecoration(
                        color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            // Buttons skeleton
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton para tarjetas de clientes
class CustomerCardSkeleton extends StatelessWidget {
  const CustomerCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Row(
              children: [
                // Avatar skeleton
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                // Text skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      Container(
                        height: 12,
                        width: 150,
                        decoration: BoxDecoration(
                          color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Status chip skeleton
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            // Phone skeleton
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingXs),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            // Stats skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) => _buildStatSkeleton()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSkeleton() {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Container(
          height: 12,
          width: 30,
          decoration: BoxDecoration(
            color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Container(
          height: 10,
          width: 40,
          decoration: BoxDecoration(
            color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

/// Skeleton para tarjetas de ventas
class SaleCardSkeleton extends StatelessWidget {
  const SaleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            // Customer skeleton
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingXs),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            // Info skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 60,
                      decoration: BoxDecoration(
                        color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXs),
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 16,
                      width: 80,
                      decoration: BoxDecoration(
                        color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXs),
                    Container(
                      height: 12,
                      width: 70,
                      decoration: BoxDecoration(
                        color: DesignTokens.textSecondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de error con opción de reintentar
class ErrorWidget extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorWidget({
    super.key,
    required this.message,
    this.actionText,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: DesignTokens.errorColor,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              'Error',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXl,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              message,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: DesignTokens.spacingLg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(actionText ?? 'Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primaryColor,
                  foregroundColor: DesignTokens.textInverseColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget de estado vacío personalizable
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor ?? DesignTokens.textSecondaryColor,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              title,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightMedium,
                color: DesignTokens.textSecondaryColor,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: DesignTokens.spacingSm),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  color: DesignTokens.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: DesignTokens.spacingLg),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText ?? 'Agregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primaryColor,
                  foregroundColor: DesignTokens.textInverseColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
