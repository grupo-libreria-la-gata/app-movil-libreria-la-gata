import 'package:flutter/material.dart';
import '../../../core/design/design_tokens.dart';

class CrudCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final List<CrudAction> actions;
  final VoidCallback? onTap;
  final bool isActive;
  final Widget? trailing;

  const CrudCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.leadingColor,
    this.actions = const [],
    this.onTap,
    this.isActive = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingXs,
      ),
      elevation: DesignTokens.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Row(
            children: [
              // Leading icon
              if (leadingIcon != null) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (leadingColor ?? DesignTokens.primaryColor)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  child: Icon(
                    leadingIcon,
                    color: leadingColor ?? DesignTokens.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
              ],
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeLg,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: isActive
                            ? DesignTokens.textPrimaryColor
                            : DesignTokens.textSecondaryColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: DesignTokens.spacingXs),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondaryColor,
                        ),
                      ),
                    ],
                    if (!isActive) ...[
                      const SizedBox(height: DesignTokens.spacingXs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingSm,
                          vertical: DesignTokens.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: DesignTokens.errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusXs),
                        ),
                        child: Text(
                          'Inactivo',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeXs,
                            color: DesignTokens.errorColor,
                            fontWeight: DesignTokens.fontWeightMedium,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Trailing widget or actions
              if (trailing != null)
                trailing!
              else if (actions.isNotEmpty)
                PopupMenuButton<CrudAction>(
                  onSelected: (action) => action.onPressed(),
                  itemBuilder: (context) => actions
                      .map((action) => PopupMenuItem<CrudAction>(
                            value: action,
                            child: Row(
                              children: [
                                Icon(
                                  action.icon,
                                  size: 20,
                                  color: action.color ?? DesignTokens.textPrimaryColor,
                                ),
                                const SizedBox(width: DesignTokens.spacingSm),
                                Text(action.label),
                              ],
                            ),
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CrudAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const CrudAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });
}
