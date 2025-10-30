import 'package:flutter/material.dart';
import '../../../data/services/cliente_service.dart';
import '../../../data/models/cliente_model.dart';
import '../../../core/design/design_tokens.dart';

class CrearClientePage extends StatefulWidget {
  const CrearClientePage({super.key});

  @override
  State<CrearClientePage> createState() => _CrearClientePageState();
}

class _CrearClientePageState extends State<CrearClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _service = ClienteService();
  bool _loading = false;

  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _direccionController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _crearCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final request = CrearClienteRequest(
        nombre: _nombreController.text.trim(),
        telefono: _telefonoController.text.trim(),
        email: _emailController.text.trim(),
        direccion: _direccionController.text.trim(),
      );

      final response = await _service.crearCliente(request);

      if (response.success) {
        _mostrarExito(response.message ?? 'Cliente creado exitosamente');
        Navigator.of(context).pop(true);
      } else {
        _mostrarError(response.message ?? 'Error al crear cliente');
      }
    } catch (e) {
      _mostrarError('Error al crear cliente: ${e.toString()}');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text(
          'Crear Cliente',
          style: TextStyle(color: DesignTokens.surfaceColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Información básica
              _buildSectionCard(
                title: 'Información Básica',
                icon: Icons.person,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo *',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es requerido';
                      }
                      if (value.trim().length < 2) {
                        return 'El nombre debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono *',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El teléfono es requerido';
                      }
                      if (value.trim().length < 8) {
                        return 'El teléfono debe tener al menos 8 dígitos';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingLg),

              // Información de contacto
              _buildSectionCard(
                title: 'Información de Contacto',
                icon: Icons.contact_mail,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email *',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El email es requerido';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Ingrese un email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  TextFormField(
                    controller: _direccionController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.words,
                  ),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingLg),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _loading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMd),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _loading ? null : _crearCliente,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignTokens.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Crear Cliente'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: DesignTokens.primaryColor),
                const SizedBox(width: DesignTokens.spacingSm),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeLg,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: DesignTokens.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            ...children,
          ],
        ),
      ),
    );
  }
}
