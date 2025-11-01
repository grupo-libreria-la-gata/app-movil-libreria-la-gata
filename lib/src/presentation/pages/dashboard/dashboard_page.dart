import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../providers/auth_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_menu_widget.dart';
import '../../../data/services/venta_service.dart';
import '../../../data/services/compra_service.dart';
import '../../../data/services/detalle_producto_service.dart';
import '../../../data/models/venta_model.dart';
import '../../../data/models/detalle_producto_model.dart';

/// Página principal del dashboard del sistema de facturación
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  bool _isLoading = true;
  
  // Datos del resumen
  Map<String, dynamic>? _ventasResumen;
  Map<String, dynamic>? _comprasResumen;
  List<VentaListResponse> _ultimasVentas = [];
  List<DetalleProducto> _productosStockBajo = [];
  
  // Servicios
  final _ventaService = VentaService();
  final _compraService = CompraService();
  final _productoService = DetalleProductoService();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    
    try {
      final authState = ref.read(authProvider);
      final usuarioId = int.tryParse(authState.user?.id ?? '1') ?? 1;
      
      final ahora = DateTime.now();
      final inicioDia = DateTime(ahora.year, ahora.month, ahora.day);
      final finDia = DateTime(ahora.year, ahora.month, ahora.day, 23, 59, 59);
      
      // Cargar datos en paralelo
      final resultados = await Future.wait([
        _ventaService.obtenerResumen(inicioDia, finDia, usuarioId).catchError((e) => <String, dynamic>{}),
        _compraService.obtenerResumen(inicioDia, finDia, usuarioId).catchError((e) => <String, dynamic>{}),
        _ventaService.obtenerPorFechas(inicioDia, finDia, usuarioId).catchError((e) => <VentaListResponse>[]),
        _productoService.obtenerActivos().catchError((e) => <DetalleProducto>[]),
      ]);
      
      if (mounted) {
        setState(() {
          _ventasResumen = resultados[0] as Map<String, dynamic>?;
          _comprasResumen = resultados[1] as Map<String, dynamic>?;
          _ultimasVentas = resultados[2] as List<VentaListResponse>;
          final productos = resultados[3] as List<DetalleProducto>;
          
          // Filtrar productos con stock bajo (stock <= 10)
          _productosStockBajo = productos.where((p) => 
            p.stock <= 10
          ).toList();
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isAuthenticated && !next.isLoading) {
        context.go('/login');
      }
    });

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppHeader(
        title: AppConfig.appName,
        showBackButton: false,
        showUserMenu: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _cargarDatos,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.instance.isSmallMobile(context)
                        ? 12
                        : 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              // Sección de bienvenida
              _buildWelcomeSection(context, authState),

              SizedBox(
                height: ResponsiveHelper.instance.getResponsiveSpacing(
                  context,
                  DesignTokens.spacingXl,
                ),
              ),

              // Resumen del día (visión ejecutiva)
              _buildExecutiveSummary(context),

              SizedBox(
                height: ResponsiveHelper.instance.getResponsiveSpacing(
                  context,
                  DesignTokens.spacingXl,
                ),
              ),

              // Indicadores accionables
              _buildActionableIndicators(context),

              SizedBox(
                height: ResponsiveHelper.instance.getResponsiveSpacing(
                  context,
                  DesignTokens.spacingXl,
                ),
              ),

              // Gráficos ligeros y representativos
              _buildLightCharts(context),

              SizedBox(
                height: ResponsiveHelper.instance.getResponsiveSpacing(
                  context,
                  DesignTokens.spacingXl,
                ),
              ),

              // Últimas facturas emitidas
              _buildRecentInvoices(context),

                      // Espacio adicional para el menú inferior
                      SizedBox(
                        height: ResponsiveHelper.instance.isSmallMobile(context)
                            ? 100
                            : 80,
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomMenuWidget(
        currentIndex: 0,
        onTap: (index) {
          _navigateToPage(context, index);
        },
      ),
    );
  }

  /// Construye la sección de bienvenida (más compacta)
  Widget _buildWelcomeSection(BuildContext context, AuthState authState) {
    final responsiveHelper = ResponsiveHelper.instance;
    final isSmallMobile = responsiveHelper.isSmallMobile(context);

    return Container(
      padding: EdgeInsets.all(isSmallMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: DesignTokens.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.textPrimaryColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    color: DesignTokens.surfaceColor,
                    fontSize: isSmallMobile ? 20 : 24,
                    fontWeight: DesignTokens.fontWeightBold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  authState.user?.name ?? 'Usuario',
                  style: TextStyle(
                    color: DesignTokens.textInverseColor.withValues(alpha: 0.9),
                    fontSize: isSmallMobile ? 16 : 18,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                if (!isSmallMobile) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Sistema de Facturación La Gata',
                    style: TextStyle(
                      color: DesignTokens.textInverseColor.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isSmallMobile)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: DesignTokens.surfaceColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.local_bar, color: DesignTokens.textInverseColor, size: 24),
            ),
        ],
      ),
    );
  }

  /// Resumen ejecutivo del día: encabezado y KPIs
  Widget _buildExecutiveSummary(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;
    final today = DateTime.now();
    final fecha =
        '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen del día – $fecha',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeLg,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingMd,
          ),
        ),
        // KPIs en fila desplazable
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildKpiCard(
                context: context,
                title: 'Facturación del día',
                value: _ventasResumen != null
                    ? '₡${(_ventasResumen!['totalMonto'] ?? 0.0).toStringAsFixed(0)}'
                    : '₡0',
                icon: Icons.attach_money,
                color: DesignTokens.successColor,
              ),
              const SizedBox(width: 12),
              _buildKpiCard(
                context: context,
                title: 'Facturas emitidas',
                value: _ventasResumen != null
                    ? '${_ventasResumen!['totalVentas'] ?? 0}'
                    : '0',
                icon: Icons.receipt_long,
                color: DesignTokens.infoColor,
              ),
              const SizedBox(width: 12),
              _buildKpiCard(
                context: context,
                title: 'Clientes atendidos',
                value: _ultimasVentas.isNotEmpty
                    ? '${_ultimasVentas.map((v) => v.clienteId).toSet().length}'
                    : '0',
                icon: Icons.people,
                color: DesignTokens.primaryColor,
              ),
              const SizedBox(width: 12),
              _buildKpiCard(
                context: context,
                title: 'Stock bajo',
                value: '${_productosStockBajo.length}',
                icon: Icons.warning,
                color: DesignTokens.warningColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isSmall = ResponsiveHelper.instance.isSmallMobile(context);
    return Container(
      width: isSmall ? 180 : 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DesignTokens.borderLightColor),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.textPrimaryColor.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: DesignTokens.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: DesignTokens.textPrimaryColor,
                    fontSize: 18,
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

  /// Indicadores accionables: pendientes, stock crítico y últimas facturas
  Widget _buildActionableIndicators(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Indicadores accionables',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeLg,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingMd,
          ),
        ),
        _buildActionableRow(context),
      ],
    );
  }

  Widget _buildActionableRow(BuildContext context) {
    final isSmall = ResponsiveHelper.instance.isSmallMobile(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Facturas por cobrar',
                subtitle: _ultimasVentas.isNotEmpty && _ultimasVentas.any((v) => v.metodoPago.toLowerCase() != 'efectivo')
                    ? '${_ultimasVentas.where((v) => v.metodoPago.toLowerCase() != 'efectivo').length} pendientes'
                    : '0 pendientes',
                icon: Icons.payments_outlined,
                color: DesignTokens.warningColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: 'Compras por pagar',
                subtitle: _comprasResumen != null
                    ? '${_comprasResumen!['totalCompras'] ?? 0} registradas'
                    : '0 registradas',
                icon: Icons.shopping_bag_outlined,
                color: DesignTokens.infoColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Stock crítico',
                subtitle: '${_productosStockBajo.length} productos bajo mínimo',
                icon: Icons.inventory_2_outlined,
                color: DesignTokens.errorColor,
              ),
            ),
            if (!isSmall) const SizedBox(width: 12),
            if (!isSmall) const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DesignTokens.borderLightColor),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.textPrimaryColor.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: DesignTokens.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: DesignTokens.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Gráficos ligeros: mini barras (ventas hora) y donut (métodos de pago)
  Widget _buildLightCharts(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;
    final isSmall = responsiveHelper.isSmallMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad del día',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeLg,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildMiniBarsCard()),
            if (!isSmall) const SizedBox(width: 12),
            Expanded(child: _buildDonutCard()),
          ],
        ),
        const SizedBox(height: 8),
        _buildTrendIndicator(),
      ],
    );
  }

  Widget _buildMiniBarsCard() {
    // Calcular ventas por hora desde los datos reales
    final ventasPorHora = <int, int>{};
    for (final venta in _ultimasVentas) {
      final hora = venta.fechaVenta.hour;
      ventasPorHora[hora] = (ventasPorHora[hora] ?? 0) + 1;
    }
    
    // Horas del día para mostrar (8, 10, 12, 14, 16, 18)
    final horasMostrar = [8, 10, 12, 14, 16, 18];
    final maxVentas = ventasPorHora.values.isNotEmpty 
        ? ventasPorHora.values.reduce((a, b) => a > b ? a : b) 
        : 1;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DesignTokens.borderLightColor),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.textPrimaryColor.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 160,
        child: BarChart(
          BarChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= horasMostrar.length)
                      return const SizedBox.shrink();
                    return Text(
                      horasMostrar[idx].toString(),
                      style: TextStyle(
                        color: DesignTokens.textSecondaryColor,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            maxY: maxVentas > 0 ? maxVentas.toDouble() + 2 : 10,
            barGroups: List.generate(
              horasMostrar.length,
              (index) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: (ventasPorHora[horasMostrar[index]] ?? 0).toDouble(),
                    color: DesignTokens.primaryColor,
                    width: 10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonutCard() {
    // Calcular distribución de métodos de pago desde datos reales
    final metodosPago = <String, int>{};
    for (final venta in _ultimasVentas) {
      final metodo = venta.metodoPago.toLowerCase();
      metodosPago[metodo] = (metodosPago[metodo] ?? 0) + 1;
    }
    
    final total = metodosPago.values.fold(0, (a, b) => a + b);
    
    // Si no hay datos, mostrar placeholder
    if (total == 0) {
      metodosPago['efectivo'] = 1;
    }
    
    final sections = <PieChartSectionData>[];
    if (metodosPago.containsKey('efectivo') || metodosPago.containsKey('cash')) {
      final valor = (metodosPago['efectivo'] ?? metodosPago['cash'] ?? 0);
      final porcentaje = total > 0 ? (valor / total) * 100 : 0;
      sections.add(PieChartSectionData(
        title: porcentaje > 5 ? 'Efectivo' : '',
        value: porcentaje.toDouble(),
        color: DesignTokens.successColor,
        radius: 40,
        titleStyle: const TextStyle(color: DesignTokens.textInverseColor, fontSize: 10),
      ));
    }
    if (metodosPago.containsKey('tarjeta') || metodosPago.containsKey('card') || metodosPago.containsKey('tarjeta de crédito')) {
      final valor = (metodosPago['tarjeta'] ?? metodosPago['card'] ?? metodosPago['tarjeta de crédito'] ?? 0);
      final porcentaje = total > 0 ? (valor / total) * 100 : 0;
      sections.add(PieChartSectionData(
        title: porcentaje > 5 ? 'Tarjeta' : '',
        value: porcentaje.toDouble(),
        color: DesignTokens.infoColor,
        radius: 40,
        titleStyle: const TextStyle(color: DesignTokens.textInverseColor, fontSize: 10),
      ));
    }
    if (metodosPago.containsKey('transferencia') || metodosPago.containsKey('transfer') || metodosPago.containsKey('transferencia bancaria')) {
      final valor = (metodosPago['transferencia'] ?? metodosPago['transfer'] ?? metodosPago['transferencia bancaria'] ?? 0);
      final porcentaje = total > 0 ? (valor / total) * 100 : 0;
      sections.add(PieChartSectionData(
        title: porcentaje > 5 ? 'Transf.' : '',
        value: porcentaje.toDouble(),
        color: DesignTokens.primaryColor,
        radius: 40,
        titleStyle: const TextStyle(color: DesignTokens.textInverseColor, fontSize: 10),
      ));
    }
    
    // Si no hay secciones, crear una por defecto
    if (sections.isEmpty) {
      sections.add(PieChartSectionData(
        title: 'Sin datos',
        value: 100,
        color: DesignTokens.textSecondaryColor,
        radius: 40,
        titleStyle: const TextStyle(color: DesignTokens.textInverseColor, fontSize: 10),
      ));
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DesignTokens.borderLightColor),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.textPrimaryColor.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 160,
        child: PieChart(
          PieChartData(
            sections: sections,
            sectionsSpace: 2,
            centerSpaceRadius: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DesignTokens.borderLightColor),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up, color: DesignTokens.successColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '+12% vs ayer',
              style: TextStyle(
                color: DesignTokens.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Lista de últimas 5 facturas emitidas
  Widget _buildRecentInvoices(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;
    final ultimas5Ventas = _ultimasVentas.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Últimas facturas emitidas',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(
              context,
              DesignTokens.fontSizeLg,
            ),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        SizedBox(
          height: responsiveHelper.getResponsiveSpacing(
            context,
            DesignTokens.spacingMd,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: DesignTokens.surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: DesignTokens.borderLightColor),
          ),
          child: ultimas5Ventas.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'No hay facturas emitidas hoy',
                      style: TextStyle(
                        color: DesignTokens.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ultimas5Ventas.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: DesignTokens.borderLightColor),
                  itemBuilder: (context, index) {
                    final venta = ultimas5Ventas[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: DesignTokens.primaryColor.withValues(
                          alpha: 0.12,
                        ),
                        child: Icon(
                          Icons.receipt,
                          color: DesignTokens.primaryColor,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        venta.clienteNombre,
                        style: TextStyle(
                          color: DesignTokens.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Factura #${venta.ventaId}',
                        style: TextStyle(color: DesignTokens.textSecondaryColor),
                      ),
                      trailing: Text(
                        '₡${venta.total.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: DesignTokens.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Construye la sección de acciones secundarias (reorganizada)
  // Widget _buildSecondaryActionsSection(
  //   BuildContext context,
  //   AuthState authState,
  // ) {
  //   final responsiveHelper = ResponsiveHelper.instance;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Más Opciones',
  //         style: TextStyle(
  //           fontSize: responsiveHelper.getResponsiveFontSize(
  //             context,
  //             DesignTokens.fontSizeLg,
  //           ),
  //           fontWeight: DesignTokens.fontWeightBold,
  //           color: DesignTokens.textPrimaryColor,
  //         ),
  //       ),
  //       SizedBox(
  //         height: responsiveHelper.getResponsiveSpacing(
  //           context,
  //           DesignTokens.spacingSm,
  //         ),
  //       ),
  //       // Grid de 2x1 para las opciones secundarias (mismo tamaño que Main Actions)
  //       GridView.count(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 12,
  //         mainAxisSpacing: 12,
  //         childAspectRatio: 1.2, // Mismo aspect ratio que Main Actions
  //         children: [
  //           DashboardCard(
  //             title: 'Administración',
  //             subtitle: 'Gestión del sistema',
  //             icon: Icons.admin_panel_settings,
  //             color: DesignTokens.textSecondaryColor,
  //             onTap: () => context.push('/admin'),
  //           ),
  //           DashboardCard(
  //             title: 'Acceso Rápido',
  //             subtitle: 'Acciones rápidas',
  //             icon: Icons.flash_on,
  //             color: DesignTokens.accentColor,
  //             onTap: () {
  //               // Mostrar un menú rápido con opciones adicionales
  //               _showQuickAccessMenu(context);
  //             },
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // /// Muestra un menú de acceso rápido
  // void _showQuickAccessMenu(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             'Acceso Rápido',
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //               color: DesignTokens.textPrimaryColor,
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           GridView.count(
  //             shrinkWrap: true,
  //             crossAxisCount: 2,
  //             crossAxisSpacing: 12,
  //             mainAxisSpacing: 12,
  //             childAspectRatio: 2.5,
  //             children: [
  //               _buildQuickAccessItem(
  //                 icon: Icons.people,
  //                 title: 'Clientes',
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   context.push('/customers');
  //                 },
  //               ),
  //               _buildQuickAccessItem(
  //                 icon: Icons.business_center,
  //                 title: 'Proveedores',
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   context.push('/suppliers');
  //                 },
  //               ),
  //               _buildQuickAccessItem(
  //                 icon: Icons.receipt_long,
  //                 title: 'Historial de Ventas',
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   context.push('/sales');
  //                 },
  //               ),
  //               _buildQuickAccessItem(
  //                 icon: Icons.history,
  //                 title: 'Historial de Compras',
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   context.push('/purchases');
  //                 },
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 20),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// Construye un elemento del menú de acceso rápido
  // Widget _buildQuickAccessItem({
  //   required IconData icon,
  //   required String title,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: DesignTokens.surfaceColor,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(color: DesignTokens.borderLightColor),
  //         boxShadow: [
  //           BoxShadow(
  //             color: DesignTokens.textPrimaryColor.withValues(alpha: 0.05),
  //             blurRadius: 4,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(icon, color: DesignTokens.primaryColor, size: 20),
  //           const SizedBox(width: 8),
  //           Expanded(
  //             child: Text(
  //               title,
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w500,
  //                 color: DesignTokens.textPrimaryColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0: // Sales
        context.go('/dashboard');
        break;
      case 1: // Manage
        context.go('/dashboard');
        break;
      case 2: // Purchases
        context.go('/dashboard');
        break;
      case 3: // Resume
        context.go('/dashboard');
        break;
    }
  }
}
