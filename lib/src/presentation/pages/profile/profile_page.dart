import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user.dart';
import '../../../core/design/design_tokens.dart';

/// Página que muestra el perfil del usuario
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _getMockUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil actualizado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              });
            },
            tooltip: _isEditing ? 'Guardar' : 'Editar',
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => context.go('/home'),
            tooltip: 'Ir al inicio',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con foto de perfil
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    DesignTokens.primaryColor,
                    DesignTokens.primaryColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingXl),
                child: Column(
                  children: [
                    // Foto de perfil
                    GestureDetector(
                      onTap: _isEditing ? _changeProfilePicture : null,
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: DesignTokens.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingLg),
                    
                    // Nombre del usuario
                    Text(
                      _user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingSm),
                    
                    // Email
                    Text(
                      _user.email,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spacingMd),
                    
                    // Badge de estado activo
                    if (_user.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingMd,
                          vertical: DesignTokens.spacingSm,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Activo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Información del perfil
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: Column(
                children: [
                  // Información personal
                  _buildSection(
                    context,
                    title: 'Información Personal',
                    icon: Icons.person,
                    children: [
                      _buildInfoField(
                        context,
                        label: 'Nombre Completo',
                        value: _user.name,
                        icon: Icons.person_outline,
                        isEditing: _isEditing,
                        onChanged: (value) {
                          setState(() {
                            _user = _user.copyWith(name: value);
                          });
                        },
                      ),
                      _buildInfoField(
                        context,
                        label: 'Email',
                        value: _user.email,
                        icon: Icons.email_outlined,
                        isEditing: _isEditing,
                        onChanged: (value) {
                          setState(() {
                            _user = _user.copyWith(email: value);
                          });
                        },
                      ),
                      _buildInfoField(
                        context,
                        label: 'Teléfono',
                        value: _user.phone ?? 'No especificado',
                        icon: Icons.phone_outlined,
                        isEditing: _isEditing,
                        onChanged: (value) {
                          setState(() {
                            _user = _user.copyWith(phone: value);
                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Estadísticas
                  _buildSection(
                    context,
                    title: 'Estadísticas',
                    icon: Icons.analytics,
                    children: [
                      _buildStatCard(
                        context,
                        icon: Icons.calendar_today,
                        title: 'Reservas Totales',
                        value: '12',
                        color: Colors.blue,
                      ),
                      const SizedBox(height: DesignTokens.spacingMd),
                      _buildStatCard(
                        context,
                        icon: Icons.flutter_dash,
                        title: 'Aves Observadas',
                        value: '45',
                        color: Colors.green,
                      ),
                      const SizedBox(height: DesignTokens.spacingMd),
                      _buildStatCard(
                        context,
                        icon: Icons.location_on,
                        title: 'Reservas Visitadas',
                        value: '8',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Opciones de cuenta
                  _buildSection(
                    context,
                    title: 'Cuenta',
                    icon: Icons.settings,
                    children: [
                      _buildOptionTile(
                        context,
                        icon: Icons.notifications_outlined,
                        title: 'Notificaciones',
                        subtitle: 'Configurar alertas y recordatorios',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Configuración de notificaciones próximamente'),
                            ),
                          );
                        },
                      ),
                      _buildOptionTile(
                        context,
                        icon: Icons.security,
                        title: 'Seguridad',
                        subtitle: 'Cambiar contraseña y configuración de seguridad',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Configuración de seguridad próximamente'),
                            ),
                          );
                        },
                      ),
                      _buildOptionTile(
                        context,
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacidad',
                        subtitle: 'Gestionar datos personales',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Configuración de privacidad próximamente'),
                            ),
                          );
                        },
                      ),
                      _buildOptionTile(
                        context,
                        icon: Icons.help_outline,
                        title: 'Ayuda y Soporte',
                        subtitle: 'Centro de ayuda y contacto',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Centro de ayuda próximamente'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Botón de cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar Sesión'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingLg),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: DesignTokens.primaryColor,
              size: 24,
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: DesignTokens.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        ...children,
      ],
    );
  }

  Widget _buildInfoField(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required bool isEditing,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isEditing)
                  TextField(
                    controller: TextEditingController(text: value),
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                else
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: DesignTokens.primaryColor,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _changeProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cambiar foto de perfil próximamente'),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  User _getMockUser() {
    return User(
      id: '1',
      name: 'Juan Nicolás López',
      email: 'juan.lopez@example.com',
      phone: '+505 8888 8888',
      role: UserRole.seller,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    );
  }
}
