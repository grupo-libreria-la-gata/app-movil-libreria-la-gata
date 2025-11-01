import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../domain/entities/user.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_header.dart';
import '../../../data/services/usuario_service.dart';

/// Página de gestión de roles y permisos
/// Solo accesible para administradores
class RoleManagementPage extends ConsumerStatefulWidget {
  const RoleManagementPage({super.key});

  @override
  ConsumerState<RoleManagementPage> createState() => _RoleManagementPageState();
}

class _RoleManagementPageState extends ConsumerState<RoleManagementPage> {
  bool _isLoading = false;
  List<User> _usuarios = [];
  String _searchQuery = '';
  UserRole? _filterRole;
  bool _mostrarInactivos = false;
  final UsuarioService _usuarioService = UsuarioService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarUsuarios();
    });
  }

  /// Cambia entre mostrar usuarios activos e inactivos
  void _toggleMostrarInactivos(bool value) {
    setState(() => _mostrarInactivos = value);
    _cargarUsuarios();
  }

  /// Verifica que el usuario actual sea administrador
  bool _verificarAcceso(WidgetRef ref, BuildContext context) {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated || !authState.user!.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/admin');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Solo los administradores pueden acceder a esta sección'),
            backgroundColor: DesignTokens.errorColor,
          ),
        );
      });
      return false;
    }
    return true;
  }

  /// Carga la lista de usuarios
  Future<void> _cargarUsuarios() async {
    final authState = ref.read(authProvider);
    final adminId = int.tryParse(authState.user?.id ?? '1') ?? 1;

    setState(() => _isLoading = true);

    try {
      List<User> usuarios;
      if (_mostrarInactivos) {
        usuarios = await _usuarioService.obtenerUsuariosInactivos(adminId);
      } else {
        usuarios = await _usuarioService.obtenerUsuariosActivos(adminId);
      }
      
      setState(() {
        _usuarios = usuarios;
        _isLoading = false;
      });
    } catch (e) {
      // Si falla, usar datos de ejemplo
      setState(() {
        _usuarios = _getDatosEjemplo();
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar usuarios: $e. Mostrando datos de ejemplo.'),
            backgroundColor: DesignTokens.warningColor,
          ),
        );
      }
    }
  }

  /// Datos de ejemplo cuando no hay conexión al backend
  List<User> _getDatosEjemplo() {
    return [
      User(
        id: '1',
        name: 'Admin Principal',
        email: 'admin@lagata.com',
        role: UserRole.admin,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      User(
        id: '2',
        name: 'Juan Pérez',
        email: 'juan@lagata.com',
        role: UserRole.seller,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      User(
        id: '3',
        name: 'María González',
        email: 'maria@lagata.com',
        role: UserRole.inventory,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      User(
        id: '4',
        name: 'Carlos Rodríguez',
        email: 'carlos@lagata.com',
        role: UserRole.cashier,
        isActive: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  /// Obtiene el nombre traducido del rol
  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.seller:
        return 'Vendedor';
      case UserRole.inventory:
        return 'Inventario';
      case UserRole.cashier:
        return 'Cajero';
    }
  }

  /// Obtiene la descripción de permisos del rol
  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Acceso completo al sistema';
      case UserRole.seller:
        return 'Realizar ventas y ver reportes básicos';
      case UserRole.inventory:
        return 'Gestionar productos y stock';
      case UserRole.cashier:
        return 'Solo realizar ventas';
    }
  }

  /// Obtiene el color del rol
  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return DesignTokens.errorColor;
      case UserRole.seller:
        return DesignTokens.successColor;
      case UserRole.inventory:
        return DesignTokens.infoColor;
      case UserRole.cashier:
        return DesignTokens.warningColor;
    }
  }

  /// Filtra los usuarios según búsqueda y rol
  List<User> get _usuariosFiltrados {
    return _usuarios.where((usuario) {
      final matchSearch = _searchQuery.isEmpty ||
          usuario.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          usuario.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchRole = _filterRole == null || usuario.role == _filterRole;
      return matchSearch && matchRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Verificar acceso
    if (!_verificarAcceso(ref, context)) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: const AppHeader(
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Header con información
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            color: DesignTokens.surfaceColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Configurar Permisos y Roles',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeLg,
                              fontWeight: DesignTokens.fontWeightBold,
                              color: DesignTokens.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingXs),
                          Text(
                            'Asigna roles a los usuarios del sistema. Solo los administradores pueden realizar esta acción.',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeMd,
                              color: DesignTokens.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingMd),
                    // Toggle para mostrar inactivos
                    Column(
                      children: [
                        Text(
                          _mostrarInactivos ? 'Mostrando Inactivos' : 'Mostrando Activos',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                        Switch(
                          value: _mostrarInactivos,
                          onChanged: _toggleMostrarInactivos,
                          activeTrackColor: DesignTokens.primaryColor.withValues(alpha: 0.5),
                          activeThumbColor: DesignTokens.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Barra de búsqueda y filtros
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            color: DesignTokens.surfaceColor,
            child: Column(
              children: [
                // Búsqueda
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o email...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: DesignTokens.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                      borderSide: BorderSide(color: DesignTokens.borderLightColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                      borderSide: BorderSide(color: DesignTokens.borderLightColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                      borderSide: BorderSide(
                        color: DesignTokens.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                // Filtro por rol
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'Todos',
                        isSelected: _filterRole == null,
                        onTap: () => setState(() => _filterRole = null),
                      ),
                      const SizedBox(width: DesignTokens.spacingSm),
                      ...UserRole.values.map((role) => Padding(
                            padding: const EdgeInsets.only(right: DesignTokens.spacingSm),
                            child: _buildFilterChip(
                              label: _getRoleName(role),
                              isSelected: _filterRole == role,
                              onTap: () => setState(() => _filterRole = role),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lista de usuarios
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _usuariosFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: DesignTokens.textSecondaryColor,
                            ),
                            const SizedBox(height: DesignTokens.spacingMd),
                            Text(
                              'No se encontraron usuarios',
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeLg,
                                color: DesignTokens.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => _cargarUsuarios(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(DesignTokens.spacingMd),
                          itemCount: _usuariosFiltrados.length,
                          itemBuilder: (context, index) {
                            final usuario = _usuariosFiltrados[index];
                            return _buildUserCard(usuario);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: DesignTokens.primaryColor,
      checkmarkColor: DesignTokens.textInverseColor,
      labelStyle: TextStyle(
        color: isSelected ? DesignTokens.textInverseColor : DesignTokens.textPrimaryColor,
        fontWeight: isSelected ? DesignTokens.fontWeightBold : DesignTokens.fontWeightNormal,
      ),
    );
  }

  Widget _buildUserCard(User usuario) {
    final roleColor = _getRoleColor(usuario.role);
    final roleName = _getRoleName(usuario.role);
    final roleDescription = _getRoleDescription(usuario.role);

    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      elevation: DesignTokens.elevationMd,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: InkWell(
        onTap: () => _mostrarDialogoCambioRol(usuario),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: roleColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person,
                      color: roleColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMd),
                  // Información del usuario
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario.name,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeLg,
                            fontWeight: DesignTokens.fontWeightBold,
                            color: DesignTokens.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacingXs),
                        Text(
                          usuario.email,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeMd,
                            color: DesignTokens.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge de rol
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingMd,
                      vertical: DesignTokens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                      border: Border.all(color: roleColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      roleName,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: roleColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              // Descripción del rol
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: DesignTokens.textSecondaryColor,
                  ),
                  const SizedBox(width: DesignTokens.spacingXs),
                  Expanded(
                    child: Text(
                      roleDescription,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        color: DesignTokens.textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingXs),
              // Estado del usuario y botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: usuario.isActive ? DesignTokens.successColor : DesignTokens.errorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingXs),
                      Text(
                        usuario.isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: usuario.isActive ? DesignTokens.successColor : DesignTokens.errorColor,
                        ),
                      ),
                    ],
                  ),
                  // Botones de acción
                  Row(
                    children: [
                      if (usuario.isActive)
                        TextButton.icon(
                          onPressed: () => _desactivarUsuario(usuario),
                          icon: const Icon(Icons.block, size: 18),
                          label: const Text('Desactivar'),
                          style: TextButton.styleFrom(
                            foregroundColor: DesignTokens.errorColor,
                          ),
                        )
                      else
                        TextButton.icon(
                          onPressed: () => _activarUsuario(usuario),
                          icon: const Icon(Icons.check_circle, size: 18),
                          label: const Text('Activar'),
                          style: TextButton.styleFrom(
                            foregroundColor: DesignTokens.successColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo para cambiar el rol de un usuario
  void _mostrarDialogoCambioRol(User usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cambiar Rol de ${usuario.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rol actual: ${_getRoleName(usuario.role)}',
              style: TextStyle(
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            const Text('Selecciona el nuevo rol:'),
            const SizedBox(height: DesignTokens.spacingMd),
            ...UserRole.values.map((role) {
              if (role == usuario.role) return const SizedBox.shrink();
              return ListTile(
                leading: Icon(
                  Icons.check_circle_outline,
                  color: _getRoleColor(role),
                ),
                title: Text(_getRoleName(role)),
                subtitle: Text(_getRoleDescription(role)),
                onTap: () {
                  Navigator.pop(context);
                  _cambiarRolUsuario(usuario, role);
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  /// Cambia el rol de un usuario
  Future<void> _cambiarRolUsuario(User usuario, UserRole nuevoRol) async {
    final authState = ref.read(authProvider);
    final adminId = int.tryParse(authState.user?.id ?? '1') ?? 1;

    try {
      // Mapear UserRole a rolId del backend
      int rolId;
      switch (nuevoRol) {
        case UserRole.admin:
          rolId = 1;
          break;
        case UserRole.seller:
          rolId = 2;
          break;
        case UserRole.cashier:
          rolId = 3;
          break;
        case UserRole.inventory:
          rolId = 4;
          break;
      }

      await _usuarioService.asignarRol(
        usuarioId: int.parse(usuario.id),
        nuevoRolId: rolId,
        usuarioAdminId: adminId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rol de ${usuario.name} cambiado a ${_getRoleName(nuevoRol)}'),
            backgroundColor: DesignTokens.successColor,
          ),
        );
        _cargarUsuarios();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar rol: $e'),
            backgroundColor: DesignTokens.errorColor,
          ),
        );
      }
    }
  }

  /// Desactiva un usuario
  Future<void> _desactivarUsuario(User usuario) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desactivar Usuario'),
        content: Text('¿Estás seguro de que deseas desactivar a ${usuario.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.errorColor,
              foregroundColor: DesignTokens.textInverseColor,
            ),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    final authState = ref.read(authProvider);
    final adminId = int.tryParse(authState.user?.id ?? '1') ?? 1;

    try {
      await _usuarioService.desactivarUsuario(
        int.parse(usuario.id),
        adminId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario ${usuario.name} desactivado exitosamente'),
            backgroundColor: DesignTokens.successColor,
          ),
        );
        _cargarUsuarios();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al desactivar usuario: $e'),
            backgroundColor: DesignTokens.errorColor,
          ),
        );
      }
    }
  }

  /// Activa un usuario
  Future<void> _activarUsuario(User usuario) async {
    final authState = ref.read(authProvider);
    final adminId = int.tryParse(authState.user?.id ?? '1') ?? 1;

    try {
      await _usuarioService.activarUsuario(
        int.parse(usuario.id),
        adminId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario ${usuario.name} activado exitosamente'),
            backgroundColor: DesignTokens.successColor,
          ),
        );
        _cargarUsuarios();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al activar usuario: $e'),
            backgroundColor: DesignTokens.errorColor,
          ),
        );
      }
    }
  }
}

