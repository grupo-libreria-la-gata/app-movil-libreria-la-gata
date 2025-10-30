import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/detalle_producto_model.dart';

class DetalleProductoService {
  final String baseUrl = 'http://localhost:5044/api/DetalleProductos';

  /// Obtener todos los detalles de productos activos
  Future<List<DetalleProducto>> obtenerActivos() async {
    final url = Uri.parse('$baseUrl/activos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DetalleProducto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener inventario: ${response.body}');
    }
  }

  /// Obtener detalle de producto por ID
  Future<DetalleProducto?> obtenerPorId(int detalleProductoId) async {
    final url = Uri.parse('$baseUrl/$detalleProductoId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return DetalleProducto.fromJson(data.first);
      }
      return null;
    } else {
      throw Exception('Error al obtener detalle de producto: ${response.body}');
    }
  }

  /// Buscar detalles de productos por nombre
  Future<List<DetalleProducto>> buscarPorNombre(String nombre) async {
    final url = Uri.parse('$baseUrl/buscar?nombre=$nombre');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DetalleProducto.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar inventario: ${response.body}');
    }
  }

  /// Ajustar stock de un producto
  Future<void> ajustarStock(int detalleProductoId, int cantidad, int usuarioId) async {
    final url = Uri.parse('$baseUrl/ajustar-stock?detalleProductoId=$detalleProductoId&cantidad=$cantidad&usuarioId=$usuarioId');
    final response = await http.post(url);

    if (response.statusCode != 204) {
      throw Exception('Error al ajustar stock: ${response.body}');
    }
  }
}