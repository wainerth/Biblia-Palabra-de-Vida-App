import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class PdfBookScreen extends StatefulWidget {
  const PdfBookScreen({super.key});

  @override
  State<PdfBookScreen> createState() => _PdfBookScreenState();
}

class _PdfBookScreenState extends State<PdfBookScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Center(child: Text("Lobros en PDF")),
      ),
    );
  }
}
