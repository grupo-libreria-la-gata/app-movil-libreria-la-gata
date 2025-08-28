import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/services/business_service.dart';
import '../../../core/services/error_service.dart';
import '../../../config/app_config.dart';
import '../../widgets/loading_widgets.dart';

/// Página de configuración del sistema
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> with LoadingMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos
  late TextEditingController _taxRateController;
  late TextEditingController _defaultDiscountController;
  late TextEditingController _businessNameController;
  late TextEditingController _businessAddressController;
  late TextEditingController _businessPhoneController;
  late TextEditingController _businessEmailController;
  late TextEditingController _businessRucController;
  late TextEditingController _invoicePrefixController;
  
  // Variables de estado
  DiscountType _selectedDiscountType = DiscountType.none;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadCurrentSettings();
  }

  @override
  void dispose() {
    _taxRateController.dispose();
    _defaultDiscountController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _businessPhoneController.dispose();
    _businessEmailController.dispose();
    _businessRucController.dispose();
    _invoicePrefixController.dispose();
    super.dispose();
  }

  /// Inicializa los controladores
  void _initializeControllers() {
    _taxRateController = TextEditingController();
    _defaultDiscountController = TextEditingController();
    _businessNameController = TextEditingController();
    _businessAddressController = TextEditingController();
    _businessPhoneController = TextEditingController();
    _businessEmailController = TextEditingController();
    _businessRucController = TextEditingController();
    _invoicePrefixController = TextEditingController();
  }

  /// Carga la configuración actual
  void _loadCurrentSettings() {
    final config = BusinessConfig.getCurrentConfig();
    
    _taxRateController.text = config['taxRate'].toString();
    _defaultDiscountController.text = config['defaultDiscount'].toString();
    _selectedDiscountType = DiscountType.values.firstWhere(
      (e) => e.name == config['defaultDiscountType'],
      orElse: () => DiscountType.none,
    );
    
    _businessNameController.text = config['businessName'];
    _businessAddressController.text = config['businessAddress'];
    _businessPhoneController.text = config['businessPhone'];
    _businessEmailController.text = config['businessEmail'];
    _businessRucController.text = config['businessRuc'];
    _invoicePrefixController.text = config['invoicePrefix'];
    
    setState(() {
      _isDirty = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        title: const Text('Configuración del Sistema'),
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isDirty)
            TextButton(
              onPressed: _saveSettings,
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Configuración de Impuestos',
                Icons.receipt_long,
                'Configura los impuestos aplicados a las ventas',
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              _buildTaxSettings(),
              const SizedBox(height: DesignTokens.spacingXl),
              
              _buildSectionHeader(
                'Configuración de Descuentos',
                Icons.discount,
                'Configura los descuentos por defecto',
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              _buildDiscountSettings(),
              const SizedBox(height: DesignTokens.spacingXl),
              
              _buildSectionHeader(
                'Información del Negocio',
                Icons.business,
                'Configura la información de tu negocio',
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              _buildBusinessSettings(),
              const SizedBox(height: DesignTokens.spacingXl),
              
              _buildSectionHeader(
                'Configuración de Facturas',
                Icons.description,
                'Configura el formato de las facturas',
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              _buildInvoiceSettings(),
              const SizedBox(height: DesignTokens.spacingXl),
              
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el encabezado de una sección
  Widget _buildSectionHeader(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        border: Border.all(
          color: DesignTokens.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: DesignTokens.primaryColor,
            size: 24,
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeLg,
                    fontWeight: DesignTokens.fontWeightSemiBold,
                    color: DesignTokens.textPrimaryColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la configuración de impuestos
  Widget _buildTaxSettings() {
    return Card(
      color: DesignTokens.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasa de Impuesto (%)',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                fontWeight: DesignTokens.fontWeightMedium,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            TextFormField(
              controller: _taxRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '15.0',
                suffixText: '%',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La tasa de impuesto es requerida';
                }
                final rate = double.tryParse(value);
                if (rate == null || rate < 0 || rate > 100) {
                  return 'Ingresa una tasa válida entre 0 y 100';
                }
                return null;
              },
              onChanged: (_) => _markAsDirty(),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              decoration: BoxDecoration(
                color: DesignTokens.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                border: Border.all(
                  color: DesignTokens.infoColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: DesignTokens.infoColor,
                    size: 20,
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Expanded(
                    child: Text(
                      'Esta tasa se aplicará automáticamente a todas las ventas',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        color: DesignTokens.infoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la configuración de descuentos
  Widget _buildDiscountSettings() {
    return Card(
      color: DesignTokens.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de Descuento por Defecto',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                fontWeight: DesignTokens.fontWeightMedium,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            DropdownButtonFormField<DiscountType>(
              value: _selectedDiscountType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              items: DiscountType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDiscountType = value!;
                  _markAsDirty();
                });
              },
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              'Valor del Descuento por Defecto',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                fontWeight: DesignTokens.fontWeightMedium,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            TextFormField(
              controller: _defaultDiscountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: _selectedDiscountType == DiscountType.percentage ? '10.0' : '1000',
                suffixText: _selectedDiscountType == DiscountType.percentage ? '%' : '₡',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El valor del descuento es requerido';
                }
                final discount = double.tryParse(value);
                if (discount == null || discount < 0) {
                  return 'Ingresa un valor válido';
                }
                if (_selectedDiscountType == DiscountType.percentage && discount > 100) {
                  return 'El porcentaje no puede ser mayor a 100%';
                }
                return null;
              },
              onChanged: (_) => _markAsDirty(),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la configuración del negocio
  Widget _buildBusinessSettings() {
    return Card(
      color: DesignTokens.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBusinessField(
              'Nombre del Negocio',
              _businessNameController,
              'La Gata',
              Icons.business,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            _buildBusinessField(
              'Dirección',
              _businessAddressController,
              'Dirección del negocio',
              Icons.location_on,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            _buildBusinessField(
              'Teléfono',
              _businessPhoneController,
              '+505 8888 8888',
              Icons.phone,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            _buildBusinessField(
              'Email',
              _businessEmailController,
              'info@lagata.com',
              Icons.email,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            _buildBusinessField(
              'RUC',
              _businessRucController,
              '1234567890123',
              Icons.numbers,
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un campo de información del negocio
  Widget _buildBusinessField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeMd,
            fontWeight: DesignTokens.fontWeightMedium,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingSm,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label es requerido';
            }
            return null;
          },
          onChanged: (_) => _markAsDirty(),
        ),
      ],
    );
  }

  /// Construye la configuración de facturas
  Widget _buildInvoiceSettings() {
    return Card(
      color: DesignTokens.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prefijo de Factura',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                fontWeight: DesignTokens.fontWeightMedium,
                color: DesignTokens.textPrimaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            TextFormField(
              controller: _invoicePrefixController,
              decoration: InputDecoration(
                hintText: 'FAC',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El prefijo es requerido';
                }
                if (value.length > 5) {
                  return 'El prefijo no puede tener más de 5 caracteres';
                }
                return null;
              },
              onChanged: (_) => _markAsDirty(),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              decoration: BoxDecoration(
                color: DesignTokens.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                border: Border.all(
                  color: DesignTokens.warningColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: DesignTokens.warningColor,
                    size: 20,
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Expanded(
                    child: Text(
                      'El formato de factura será: ${_invoicePrefixController.text}${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}XXXX',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        color: DesignTokens.warningColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye las acciones
  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restore),
            label: const Text('Restaurar Valores'),
            style: OutlinedButton.styleFrom(
              foregroundColor: DesignTokens.textSecondaryColor,
              side: BorderSide(color: DesignTokens.textSecondaryColor),
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingLg,
                vertical: DesignTokens.spacingMd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              ),
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spacingMd),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isDirty ? _saveSettings : null,
            icon: const Icon(Icons.save),
            label: const Text('Guardar Cambios'),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingLg,
                vertical: DesignTokens.spacingMd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Marca el formulario como modificado
  void _markAsDirty() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  /// Guarda la configuración
  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    await executeWithErrorHandling(() async {
      // Actualizar configuración de impuestos
      final taxRate = double.parse(_taxRateController.text);
      BusinessConfig.updateTaxRate(taxRate);

      // Actualizar configuración de descuentos
      final discountValue = double.parse(_defaultDiscountController.text);
      BusinessConfig.updateDiscountConfig(_selectedDiscountType, discountValue);

      // Actualizar información del negocio
      BusinessConfig.businessName = _businessNameController.text;
      BusinessConfig.businessAddress = _businessAddressController.text;
      BusinessConfig.businessPhone = _businessPhoneController.text;
      BusinessConfig.businessEmail = _businessEmailController.text;
      BusinessConfig.businessRuc = _businessRucController.text;
      BusinessConfig.invoicePrefix = _invoicePrefixController.text;

      // Simular guardado
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isDirty = false;
      });

      ErrorService().showSuccessSnackBar(
        context,
        'Configuración guardada exitosamente',
      );
    });
  }

  /// Restaura los valores por defecto
  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Valores'),
        content: const Text(
          '¿Estás seguro de que quieres restaurar todos los valores a su configuración por defecto? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadDefaultValues();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );
  }

  /// Carga los valores por defecto
  void _loadDefaultValues() {
    _taxRateController.text = AppConfig.taxRate.toString();
    _defaultDiscountController.text = '0.0';
    _selectedDiscountType = DiscountType.none;
    _businessNameController.text = AppConfig.businessName;
    _businessAddressController.text = AppConfig.businessAddress;
    _businessPhoneController.text = AppConfig.businessPhone;
    _businessEmailController.text = AppConfig.businessEmail;
    _businessRucController.text = AppConfig.businessRuc;
    _invoicePrefixController.text = AppConfig.invoicePrefix;

    setState(() {
      _isDirty = true;
    });

    ErrorService().showInfoSnackBar(
      context,
      'Valores restaurados. Recuerda guardar los cambios.',
    );
  }
}
