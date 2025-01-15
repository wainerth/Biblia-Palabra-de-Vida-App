import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/bottom_navigation_items.dart';
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
    PrayerScreen(),
    AudioScreen(),
    OfferingsScreen(),
    ContactScreen(),
    ConfigScreen(),
  ];

  void _onItemTapped(int index) {
    if(index.toString() == 1.toString()){
        Navigator.pushNamed(context, '/prayerPage');
        return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: CustomBottomNavigationBarWidget(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            backgroundColor: Color(0XFF7D7878),
            selectedItemColor: Color(0XFF12CBC4),
            unselectedItemColor: Colors.white,
            selectedLabelStyle: StylesApp(context).textStyleBody10,
            unselectedLabelStyle: StylesApp(context).textStyleBody10,
            items: getBottomNavigationBarItems(),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped)

        //  BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   showUnselectedLabels: true,
        //   backgroundColor: Color(0XFF7D7878),
        //   selectedItemColor: Color(0XFF12CBC4),
        //   unselectedItemColor: Colors.white,
        //   selectedLabelStyle: StylesApp(context).textStyleBody10,
        //   unselectedLabelStyle:StylesApp(context).textStyleBody10 ,
        //   items: getBottomNavigationBarItems(),
        //   currentIndex: _selectedIndex,
        //   onTap: _onItemTapped,
        // ),
        );
  }
}
