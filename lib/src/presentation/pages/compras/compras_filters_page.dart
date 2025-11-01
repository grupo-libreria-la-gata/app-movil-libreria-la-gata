import 'package:flutter/material.dart';
import '../../../core/design/design_tokens.dart';

class ComprasFiltersPage extends StatefulWidget {
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final int? proveedorId;

  const ComprasFiltersPage({
    super.key,
    this.fechaInicio,
    this.fechaFin,
    this.proveedorId,
  });

  @override
  State<ComprasFiltersPage> createState() => _ComprasFiltersPageState();
}

class _ComprasFiltersPageState extends State<ComprasFiltersPage> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  int? _proveedorId;

  @override
  void initState() {
    super.initState();
    _fechaInicio = widget.fechaInicio;
    _fechaFin = widget.fechaFin;
    _proveedorId = widget.proveedorId;
  }

  Future<void> _seleccionarFechaInicio() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() {
        _fechaInicio = fecha;
        // Si la fecha fin es anterior a la fecha inicio, limpiar fecha fin
        if (_fechaFin != null && _fechaFin!.isBefore(fecha)) {
          _fechaFin = null;
        }
      });
    }
  }

  Future<void> _seleccionarFechaFin() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaFin ?? _fechaInicio ?? DateTime.now(),
      firstDate: _fechaInicio ?? DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() {
        _fechaFin = fecha;
      });
    }
  }

  void _limpiarFiltros() {
    setState(() {
      _fechaInicio = null;
      _fechaFin = null;
      _proveedorId = null;
    });
  }

  void _aplicarFiltros() {
    Navigator.of(context).pop({
      'fechaInicio': _fechaInicio,
      'fechaFin': _fechaFin,
      'proveedorId': _proveedorId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros de Compras'),
        actions: [
          TextButton(
            onPressed: _limpiarFiltros,
            child: Text('Limpiar', style: TextStyle(color: DesignTokens.surfaceColor)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros por fecha
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filtros por Fecha',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fecha inicio
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Fecha de Inicio'),
                      subtitle: Text(
                        _fechaInicio != null
                            ? '${_fechaInicio!.day}/${_fechaInicio!.month}/${_fechaInicio!.year}'
                            : 'Seleccionar fecha',
                      ),
                      trailing: _fechaInicio != null
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _fechaInicio = null;
                                });
                              },
                            )
                          : null,
                      onTap: _seleccionarFechaInicio,
                    ),

                    const Divider(),

                    // Fecha fin
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Fecha de Fin'),
                      subtitle: Text(
                        _fechaFin != null
                            ? '${_fechaFin!.day}/${_fechaFin!.month}/${_fechaFin!.year}'
                            : 'Seleccionar fecha',
                      ),
                      trailing: _fechaFin != null
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _fechaFin = null;
                                });
                              },
                            )
                          : null,
                      onTap: _seleccionarFechaFin,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filtros por proveedor
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filtros por Proveedor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<int>(
                      initialValue: _proveedorId,
                      decoration: const InputDecoration(
                        labelText: 'Proveedor',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todos los proveedores'),
                        ),
                        // Simulación de proveedores - cargar desde el servicio
                        const DropdownMenuItem(
                          value: 1,
                          child: Text('Proveedor 1'),
                        ),
                        const DropdownMenuItem(
                          value: 2,
                          child: Text('Proveedor 2'),
                        ),
                        const DropdownMenuItem(
                          value: 3,
                          child: Text('Proveedor 3'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _proveedorId = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filtros rápidos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filtros Rápidos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _FiltroRapidoChip(
                          label: 'Hoy',
                          onTap: () {
                            final hoy = DateTime.now();
                            setState(() {
                              _fechaInicio = DateTime(
                                hoy.year,
                                hoy.month,
                                hoy.day,
                              );
                              _fechaFin = DateTime(
                                hoy.year,
                                hoy.month,
                                hoy.day,
                                23,
                                59,
                                59,
                              );
                            });
                          },
                        ),
                        _FiltroRapidoChip(
                          label: 'Esta Semana',
                          onTap: () {
                            final hoy = DateTime.now();
                            final inicioSemana = hoy.subtract(
                              Duration(days: hoy.weekday - 1),
                            );
                            setState(() {
                              _fechaInicio = DateTime(
                                inicioSemana.year,
                                inicioSemana.month,
                                inicioSemana.day,
                              );
                              _fechaFin = DateTime(
                                hoy.year,
                                hoy.month,
                                hoy.day,
                                23,
                                59,
                                59,
                              );
                            });
                          },
                        ),
                        _FiltroRapidoChip(
                          label: 'Este Mes',
                          onTap: () {
                            final hoy = DateTime.now();
                            setState(() {
                              _fechaInicio = DateTime(hoy.year, hoy.month, 1);
                              _fechaFin = DateTime(
                                hoy.year,
                                hoy.month,
                                hoy.day,
                                23,
                                59,
                                59,
                              );
                            });
                          },
                        ),
                        _FiltroRapidoChip(
                          label: 'Últimos 30 días',
                          onTap: () {
                            final hoy = DateTime.now();
                            final hace30Dias = hoy.subtract(
                              const Duration(days: 30),
                            );
                            setState(() {
                              _fechaInicio = DateTime(
                                hace30Dias.year,
                                hace30Dias.month,
                                hace30Dias.day,
                              );
                              _fechaFin = DateTime(
                                hoy.year,
                                hoy.month,
                                hoy.day,
                                23,
                                59,
                                59,
                              );
                            });
                          },
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: DesignTokens.textPrimaryColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _aplicarFiltros,
                child: const Text('Aplicar Filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltroRapidoChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FiltroRapidoChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
