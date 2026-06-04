import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/bottom_navigation_items.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class LayoutLibrary extends StatefulWidget {
  const LayoutLibrary({super.key});

  @override
  State<LayoutLibrary> createState() => _LayoutLibraryState();
}

class _LayoutLibraryState extends State<LayoutLibrary> {
  int _selectedIndex = 1;
  final List<Widget> _screens = [
    WorkspaceScreen(),
    LibraryScreen(),
    AudioBookScreen(),
    PdfBookScreen(),
    CartScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: CustomBottomNavigationBarWidget(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            selectedItemColor: const Color.fromARGB(255, 79, 75, 82),
            unselectedItemColor: Colors.white,
            selectedLabelStyle: StylesApp(context).textStyleBody10,
            unselectedLabelStyle: StylesApp(context).textStyleBody10,
            items: getItemsLibrary(context),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped));
  }

  /// método para moverse dentro de buttonNavigator
  void _onItemTapped(int value) {
    if (value == 0) {
      Navigator.popAndPushNamed(
        context,
        '/layoutPage',
        arguments: {'selectedIndex': value},
      );
      return;
    }
    setState(() {
      _selectedIndex = value;
    });

  }
}
