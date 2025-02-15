import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text('Settings Screen'),
            )
          ],
        ),
      ),
    );
  }
}
