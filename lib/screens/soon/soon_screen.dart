import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class SoonScreen extends StatelessWidget {
  const SoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: StyleColor.turquoise),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 44.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                width: double.infinity,
                decoration: BoxDecoration(color: StyleColor.turquoise),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 10,
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                            color: StyleColor.orange,
                            borderRadius: BorderRadius.circular(32.0)),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 250,
                      width: 250,
                      decoration:BoxDecoration(
                        color:Colors.black,
                        borderRadius: BorderRadius.circular(200)
                      ),
                      child: Image.asset(
                        "assets/comingSoon.gif", // GIF animado
                        height: 200,
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Próximamente",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Estamos trabajando en algo increíble para ti.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
