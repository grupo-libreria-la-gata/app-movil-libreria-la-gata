import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';

/// Widget personalizado para la barra de búsqueda
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onClear,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        border: Border.all(
          color: DesignTokens.dividerColor,
          width: 1,
        ),
        boxShadow: DesignTokens.cardShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: DesignTokens.textSecondaryColor,
            fontSize: DesignTokens.fontSizeMd,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: DesignTokens.textSecondaryColor,
            size: 20,
          ),
          suffixIcon: showClearButton && controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: DesignTokens.textSecondaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                    onChanged?.call('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingMd,
          ),
        ),
        style: TextStyle(
          fontSize: DesignTokens.fontSizeMd,
          color: DesignTokens.textPrimaryColor,
        ),
      ),
    );
  }
}
