import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/categoria_model.dart';

class CategoriaService {
  final String baseUrl = 'http://localhost:5044/api/Categorias';
  final int usuarioId = 1; // ⚠️ Reemplazar con el usuario logueado

  Future<List<Categoria>> obtenerActivos() async {
    final url = Uri.parse('$baseUrl/activos');
    final response = await http.get(url);

    // Debug logging removed for production

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener categorías activas: ${response.body}');
    }
  }

  Future<void> crearCategoria(String nombre) async {
    final url = Uri.parse('$baseUrl?nombre=$nombre&usuarioId=$usuarioId');
    final response = await http.post(url);

    // Debug logging removed for production
    if (response.statusCode != 201) {
      throw Exception('Error al crear categoría: ${response.body}');
    }
  }

  Future<void> editarCategoria(int categoriaId, String nombre) async {
    final url = Uri.parse(
      '$baseUrl?categoriaId=$categoriaId&nombre=$nombre&usuarioId=$usuarioId',
    );
    final response = await http.put(url);

    // Debug logging removed for production
    if (response.statusCode != 204) {
      throw Exception('Error al editar categoría: ${response.body}');
    }
  }

  Future<void> desactivarCategoria(int categoriaId) async {
    final url = Uri.parse(
      '$baseUrl/desactivar?categoriaId=$categoriaId&usuarioId=$usuarioId',
    );
    final response = await http.post(url);

    // Debug logging removed for production
    if (response.statusCode != 204) {
      throw Exception('Error al desactivar categoría: ${response.body}');
    }
  }
}
