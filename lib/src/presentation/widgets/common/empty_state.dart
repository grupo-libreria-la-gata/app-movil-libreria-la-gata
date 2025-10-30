import 'package:flutter/material.dart';
import '../../../core/design/design_tokens.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
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
              textAlign: TextAlign.center,
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
            if (action != null) ...[
              const SizedBox(height: DesignTokens.spacingLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
