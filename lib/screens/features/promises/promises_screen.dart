import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class PromisesScreen extends StatefulWidget {
  const PromisesScreen({super.key});

  @override
  State<PromisesScreen> createState() => _PromisesScreenState();
}

class _PromisesScreenState extends State<PromisesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Text('Pantalla de Promesas'),
          ),
        ),
      ),
    );
  }
}
