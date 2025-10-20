import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/detalle_producto_model.dart';

class DetalleProductoService {
  final String baseUrl = 'http://localhost:5044/api/DetalleProductos';

  /// Obtener todos los detalles de productos activos
  Future<List<DetalleProducto>> obtenerActivos() async {
    final url = Uri.parse('$baseUrl/activos');
    final response = await http.get(url);

    // Debug logging removed for production

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DetalleProducto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al obtener detalles de productos activos: ${response.body}',
      );
    }
  }

  /// Obtener todos los detalles de productos
  Future<List<DetalleProducto>> obtenerTodos() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DetalleProducto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al obtener detalles de productos: ${response.body}',
      );
    }
  }

  /// Obtener detalle de producto por ID
  Future<DetalleProducto> obtenerPorId(int detalleProductoId) async {
    final url = Uri.parse('$baseUrl/$detalleProductoId');
    final response = await http.get(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DetalleProducto.fromJson(data);
    } else {
      throw Exception('Error al obtener detalle de producto: ${response.body}');
    }
  }

  /// Actualizar stock de un detalle de producto
  Future<void> actualizarStock(int detalleProductoId, int nuevoStock) async {
    final url = Uri.parse('$baseUrl/$detalleProductoId/stock');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'stock': nuevoStock}),
    );

    // Debug logging removed for production

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar stock: ${response.body}');
    }
  }

  /// Buscar detalles de productos por nombre
  Future<List<DetalleProducto>> buscarPorNombre(String nombre) async {
    final url = Uri.parse('$baseUrl/buscar?nombre=$nombre');
    final response = await http.get(url);

    // Debug logging removed for production

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DetalleProducto.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al buscar detalles de productos: ${response.body}',
      );
    }
  }
}
