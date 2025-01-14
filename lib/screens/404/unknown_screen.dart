import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("¡Lo siento, Pantalla no disponible!"),
      ),
    );
  }
}
