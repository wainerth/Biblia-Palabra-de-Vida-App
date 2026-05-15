// import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
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
  bool _hasProcessedInitialArguments = false;
  final List<Widget> _screens = [
    WorkspaceScreen(),
    BibleScreen(),
    PrayerScreen(),
    if (GraphQLConfig.development) RadioScreen(),
    if (GraphQLConfig.development) OfferingsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasProcessedInitialArguments) return;
    final Object? args = ModalRoute.of(context)!.settings.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args.containsKey('selectedIndex')) {
      setState(() {
        _hasProcessedInitialArguments = true;
        _selectedIndex = (args as Map<String, dynamic>)["selectedIndex"];
      });
    }
  }

  getItemsBar(int index, BuildContext context) {
    return index.toString() == 2.toString()
        ? getItemsMap(context)
        : getBottomNavigationBarItems(context);
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
