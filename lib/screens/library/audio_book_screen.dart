import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class AudioBookScreen extends StatefulWidget {
  const AudioBookScreen({super.key});

  @override
  State<AudioBookScreen> createState() => _AudioBookScreenState();
}

class _AudioBookScreenState extends State<AudioBookScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Center(
          child: Text('Audio Libros'),
        ),
      ),
    );
  }
}
