import 'package:flutter/material.dart';
import '../../../core/design/design_tokens.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool enabled;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Buscar...',
    this.onChanged,
    this.onClear,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        boxShadow: DesignTokens.cardShadow,
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.search,
            color: DesignTokens.textSecondaryColor,
          ),
          suffixIcon: onClear != null
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: DesignTokens.textSecondaryColor,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingSm,
          ),
        ),
      ),
    );
  }
}
