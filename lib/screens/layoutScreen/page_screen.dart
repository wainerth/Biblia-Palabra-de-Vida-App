import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/bottom_navigation_items.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key});

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    WorkspaceScreen(),
    BibleScreen(),
    PrayerScreen(),
    AudioScreen(),
    OfferingsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });
    if (index.toString() == 2.toString()) {
      Navigator.pushNamed(context, '/prayerPage');
      return;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Object? args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      setState(() {
        _selectedIndex = (args as Map<String, dynamic>)["selectedIndex"];
      });
    }
  }

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
            items: getBottomNavigationBarItems(context),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped));
  }
}
