import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/compra_model.dart';
import '../models/request_models.dart';

class CompraService {
  final String baseUrl = 'http://localhost:5044/api/Compras';

  /// Obtener todas las compras
  Future<List<CompraListResponse>> obtenerTodas(int usuarioId) async {
    final url = Uri.parse('$baseUrl?usuarioId=$usuarioId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CompraListResponse.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener compras: ${response.body}');
    }
  }

  /// Obtener compra completa por ID
  Future<Compra?> obtenerPorId(int compraId) async {
    final url = Uri.parse('$baseUrl/$compraId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Compra.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener compra: ${response.body}');
    }
  }

  /// Obtener compras por rango de fechas
  Future<List<CompraListResponse>> obtenerPorFechas(
    DateTime fechaInicio,
    DateTime fechaFin,
    int usuarioId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/por-fechas?fechaInicio=${fechaInicio.toIso8601String()}&fechaFin=${fechaFin.toIso8601String()}&usuarioId=$usuarioId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CompraListResponse.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener compras por fechas: ${response.body}');
    }
  }

  /// Obtener compras por proveedor
  Future<List<CompraListResponse>> obtenerPorProveedor(
    int proveedorId,
    int usuarioId,
  ) async {
    final url = Uri.parse('$baseUrl/por-proveedor/$proveedorId?usuarioId=$usuarioId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CompraListResponse.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener compras por proveedor: ${response.body}');
    }
  }

  /// Crear una nueva compra
  Future<Compra> crearCompra(CrearCompraRequest request) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Compra.fromJson(data);
    } else {
      throw Exception('Error al crear compra: ${response.body}');
    }
  }

  /// Calcular total de detalles
  double calcularTotal(List<CrearCompraDetalleRequest> detalles) {
    return detalles.fold(0.0, (sum, detalle) => sum + detalle.subtotal);
  }

  /// Validar detalles
  bool validarDetalles(List<CrearCompraDetalleRequest> detalles) {
    return detalles.isNotEmpty && detalles.every((d) => d.cantidad > 0 && d.precioUnitario > 0);
  }
}