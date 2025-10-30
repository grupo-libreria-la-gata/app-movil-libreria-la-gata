import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/venta_model.dart';
import '../models/request_models.dart';

class VentaService {
  final String baseUrl = 'http://localhost:5044/api/Ventas';

  /// Obtener todas las ventas
  Future<List<VentaListResponse>> obtenerTodas(int usuarioId) async {
    final url = Uri.parse('$baseUrl?usuarioId=$usuarioId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => VentaListResponse.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener ventas: ${response.body}');
    }
  }

  /// Obtener venta completa por ID
  Future<Venta?> obtenerPorId(int ventaId) async {
    final url = Uri.parse('$baseUrl/$ventaId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Venta.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener venta: ${response.body}');
    }
  }

  /// Obtener ventas por rango de fechas
  Future<List<VentaListResponse>> obtenerPorFechas(
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
      return data.map((json) => VentaListResponse.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener ventas por fechas: ${response.body}');
    }
  }

  /// Obtener ventas por cliente
  Future<List<VentaListResponse>> obtenerPorCliente(
    int clienteId,
    int usuarioId,
  ) async {
    final url = Uri.parse('$baseUrl/por-cliente/$clienteId?usuarioId=$usuarioId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => VentaListResponse.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener ventas por cliente: ${response.body}');
    }
  }

  /// Crear una nueva venta
  Future<Venta> crearVenta(CrearVentaRequest request) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Venta.fromJson(data);
    } else {
      throw Exception('Error al crear venta: ${response.body}');
    }
  }
}