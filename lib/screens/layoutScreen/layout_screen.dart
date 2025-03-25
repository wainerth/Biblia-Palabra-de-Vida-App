import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushNamed(context, '/layoutPage');
      }
    });
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
      body: SafeArea(
        child: items[_selectedIndex].page,
      ),
      bottomNavigationBar: CustomBottomNavigationBarWidget(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Color(0XFF7D7878),
        selectedItemColor: Color(0XFF12CBC4),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: StylesApp(context).textStyleBody10,
        unselectedLabelStyle: StylesApp(context).textStyleBody10,
        items: items
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(
                    item.icon,
                    size: StylesApp(context).sizeIconBottomBar,
                  ),
                  label: item.title,
                ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
