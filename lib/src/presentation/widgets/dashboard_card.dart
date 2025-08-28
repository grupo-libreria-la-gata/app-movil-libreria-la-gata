import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';

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
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              
              // Título
              Text(
                title,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: DesignTokens.spacingXs),
              
              // Subtítulo
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeSm,
                  color: DesignTokens.textSecondaryColor,
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
