import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/utils/responsive_helper.dart';

/// Página de configuración del sistema
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  double _fontSize = 16.0;
  bool _isDarkMode = false;
  String _selectedLanguage = 'Español';
  final List<String> _languages = ['Español', 'English'];
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingMd,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Configuración de apariencia
            _buildAppearanceSection(),

            const SizedBox(height: DesignTokens.spacingLg),

            // Configuración de idioma
            _buildLanguageSection(),

            const SizedBox(height: DesignTokens.spacingLg),

            // Configuración de notificaciones
            _buildNotificationsSection(),

            const SizedBox(height: DesignTokens.spacingLg),

            // Configuración de sistema
            _buildSystemSection(),

            const SizedBox(height: DesignTokens.spacingLg),

            // Botones de acción
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apariencia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            // Tamaño de fuente
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tamaño de fuente'),
                Text('${_fontSize.round()}px'),
              ],
            ),
            Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 12,
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),

            const SizedBox(height: DesignTokens.spacingMd),

            // Modo oscuro
            SwitchListTile(
              title: const Text('Modo oscuro'),
              subtitle: const Text('Cambiar entre tema claro y oscuro'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Idioma',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            DropdownButtonFormField<String>(
              initialValue: _selectedLanguage,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              items: _languages.map((language) {
                return DropdownMenuItem(value: language, child: Text(language));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notificaciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            SwitchListTile(
              title: const Text('Notificaciones'),
              subtitle: const Text('Recibir notificaciones del sistema'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),

            SwitchListTile(
              title: const Text('Sonido'),
              subtitle: const Text('Reproducir sonidos en las notificaciones'),
              value: _soundEnabled,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    }
                  : null,
            ),

            SwitchListTile(
              title: const Text('Vibración'),
              subtitle: const Text('Vibrar en las notificaciones'),
              value: _vibrationEnabled,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemSection() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sistema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: DesignTokens.spacingMd),

            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Almacenamiento'),
              subtitle: const Text('Gestionar espacio de almacenamiento'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Funcionalidad de almacenamiento en desarrollo',
                    ),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Respaldo'),
              subtitle: const Text('Crear y restaurar respaldos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de respaldo en desarrollo'),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Seguridad'),
              subtitle: const Text('Configurar opciones de seguridad'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de seguridad en desarrollo'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Guardar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingMd),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _resetSettings,
            icon: const Icon(Icons.refresh),
            label: const Text('Restaurar'),
          ),
        ),
      ],
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración guardada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetSettings() {
    setState(() {
      _fontSize = 16.0;
      _isDarkMode = false;
      _selectedLanguage = 'Español';
      _notificationsEnabled = true;
      _soundEnabled = true;
      _vibrationEnabled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración restaurada a valores predeterminados'),
      ),
    );
  }
}
