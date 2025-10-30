import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../config/app_config.dart';
import '../../../core/design/design_tokens.dart';

class ConnectionTestWidget extends StatefulWidget {
  const ConnectionTestWidget({super.key});

  @override
  State<ConnectionTestWidget> createState() => _ConnectionTestWidgetState();
}

class _ConnectionTestWidgetState extends State<ConnectionTestWidget> {
  bool _isTesting = false;
  String _testResult = '';
  String _currentUrl = AppConfig.baseUrl;

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = 'Probando conexión...';
    });

    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.receiveTimeout = const Duration(seconds: 10);

      print('🔍 [DEBUG] ConnectionTest: Probando ${_currentUrl}/api/Clientes');
      
      final response = await dio.get('$_currentUrl/api/Clientes');
      
      setState(() {
        _testResult = '✅ Conexión exitosa!\n'
            'Status: ${response.statusCode}\n'
            'URL: $_currentUrl\n'
            'Datos recibidos: ${response.data is List ? (response.data as List).length : 'N/A'} elementos';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ Error de conexión:\n$e\n\n'
            'URL probada: $_currentUrl\n\n'
            'Posibles soluciones:\n'
            '1. Verifica que el servidor esté ejecutándose\n'
            '2. Cambia la IP en app_config.dart\n'
            '3. Para emulador Android usa: 10.0.2.2:5044\n'
            '4. Para dispositivo físico usa tu IP local';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wifi_find,
                  color: DesignTokens.primaryColor,
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                const Text(
                  'Prueba de Conexión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              'URL actual: $_currentUrl',
              style: const TextStyle(
                fontSize: 14,
                color: DesignTokens.textSecondaryColor,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isTesting ? null : _testConnection,
                icon: _isTesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(_isTesting ? 'Probando...' : 'Probar Conexión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            if (_testResult.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingMd),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                decoration: BoxDecoration(
                  color: _testResult.contains('✅')
                      ? DesignTokens.successColor.withValues(alpha: 0.1)
                      : DesignTokens.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
                  border: Border.all(
                    color: _testResult.contains('✅')
                        ? DesignTokens.successColor
                        : DesignTokens.errorColor,
                  ),
                ),
                child: Text(
                  _testResult,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: _testResult.contains('✅')
                        ? DesignTokens.successColor
                        : DesignTokens.errorColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
