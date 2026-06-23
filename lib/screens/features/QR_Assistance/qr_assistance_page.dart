// lib/modules/assistance/pages/qr_assistance_page.dart
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'qr_scanner_page.dart';
import 'assistance_history_page.dart';
import 'medals_page.dart';

class QRAssistancePage extends StatefulWidget {
  const QRAssistancePage({super.key});

  @override
  State<QRAssistancePage> createState() => _QRAssistancePageState();
}

class _QRAssistancePageState extends State<QRAssistancePage> {
  bool _isLoading = false;
  int _currentRacha = 0;
  int _totalAssistances = 0;
  List<MedalModel> _medals = [];
  List<ChurchModel> _affiliatedChurches = [];
  AssistanceRecord? _lastAssistance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadMedals();
  }

  void _loadUserData() {
    // Simular carga de datos - Reemplazar con API real
    _currentRacha = 5;
    _totalAssistances = 23;
    _lastAssistance = AssistanceRecord(
      id: '1',
      churchId: '1',
      churchName: 'Iglesia Principal',
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: DateTime.now().subtract(const Duration(days: 1)),
      method: 'qr',
    );
    _affiliatedChurches = [
      ChurchModel(
        id: '1',
        name: 'Iglesia Principal',
        address: 'Av. Libertador',
        phone: '0414-1234567',
        email: 'info@iglesiaprincipal.com',
        qrCode: 'CHURCH_001',
        isAffiliated: true,
      ),
    ];
  }

  void _loadMedals() {
    _medals = [
      MedalModel(
        id: '1',
        name: 'Primera Asistencia',
        description: 'Registraste tu primera asistencia',
        icon: '🎉',
        color: Colors.amber,
        isAchieved: true,
        achievedDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
      MedalModel(
        id: '2',
        name: 'Racha de 7 días',
        description: '7 asistencias consecutivas',
        icon: '🔥',
        color: Colors.orange,
        isAchieved: _currentRacha >= 7,
      ),
      MedalModel(
        id: '3',
        name: 'Racha de 30 días',
        description: '30 asistencias consecutivas',
        icon: '⭐',
        color: Colors.purple,
        requiredRacha: 30,
      ),
      MedalModel(
        id: '4',
        name: 'Asistencia Perfecta',
        description: 'Asististe a todos los eventos del mes',
        icon: '🏆',
        color: Colors.amber,
      ),
      MedalModel(
        id: '5',
        name: 'Miembro Destacado',
        description: 'Top 10% de asistencias',
        icon: '👑',
        color: Colors.cyan,
      ),
    ];
  }

  Future<void> _scanQR() async {
    // Solicitar permiso de cámara
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      _showSnackbar(
          'Se necesita permiso de cámara para escanear QR', Colors.red);
      return;
    }

    // Navegar al escáner
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerPage()),
    );

    if (result != null) {
      _processQR(result);
    }
  }

  void _processQR(String qrData) async {
    setState(() => _isLoading = true);

    // Simular procesamiento - Reemplazar con API real
    await Future.delayed(const Duration(seconds: 1));

    // Verificar si el QR pertenece a una iglesia
    // Aquí llamarías a tu API para validar el QR

    // Simular resultado
    final church = ChurchModel(
      id: '1',
      name: 'Iglesia Principal',
      address: 'Av. Libertador',
      phone: '0414-1234567',
      email: 'info@iglesiaprincipal.com',
      qrCode: qrData,
    );

    setState(() => _isLoading = false);

    // Verificar afiliación
    final isAffiliated = _affiliatedChurches.any((c) => c.id == church.id);

    if (!isAffiliated) {
      _showAffiliationDialog(church);
      return;
    }

    // Verificar si ya asistió hoy
    final alreadyAttended = _checkIfAlreadyAttendedToday(church.id);
    if (alreadyAttended) {
      _showSnackbar(
          'Ya registraste tu asistencia hoy en esta iglesia', Colors.orange);
      return;
    }

    // Registrar asistencia
    _registerAssistance(church);
  }

  bool _checkIfAlreadyAttendedToday(String churchId) {
    // Simular verificación - Reemplazar con API real
    return false;
  }

  void _registerAssistance(ChurchModel church) async {
    setState(() => _isLoading = true);

    // Simular registro - Reemplazar con API real
    await Future.delayed(const Duration(seconds: 1));

    // Obtener ubicación (opcional)
    // final location = await _getCurrentLocation();

    setState(() {
      _totalAssistances++;
      _currentRacha++;
      _isLoading = false;
    });

    // Mostrar confirmación
    _showSuccessDialog(church);

    // Verificar nuevas medallas
    _checkNewMedals();
  }

  void _checkNewMedals() {
    final newMedals = _medals
        .where((m) =>
            !m.isAchieved &&
            (m.requiredRacha == 0 || _currentRacha >= m.requiredRacha))
        .toList();

    if (newMedals.isNotEmpty) {
      _showMedalDialog(newMedals.first);
    }
  }

  void _showAffiliationDialog(ChurchModel church) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Afiliación requerida'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.church, size: 50, color: StyleColor.turquoise),
            const SizedBox(height: 16),
            Text(
              '¿Deseas afiliarte a ${church.name}?',
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Al afiliarte podrás registrar tu asistencia y recibir beneficios.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _affiliateToChurch(church);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: StyleColor.turquoise,
            ),
            child: const Text('Afiliarme'),
          ),
        ],
      ),
    );
  }

  void _affiliateToChurch(ChurchModel church) async {
    setState(() => _isLoading = true);

    // Simular afiliación - Reemplazar con API real
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _affiliatedChurches.add(church);
      _isLoading = false;
    });

    _showSnackbar('¡Te has afiliado a ${church.name}!', Colors.green);

    // Registrar asistencia después de afiliarse
    _registerAssistance(church);
  }

  void _showSuccessDialog(ChurchModel church) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text(
              '¡Asistencia Registrada!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: StyleColor.turquoise,
              ),
            ),
            const SizedBox(height: 8),
            Text('Has registrado tu asistencia a ${church.name}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    'Racha actual: $_currentRacha días',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showMedalDialog(MedalModel medal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(medal.icon, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              '¡Medalla Desbloqueada!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: medal.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              medal.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              medal.description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Ver medallas'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MedalsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleColor.turquoise,
        title: const Text(
          'Asistencia QR',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AssistanceHistoryPage()),
              );
            },
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Historial',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MedalsPage()),
              );
            },
            icon: const Icon(Icons.emoji_events, color: Colors.white),
            tooltip: 'Medallas',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarjeta de racha y estadísticas
                  _buildStatsCard(),
                  const SizedBox(height: 20),

                  // Botón principal de escaneo
                  _buildScanButton(),
                  const SizedBox(height: 24),

                  // Última asistencia
                  if (_lastAssistance != null) _buildLastAssistance(),
                  const SizedBox(height: 16),

                  // Mis iglesias
                  _buildChurchesSection(),
                  const SizedBox(height: 16),

                  // Medallas recientes
                  _buildMedalsSection(),

                  // if (_affiliatedChurches.isNotEmpty) ...[
                  //   const SizedBox(height: 16),
                  //   // Botón dashboard iglesia (solo para administradores)
                  //   if (_isChurchAdmin()) _buildDashboardButton(),
                  // ],
                ],
              ),
            ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [StyleColor.turquoise, StyleColor.turquoise.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: StyleColor.turquoise.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.local_fire_department,
                value: '$_currentRacha',
                label: 'Racha actual',
                color: Colors.orange,
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                value: '$_totalAssistances',
                label: 'Asistencias',
                color: Colors.white,
              ),
              _buildStatItem(
                icon: Icons.emoji_events,
                value: _medals.where((m) => m.isAchieved).length.toString(),
                label: 'Medallas',
                color: Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _currentRacha / 30,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation(Colors.orange),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Text(
            '${_currentRacha}/30 días para la medalla "Racha de 30 días"',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildScanButton() {
    return InkWell(
      onTap: _scanQR,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: StyleColor.turquoise.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: StyleColor.turquoise.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                size: 60,
                color: StyleColor.turquoise,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Escanear Código QR',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Escanea el QR de tu iglesia o evento',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastAssistance() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Última asistencia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.church, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(_lastAssistance!.churchName),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(_lastAssistance!.formattedDate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChurchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis Iglesias',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._affiliatedChurches.map((church) => ListTile(
              leading: CircleAvatar(
                backgroundColor: StyleColor.turquoise.withOpacity(0.1),
                child: const Icon(Icons.church, color: StyleColor.turquoise),
              ),
              title: Text(church.name),
              subtitle: Text(church.address),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Ver detalles de la iglesia
              },
            )),
        if (_affiliatedChurches.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Aún no estás afiliado a ninguna iglesia'),
            ),
          ),
      ],
    );
  }

  Widget _buildMedalsSection() {
    final recentMedals = _medals.where((m) => m.isAchieved).take(3).toList();

    if (recentMedals.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medallas recientes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recentMedals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final medal = recentMedals[index];
              return Container(
                width: 80,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: medal.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(medal.icon, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 4),
                    Text(
                      medal.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildDashboardButton() {
  //   return ElevatedButton.icon(
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (_) => const ChurchDashboardPage()),
  //       );
  //     },
  //     icon: const Icon(Icons.dashboard),
  //     label: const Text('Dashboard Iglesia'),
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: StyleColor.turquoise,
  //       foregroundColor: Colors.white,
  //       minimumSize: const Size(double.infinity, 50),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //   );
  // }

  bool _isChurchAdmin() {
    // Verificar si el usuario es administrador de alguna iglesia
    return true; // Reemplazar con lógica real
  }
}
