import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/proveedor_model.dart';

class ProveedorService {
  final String baseUrl = 'http://localhost:5044/api/Proveedores';

  Future<List<Proveedor>> obtenerActivos() async {
    final url = Uri.parse('$baseUrl/activos');
    final response = await http.get(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Proveedor.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener proveedores activos: ${response.body}');
    }
  }

  Future<List<Proveedor>> obtenerTodos() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Proveedor.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener proveedores: ${response.body}');
    }
  }

  Future<Proveedor> obtenerPorId(int proveedorId) async {
    final url = Uri.parse('$baseUrl/$proveedorId');
    final response = await http.get(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Proveedor.fromJson(data);
    } else {
      throw Exception('Error al obtener proveedor: ${response.body}');
    }
  }

  Future<Proveedor> crearProveedor(CrearProveedorRequest request) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Proveedor.fromJson(data);
    } else {
      throw Exception('Error al crear proveedor: ${response.body}');
    }
  }

  Future<Proveedor> actualizarProveedor(
    int proveedorId,
    ActualizarProveedorRequest request,
  ) async {
    final url = Uri.parse('$baseUrl/$proveedorId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Proveedor.fromJson(data);
    } else {
      throw Exception('Error al actualizar proveedor: ${response.body}');
    }
  }

  Future<void> desactivarProveedor(int proveedorId) async {
    final url = Uri.parse('$baseUrl/$proveedorId/desactivar');
    final response = await http.post(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode != 204) {
      throw Exception('Error al desactivar proveedor: ${response.body}');
    }
  }

  Future<void> activarProveedor(int proveedorId) async {
    final url = Uri.parse('$baseUrl/$proveedorId/activar');
    final response = await http.post(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode != 204) {
      throw Exception('Error al activar proveedor: ${response.body}');
    }
  }
}
