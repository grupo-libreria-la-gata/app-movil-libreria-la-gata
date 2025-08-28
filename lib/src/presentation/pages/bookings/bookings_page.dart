import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/booking.dart';
import '../../../core/design/design_tokens.dart';

/// Página que muestra las reservas del usuario
class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String _selectedStatus = 'Todas';
  List<Booking> _filteredBookings = [];

  // Datos mock de reservas
  final List<Booking> _bookings = [
    Booking(
      bookingId: '1',
      userId: '1',
      reserveId: '1',
      guideId: '1',
      fechaHora: DateTime.now().add(const Duration(days: 7)),
      personas: 4,
      estado: 'Confirmada',
      total: 120.0,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Booking(
      bookingId: '2',
      userId: '1',
      reserveId: '2',
      guideId: '2',
      fechaHora: DateTime.now().add(const Duration(days: 14)),
      personas: 2,
      estado: 'Pendiente',
      total: 80.0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Booking(
      bookingId: '3',
      userId: '1',
      reserveId: '3',
      guideId: '3',
      fechaHora: DateTime.now().subtract(const Duration(days: 5)),
      personas: 6,
      estado: 'Completada',
      total: 200.0,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Booking(
      bookingId: '4',
      userId: '1',
      reserveId: '1',
      guideId: '1',
      fechaHora: DateTime.now().subtract(const Duration(days: 20)),
      personas: 3,
      estado: 'Cancelada',
      total: 90.0,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredBookings = _bookings;
  }

  void _filterBookings() {
    setState(() {
      if (_selectedStatus == 'Todas') {
        _filteredBookings = _bookings;
      } else {
        _filteredBookings = _bookings.where((booking) => 
          booking.estado == _selectedStatus
        ).toList();
      }
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
          'Mis Reservas',
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
          // Filtros
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: DesignTokens.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(DesignTokens.borderRadiusLg),
                bottomRight: Radius.circular(DesignTokens.borderRadiusLg),
              ),
            ),
            child: Row(
              children: [
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
                      'Pendiente',
                      'Confirmada',
                      'Completada',
                      'Cancelada',
                    ].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                        _filterBookings();
                      });
                    },
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/bookings/create');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Reserva'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignTokens.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingLg,
                      vertical: DesignTokens.spacingMd,
                    ),
                  ),
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
                  Icons.calendar_today,
                  color: DesignTokens.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Text(
                  '${_filteredBookings.length} reservas encontradas',
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
            child: _filteredBookings.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: DesignTokens.spacingMd),
                        Text(
                          'No tienes reservas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: DesignTokens.spacingSm),
                        Text(
                          '¡Haz tu primera reserva!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(DesignTokens.spacingMd),
                    itemCount: _filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = _filteredBookings[index];
                      return _buildBookingCard(context, booking);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final isPast = booking.fechaHora.isBefore(DateTime.now());
    final isToday = booking.fechaHora.day == DateTime.now().day &&
                    booking.fechaHora.month == DateTime.now().month &&
                    booking.fechaHora.year == DateTime.now().year;

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
              Colors.orange.withValues(alpha: 0.1),
              Colors.orange.withValues(alpha: 0.05),
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
              // Header con estado y fecha
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
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
                          'Reserva #${booking.bookingId}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(booking.fechaHora),
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
                      color: _getStatusColor(booking.estado),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                    ),
                    child: Text(
                      booking.estado,
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
              
              // Información de la reserva
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.people,
                      label: 'Personas',
                      value: '${booking.personas}',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.attach_money,
                      label: 'Total',
                      value: '\$${booking.total.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingMd),
              
              // Información adicional
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.location_on,
                      label: 'Reserva',
                      value: 'Reserva Natural #${booking.reserveId}',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.person,
                      label: 'Guía',
                      value: 'Guía #${booking.guideId}',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingLg),
              
              // Botones de acción
              Row(
                children: [
                  if (booking.estado == 'Pendiente' || booking.estado == 'Confirmada') ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showCancelDialog(context, booking);
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancelar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                        ),
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingMd),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showBookingDetails(context, booking);
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Ver Detalles'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.orange,
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
      case 'Pendiente':
        return Colors.orange;
      case 'Confirmada':
        return Colors.blue;
      case 'Completada':
        return Colors.green;
      case 'Cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Hoy a las ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference == 1) {
      return 'Mañana a las ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference > 1) {
      return 'En $difference días';
    } else {
      return 'Hace ${difference.abs()} días';
    }
  }

  void _showCancelDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: Text('¿Estás seguro de que quieres cancelar la reserva #${booking.bookingId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reserva cancelada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sí, Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles de Reserva #${booking.bookingId}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${_formatDate(booking.fechaHora)}'),
            Text('Personas: ${booking.personas}'),
            Text('Total: \$${booking.total.toStringAsFixed(2)}'),
            Text('Estado: ${booking.estado}'),
            Text('Reserva: #${booking.reserveId}'),
            Text('Guía: #${booking.guideId}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
