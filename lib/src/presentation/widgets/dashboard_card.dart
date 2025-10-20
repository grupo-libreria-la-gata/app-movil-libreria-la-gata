import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';
import '../../core/utils/responsive_helper.dart';

/// Widget para las tarjetas del dashboard
class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;

    return Card(
      elevation: DesignTokens.elevationMd,
      color: DesignTokens.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Container(
          padding: EdgeInsets.all(
            responsiveHelper.getResponsiveSpacing(
              context,
              DesignTokens.spacingMd,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono
              Container(
                width: responsiveHelper.getResponsiveIconSize(context, 50),
                height: responsiveHelper.getResponsiveIconSize(context, 50),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    DesignTokens.borderRadiusMd,
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: responsiveHelper.getResponsiveIconSize(context, 28),
                ),
              ),
              SizedBox(
                height: responsiveHelper.getResponsiveSpacing(
                  context,
                  DesignTokens.spacingMd,
                ),
              ),

              // Título
              Text(
                title,
                style: TextStyle(
                  fontSize: responsiveHelper.getResponsiveFontSize(
                    context,
                    DesignTokens.fontSizeLg,
                  ),
                  fontWeight: DesignTokens.fontWeightBold,
                  color: const Color(
                    0xFF1A1A1A,
                  ), // Negro suave para mejor contraste
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(
                height: responsiveHelper.getResponsiveSpacing(
                  context,
                  DesignTokens.spacingXs,
                ),
              ),

              // Subtítulo
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: responsiveHelper.getResponsiveFontSize(
                    context,
                    DesignTokens.fontSizeSm,
                  ),
                  color: const Color(
                    0xFF666666,
                  ), // Gris medio para mejor contraste
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
