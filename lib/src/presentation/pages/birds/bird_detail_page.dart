import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/bird.dart';
import '../../../core/design/design_tokens.dart';

/// Página que muestra el detalle completo de una ave
class BirdDetailPage extends StatelessWidget {
  final String birdId;

  const BirdDetailPage({super.key, required this.birdId});

  @override
  Widget build(BuildContext context) {
    final bird = _getMockBird();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/birds'),
        ),
        title: const Text(
          'Detalle de Ave',
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
                      Colors.blue,
                      Colors.blue.withValues(alpha: 0.8),
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
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                      child: const Icon(
                        Icons.flutter_dash,
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
                              bird.nombreComun,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bird.nombreCientifico ?? 'Sin nombre científico',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (bird.esEndemica)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: DesignTokens.spacingSm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                                    ),
                                    child: const Text(
                                      'Endémica',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (bird.migratoria)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: DesignTokens.spacingSm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                                    ),
                                    child: const Text(
                                      'Migratoria',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
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
                    icon: Icons.description,
                    child: Text(
                      bird.descripcion ?? 'Sin descripción disponible',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Información taxonómica
                  _buildSection(
                    context,
                    title: 'Información Taxonómica',
                    icon: Icons.category,
                    child: Column(
                      children: [
                        _buildInfoItem(
                          context,
                          label: 'Familia',
                          value: bird.familia ?? 'Sin información',
                          icon: Icons.family_restroom,
                        ),
                        _buildInfoItem(
                          context,
                          label: 'Nombre Científico',
                          value: bird.nombreCientifico ?? 'Sin información',
                          icon: Icons.science,
                        ),
                        _buildInfoItem(
                          context,
                          label: 'Estado',
                          value: _getStatusText(bird),
                          icon: Icons.info,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Tags
                  if (bird.tags.isNotEmpty)
                    _buildSection(
                      context,
                      title: 'Características',
                      icon: Icons.tag,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: bird.tags.map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingMd,
                            vertical: DesignTokens.spacingSm,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                            border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Distribución (placeholder)
                  _buildSection(
                    context,
                    title: 'Distribución',
                    icon: Icons.map,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: DesignTokens.spacingMd),
                            Text(
                              'Mapa de distribución próximamente',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingXl),
                  
                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('🔊 Sonido próximamente'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.volume_up),
                          label: const Text('Escuchar Canto'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                          ),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingMd),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('📸 Galería de fotos próximamente'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Ver Fotos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                          ),
                        ),
                      ),
                    ],
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
              color: Colors.blue,
              size: 24,
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        child,
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
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
                    color: Colors.grey[600],
                    fontSize: 12,
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
      ),
    );
  }

  String _getStatusText(Bird bird) {
    if (bird.esEndemica) return 'Endémica';
    if (bird.migratoria) return 'Migratoria';
    return 'Residente';
  }

  Bird _getMockBird() {
    // Simular obtención de datos según el ID
    final birds = [
      Bird(
        birdId: '1',
        nombreComun: 'Quetzal',
        nombreCientifico: 'Pharomachrus mocinno',
        familia: 'Trogonidae',
        descripcion: 'El quetzal es una de las aves más hermosas de Centroamérica, conocida por su plumaje verde iridiscente y su larga cola. Esta especie emblemática habita en los bosques nubosos de montaña y es considerada sagrada por las culturas precolombinas. Los machos tienen una cola extraordinariamente larga que puede alcanzar hasta 1 metro de longitud.',
        esEndemica: false,
        migratoria: false,
        tags: ['especie emblemática', 'bosque nuboso', 'plumaje verde', 'cola larga'],
        createdAt: DateTime.now(),
      ),
      Bird(
        birdId: '2',
        nombreComun: 'Momoto Cejiazul',
        nombreCientifico: 'Eumomota superciliosa',
        familia: 'Momotidae',
        descripcion: 'Ave colorida con una distintiva raya azul sobre el ojo y una cola larga con forma de raqueta. Es común en los bosques tropicales y subtropicales, donde se alimenta principalmente de insectos y pequeños reptiles.',
        esEndemica: false,
        migratoria: false,
        tags: ['colorida', 'selva', 'ceja azul', 'cola raqueta'],
        createdAt: DateTime.now(),
      ),
      Bird(
        birdId: '3',
        nombreComun: 'Tucán Pico Iris',
        nombreCientifico: 'Ramphastos sulfuratus',
        familia: 'Ramphastidae',
        descripcion: 'Tucán grande con un pico multicolor característico, común en los bosques tropicales. Se alimenta principalmente de frutas, pero también consume insectos y pequeños vertebrados.',
        esEndemica: false,
        migratoria: false,
        tags: ['tucán', 'pico grande', 'multicolor', 'frutívoros'],
        createdAt: DateTime.now(),
      ),
      Bird(
        birdId: '4',
        nombreComun: 'Loro Frentirrojo',
        nombreCientifico: 'Amazona autumnalis',
        familia: 'Psittacidae',
        descripcion: 'Loro de tamaño mediano con frente roja y mejillas azules, muy vocal y social. Forma bandadas ruidosas y se alimenta de frutas, semillas y flores.',
        esEndemica: false,
        migratoria: false,
        tags: ['loro', 'social', 'frente roja', 'vocal'],
        createdAt: DateTime.now(),
      ),
      Bird(
        birdId: '5',
        nombreComun: 'Colibrí Esmeralda',
        nombreCientifico: 'Chlorostilbon canivetii',
        familia: 'Trochilidae',
        descripcion: 'Colibrí pequeño con plumaje verde esmeralda brillante, muy activo en busca de néctar. Es una especie migratoria que visita Nicaragua durante ciertas épocas del año.',
        esEndemica: false,
        migratoria: true,
        tags: ['colibrí', 'migratorio', 'esmeralda', 'néctar'],
        createdAt: DateTime.now(),
      ),
      Bird(
        birdId: '6',
        nombreComun: 'Gavilán Caminero',
        nombreCientifico: 'Buteo magnirostris',
        familia: 'Accipitridae',
        descripcion: 'Gavilán de tamaño mediano que se alimenta principalmente de reptiles y pequeños mamíferos. Es común en áreas abiertas y bordes de bosque.',
        esEndemica: false,
        migratoria: false,
        tags: ['rapaz', 'cazador', 'áreas abiertas', 'reptiles'],
        createdAt: DateTime.now(),
      ),
    ];

    return birds.firstWhere(
      (bird) => bird.birdId == birdId,
      orElse: () => birds.first,
    );
  }
}
