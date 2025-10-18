import 'package:flutter/material.dart';
import '../../../data/models/compra_model.dart';

class DetalleCompraWidget extends StatelessWidget {
  final CrearDetalleCompraRequest detalle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DetalleCompraWidget({
    Key? key,
    required this.detalle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Producto ID: ${detalle.detalleProductoId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Cantidad: ${detalle.cantidad}'),
                      const SizedBox(width: 16),
                      Text('Precio: \$${detalle.precioUnitario.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Subtotal: \$${detalle.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Eliminar Producto'),
                        content: const Text('¿Está seguro de que desea eliminar este producto?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onDelete();
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
