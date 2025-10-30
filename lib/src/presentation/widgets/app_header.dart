import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/design_tokens.dart';
import '../providers/auth_provider.dart';

/// Header consistente para todas las pantallas de la aplicación
class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool showUserMenu;

  const AppHeader({
    super.key,
    this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.showUserMenu = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: DesignTokens.primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/dashboard'),
            child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_bar,
              color: Colors.green,
              size: 20,
            ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/dashboard'),
              child: const Text(
                'LA GATA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Notificaciones
        Tooltip(
          message: 'Notificaciones',
          decoration: BoxDecoration(
            color: DesignTokens.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(color: DesignTokens.surfaceColor, fontSize: 12),
          child: IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🔔 Notificaciones próximamente')),
              );
            },
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ),
        // Menú de usuario (solo si se solicita)
        if (showUserMenu) _buildUserMenu(ref, context),
      ],
    );
  }

  Widget _buildUserMenu(WidgetRef ref, BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return PopupMenuButton<String>(
      icon: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 16,
        child: Text(
          authState.user?.name.substring(0, 1).toUpperCase() ?? 'U',
          style: const TextStyle(
            color: DesignTokens.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      onSelected: (value) async {
        switch (value) {
          case 'profile':
            context.push('/profile');
            break;
          case 'settings':
            context.push('/settings');
            break;
          case 'logout':
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Cerrar sesión'),
                content: const Text('¿Deseas cerrar sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Cerrar sesión'),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              ref.read(authProvider.notifier).signOut();
              context.go('/login');
            }
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 8),
              Text('Perfil'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, size: 20),
              SizedBox(width: 8),
              Text('Configuración'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 8),
              Text('Cerrar Sesión'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
