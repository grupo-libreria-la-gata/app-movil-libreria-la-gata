import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';
import '../../core/services/pdf_service.dart';
import '../../core/services/error_service.dart';
import 'loading_widgets.dart';

/// Widget para exportar PDFs
class PdfExportWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Future<File> Function() generatePdf;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const PdfExportWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.generatePdf,
    this.onSuccess,
    this.onError,
  });

  @override
  State<PdfExportWidget> createState() => _PdfExportWidgetState();
}

class _PdfExportWidgetState extends State<PdfExportWidget> {
  bool _isGenerating = false;
  File? _generatedFile;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DesignTokens.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingSm),
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.borderRadiusSm,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: DesignTokens.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightSemiBold,
                          color: DesignTokens.textPrimaryColor,
                        ),
                      ),
                      Text(
                        widget.subtitle,
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
            const SizedBox(height: DesignTokens.spacingMd),
            if (_isGenerating)
              const LoadingSpinner(message: 'Generando PDF...')
            else if (_generatedFile != null)
              _buildSuccessActions()
            else
              _buildGenerateButton(),
          ],
        ),
      ),
    );
  }

  /// Construye el botón para generar PDF
  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _generatePdf,
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('Generar PDF'),
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
    );
  }

  /// Construye las acciones después de generar el PDF
  Widget _buildSuccessActions() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          decoration: BoxDecoration(
            color: DesignTokens.successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            border: Border.all(
              color: DesignTokens.successColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: DesignTokens.successColor,
                size: 20,
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(
                child: Text(
                  'PDF generado exitosamente',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    color: DesignTokens.successColor,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openPdf,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Abrir'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DesignTokens.primaryColor,
                  side: BorderSide(color: DesignTokens.primaryColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingMd,
                    vertical: DesignTokens.spacingSm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      DesignTokens.borderRadiusMd,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _sharePdf,
                icon: const Icon(Icons.share),
                label: const Text('Compartir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingMd,
                    vertical: DesignTokens.spacingSm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      DesignTokens.borderRadiusMd,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: _generateNewPdf,
            icon: const Icon(Icons.refresh),
            label: const Text('Generar Nuevo'),
            style: TextButton.styleFrom(
              foregroundColor: DesignTokens.textSecondaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: DesignTokens.spacingSm,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Genera el PDF
  Future<void> _generatePdf() async {
    try {
      setState(() {
        _isGenerating = true;
      });

      final file = await widget.generatePdf();

      setState(() {
        _generatedFile = file;
        _isGenerating = false;
      });

      widget.onSuccess?.call();

      if (mounted) {
        ErrorService().showSuccessSnackBar(
          context,
          'PDF generado exitosamente',
        );
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      widget.onError?.call();

      if (mounted) {
        ErrorService().showErrorSnackBar(
          context,
          'Error al generar PDF: ${e.toString()}',
        );
      }
    }
  }

  /// Abre el PDF generado
  Future<void> _openPdf() async {
    if (_generatedFile == null) return;

    try {
      await PdfService().openPdf(_generatedFile!);
    } catch (e) {
      if (mounted) {
        ErrorService().showErrorSnackBar(
          context,
          'Error al abrir PDF: ${e.toString()}',
        );
      }
    }
  }

  /// Comparte el PDF generado
  Future<void> _sharePdf() async {
    if (_generatedFile == null) return;

    try {
      await PdfService().sharePdf(_generatedFile!);
    } catch (e) {
      if (mounted) {
        ErrorService().showErrorSnackBar(
          context,
          'Error al compartir PDF: ${e.toString()}',
        );
      }
    }
  }

  /// Genera un nuevo PDF
  void _generateNewPdf() {
    setState(() {
      _generatedFile = null;
    });
  }
}

/// Widget para exportar factura en PDF
class InvoicePdfExportWidget extends StatelessWidget {
  final Map<String, dynamic> sale;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const InvoicePdfExportWidget({
    super.key,
    required this.sale,
    this.onSuccess,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return PdfExportWidget(
      title: 'Factura PDF',
      subtitle: 'Genera la factura ${sale['invoiceNumber']} en formato PDF',
      icon: Icons.receipt_long,
      generatePdf: () => PdfService().generateInvoicePdf(sale),
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}

/// Widget para exportar reporte de ventas en PDF
class SalesReportPdfExportWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sales;
  final Map<String, dynamic> stats;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const SalesReportPdfExportWidget({
    super.key,
    required this.sales,
    required this.stats,
    required this.startDate,
    required this.endDate,
    this.onSuccess,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return PdfExportWidget(
      title: 'Reporte de Ventas PDF',
      subtitle: 'Genera reporte de ventas del período seleccionado',
      icon: Icons.analytics,
      generatePdf: () =>
          PdfService().generateSalesReportPdf(sales, stats, startDate, endDate),
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}

/// Widget para exportar reporte de inventario en PDF
class InventoryReportPdfExportWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Map<String, dynamic> stats;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const InventoryReportPdfExportWidget({
    super.key,
    required this.products,
    required this.stats,
    this.onSuccess,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return PdfExportWidget(
      title: 'Reporte de Inventario PDF',
      subtitle: 'Genera reporte completo del inventario actual',
      icon: Icons.inventory,
      generatePdf: () =>
          PdfService().generateInventoryReportPdf(products, stats),
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
