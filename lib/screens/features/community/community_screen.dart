import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             HeadScreenNotAvatar(
                  title: "Comunidad",
                  onRoute: () {
                    Navigator.pushNamed(context, "/layoutPage");
                  },
                ),
            Center(child: Text("Página de Comunidad")),
          ],
        ),
      ),
    );
  }
}
