import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/reserve.dart';
import '../../../core/design/design_tokens.dart';

/// Página que muestra el listado de reservas naturales
class ReservesPage extends StatefulWidget {
  const ReservesPage({super.key});

  @override
  State<ReservesPage> createState() => _ReservesPageState();
}

class _ReservesPageState extends State<ReservesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedProvince = 'Todas';
  List<Reserve> _filteredReserves = [];

  // Datos mock de reservas
  final List<Reserve> _reserves = [
    Reserve(
      reserveId: '1',
      nombre: 'Reserva Natural Indio Maíz',
      descripcion: 'Una de las reservas más grandes de Nicaragua, hogar de cientos de especies de aves y vida silvestre.',
      lat: 10.8231,
      lng: -84.6295,
      direccion: 'Río San Juan, Nicaragua',
      provincia: 'Río San Juan',
      horario: '6:00 AM - 6:00 PM',
      telefono: '+505 8888 8888',
      emailContacto: 'info@indio-maiz.com',
      estado: 'Abierta',
      createdAt: DateTime.now(),
    ),
    Reserve(
      reserveId: '2',
      nombre: 'Reserva Natural Cerro Silva',
      descripcion: 'Reserva montañosa con senderos para observación de aves y vistas panorámicas.',
      lat: 12.1364,
      lng: -84.1945,
      direccion: 'Río San Juan, Nicaragua',
      provincia: 'Río San Juan',
      horario: '7:00 AM - 5:00 PM',
      telefono: '+505 7777 7777',
      emailContacto: 'info@cerro-silva.com',
      estado: 'Abierta',
      createdAt: DateTime.now(),
    ),
    Reserve(
      reserveId: '3',
      nombre: 'Reserva Natural Volcán Mombacho',
      descripcion: 'Reserva en las faldas del volcán Mombacho, famosa por su biodiversidad y senderos.',
      lat: 11.8267,
      lng: -85.9683,
      direccion: 'Granada, Nicaragua',
      provincia: 'Granada',
      horario: '8:00 AM - 4:00 PM',
      telefono: '+505 6666 6666',
      emailContacto: 'info@mombacho.com',
      estado: 'Abierta',
      createdAt: DateTime.now(),
    ),
    Reserve(
      reserveId: '4',
      nombre: 'Reserva Natural Laguna de Apoyo',
      descripcion: 'Reserva alrededor de la laguna de cráter, ideal para observación de aves acuáticas.',
      lat: 11.9167,
      lng: -86.0333,
      direccion: 'Granada, Nicaragua',
      provincia: 'Granada',
      horario: '6:00 AM - 6:00 PM',
      telefono: '+505 5555 5555',
      emailContacto: 'info@apoyo.com',
      estado: 'Abierta',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredReserves = _reserves;
    _searchController.addListener(_filterReserves);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterReserves() {
    setState(() {
      final searchTerm = _searchController.text.toLowerCase();
      _filteredReserves = _reserves.where((reserve) {
        final matchesSearch = reserve.nombre.toLowerCase().contains(searchTerm) ||
            (reserve.descripcion?.toLowerCase().contains(searchTerm) ?? false);
        final matchesProvince = _selectedProvince == 'Todas' || 
            reserve.provincia == _selectedProvince;
        return matchesSearch && matchesProvince;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Reservas Naturales',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => context.go('/home'),
            tooltip: 'Ir al inicio',
          ),
        ],
      ),
      body: Column(
        children: [
          // Sección de búsqueda y filtros
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: DesignTokens.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(DesignTokens.borderRadiusLg),
                bottomRight: Radius.circular(DesignTokens.borderRadiusLg),
              ),
            ),
            child: Column(
              children: [
                // Barra de búsqueda
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar reservas...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                
                // Filtro por provincia
                Row(
                  children: [
                    const Text(
                      'Provincia: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: DesignTokens.spacingSm),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedProvince,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          'Todas',
                          ..._reserves.map((r) => r.provincia ?? '').where((p) => p.isNotEmpty).toSet().toList(),
                        ].map((province) {
                          return DropdownMenuItem(
                            value: province,
                            child: Text(province),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProvince = value!;
                            _filterReserves();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Contador de resultados
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Row(
              children: [
                Icon(
                  Icons.forest,
                  color: DesignTokens.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Text(
                  '${_filteredReserves.length} reservas encontradas',
                  style: TextStyle(
                    color: DesignTokens.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de reservas
          Expanded(
            child: _filteredReserves.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: DesignTokens.spacingMd),
                        Text(
                          'No se encontraron reservas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(DesignTokens.spacingMd),
                    itemCount: _filteredReserves.length,
                    itemBuilder: (context, index) {
                      final reserve = _filteredReserves[index];
                      return _buildReserveCard(context, reserve);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReserveCard(BuildContext context, Reserve reserve) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
          gradient: LinearGradient(
            colors: [
              DesignTokens.primaryColor.withValues(alpha: 0.1),
              DesignTokens.primaryColor.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con icono y estado
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: DesignTokens.primaryColor,
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                    child: const Icon(
                      Icons.forest,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reserve.nombre,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingSm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: DesignTokens.primaryColor,
                            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                          ),
                          child: Text(
                            reserve.estado ?? 'Desconocido',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingMd),
              
              // Descripción
              Text(
                reserve.descripcion ?? 'Sin descripción disponible',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              
              const SizedBox(height: DesignTokens.spacingMd),
              
              // Información de ubicación y horario
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: DesignTokens.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reserve.provincia ?? 'Sin ubicación',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: DesignTokens.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reserve.horario ?? 'Horario no disponible',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingLg),
              
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.go('/reserves/${reserve.reserveId}');
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Ver Detalles'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DesignTokens.primaryColor,
                        side: BorderSide(color: DesignTokens.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMd),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar navegación a reserva
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Reservar en ${reserve.nombre}'),
                            backgroundColor: DesignTokens.primaryColor,
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Reservar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignTokens.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
