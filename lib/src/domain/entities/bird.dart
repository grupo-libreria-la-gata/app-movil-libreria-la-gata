import 'package:uuid/uuid.dart';

class Bird {
  final String birdId;
  final String nombreComun;
  final String? nombreCientifico;
  final String? familia;
  final String? descripcion;
  final bool esEndemica;
  final bool migratoria;
  final List<String> tags;
  final DateTime createdAt;

  Bird({
    String? birdId,
    required this.nombreComun,
    this.nombreCientifico,
    this.familia,
    this.descripcion,
    this.esEndemica = false,
    this.migratoria = false,
    this.tags = const [],
    DateTime? createdAt,
  }) : 
    birdId = birdId ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  factory Bird.fromJson(Map<String, dynamic> json) {
    return Bird(
      birdId: json['birdId'],
      nombreComun: json['nombreComun'],
      nombreCientifico: json['nombreCientifico'],
      familia: json['familia'],
      descripcion: json['descripcion'],
      esEndemica: json['esEndemica'] ?? false,
      migratoria: json['migratoria'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birdId': birdId,
      'nombreComun': nombreComun,
      'nombreCientifico': nombreCientifico,
      'familia': familia,
      'descripcion': descripcion,
      'esEndemica': esEndemica,
      'migratoria': migratoria,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Bird copyWith({
    String? nombreComun,
    String? nombreCientifico,
    String? familia,
    String? descripcion,
    bool? esEndemica,
    bool? migratoria,
    List<String>? tags,
  }) {
    return Bird(
      birdId: birdId,
      nombreComun: nombreComun ?? this.nombreComun,
      nombreCientifico: nombreCientifico ?? this.nombreCientifico,
      familia: familia ?? this.familia,
      descripcion: descripcion ?? this.descripcion,
      esEndemica: esEndemica ?? this.esEndemica,
      migratoria: migratoria ?? this.migratoria,
      tags: tags ?? this.tags,
      createdAt: createdAt,
    );
  }
}
