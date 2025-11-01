import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/utils/responsive_helper.dart';

/// Página de reportes para ventas y compras
class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedReportType = 'Ventas';
  final List<String> _reportTypes = ['Ventas', 'Compras', 'Inventario'];

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        title: const Text('Reportes'),
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
            // Filtros de fecha
            _buildDateFilters(),

            const SizedBox(height: DesignTokens.spacingLg),

            // Tipo de reporte
            _buildReportTypeSelector(),

            const SizedBox(height: DesignTokens.spacingLg),

            // Botones de exportación
            _buildExportButtons(),

            const SizedBox(height: DesignTokens.spacingLg),

            // Vista previa del reporte
            _buildReportPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilters() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros de Fecha',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    'Fecha Inicio',
                    _startDate,
                    (date) => setState(() => _startDate = date),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: _buildDateField(
                    'Fecha Fin',
                    _endDate,
                    (date) => setState(() => _endDate = date),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? date,
    Function(DateTime?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              onChanged(selectedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingSm,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: DesignTokens.borderLightColor),
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: DesignTokens.textSecondaryColor),
                const SizedBox(width: DesignTokens.spacingSm),
                Text(
                  date != null
                      ? '${date.day}/${date.month}/${date.year}'
                      : 'Seleccionar fecha',
                  style: TextStyle(
                    color: date != null ? DesignTokens.textPrimaryColor : DesignTokens.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportTypeSelector() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tipo de Reporte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            DropdownButtonFormField<String>(
              initialValue: _selectedReportType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              items: _reportTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButtons() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exportar Reporte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _startDate != null && _endDate != null
                        ? () => _exportToPDF()
                        : null,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Exportar PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesignTokens.primaryColor,
                      foregroundColor: DesignTokens.textInverseColor,
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _startDate != null && _endDate != null
                        ? () => _exportToExcel()
                        : null,
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Exportar Excel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesignTokens.successColor,
                      foregroundColor: DesignTokens.textInverseColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportPreview() {
    return Card(
      elevation: DesignTokens.elevationSm,
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vista Previa del Reporte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            if (_startDate != null && _endDate != null) ...[
              _buildReportSummary(),
              const SizedBox(height: DesignTokens.spacingLg),
              _buildChartsSection(),
            ] else ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(DesignTokens.spacingXl),
                  child: Text(
                    'Selecciona las fechas para generar el reporte',
                    style: TextStyle(fontSize: 16, color: DesignTokens.textSecondaryColor),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReportSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Período:'),
            Text(
              '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Tipo:'), Text(_selectedReportType)],
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total de registros:'),
            Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Monto total:'),
            Text('₡0.00', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  // Sección de gráficos (datos estáticos por ahora)
  Widget _buildChartsSection() {
    final responsiveHelper = ResponsiveHelper.instance;
    final chartHeight = responsiveHelper.getResponsiveSpacing(
      context,
      260,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Indicadores',
          style: TextStyle(
            fontSize: DesignTokens.fontSizeLg,
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        // Línea: tendencia diaria
        Container(
          height: chartHeight,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DesignTokens.surfaceColor,
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            border: Border.all(color: DesignTokens.borderLightColor),
          ),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                      final i = value.toInt();
                      return i >= 0 && i < labels.length
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(labels[i], style: const TextStyle(fontSize: 12)),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: DesignTokens.primaryColor,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  spots: const [
                    FlSpot(0, 3),
                    FlSpot(1, 2.4),
                    FlSpot(2, 4),
                    FlSpot(3, 3.5),
                    FlSpot(4, 5),
                    FlSpot(5, 3),
                    FlSpot(6, 4.5),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingLg),
        // Barras: Top categorías
        Container(
          height: chartHeight,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DesignTokens.surfaceColor,
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            border: Border.all(color: DesignTokens.borderLightColor),
          ),
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = ['Lic.', 'Vinos', 'Cerv.', 'Ref.', 'Snacks'];
                      final i = value.toInt();
                      return i >= 0 && i < labels.length
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(labels[i], style: const TextStyle(fontSize: 12)),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 12, color: DesignTokens.secondaryColor)]),
                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 9, color: DesignTokens.secondaryColor)]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: DesignTokens.secondaryColor)]),
                BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 7, color: DesignTokens.secondaryColor)]),
                BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 6, color: DesignTokens.secondaryColor)]),
              ],
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingLg),
        // Pie: Métodos de pago
        Container(
          height: chartHeight,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DesignTokens.surfaceColor,
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            border: Border.all(color: DesignTokens.borderLightColor),
          ),
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 38,
              sections: [
                PieChartSectionData(
                  color: DesignTokens.primaryColor,
                  value: 55,
                  title: 'Efectivo',
                  radius: 58,
                  titleStyle: TextStyle(color: DesignTokens.surfaceColor, fontSize: 12),
                ),
                PieChartSectionData(
                  color: DesignTokens.successColor,
                  value: 25,
                  title: 'Tarjeta',
                  radius: 54,
                  titleStyle: TextStyle(color: DesignTokens.surfaceColor, fontSize: 12),
                ),
                PieChartSectionData(
                  color: DesignTokens.warningColor,
                  value: 20,
                  title: 'Transf.',
                  radius: 50,
                  titleStyle: TextStyle(color: DesignTokens.surfaceColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de exportación PDF en desarrollo'),
      ),
    );
  }

  void _exportToExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de exportación Excel en desarrollo'),
      ),
    );
  }
}
