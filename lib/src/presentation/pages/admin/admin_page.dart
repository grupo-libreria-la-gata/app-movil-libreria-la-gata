import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';

/// Página de administración del sistema
class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text(
          'Administración',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Text(
              'Panel de Administración',
              style: TextStyle(
                fontSize: DesignTokens.fontSize2xl,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              'Gestiona el sistema y configura los parámetros',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textSecondaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXl),

            // Opciones de administración
            _buildAdminOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOptions(BuildContext context) {
    return Column(
      children: [
        _buildAdminCard(
          context,
          title: 'Agregar Nuevo Usuario',
          subtitle: 'Registrar un nuevo empleado en el sistema',
          icon: Icons.person_add,
          color: DesignTokens.primaryColor,
          onTap: () => context.push('/register'),
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        _buildAdminCard(
          context,
          title: 'Gestión de Roles',
          subtitle: 'Configurar permisos y roles de usuarios',
          icon: Icons.security,
          color: DesignTokens.accentColor,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gestión de roles - En desarrollo'),
                backgroundColor: Colors.orange,
              ),
            );
          },
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        _buildAdminCard(
          context,
          title: 'Respaldo y Restauración',
          subtitle: 'Gestionar copias de seguridad',
          icon: Icons.backup,
          color: DesignTokens.warningColor,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Respaldo y restauración - En desarrollo'),
                backgroundColor: Colors.orange,
              ),
            );
          },
        ),

        const SizedBox(height: DesignTokens.spacingMd),

        _buildAdminCard(
          context,
          title: 'Gestión de Marcas',
          subtitle: 'Crear, editar y desactivar marcas',
          icon: Icons.local_offer,
          color: DesignTokens.successColor,
          onTap: () => context.push('/admin/brands'),
        ),

        const SizedBox(height: DesignTokens.spacingMd),

        _buildAdminCard(
          context,
          title: 'Gestión de Productos',
          subtitle: 'Administrar productos',
          icon: Icons.precision_manufacturing,
          color: DesignTokens.infoColor,
          onTap: () => context.push('/admin/products'),
        ),

        const SizedBox(height: DesignTokens.spacingMd),

        _buildAdminCard(
          context,
          title: 'Gestión de Categorías',
          subtitle: 'Organizar productos por categoría',
          icon: Icons.category,
          color: DesignTokens.warningColor,
          onTap: () => context.push('/admin/categories'),
        ),
      ],
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: DesignTokens.elevationMd,
      color: DesignTokens.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Row(
            children: [
              // Icono
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    DesignTokens.borderRadiusMd,
                  ),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: DesignTokens.spacingLg),

              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeLg,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingXs),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeMd,
                        color: DesignTokens.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Flecha
              Icon(
                Icons.arrow_forward_ios,
                color: DesignTokens.textSecondaryColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
