import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';

/// Widget para mostrar estadísticas en el dashboard
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? change;
  final bool? isPositive;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.change,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: DesignTokens.elevationSm,
      color: DesignTokens.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono y cambio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icono
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                
                // Indicador de cambio
                if (change != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingSm,
                      vertical: DesignTokens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: _getChangeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getChangeIcon(),
                          size: 12,
                          color: _getChangeColor(),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          change!,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeXs,
                            fontWeight: DesignTokens.fontWeightMedium,
                            color: _getChangeColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: DesignTokens.spacingMd),
            
            // Valor principal
            Text(
              value,
              style: TextStyle(
                fontSize: DesignTokens.fontSize2xl,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingXs),
            
            // Título
            Text(
              title,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                color: DesignTokens.textSecondaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Obtiene el color del indicador de cambio
  Color _getChangeColor() {
    if (isPositive == null) return DesignTokens.textSecondaryColor;
    return isPositive! ? DesignTokens.successColor : DesignTokens.errorColor;
  }

  /// Obtiene el icono del indicador de cambio
  IconData _getChangeIcon() {
    if (isPositive == null) return Icons.remove;
    return isPositive! ? Icons.trending_up : Icons.trending_down;
  }
}
