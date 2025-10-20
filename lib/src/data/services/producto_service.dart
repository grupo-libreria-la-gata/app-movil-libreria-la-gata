import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/producto_model.dart';

class ProductoService {
  final String baseUrl = 'http://localhost:5044/api/Productos';
  final int usuarioId = 1; // ⚠️ Reemplazar con el usuario logueado

  Future<List<Producto>> obtenerActivos() async {
    final url = Uri.parse('$baseUrl/activos');
    final response = await http.get(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener productos activos: ${response.body}');
    }
  }

  Future<void> crearProducto(String nombre) async {
    final url = Uri.parse('$baseUrl?nombre=$nombre&usuarioId=$usuarioId');
    final response = await http.post(url);

    // Debug logging removed for production
    if (response.statusCode != 201) {
      throw Exception('Error al crear producto: ${response.body}');
    }
  }

  Future<void> editarProducto(int productoId, String nombre) async {
    final url = Uri.parse('$baseUrl?productoId=$productoId&nombre=$nombre&usuarioId=$usuarioId');
    final response = await http.put(url);

    // Debug logging removed for production
    if (response.statusCode != 204) {
      throw Exception('Error al editar producto: ${response.body}');
    }
  }

  Future<void> desactivarProducto(int productoId) async {
    final url = Uri.parse('$baseUrl/desactivar?productoId=$productoId&usuarioId=$usuarioId');
    final response = await http.post(url);

    // Debug logging removed for production
    if (response.statusCode != 204) {
      throw Exception('Error al desactivar producto: ${response.body}');
    }
  }
}
