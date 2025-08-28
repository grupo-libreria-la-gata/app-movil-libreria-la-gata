import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';
import '../../core/utils/responsive_helper.dart';

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
    final responsiveHelper = ResponsiveHelper.instance;
    final isSmallMobile = responsiveHelper.isSmallMobile(context);
    
    return Card(
      elevation: DesignTokens.elevationSm,
      color: DesignTokens.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Container(
        padding: EdgeInsets.all(responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingSm)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono y cambio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icono
                Container(
                  width: responsiveHelper.getResponsiveIconSize(context, 40),
                  height: responsiveHelper.getResponsiveIconSize(context, 40),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: responsiveHelper.getResponsiveIconSize(context, 20),
                  ),
                ),
                
                // Indicador de cambio
                if (change != null && !isSmallMobile) // Ocultar en móviles muy pequeños
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingSm),
                      vertical: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingXs),
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
                          size: responsiveHelper.getResponsiveIconSize(context, 12),
                          color: _getChangeColor(),
                        ),
                        SizedBox(width: responsiveHelper.getResponsiveSpacing(context, 2)),
                        Text(
                          change!,
                          style: TextStyle(
                            fontSize: responsiveHelper.getResponsiveFontSize(context, DesignTokens.fontSizeXs),
                            fontWeight: DesignTokens.fontWeightMedium,
                            color: _getChangeColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingSm)),
            
            // Valor principal
            Text(
              value,
              style: TextStyle(
                fontSize: responsiveHelper.getResponsiveFontSize(context, DesignTokens.fontSize2xl),
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            
            SizedBox(height: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingXs)),
            
            // Título
            Text(
              title,
              style: TextStyle(
                fontSize: responsiveHelper.getResponsiveFontSize(context, DesignTokens.fontSizeSm),
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
