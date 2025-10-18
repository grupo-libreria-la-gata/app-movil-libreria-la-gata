import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/marca_model.dart';

class MarcaService {
  final String baseUrl = 'http://localhost:5044/api/Marcas';
  final int usuarioId = 1; // ⚠️ Reemplaza con el ID real del usuario logueado

  Future<List<Marca>> obtenerActivos() async {
    final url = Uri.parse('$baseUrl/activos');
    final response = await http.get(url);

    print('GET /activos → ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Marca.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener marcas activas: ${response.body}');
    }
  }

  Future<void> crearMarca(String nombre) async {
    final url = Uri.parse('$baseUrl?nombre=$nombre&usuarioId=$usuarioId');
    final response = await http.post(url);

    print('POST /crear → ${response.statusCode}');
    if (response.statusCode != 201) {
      throw Exception('Error al crear marca: ${response.body}');
    }
  }

  Future<void> editarMarca(int marcaId, String nombre) async {
    final url = Uri.parse('$baseUrl?marcaId=$marcaId&nombre=$nombre&usuarioId=$usuarioId');
    final response = await http.put(url);

    print('PUT /editar → ${response.statusCode}');
    if (response.statusCode != 204) {
      throw Exception('Error al editar marca: ${response.body}');
    }
  }

  Future<void> desactivarMarca(int marcaId) async {
    final url = Uri.parse('$baseUrl/desactivar?marcaId=$marcaId&usuarioId=$usuarioId');
    final response = await http.post(url);

    print('POST /desactivar → ${response.statusCode}');
    if (response.statusCode != 204) {
      throw Exception('Error al desactivar marca: ${response.body}');
    }
  }
}