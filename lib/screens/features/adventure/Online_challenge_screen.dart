import 'package:biblia_palabra_de_vida_app/screens/library/book_detail_screen.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class OnlineChallengeScreen extends StatefulWidget {
  const OnlineChallengeScreen({super.key});

  @override
  State<OnlineChallengeScreen> createState() => _OnlineChallengeScreenState();
}

class _OnlineChallengeScreenState extends State<OnlineChallengeScreen> {
  int _selectedCategory = 0;
  final List<String> categories = ['Todos', 'Diarios', 'Semanal', 'Grupales', 'Individuales'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
            foregroundColor: WidgetStatePropertyAll(StyleColor.white),
          ),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(Icons.arrow_back, size: 30),
        ),
        title: Text("Retos Bíblicos"),
        titleTextStyle: StylesApp(context)
            .textStyleBody20
            .copyWith(color: StyleColor.white),
        backgroundColor: StyleColor.turquoise,
      ),
      body: Column(
        children: [
          // Selector de categorías
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: _selectedCategory == index,
                    selectedColor: StyleColor.turquoise,
                    labelStyle: TextStyle(
                      color: _selectedCategory == index 
                          ? StyleColor.white 
                          : StyleColor.grayDark,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Reto: Versículo del día
                ChallengeCard(
                  title: "Versículo del Día",
                  description: "Memoriza y comparte el versículo diario",
                  icon: Icons.lightbulb_outline,
                  color: StyleColor.orange,
                  participants: 254,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DailyVerseChallenge()
                    ));
                  },
                ),
                
                // Reto: Serie de lectura
                ChallengeCard(
                  title: "Leer los Evangelios en 30 días",
                  description: "Completa la lectura de Mateo, Marcos, Lucas y Juan",
                  icon: Icons.book,
                  color: StyleColor.greenLight,
                  participants: 189,
                  progress: 65,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ReadingChallenge()
                    ));
                  },
                ),
                
                // Reto: Quiz bíblico
                ChallengeCard(
                  title: "Quiz de Personajes Bíblicos",
                  description: "Pon a prueba tu conocimiento de personajes",
                  icon: Icons.quiz,
                  color: StyleColor.blueMedium,
                  participants: 312,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => QuizChallenge()
                    ));
                  },
                ),
                
                // Reto: Grupo de estudio
                ChallengeCard(
                  title: "Estudio de Romanos en Grupo",
                  description: "Únete a un grupo para estudiar esta epístola",
                  icon: Icons.group,
                  color: StyleColor.electricViolet,
                  participants: 45,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => GroupStudyChallenge()
                    ));
                  },
                ),
                
                // Reto: Oración comunitaria
                ChallengeCard(
                  title: "Cadena de Oración 24/7",
                  description: "Participa en nuestra cadena de oración continua",
                  icon: Icons.access_time,
                  color: StyleColor.yellowLight,
                  participants: 127,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PrayerChainChallenge()
                    ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  ReadingChallenge() {}
  
  GroupStudyChallenge() {}
  
  PrayerChainChallenge() {}
  
  QuizChallenge() {}
}

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int participants;
  final int? progress;
  final VoidCallback onPressed;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.participants,
    this.progress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: StylesApp(context).textStyleBody16.copyWith(
                            fontWeight: FontWeight.bold,
                            color: StyleColor.black,
                          ),
                        ),
                        Text(
                          description,
                          style: StylesApp(context).textStyleBody14.copyWith(
                            color: StyleColor.grayDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Barra de progreso (si aplica)
              if (progress != null) ...[
                LinearProgressIndicator(
                  value: progress! / 100,
                  backgroundColor: StyleColor.grayMedium,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                SizedBox(height: 8),
                Text(
                  "$progress% completado",
                  style: StylesApp(context).textStyleBody12.copyWith(
                    color: StyleColor.grayDark,
                  ),
                ),
                SizedBox(height: 8),
              ],
              
              // Participantes
              Row(
                children: [
                  Icon(Icons.people_outline, size: 16, color: StyleColor.grayDark),
                  SizedBox(width: 4),
                  Text(
                    "2 participantes",
                    style: StylesApp(context).textStyleBody12.copyWith(
                      color: StyleColor.grayDark,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Unirse",
                    style: StylesApp(context).textStyleBody14.copyWith(
                      color: StyleColor.turquoise,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Ejemplo de pantalla de reto específico
class DailyVerseChallenge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Versículo del Día"),
        backgroundColor: StyleColor.turquoise,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Juan 3:16",
              style: StylesApp(context).textStyleBody20.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Porque de tal manera amó Dios al mundo, que ha dado a su Hijo unigénito, "
              "para que todo aquel que en él cree, no se pierda, mas tenga vida eterna.",
              textAlign: TextAlign.center,
              style: StylesApp(context).textStyleBody16,
            ),
            SizedBox(height: 30),
            IconTextButton(
              text: "Marcar como Completado",
              onPressed: () {
                // Lógica para marcar como completado
              },
              backgroundColor: StyleColor.orange,
            ),
          ],
        ),
      ),
    );
  }
}