import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../config/app_config.dart';

/// Servicio para generar PDFs
class PdfService {
  static final PdfService _instance = PdfService._internal();
  factory PdfService() => _instance;
  PdfService._internal();

  /// Genera una factura en PDF
  Future<File> generateInvoicePdf(Map<String, dynamic> sale) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              _buildHeader(),
              pw.SizedBox(height: 20),

              // Información de la factura
              _buildInvoiceInfo(sale),
              pw.SizedBox(height: 20),

              // Información del cliente
              _buildCustomerInfo(sale),
              pw.SizedBox(height: 20),

              // Tabla de productos
              _buildProductsTable(sale),
              pw.SizedBox(height: 20),

              // Totales
              _buildTotals(sale),
              pw.SizedBox(height: 30),

              // Pie de página
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return await _savePdf(pdf, 'factura_${sale['invoiceNumber']}.pdf');
  }

  /// Genera un reporte de ventas en PDF
  Future<File> generateSalesReportPdf(
    List<Map<String, dynamic>> sales,
    Map<String, dynamic> stats,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              _buildHeader(),
              pw.SizedBox(height: 20),

              // Título del reporte
              pw.Text(
                'Reporte de Ventas',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              // Período del reporte
              pw.Text(
                'Período: ${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),

              // Estadísticas resumidas
              _buildSalesStats(stats),
              pw.SizedBox(height: 20),

              // Tabla de ventas
              _buildSalesTable(sales),
              pw.SizedBox(height: 20),

              // Pie de página
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return await _savePdf(
      pdf,
      'reporte_ventas_${startDate.day}_${startDate.month}_${startDate.year}.pdf',
    );
  }

  /// Genera un reporte de inventario en PDF
  Future<File> generateInventoryReportPdf(
    List<Map<String, dynamic>> products,
    Map<String, dynamic> stats,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              _buildHeader(),
              pw.SizedBox(height: 20),

              // Título del reporte
              pw.Text(
                'Reporte de Inventario',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              // Estadísticas del inventario
              _buildInventoryStats(stats),
              pw.SizedBox(height: 20),

              // Tabla de productos
              _buildInventoryTable(products),
              pw.SizedBox(height: 20),

              // Pie de página
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return await _savePdf(
      pdf,
      'reporte_inventario_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}.pdf',
    );
  }

  /// Construye el encabezado del PDF
  pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              AppConfig.businessName,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              AppConfig.businessAddress,
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              'Tel: ${AppConfig.businessPhone}',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              'RUC: ${AppConfig.businessRuc}',
              style: pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'La Gata',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Sistema de Facturación',
              style: pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la información de la factura
  pw.Widget _buildInvoiceInfo(Map<String, dynamic> sale) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'FACTURA',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'No. ${sale['invoiceNumber']}',
              style: pw.TextStyle(fontSize: 14),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Fecha: ${DateTime.parse(sale['createdAt']).day}/${DateTime.parse(sale['createdAt']).month}/${DateTime.parse(sale['createdAt']).year}',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              'Hora: ${DateTime.parse(sale['createdAt']).hour}:${DateTime.parse(sale['createdAt']).minute.toString().padLeft(2, '0')}',
              style: pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la información del cliente
  pw.Widget _buildCustomerInfo(Map<String, dynamic> sale) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'CLIENTE',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Nombre: ${sale['customerName']}',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.Text(
            'Vendedor: ${sale['sellerName']}',
            style: pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Construye la tabla de productos
  pw.Widget _buildProductsTable(Map<String, dynamic> sale) {
    final items = sale['items'] as List<dynamic>;

    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
      },
      children: [
        // Encabezado
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Producto',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Cant.',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Precio',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Total',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),
        // Productos
        ...items.map(
          (item) => pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  item['productName'],
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  item['quantity'].toString(),
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  '₡${item['price'].toStringAsFixed(0)}',
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  '₡${item['total'].toStringAsFixed(0)}',
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye los totales
  pw.Widget _buildTotals(Map<String, dynamic> sale) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Subtotal:', style: pw.TextStyle(fontSize: 12)),
              pw.Text(
                '₡${sale['subtotal'].toStringAsFixed(0)}',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('IVA (15%):', style: pw.TextStyle(fontSize: 12)),
              pw.Text(
                '₡${sale['tax'].toStringAsFixed(0)}',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
          if (sale['discount'] > 0) ...[
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Descuento:', style: pw.TextStyle(fontSize: 12)),
                pw.Text(
                  '-₡${sale['discount'].toStringAsFixed(0)}',
                  style: pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'TOTAL:',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '₡${sale['total'].toStringAsFixed(0)}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye las estadísticas de ventas
  pw.Widget _buildSalesStats(Map<String, dynamic> stats) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        color: PdfColors.grey100,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ESTADÍSTICAS DEL PERÍODO',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total de ventas: ${stats['totalSales']}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Ingresos totales: ₡${stats['totalRevenue'].toStringAsFixed(0)}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Ticket promedio: ₡${stats['averageTicket'].toStringAsFixed(0)}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Productos vendidos: ${stats['totalItems']}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la tabla de ventas
  pw.Widget _buildSalesTable(List<Map<String, dynamic>> sales) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(1),
      },
      children: [
        // Encabezado
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Factura',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Cliente',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Fecha',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Estado',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Total',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        // Ventas
        ...sales.map(
          (sale) => pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  sale['invoiceNumber'],
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  sale['customerName'],
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  '${DateTime.parse(sale['createdAt']).day}/${DateTime.parse(sale['createdAt']).month}',
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  sale['status'],
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  '₡${sale['total'].toStringAsFixed(0)}',
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye las estadísticas del inventario
  pw.Widget _buildInventoryStats(Map<String, dynamic> stats) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        color: PdfColors.grey100,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ESTADÍSTICAS DEL INVENTARIO',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total de productos: ${stats['totalProducts']}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Valor total: ₡${stats['totalValue'].toStringAsFixed(0)}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Productos con stock bajo: ${stats['lowStockProducts']}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Productos agotados: ${stats['outOfStockProducts']}',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye la tabla de inventario
  pw.Widget _buildInventoryTable(List<Map<String, dynamic>> products) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(1),
      },
      children: [
        // Encabezado
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Producto',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Categoría',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Stock',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Precio',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Valor',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        // Productos
        ...products.map(
          (product) => pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  product['name'],
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  product['category'],
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  product['stock'].toString(),
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  '₡${product['price'].toStringAsFixed(0)}',
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  '₡${(product['price'] * product['stock']).toStringAsFixed(0)}',
                  style: pw.TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye el pie de página
  pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        color: PdfColors.grey100,
      ),
      child: pw.Column(
        children: [
          pw.Text(
            '¡Gracias por su compra!',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'La Gata - Sistema de Facturación',
            style: pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Generado el ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} a las ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            style: pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  /// Guarda el PDF en el dispositivo
  Future<File> _savePdf(pw.Document pdf, String fileName) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Abre el PDF generado
  Future<void> openPdf(File file) async {
    await OpenFile.open(file.path);
  }

  /// Comparte el PDF
  Future<void> sharePdf(File file) async {
    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Reporte generado por La Gata');
  }
}
