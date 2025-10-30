import '../entities/sale.dart';
import '../../data/models/base_model.dart';

/// Interfaz del repositorio de ventas
abstract class SaleRepository {
  /// Obtiene todas las ventas con paginación
  Future<PaginatedResponse<Sale>> getSales({
    int page = 1,
    int limit = 20,
    String? search,
    String? customerName,
    String? sellerId,
    SaleStatus? status,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    double? minTotal,
    double? maxTotal,
    String? sortBy,
    String? sortOrder,
  });

  /// Obtiene una venta por ID
  Future<Sale?> getSaleById(String id);

  /// Obtiene una venta por número de factura
  Future<Sale?> getSaleByInvoiceNumber(String invoiceNumber);

  /// Crea una nueva venta
  Future<Sale> createSale(Sale sale);

  /// Actualiza una venta existente
  Future<Sale> updateSale(String id, Sale sale);

  /// Elimina una venta
  Future<bool> deleteSale(String id);

  /// Cancela una venta
  Future<Sale> cancelSale(String id, String reason);

  /// Reembolsa una venta
  Future<Sale> refundSale(String id, String reason);

  /// Obtiene ventas por vendedor
  Future<List<Sale>> getSalesBySeller(String sellerId, {
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Obtiene ventas por cliente
  Future<List<Sale>> getSalesByCustomer(String customerName);

  /// Obtiene ventas por período
  Future<List<Sale>> getSalesByPeriod(DateTime startDate, DateTime endDate);

  /// Obtiene estadísticas de ventas
  Future<Map<String, dynamic>> getSalesStats({
    DateTime? startDate,
    DateTime? endDate,
    String? sellerId,
  });

  /// Obtiene el siguiente número de factura
  Future<String> getNextInvoiceNumber();

  /// Obtiene productos más vendidos
  Future<List<Map<String, dynamic>>> getTopSellingProducts({
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Obtiene clientes más frecuentes
  Future<List<Map<String, dynamic>>> getTopCustomers({
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Obtiene reporte de ventas diarias
  Future<List<Map<String, dynamic>>> getDailySalesReport(DateTime date);

  /// Obtiene reporte de ventas mensuales
  Future<List<Map<String, dynamic>>> getMonthlySalesReport(int year, int month);

  /// Obtiene reporte de ventas anuales
  Future<List<Map<String, dynamic>>> getYearlySalesReport(int year);

  /// Exporta ventas a un archivo
  Future<String> exportSales(List<String> saleIds, String format);

  /// Obtiene ventas pendientes de pago
  Future<List<Sale>> getPendingSales();

  /// Obtiene ventas con descuentos
  Future<List<Sale>> getSalesWithDiscounts({
    DateTime? startDate,
    DateTime? endDate,
  });
}




