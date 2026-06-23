// lib/modules/assistance/pages/medals_page.dart
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';


class MedalsPage extends StatefulWidget {
  const MedalsPage({super.key});

  @override
  State<MedalsPage> createState() => _MedalsPageState();
}

class _MedalsPageState extends State<MedalsPage> {
  List<MedalModel> _medals = [];

  @override
  void initState() {
    super.initState();
    _loadMedals();
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
        isAchieved: false,
        requiredRacha: 7,
      ),
      MedalModel(
        id: '3',
        name: 'Racha de 30 días',
        description: '30 asistencias consecutivas',
        icon: '⭐',
        color: Colors.purple,
        isAchieved: false,
        requiredRacha: 30,
      ),
      MedalModel(
        id: '4',
        name: 'Asistencia Perfecta',
        description: 'Asististe a todos los eventos del mes',
        icon: '🏆',
        color: Colors.amber,
        isAchieved: false,
      ),
      MedalModel(
        id: '5',
        name: 'Miembro Destacado',
        description: 'Top 10% de asistencias',
        icon: '👑',
        color: Colors.cyan,
        isAchieved: true,
        achievedDate: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final achievedCount = _medals.where((m) => m.isAchieved).length;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleColor.turquoise,
        title: const Text(
          'Mis Medallas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progreso
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [StyleColor.turquoise, StyleColor.turquoise.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Colección de Medallas',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '$achievedCount/${_medals.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: achievedCount / _medals.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
          
          // Lista de medallas
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _medals.length,
              itemBuilder: (context, index) {
                final medal = _medals[index];
                return _buildMedalCard(medal);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedalCard(MedalModel medal) {
    return Container(
      decoration: BoxDecoration(
        color: medal.isAchieved ? medal.color.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: medal.isAchieved 
            ? Border.all(color: medal.color, width: 2)
            : Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: medal.isAchieved ? 1.0 : 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(medal.icon, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text(
                  medal.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: medal.isAchieved ? medal.color : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    medal.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: medal.isAchieved ? Colors.grey.shade700 : Colors.grey.shade500,
                    ),
                  ),
                ),
                if (medal.isAchieved && medal.achievedDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Obtenida: ${medal.achievedDate!.day}/${medal.achievedDate!.month}/${medal.achievedDate!.year}',
                    style: const TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ],
              ],
            ),
          ),
          if (!medal.isAchieved)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Icon(Icons.lock, size: 40, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}