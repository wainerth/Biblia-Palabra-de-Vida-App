// improved_slow_connection_widget.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class BibleSlowConnectionMonitor extends StatefulWidget {
  final Widget child;
  final int warningThreshold; // segundos para mostrar advertencia
  final bool showPersistentWarning; // mostrar siempre o solo en diálogo

  const BibleSlowConnectionMonitor({
    Key? key,
    required this.child,
    this.warningThreshold = 3,
    this.showPersistentWarning = false,
  }) : super(key: key);

  @override
  _BibleSlowConnectionMonitorState createState() =>
      _BibleSlowConnectionMonitorState();
}

class _BibleSlowConnectionMonitorState
    extends State<BibleSlowConnectionMonitor> {
  bool _isChecking = false;
  bool _connectionIsSlow = false;
  Timer? _checkTimer;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _startPeriodicChecks();
  }

  void _startPeriodicChecks() {
    // Verificar cada 30 segundos en segundo plano
    _checkTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _performConnectionCheck(silent: true);
    });
  }

  Future<void> _performConnectionCheck({bool silent = false}) async {
    if (_isChecking) return;

    setState(() => _isChecking = true);

    try {
      // 1. Verificar si hay conexión
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        if (!silent) _showNoConnectionDialog();
        return;
      }

      // 2. Medir velocidad con un recurso pequeño de TU app
      final stopwatch = Stopwatch()..start();

      // Intenta cargar algo pequeño de TU API
      await Future.any([
        // Este es un ejemplo - AJÚSTALO PARA TU APP:
        // Future.delayed(Duration(seconds: widget.warningThreshold)),

        // O mejor: un endpoint pequeño de tu backend
        // http.get(Uri.parse('https://tu-api.com/health-check'))

        // Para empezar, usamos un simple delay
        Future.delayed(Duration(milliseconds: 500)),
      ]);

      stopwatch.stop();

      // 3. Determinar si es lento
      final isSlow =
          stopwatch.elapsedMilliseconds > widget.warningThreshold * 1000;

      if (isSlow && !silent) {
        _showSlowConnectionDialog(stopwatch.elapsedMilliseconds);
      }

      setState(() => _connectionIsSlow = isSlow);
    } catch (e) {
      if (!silent) {
        _showErrorDialog();
      }
    } finally {
      setState(() => _isChecking = false);
    }
  }

  void _showSlowConnectionDialog(int milliseconds) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.signal_wifi_statusbar_connected_no_internet_4,
                color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Conexión Lenta'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tu conexión a internet está respondiendo lentamente.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Tiempo de respuesta: ${(milliseconds / 1000).toStringAsFixed(1)} segundos',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Esto puede afectar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Búsqueda en la Biblia'),
                  Text('• Carga de capítulos'),
                  Text('• Sincronización de notas'),
                  Text('• Descarga de recursos'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performConnectionCheck(); // Volver a verificar
            },
            child: Text('Verificar de nuevo'),
          ),
          if (widget.showPersistentWarning)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Activar modo "siempre visible"
                setState(() => _connectionIsSlow = true);
              },
              child: Text('Mostrar aviso'),
            ),
        ],
      ),
    );
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Sin Conexión'),
          ],
        ),
        content: Text(
          'No hay conexión a internet disponible. '
          'Algunas funciones de la aplicación no estarán disponibles.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error de Conexión'),
        content: Text('No se pudo verificar la conexión a internet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,

          // Indicador flotante (opcional, no intrusivo)
          if (_connectionIsSlow && widget.showPersistentWarning)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: GestureDetector(
                onTap: () =>
                    _showSlowConnectionDialog(widget.warningThreshold * 1000),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.speed, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Lento',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }
}
