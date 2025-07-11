import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBarWidget extends StatelessWidget {
  final BottomNavigationBarType type;
  final bool showUnselectedLabels;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBarWidget({
    super.key,
    required this.type,
    required this.showUnselectedLabels,
    required this.backgroundColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
      Container(
        decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 10,
          offset: Offset(0, -2), // Shadow above the widget
          ),
        ],
        ),
        child: BottomNavigationBar(
        elevation: 8.0,
        type: type,
        showUnselectedLabels: showUnselectedLabels,
        backgroundColor: backgroundColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        selectedLabelStyle: selectedLabelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
        ),
      ),
      // Positioned(
      //   top: -40, // Puedes ajustar este valor
      //   right: 10,
      //   child: Visibility(
      //   visible: true,
      //   child: Container(
      //     width: 40,
      //     height: 40,
      //     decoration: BoxDecoration(
      //     color: Colors.transparent,
      //     ),
      //     child: IconButton(
      //     padding: EdgeInsets.all(0),
      //     iconSize: 40,
      //     onPressed: () {},
      //     icon: Stack(
      //       alignment: Alignment.center,
      //       children: [
      //       Icon(
      //         Icons.notifications,
      //         size: 40,
      //         color: StyleColor.redLight,
      //       ),
      //       Positioned(
      //         right: 12,
      //         top: 12,
      //         child: Container(
      //         padding: EdgeInsets.all(0),
      //         decoration: BoxDecoration(
      //           // color: Colors.white,
      //           // shape: BoxShape.circle,
      //         ),
      //         constraints: BoxConstraints(
      //           minWidth: 16,
      //           minHeight: 16,
      //         ),
      //         child: Center(
      //           child: Text(
      //           "2",
      //           style: StylesApp(context)
      //             .textStyleBody10
      //             .copyWith(
      //               // color: StyleColor.redLight,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           textAlign: TextAlign.center,
      //           ),
      //         ),
      //         ),
      //       ),
      //       ],
      //     ),
      //     ),
      //   ),
      //   ),
      // ),
      ],
    );
  }
}
