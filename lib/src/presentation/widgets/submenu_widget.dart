import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';

class SubmenuWidget extends StatelessWidget {
  final String title;
  final List<SubmenuItem> items;
  final VoidCallback? onClose;

  const SubmenuWidget({
    super.key,
    required this.title,
    required this.items,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: DesignTokens.surfaceColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.textPrimaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close,
                      color: DesignTokens.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Items del submenu
              ...items.map(
                (item) => _buildSubmenuItem(context: context, item: item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmenuItem({
    required BuildContext context,
    required SubmenuItem item,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: item.color, size: 20),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: DesignTokens.textSecondaryColor,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: DesignTokens.textSecondaryColor,
        ),
        onTap: () {
          item.onTap();
          if (onClose != null) onClose!();
        },
      ),
    );
  }
}

class SubmenuItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  SubmenuItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
