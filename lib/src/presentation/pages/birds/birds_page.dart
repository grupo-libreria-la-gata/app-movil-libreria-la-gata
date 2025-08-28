import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/bird.dart';
import '../../../core/design/design_tokens.dart';

/// Página que muestra el catálogo de aves
class BirdsPage extends StatefulWidget {
  const BirdsPage({super.key});

  @override
  State<BirdsPage> createState() => _BirdsPageState();
}

class _BirdsPageState extends State<BirdsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFamily = 'Todas';
  String _selectedStatus = 'Todas';
  List<Bird> _filteredBirds = [];

  // Datos mock de aves
  final List<Bird> _birds = [
    Bird(
      birdId: '1',
      nombreComun: 'Quetzal',
      nombreCientifico: 'Pharomachrus mocinno',
      familia: 'Trogonidae',
      descripcion: 'El quetzal es una de las aves más hermosas de Centroamérica, conocida por su plumaje verde iridiscente y su larga cola.',
      esEndemica: false,
      migratoria: false,
      tags: ['especie emblemática', 'bosque nuboso'],
      createdAt: DateTime.now(),
    ),
    Bird(
      birdId: '2',
      nombreComun: 'Momoto Cejiazul',
      nombreCientifico: 'Eumomota superciliosa',
      familia: 'Momotidae',
      descripcion: 'Ave colorida con una distintiva raya azul sobre el ojo y una cola larga con forma de raqueta.',
      esEndemica: false,
      migratoria: false,
      tags: ['colorida', 'selva'],
      createdAt: DateTime.now(),
    ),
    Bird(
      birdId: '3',
      nombreComun: 'Tucán Pico Iris',
      nombreCientifico: 'Ramphastos sulfuratus',
      familia: 'Ramphastidae',
      descripcion: 'Tucán grande con un pico multicolor característico, común en los bosques tropicales.',
      esEndemica: false,
      migratoria: false,
      tags: ['tucán', 'pico grande'],
      createdAt: DateTime.now(),
    ),
    Bird(
      birdId: '4',
      nombreComun: 'Loro Frentirrojo',
      nombreCientifico: 'Amazona autumnalis',
      familia: 'Psittacidae',
      descripcion: 'Loro de tamaño mediano con frente roja y mejillas azules, muy vocal y social.',
      esEndemica: false,
      migratoria: false,
      tags: ['loro', 'social'],
      createdAt: DateTime.now(),
    ),
    Bird(
      birdId: '5',
      nombreComun: 'Colibrí Esmeralda',
      nombreCientifico: 'Chlorostilbon canivetii',
      familia: 'Trochilidae',
      descripcion: 'Colibrí pequeño con plumaje verde esmeralda brillante, muy activo en busca de néctar.',
      esEndemica: false,
      migratoria: true,
      tags: ['colibrí', 'migratorio'],
      createdAt: DateTime.now(),
    ),
    Bird(
      birdId: '6',
      nombreComun: 'Gavilán Caminero',
      nombreCientifico: 'Buteo magnirostris',
      familia: 'Accipitridae',
      descripcion: 'Gavilán de tamaño mediano que se alimenta principalmente de reptiles y pequeños mamíferos.',
      esEndemica: false,
      migratoria: false,
      tags: ['rapaz', 'cazador'],
      createdAt: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredBirds = _birds;
    _searchController.addListener(_filterBirds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBirds() {
    setState(() {
      final searchTerm = _searchController.text.toLowerCase();
      _filteredBirds = _birds.where((bird) {
                 final matchesSearch = bird.nombreComun.toLowerCase().contains(searchTerm) ||
             (bird.nombreCientifico?.toLowerCase().contains(searchTerm) ?? false) ||
             (bird.descripcion?.toLowerCase().contains(searchTerm) ?? false);
        
                 final matchesFamily = _selectedFamily == 'Todas' || (bird.familia == _selectedFamily);
        
        final matchesStatus = _selectedStatus == 'Todas' ||
            (_selectedStatus == 'Endémica' && bird.esEndemica) ||
            (_selectedStatus == 'Migratoria' && bird.migratoria) ||
            (_selectedStatus == 'Residente' && !bird.esEndemica && !bird.migratoria);
        
        return matchesSearch && matchesFamily && matchesStatus;
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
          'Catálogo de Aves',
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
                    hintText: 'Buscar aves...',
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
                        value: _selectedFamily,
                        decoration: InputDecoration(
                          labelText: 'Familia',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          'Todas',
                                                     ..._birds.map((b) => b.familia ?? '').where((f) => f.isNotEmpty).toSet(),
                        ].map((family) {
                          return DropdownMenuItem(
                            value: family,
                            child: Text(family),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFamily = value!;
                            _filterBirds();
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
                          'Endémica',
                          'Migratoria',
                          'Residente',
                        ].map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                            _filterBirds();
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
                  Icons.flutter_dash,
                  color: DesignTokens.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Text(
                  '${_filteredBirds.length} aves encontradas',
                  style: TextStyle(
                    color: DesignTokens.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de aves
          Expanded(
            child: _filteredBirds.isEmpty
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
                          'No se encontraron aves',
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
                    itemCount: _filteredBirds.length,
                    itemBuilder: (context, index) {
                      final bird = _filteredBirds[index];
                      return _buildBirdCard(context, bird);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirdCard(BuildContext context, Bird bird) {
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
              Colors.blue.withValues(alpha: 0.1),
              Colors.blue.withValues(alpha: 0.05),
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                    child: const Icon(
                      Icons.flutter_dash,
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
                          bird.nombreComun,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bird.nombreCientifico ?? 'Sin nombre científico',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badges de estado
                  Column(
                    children: [
                      if (bird.esEndemica)
                        Container(
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
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (bird.migratoria)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
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
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.spacingMd),
              
              // Descripción
              Text(
                bird.descripcion ?? 'Sin descripción disponible',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: DesignTokens.spacingMd),
              
              // Información adicional
              Row(
                children: [
                  Icon(
                    Icons.category,
                    color: Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                                     Text(
                     bird.familia ?? 'Sin familia',
                     style: TextStyle(
                       color: Colors.grey[600],
                       fontSize: 14,
                     ),
                   ),
                ],
              ),
              
              if (bird.tags.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: bird.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 10,
                      ),
                    ),
                  )).toList(),
                ),
              ],
              
              const SizedBox(height: DesignTokens.spacingLg),
              
              // Botón de acción
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.go('/birds/${bird.birdId}');
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Ver Detalles'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
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
}
