import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: Center(
            child: Text("Pantalla de juegos"),
          ),
        ),
      ),
    );
  }
}
