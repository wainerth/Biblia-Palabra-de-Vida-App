import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          Flexible(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(3, (index) {
                return Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90.0,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(100), // Ajusta el radio para redondear
                        child: Image.asset('/aventura.png', fit: BoxFit.cover),
                      ),
                    ),
                    Text( textAlign: TextAlign.center, "Aventura")
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
