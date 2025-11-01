import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/proveedor_model.dart';
import '../models/base_model.dart';
import '../../config/app_config.dart';

class ProveedorService {
  String get baseUrl => '${AppConfig.baseUrl}/api/Proveedores';

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

  Future<List<Proveedor>> obtenerInactivos() async {
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

  Future<ApiResponse<Proveedor>> crearProveedor(
    CrearProveedorRequest request,
  ) async {
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
      return ApiResponse.success(
        data: Proveedor.fromJson(data),
        message: 'Proveedor creado exitosamente',
      );
    } else {
      return ApiResponse.error(
        message: 'Error al crear proveedor: ${response.body}',
      );
    }
  }

  Future<ApiResponse<Proveedor>> actualizarProveedor(
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
      return ApiResponse.success(
        data: Proveedor.fromJson(data),
        message: 'Proveedor actualizado exitosamente',
      );
    } else {
      return ApiResponse.error(
        message: 'Error al actualizar proveedor: ${response.body}',
      );
    }
  }

  Future<ApiResponse<bool>> desactivarProveedor(int proveedorId) async {
    final url = Uri.parse('$baseUrl/$proveedorId/desactivar');
    final response = await http.post(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 204) {
      return ApiResponse.success(
        data: true,
        message: 'Proveedor desactivado exitosamente',
      );
    } else {
      return ApiResponse.error(
        message: 'Error al desactivar proveedor: ${response.body}',
      );
    }
  }

  Future<ApiResponse<bool>> activarProveedor(int proveedorId) async {
    final url = Uri.parse('$baseUrl/$proveedorId/activar');
    final response = await http.post(url);

    // Debug logging removed for production
    // Debug logging removed for production

    if (response.statusCode == 204) {
      return ApiResponse.success(
        data: true,
        message: 'Proveedor activado exitosamente',
      );
    } else {
      return ApiResponse.error(
        message: 'Error al activar proveedor: ${response.body}',
      );
    }
  }

  Future<List<Proveedor>> buscarPorNombre(String nombre) async {
    final url = Uri.parse('$baseUrl/activos/buscar?nombre=$nombre');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Proveedor.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar proveedores: ${response.body}');
    }
  }
}
