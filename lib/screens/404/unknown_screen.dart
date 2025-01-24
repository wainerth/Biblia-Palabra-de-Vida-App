import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 100,
            color: Colors.red,
          ),
          SizedBox(height: 20),
          Text(
            "404",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "¡Lo siento, Pantalla no disponible!",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      ),
    );
  }
}
