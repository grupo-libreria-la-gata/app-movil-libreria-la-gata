import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/reserve.dart';
import '../../../core/design/design_tokens.dart';

/// Página que muestra los detalles de una reserva natural específica
class ReserveDetailPage extends StatelessWidget {
  final String reserveId;

  const ReserveDetailPage({
    super.key,
    required this.reserveId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Obtener datos reales de la API
    final reserve = _getMockReserve();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/reserves'),
        ),
        title: const Text(
          'Detalle de Reserva',
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
      body: CustomScrollView(
        slivers: [
          // SliverAppBar con imagen de fondo
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: DesignTokens.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      DesignTokens.primaryColor,
                      DesignTokens.primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Placeholder para imagen de fondo
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: DesignTokens.primaryColor.withValues(alpha: 0.3),
                      ),
                      child: const Icon(
                        Icons.forest,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    // Overlay con información
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(DesignTokens.spacingLg),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reserve.nombre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingSm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descripción
                  _buildSection(
                    context,
                    title: 'Descripción',
                    icon: Icons.info_outline,
                    child: Text(
                      reserve.descripcion ?? 'Sin descripción disponible',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Información de contacto
                  _buildSection(
                    context,
                    title: 'Información de Contacto',
                    icon: Icons.contact_phone,
                    child: Column(
                      children: [
                        _buildContactItem(
                          context,
                          icon: Icons.phone,
                          label: 'Teléfono',
                          value: reserve.telefono ?? 'No disponible',
                        ),
                        const SizedBox(height: DesignTokens.spacingMd),
                        _buildContactItem(
                          context,
                          icon: Icons.email,
                          label: 'Email',
                          value: reserve.emailContacto ?? 'No disponible',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Ubicación y horarios
                  _buildSection(
                    context,
                    title: 'Ubicación y Horarios',
                    icon: Icons.location_on,
                    child: Column(
                      children: [
                        _buildContactItem(
                          context,
                          icon: Icons.location_on,
                          label: 'Dirección',
                          value: reserve.direccion ?? 'No disponible',
                        ),
                        const SizedBox(height: DesignTokens.spacingMd),
                        _buildContactItem(
                          context,
                          icon: Icons.access_time,
                          label: 'Horario',
                          value: reserve.horario ?? 'No disponible',
                        ),
                        const SizedBox(height: DesignTokens.spacingMd),
                        _buildContactItem(
                          context,
                          icon: Icons.map,
                          label: 'Provincia',
                          value: reserve.provincia ?? 'No disponible',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Mapa (placeholder)
                  _buildSection(
                    context,
                    title: 'Ubicación en el Mapa',
                    icon: Icons.map,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: DesignTokens.spacingSm),
                          Text(
                            'Mapa próximamente',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingSm),
                          Text(
                            'Coordenadas: ${reserve.lat}, ${reserve.lng}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Servicios disponibles
                  _buildSection(
                    context,
                    title: 'Servicios Disponibles',
                    icon: Icons.list_alt,
                    child: Column(
                      children: [
                        _buildServiceItem(context, 'Guías certificados', Icons.person),
                        _buildServiceItem(context, 'Senderos marcados', Icons.directions_walk),
                        _buildServiceItem(context, 'Observación de aves', Icons.flutter_dash),
                        _buildServiceItem(context, 'Área de descanso', Icons.beach_access),
                        _buildServiceItem(context, 'Estacionamiento', Icons.local_parking),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implementar compartir
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función de compartir próximamente'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Compartir'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: DesignTokens.primaryColor,
                            side: BorderSide(color: DesignTokens.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingLg),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingMd),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implementar favoritos
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Agregado a favoritos'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Favorito'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingLg),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingLg),
                  
                  // Botón de reservar
                  SizedBox(
                    width: double.infinity,
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
                      label: const Text('Reservar Visita'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignTokens.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingLg),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: DesignTokens.primaryColor,
              size: 24,
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: DesignTokens.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        child,
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: DesignTokens.primaryColor,
          size: 20,
        ),
        const SizedBox(width: DesignTokens.spacingSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(BuildContext context, String service, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Text(
            service,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Reserve _getMockReserve() {
    // Simular obtener datos de la API basado en reserveId
    return Reserve(
      reserveId: reserveId,
      nombre: 'Reserva Natural Indio Maíz',
      descripcion: 'Una de las reservas más grandes de Nicaragua, hogar de cientos de especies de aves y vida silvestre. Esta reserva natural ofrece una experiencia única para los amantes de la naturaleza, con senderos bien marcados, guías certificados y la oportunidad de observar aves endémicas y migratorias en su hábitat natural.',
      lat: 10.8231,
      lng: -84.6295,
      direccion: 'Río San Juan, Nicaragua',
      provincia: 'Río San Juan',
      horario: '6:00 AM - 6:00 PM',
      telefono: '+505 8888 8888',
      emailContacto: 'info@indio-maiz.com',
      estado: 'Abierta',
      createdAt: DateTime.now(),
    );
  }
}
