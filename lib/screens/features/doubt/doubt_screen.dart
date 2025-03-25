import 'package:flutter/material.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class DoubtScreen extends StatelessWidget {
  const DoubtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Column(
          children: [
             HeadScreenNotAvatar(
                  title: "Dudas",
                  onRoute: () {
                    Navigator.pushNamed(context, "/layoutPage");
                  },
                ),
            Center(child: Text("Página de Dudas")),
          ],
        ),
      ),
    );
  }
}