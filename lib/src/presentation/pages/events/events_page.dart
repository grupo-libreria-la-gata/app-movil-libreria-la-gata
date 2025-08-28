import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';

/// Página que muestra los eventos de aviturismo
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todas';
  String _selectedStatus = 'Todas';
  List<Event> _filteredEvents = [];

  // Datos mock de eventos
  final List<Event> _events = [
    Event(
      eventId: '1',
      titulo: 'Festival de Aves Migratorias',
      descripcion: 'Celebra la llegada de las aves migratorias a Nicaragua con actividades educativas, observación de aves y talleres para toda la familia.',
      fechaInicio: DateTime.now().add(const Duration(days: 15)),
      fechaFin: DateTime.now().add(const Duration(days: 17)),
      ubicacion: 'Reserva Natural Chocoyero-El Brujo',
      categoria: 'Festival',
      estado: 'Próximo',
      precio: 25.0,
      cupoMaximo: 100,
      cupoDisponible: 75,
      imagenUrl: null,
    ),
    Event(
      eventId: '2',
      titulo: 'Conteo Navideño de Aves',
      descripcion: 'Participa en el tradicional conteo navideño de aves, una actividad científica ciudadana que ayuda a monitorear las poblaciones de aves.',
      fechaInicio: DateTime.now().add(const Duration(days: 30)),
      fechaFin: DateTime.now().add(const Duration(days: 30)),
      ubicacion: 'Múltiples ubicaciones en Nicaragua',
      categoria: 'Conteo',
      estado: 'Próximo',
      precio: 0.0,
      cupoMaximo: 200,
      cupoDisponible: 150,
      imagenUrl: null,
    ),
    Event(
      eventId: '3',
      titulo: 'Taller de Fotografía de Aves',
      descripcion: 'Aprende técnicas profesionales para fotografiar aves en su hábitat natural. Incluye equipo de préstamo y guía especializada.',
      fechaInicio: DateTime.now().add(const Duration(days: 7)),
      fechaFin: DateTime.now().add(const Duration(days: 7)),
      ubicacion: 'Reserva Natural Volcán Mombacho',
      categoria: 'Taller',
      estado: 'Próximo',
      precio: 50.0,
      cupoMaximo: 20,
      cupoDisponible: 5,
      imagenUrl: null,
    ),
    Event(
      eventId: '4',
      titulo: 'Expedición Nocturna de Búhos',
      descripcion: 'Explora el mundo de las aves nocturnas en una expedición especial bajo las estrellas. Identificación de búhos y otras aves nocturnas.',
      fechaInicio: DateTime.now().add(const Duration(days: 3)),
      fechaFin: DateTime.now().add(const Duration(days: 3)),
      ubicacion: 'Reserva Natural Laguna de Apoyo',
      categoria: 'Expedición',
      estado: 'Próximo',
      precio: 35.0,
      cupoMaximo: 15,
      cupoDisponible: 0,
      imagenUrl: null,
    ),
    Event(
      eventId: '5',
      titulo: 'Festival del Quetzal',
      descripcion: 'Celebra la belleza del quetzal, ave nacional de Guatemala, en su hábitat natural. Observación, fotografía y conservación.',
      fechaInicio: DateTime.now().subtract(const Duration(days: 10)),
      fechaFin: DateTime.now().subtract(const Duration(days: 8)),
      ubicacion: 'Reserva Natural Cerro Musún',
      categoria: 'Festival',
      estado: 'Finalizado',
      precio: 40.0,
      cupoMaximo: 80,
      cupoDisponible: 0,
      imagenUrl: null,
    ),
    Event(
      eventId: '6',
      titulo: 'Curso de Identificación de Aves',
      descripcion: 'Curso intensivo para aprender a identificar aves por su canto, plumaje y comportamiento. Ideal para principiantes.',
      fechaInicio: DateTime.now().add(const Duration(days: 45)),
      fechaFin: DateTime.now().add(const Duration(days: 47)),
      ubicacion: 'Centro de Educación Ambiental',
      categoria: 'Curso',
      estado: 'Próximo',
      precio: 80.0,
      cupoMaximo: 30,
      cupoDisponible: 25,
      imagenUrl: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredEvents = _events;
    _searchController.addListener(_filterEvents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterEvents() {
    setState(() {
      final searchTerm = _searchController.text.toLowerCase();
      _filteredEvents = _events.where((event) {
        final matchesSearch = event.titulo.toLowerCase().contains(searchTerm) ||
            event.descripcion.toLowerCase().contains(searchTerm) ||
            event.ubicacion.toLowerCase().contains(searchTerm);
        
        final matchesCategory = _selectedCategory == 'Todas' || event.categoria == _selectedCategory;
        final matchesStatus = _selectedStatus == 'Todas' || event.estado == _selectedStatus;
        
        return matchesSearch && matchesCategory && matchesStatus;
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
          'Eventos',
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
                    hintText: 'Buscar eventos...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                
                // Filtros
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          'Todas',
                          'Festival',
                          'Conteo',
                          'Taller',
                          'Expedición',
                          'Curso',
                        ].map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                            _filterEvents();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingMd),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          'Todas',
                          'Próximo',
                          'En Curso',
                          'Finalizado',
                        ].map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                            _filterEvents();
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
                  Icons.event,
                  color: DesignTokens.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Text(
                  '${_filteredEvents.length} eventos encontrados',
                  style: TextStyle(
                    color: DesignTokens.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de eventos
          Expanded(
            child: _filteredEvents.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: DesignTokens.spacingMd),
                        Text(
                          'No se encontraron eventos',
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
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      return _buildEventCard(context, event);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    final isSoldOut = event.cupoDisponible == 0;
    final isFree = event.precio == 0;

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
              Colors.purple.withValues(alpha: 0.1),
              Colors.purple.withValues(alpha: 0.05),
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
              // Header con imagen y estado
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                    child: const Icon(
                      Icons.event,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.titulo,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.ubicacion,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge de estado
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingSm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(event.estado),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                    ),
                    child: Text(
                      event.estado,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingMd),
              
              // Descripción
              Text(
                event.descripcion,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: DesignTokens.spacingMd),
              
              // Información del evento
              Row(
                children: [
                  Expanded(
                    child: _buildEventInfo(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Fecha',
                      value: _formatEventDate(event.fechaInicio, event.fechaFin),
                    ),
                  ),
                  Expanded(
                    child: _buildEventInfo(
                      context,
                      icon: Icons.category,
                      label: 'Categoría',
                      value: event.categoria,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingSm),
              
              Row(
                children: [
                  Expanded(
                    child: _buildEventInfo(
                      context,
                      icon: Icons.people,
                      label: 'Cupo',
                      value: '${event.cupoDisponible}/${event.cupoMaximo}',
                    ),
                  ),
                  Expanded(
                    child: _buildEventInfo(
                      context,
                      icon: Icons.attach_money,
                      label: 'Precio',
                      value: isFree ? 'Gratis' : '\$${event.precio.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingLg),
              
              // Botón de acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isSoldOut ? null : () {
                    _showEventDetails(context, event);
                  },
                  icon: Icon(isSoldOut ? Icons.block : Icons.info_outline),
                  label: Text(isSoldOut ? 'Agotado' : 'Ver Detalles'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSoldOut ? Colors.grey : Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfo(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.purple,
          size: 16,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Próximo':
        return Colors.blue;
      case 'En Curso':
        return Colors.green;
      case 'Finalizado':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String _formatEventDate(DateTime startDate, DateTime endDate) {
    final start = '${startDate.day}/${startDate.month}/${startDate.year}';
    final end = '${endDate.day}/${endDate.month}/${endDate.year}';
    
    if (startDate.isAtSameMomentAs(endDate)) {
      return start;
    } else {
      return '$start - $end';
    }
  }

  void _showEventDetails(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.titulo),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descripción: ${event.descripcion}'),
              const SizedBox(height: 8),
              Text('Ubicación: ${event.ubicacion}'),
              Text('Fecha: ${_formatEventDate(event.fechaInicio, event.fechaFin)}'),
              Text('Categoría: ${event.categoria}'),
              Text('Estado: ${event.estado}'),
              Text('Cupo: ${event.cupoDisponible}/${event.cupoMaximo}'),
              Text('Precio: ${event.precio == 0 ? 'Gratis' : '\$${event.precio.toStringAsFixed(2)}'}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          if (event.cupoDisponible > 0)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Inscripción próximamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Inscribirse'),
            ),
        ],
      ),
    );
  }
}

// Clase para representar un evento
class Event {
  final String eventId;
  final String titulo;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String ubicacion;
  final String categoria;
  final String estado;
  final double precio;
  final int cupoMaximo;
  final int cupoDisponible;
  final String? imagenUrl;

  Event({
    required this.eventId,
    required this.titulo,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.ubicacion,
    required this.categoria,
    required this.estado,
    required this.precio,
    required this.cupoMaximo,
    required this.cupoDisponible,
    this.imagenUrl,
  });
}
