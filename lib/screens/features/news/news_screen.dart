import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Column(
          children: [
             HeadScreenNotAvatar(
                  title: "Novedades",
                  onRoute: () {
                    Navigator.pushNamed(context, "/layoutPage");
                  },
                ),
            Center(child: Text("Página de Novedades")),
          ],
        ),
      ),
    );

  }
}