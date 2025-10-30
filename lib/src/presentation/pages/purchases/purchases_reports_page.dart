import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';

class PurchasesReportsPage extends ConsumerStatefulWidget {
  const PurchasesReportsPage({super.key});

  @override
  ConsumerState<PurchasesReportsPage> createState() =>
      _PurchasesReportsPageState();
}

class _PurchasesReportsPageState extends ConsumerState<PurchasesReportsPage> {
  DateTime _fechaInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fechaFin = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Reports'),
        backgroundColor: DesignTokens.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros de fecha
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date Range',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Start Date'),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final fecha = await showDatePicker(
                                    context: context,
                                    initialDate: _fechaInicio,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (fecha != null) {
                                    setState(() {
                                      _fechaInicio = fecha;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('End Date'),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final fecha = await showDatePicker(
                                    context: context,
                                    initialDate: _fechaFin,
                                    firstDate: _fechaInicio,
                                    lastDate: DateTime.now(),
                                  );
                                  if (fecha != null) {
                                    setState(() {
                                      _fechaFin = fecha;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${_fechaFin.day}/${_fechaFin.month}/${_fechaFin.year}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Generating report...'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignTokens.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Generate Report'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Opciones de reporte
            const Text(
              'Report Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildReportCard(
                    title: 'Purchase Summary',
                    subtitle: 'Total purchases and amounts',
                    icon: Icons.summarize,
                    color: DesignTokens.primaryColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Purchase Summary - In development'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                  _buildReportCard(
                    title: 'Top Suppliers',
                    subtitle: 'Most frequent suppliers',
                    icon: Icons.business,
                    color: DesignTokens.successColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Top Suppliers - In development'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                  _buildReportCard(
                    title: 'Product Analysis',
                    subtitle: 'Most purchased products',
                    icon: Icons.analytics,
                    color: DesignTokens.infoColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product Analysis - In development'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                  _buildReportCard(
                    title: 'Export Data',
                    subtitle: 'Export to Excel/PDF',
                    icon: Icons.download,
                    color: DesignTokens.warningColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Export Data - In development'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: DesignTokens.textSecondaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
