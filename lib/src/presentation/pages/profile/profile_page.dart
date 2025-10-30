import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(color: DesignTokens.textPrimaryColor)),
        backgroundColor: DesignTokens.surfaceColor,
        foregroundColor: DesignTokens.textPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showProfileOptions(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sección de Usuario
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DesignTokens.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: DesignTokens.shadowSmall,
              ),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: DesignTokens.primaryColor,
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: DesignTokens.surfaceColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Información del usuario
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Usuario',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'usuario@ejemplo.com',
                          style: const TextStyle(
                            fontSize: 14,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Sección de Configuración
            _buildSection(
              title: 'Configuración',
              children: [
                _buildSettingItem(
                  icon: Icons.language,
                  title: 'Idioma',
                  subtitle: 'Español',
                  onTap: () => _showLanguageDialog(),
                ),
                _buildSettingItem(
                  icon: Icons.straighten,
                  title: 'Unidades de Medida',
                  subtitle: 'Métricas',
                  onTap: () => _showUnitsDialog(),
                ),
                _buildSettingItem(
                  icon: Icons.notifications,
                  title: 'Notificaciones',
                  subtitle: '9:00',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // Lógica para cambiar notificaciones
                    },
                    activeColor: DesignTokens.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Sección de Ayuda
            _buildSection(
              title: 'Ayuda',
              children: [
                _buildSettingItem(
                  icon: Icons.telegram,
                  title: 'Comunidad en Telegram',
                  onTap: () => _openTelegram(),
                ),
                _buildSettingItem(
                  icon: Icons.feedback,
                  title: 'Sugerencias de Mejora',
                  onTap: () => _openFeedback(),
                ),
                _buildSettingItem(
                  icon: Icons.local_florist,
                  title: 'Sugerir Producto',
                  onTap: () => _suggestProduct(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Sección de Información Legal
            _buildSection(
              title: 'Información Legal',
              children: [
                _buildSettingItem(
                  icon: Icons.privacy_tip,
                  title: 'Política de Privacidad',
                  onTap: () => _openPrivacyPolicy(),
                ),
                _buildSettingItem(
                  icon: Icons.description,
                  title: 'Términos y Condiciones',
                  onTap: () => _openTerms(),
                ),
                _buildSettingItem(
                  icon: Icons.info,
                  title: 'Acerca de',
                  onTap: () => _showAboutDialog(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Botón de Cerrar Sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.errorColor,
                  foregroundColor: DesignTokens.surfaceColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: DesignTokens.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: DesignTokens.shadowSmall,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: DesignTokens.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: DesignTokens.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: DesignTokens.textPrimaryColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: DesignTokens.textSecondaryColor,
              ),
            )
          : null,
      trailing:
          trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: DesignTokens.textSecondaryColor,
          ),
      onTap: onTap,
    );
  }

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar Perfil'),
              onTap: () {
                Navigator.pop(context);
                // Navegar a editar perfil
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                // Navegar a configuración
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Español'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unidades de Medida'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Métricas'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Imperial'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openTelegram() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Abriendo Telegram...')));
  }

  void _openFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo formulario de sugerencias...')),
    );
  }

  void _suggestProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo formulario de sugerir producto...'),
      ),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo política de privacidad...')),
    );
  }

  void _openTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo términos y condiciones...')),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'La Gata',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.pets),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Está seguro de que desea cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
