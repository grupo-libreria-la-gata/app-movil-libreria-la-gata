import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/design_tokens.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  String _selectedCategory = 'Todos';
  final List<String> _categories = ['Todos', 'Aves', 'Conservación', 'Técnicas', 'Reservas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          children: [
            Icon(
              Icons.school,
              color: Colors.green,
              size: 24,
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Text(
              'Educación',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.grey),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryFilter(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aprende sobre Aviturismo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'Descubre el fascinante mundo de las aves y la conservación de la naturaleza en Nicaragua',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingLg,
        vertical: DesignTokens.spacingMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categorías',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Container(
                  margin: const EdgeInsets.only(right: DesignTokens.spacingSm),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.green.withValues(alpha: 0.2),
                    checkmarkColor: Colors.green,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.green[800] : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? Colors.green : Colors.grey[300]!,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final filteredContent = _getFilteredContent();
    
    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      itemCount: filteredContent.length,
      itemBuilder: (context, index) {
        final content = filteredContent[index];
        return _buildContentCard(content);
      },
    );
  }

  Widget _buildContentCard(EducationalContent content) {
    return Card(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingLg),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignTokens.borderRadiusLg),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey.withValues(alpha: 0.05),
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
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(content.category),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                    child: Icon(
                      _getCategoryIcon(content.category),
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
                          content.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.category,
                              color: _getCategoryColor(content.category),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              content.category,
                              style: TextStyle(
                                color: _getCategoryColor(content.category),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: DesignTokens.spacingMd),
                            Icon(
                              Icons.access_time,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${content.duration} min',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingSm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(content.type),
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                    ),
                    child: Text(
                      content.type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              Text(
                content.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${content.rating}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMd),
                  Icon(
                    Icons.people,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${content.students} estudiantes',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingLg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showContentDetails(content),
                  icon: Icon(_getTypeIcon(content.type)),
                  label: Text('Ver ${content.type}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getCategoryColor(content.category),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Aves':
        return Colors.blue;
      case 'Conservación':
        return Colors.green;
      case 'Técnicas':
        return Colors.orange;
      case 'Reservas':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Aves':
        return Icons.flutter_dash;
      case 'Conservación':
        return Icons.eco;
      case 'Técnicas':
        return Icons.camera_alt;
      case 'Reservas':
        return Icons.park;
      default:
        return Icons.school;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Artículo':
        return Colors.blue;
      case 'Video':
        return Colors.red;
      case 'Quiz':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Artículo':
        return Icons.article;
      case 'Video':
        return Icons.play_circle;
      case 'Quiz':
        return Icons.quiz;
      default:
        return Icons.school;
    }
  }

  List<EducationalContent> _getFilteredContent() {
    final allContent = _getMockContent();
    if (_selectedCategory == 'Todos') {
      return allContent;
    }
    return allContent.where((content) => content.category == _selectedCategory).toList();
  }

  List<EducationalContent> _getMockContent() {
    return [
      EducationalContent(
        title: 'Introducción al Aviturismo en Nicaragua',
        description: 'Descubre las mejores prácticas para observar aves en Nicaragua, incluyendo técnicas de identificación y equipamiento básico necesario.',
        category: 'Aves',
        type: 'Artículo',
        duration: 15,
        rating: 4.8,
        students: 1250,
      ),
      EducationalContent(
        title: 'Identificación de Aves Endémicas',
        description: 'Aprende a identificar las especies endémicas de Nicaragua y su importancia en la conservación de la biodiversidad local.',
        category: 'Aves',
        type: 'Video',
        duration: 25,
        rating: 4.9,
        students: 890,
      ),
      EducationalContent(
        title: 'Técnicas de Fotografía de Aves',
        description: 'Masterclass sobre técnicas avanzadas de fotografía para capturar imágenes espectaculares de aves en su hábitat natural.',
        category: 'Técnicas',
        type: 'Video',
        duration: 45,
        rating: 4.7,
        students: 567,
      ),
      EducationalContent(
        title: 'Conservación de Hábitats Naturales',
        description: 'Conoce las amenazas que enfrentan las aves y sus hábitats, y cómo puedes contribuir a su conservación.',
        category: 'Conservación',
        type: 'Artículo',
        duration: 20,
        rating: 4.6,
        students: 432,
      ),
      EducationalContent(
        title: 'Quiz: Aves de Nicaragua',
        description: 'Pon a prueba tus conocimientos sobre las aves más comunes de Nicaragua con este divertido quiz interactivo.',
        category: 'Aves',
        type: 'Quiz',
        duration: 10,
        rating: 4.5,
        students: 2100,
      ),
      EducationalContent(
        title: 'Reservas Naturales de Nicaragua',
        description: 'Explora las principales reservas naturales del país y las especies que puedes encontrar en cada una.',
        category: 'Reservas',
        type: 'Artículo',
        duration: 18,
        rating: 4.4,
        students: 678,
      ),
      EducationalContent(
        title: 'Técnicas de Observación Silenciosa',
        description: 'Aprende técnicas para acercarte a las aves sin perturbarlas y maximizar tus oportunidades de observación.',
        category: 'Técnicas',
        type: 'Video',
        duration: 30,
        rating: 4.8,
        students: 345,
      ),
      EducationalContent(
        title: 'Conservación de Especies Migratorias',
        description: 'Descubre la importancia de proteger las rutas migratorias y cómo las aves migratorias conectan ecosistemas.',
        category: 'Conservación',
        type: 'Artículo',
        duration: 22,
        rating: 4.3,
        students: 234,
      ),
    ];
  }

  void _showContentDetails(EducationalContent content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getCategoryIcon(content.category),
              color: _getCategoryColor(content.category),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: Text(
                content.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.description,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                const SizedBox(width: 4),
                Text('${content.duration} minutos'),
                const SizedBox(width: DesignTokens.spacingLg),
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${content.rating}'),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              '${content.students} estudiantes han completado este contenido',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showComingSoonDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getCategoryColor(content.category),
              foregroundColor: Colors.white,
            ),
            child: Text('Comenzar ${content.type}'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: DesignTokens.spacingSm),
            Text('Próximamente'),
          ],
        ),
        content: const Text(
          'Esta funcionalidad estará disponible próximamente. ¡Mantente atento a las actualizaciones!',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}

class EducationalContent {
  final String title;
  final String description;
  final String category;
  final String type;
  final int duration;
  final double rating;
  final int students;

  EducationalContent({
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.duration,
    required this.rating,
    required this.students,
  });
}
