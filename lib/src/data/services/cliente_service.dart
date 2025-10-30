import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cliente_model.dart';
import '../models/base_model.dart';

class ClienteService {
  final String baseUrl = 'http://localhost:5044/api/Clientes';

  /// Obtener todos los clientes activos
  Future<List<Cliente>> obtenerActivos() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

      if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener clientes activos: ${response.body}');
    }
  }

  /// Obtener cliente por ID
  Future<Cliente?> obtenerPorId(int clienteId) async {
    final url = Uri.parse('$baseUrl/$clienteId');
    final response = await http.get(url);
    
      if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return Cliente.fromJson(data.first);
        }
        return null;
    } else {
      throw Exception('Error al obtener cliente: ${response.body}');
    }
  }

  /// Buscar clientes por nombre
  Future<List<Cliente>> buscarPorNombre(String nombre) async {
    final url = Uri.parse('$baseUrl/buscar?nombre=$nombre');
    final response = await http.get(url);
    
      if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar clientes: ${response.body}');
    }
  }

  /// Obtener clientes inactivos
  Future<List<Cliente>> obtenerInactivos() async {
    final url = Uri.parse('$baseUrl/inactivos');
    final response = await http.get(url);
    
      if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener clientes inactivos: ${response.body}');
    }
  }

  /// Buscar clientes inactivos por nombre
  Future<List<Cliente>> buscarInactivosPorNombre(String nombre) async {
    final url = Uri.parse('$baseUrl/inactivos/buscar?nombre=$nombre');
    final response = await http.get(url);
    
      if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar clientes inactivos: ${response.body}');
    }
  }

  /// Crear nuevo cliente
  Future<ApiResponse<dynamic>> crearCliente(CrearClienteRequest request) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    
    if (response.statusCode == 200) {
      return ApiResponse.success(
        data: jsonDecode(response.body),
        message: 'Cliente creado exitosamente',
      );
    } else {
      return ApiResponse.error(
        message: 'Error al crear cliente: ${response.body}',
      );
    }
  }

  /// Actualizar cliente
  Future<ApiResponse<dynamic>> actualizarCliente(
    int clienteId,
    ActualizarClienteRequest request,
  ) async {
    final url = Uri.parse('$baseUrl/$clienteId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
      );
    
    if (response.statusCode == 200) {
      return ApiResponse.success(
        data: jsonDecode(response.body),
        message: 'Cliente actualizado exitosamente',
      );
    } else {
      return ApiResponse.error(
        message: 'Error al actualizar cliente: ${response.body}',
      );
    }
  }

  /// Desactivar cliente
  Future<ApiResponse<dynamic>> desactivarCliente(int clienteId) async {
    final url = Uri.parse('$baseUrl/$clienteId/desactivar');
    final response = await http.post(url);
    
    if (response.statusCode == 200) {
      return ApiResponse.success(
        data: jsonDecode(response.body),
        message: 'Cliente desactivado exitosamente',
      );
    } else {
      return ApiResponse.error(
        message: 'Error al desactivar cliente: ${response.body}',
      );
    }
  }

  /// Activar cliente
  Future<ApiResponse<dynamic>> activarCliente(int clienteId) async {
    final url = Uri.parse('$baseUrl/$clienteId/activar');
    final response = await http.post(url);
    
    if (response.statusCode == 200) {
      return ApiResponse.success(
        data: jsonDecode(response.body),
        message: 'Cliente activado exitosamente',
      );
    } else {
      return ApiResponse.error(
        message: 'Error al activar cliente: ${response.body}',
      );
    }
  }
}
