// search_router_screen.dart
import 'package:biblia_palabra_de_vida_app/screens/features/bible/search_bible_screen.dart';
import 'package:flutter/material.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';

class SearchRouterScreen extends StatefulWidget {
  final VersionModel currentVersion;
  final BookModel currentBook;
  final ChapterModel currentChapter;
  final Function(InputDataSearchModel)? onResult;

  const SearchRouterScreen({
    super.key,
    required this.currentVersion,
    required this.currentBook,
    required this.currentChapter,
    this.onResult,
  });

  @override
  _SearchRouterScreenState createState() => _SearchRouterScreenState();
}

class _SearchRouterScreenState extends State<SearchRouterScreen> {
  // Estado para manejar el teclado
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el teclado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupKeyboardListener();
    });
  }

  void _setupKeyboardListener() {
    // Verificar si el teclado está visible
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Puedes agregar un listener si es necesario
  }

  @override
  Widget build(BuildContext context) {
    // Aislar completamente el MediaQuery para esta pantalla
    final originalMediaQuery = MediaQuery.of(context);

    return MediaQuery(
      // 🔥 CLAVE: Congelar el MediaQuery para evitar propagación
      data: originalMediaQuery.copyWith(
        viewInsets: EdgeInsets.zero, // Ignorar teclado
        padding: originalMediaQuery.padding,
      ),
      child: WillPopScope(
        onWillPop: () async {
          // Cerrar teclado antes de salir
          FocusScope.of(context).unfocus();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Fondo semitransparente que captura taps
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (!_keyboardVisible) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              // Contenido centrado
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Evitar que taps en el contenido cierren la pantalla
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 900,
                      maxHeight: MediaQuery.of(context).size.height * 0.9,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: FocusScope(
                      // 🔥 Aislar el FocusScope
                      node: FocusScopeNode(),
                      child:Container()
                      //  SearchBibleScreen(
                      //   currentVersion: widget.currentVersion,
                      //   currentBook: widget.currentBook,
                      //   currentChapter: widget.currentChapter,
                      //   onResult: (result) {
                      //     Navigator.pop(context, result);
                      //   },
                      // ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
