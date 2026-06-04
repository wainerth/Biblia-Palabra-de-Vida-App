import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/models/bottom_nav_item.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

List<BottomNavigationBarItem> getBottomNavigationBarItems(
    BuildContext context) {
  final translationProvider = context.read<AppTranslationProvider>();

  return [
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.violetDream,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.bible'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.black,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.bible'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/prayer.png',
            color: StyleColor.greenDark,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.prayer'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.greenDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/prayer.png',
            color: StyleColor.greenDark,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.fitHeight,
          ),
          Text(
            translationProvider.tr('navigation.prayer'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.audiotrack,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.blueDark,
            ),
            Text(
              'Radio',
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.blueDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.blueDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.audiotrack,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.blueDark,
            ),
            Text(
              'Radio',
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.blueDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Image.asset(
              'assets/heat.png',
              color: StyleColor.redDark,
              width: StylesApp(context).sizeIconBottomBar,
              fit: BoxFit.cover,
            ),
            Text(
              translationProvider.tr('navigation.offerings'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.redDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Image.asset(
              'assets/heat.png',
              color: StyleColor.redDark,
              width: StylesApp(context).sizeIconBottomBar,
              fit: BoxFit.cover,
            ),
            Text(
              translationProvider.tr('navigation.offerings'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.settings,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.grayMedium,
          ),
          Text(
            translationProvider.tr('navigation.settings'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.grayMedium,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.grayMedium,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.settings,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.grayMedium,
          ),
          Text(
            translationProvider.tr('navigation.settings'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.grayMedium,
                ),
          ),
        ],
      ),
      label: '',
    ),
  ];
}

List<BottomNavigationBarItem> getItemsBarBible(BuildContext context) {
  final translationProvider = context.read<AppTranslationProvider>();

  return [
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.violetDream,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.bible'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.black,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.bible'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/prayer.png',
            color: StyleColor.greenDark,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.prayer'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.greenDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/prayer.png',
            color: StyleColor.greenDark,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.fitHeight,
          ),
          Text(
            translationProvider.tr('navigation.prayer'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.audiotrack,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.blueDark,
            ),
            Text(
              'Radio',
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.blueDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.blueDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.audiotrack,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.blueDark,
            ),
            Text(
              'Radio',
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.blueDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Image.asset(
              'assets/heat.png',
              color: StyleColor.redDark,
              width: StylesApp(context).sizeIconBottomBar,
              fit: BoxFit.cover,
            ),
            Text(
              translationProvider.tr('navigation.offerings'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.redDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Image.asset(
              'assets/heat.png',
              color: StyleColor.redDark,
              width: StylesApp(context).sizeIconBottomBar,
              fit: BoxFit.cover,
            ),
            Text(
              translationProvider.tr('navigation.offerings'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.settings,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.grayMedium,
          ),
          Text(
            translationProvider.tr('navigation.settings'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.grayMedium,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.grayMedium,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.settings,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.grayMedium,
          ),
          Text(
            translationProvider.tr('navigation.settings'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.grayMedium,
                ),
          ),
        ],
      ),
      label: '',
    ),
  ];
}

List<BottomNavigationBarItem> getItemsBarSecond(BuildContext context) {
  final translationProvider = context.read<AppTranslationProvider>();

  return [
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.violetDream,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.directions_walk_outlined,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.black,
          ),
          Text(
            translationProvider.tr('navigation.adventures'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.black,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.directions_walk_outlined,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.black,
          ),
          Text(
            translationProvider.tr('navigation.adventures'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.area_chart_sharp,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.greenDark,
          ),
          Text(
            translationProvider.tr('navigation.ranking'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.greenDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.area_chart_sharp,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.greenDark,
          ),
          Text(
            translationProvider.tr('navigation.ranking'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.question_mark_outlined,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.blueDark,
          ),
          Text(
            translationProvider.tr('navigation.doubts'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.blueDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.question_mark_outlined,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.blueDark,
          ),
          Text(
            translationProvider.tr('navigation.doubts'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.blueDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.language,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.redDark,
            ),
            Text(
              translationProvider.tr('navigation.online_challenge'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.redDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.language,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.redDark,
            ),
            Text(
              translationProvider.tr('navigation.online_challenge'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.grayMedium,
            ),
            Text(
              translationProvider.tr('navigation.news'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.grayMedium,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.grayMedium,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.grayMedium,
            ),
            Text(
              translationProvider.tr('navigation.news'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.grayMedium,
                  ),
            ),
          ],
        ),
        label: '',
      ),
  ];
}

final List<BottomNavItem> items = [
  BottomNavItem(
    title: "Inicio",
    icon: Icons.home_outlined,
    page: WorkspaceScreen(),
  ),
  BottomNavItem(
      title: "Aventuras",
      icon: Icons.directions_walk_outlined,
      page: AventureScreen()),
  BottomNavItem(
    title: "Ranking",
    icon: Icons.area_chart_sharp,
    page: RankingScreen(),
  ),
  BottomNavItem(
    title: "Dudas",
    icon: Icons.question_mark_outlined,
    page: DoubtScreen(),
  ),
  if (ApiConfig.development)
    BottomNavItem(
        title: "Reto online",
        icon: Icons.language,
        page: ApiConfig.development ? OnlineChallengeScreen() : SoonScreen()),
  if (ApiConfig.development)
    BottomNavItem(
        title: "Novedad",
        icon: Icons.notifications_none_rounded,
        page: ApiConfig.development ? NewsScreen() : SoonScreen() // ,
        )
];

List<BottomNavigationBarItem> getItemsMap(BuildContext context) {
  final translationProvider = context.read<AppTranslationProvider>();

  return [
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.violetDream,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.directions_walk_outlined,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.black,
          ),
          Text(
            translationProvider.tr('navigation.adventures'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.black,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.directions_walk_outlined,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.black,
          ),
          Text(
            translationProvider.tr('navigation.adventures'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.map_rounded,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.greenDark,
          ),
          Text(
            translationProvider.tr('navigation.map'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.greenDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.map_rounded,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.greenDark,
          ),
          Text(
            translationProvider.tr('navigation.map'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.area_chart_sharp,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.blueDark,
          ),
          Text(
            translationProvider.tr('navigation.ranking'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.blueDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.blueDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.area_chart_sharp,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.blueDark,
          ),
          Text(
            translationProvider.tr('navigation.ranking'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.blueDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.question_mark_outlined,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.redDark,
          ),
          Text(
            translationProvider.tr('navigation.doubts'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.redDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.redDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.question_mark_outlined,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.redDark,
          ),
          Text(
            translationProvider.tr('navigation.doubts'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.redDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.language,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.grayMedium,
            ),
            Text(
              translationProvider.tr('navigation.online_challenge'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.grayMedium,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.grayMedium,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.language,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.grayMedium,
            ),
            Text(
              translationProvider.tr('navigation.online_challenge'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.grayMedium,
                  ),
            ),
          ],
        ),
        label: '',
      ),
  ];
}

final List<BottomNavItem> itemsMap = [
  BottomNavItem(
      title: "Inicio", icon: Icons.home_outlined, page: WorkspaceScreen()),
  BottomNavItem(
      title: "Aventuras",
      icon: Icons.directions_walk_outlined,
      page: AventureScreen()),
  BottomNavItem(title: "Mapa", icon: Icons.map_rounded, page: MapScreen()),
  BottomNavItem(
    title: "Dudas",
    icon: Icons.question_mark_outlined,
    page: DoubtScreen(),
  ),
  BottomNavItem(
    title: "Reto online",
    icon: Icons.language,
    page: ApiConfig.development ? OnlineChallengeScreen() : SoonScreen(),
  ),
  BottomNavItem(
    title: "Novedad",
    icon: Icons.notifications_none_rounded,
    page: ApiConfig.development ? NewsScreen() : SoonScreen(),
  )
];

List<BottomNavigationBarItem> getItemsPromises(BuildContext context) {
  final translationProvider = context.read<AppTranslationProvider>();

  return [
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.violetDream,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.bible'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.black,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.bible'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.sync,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.greenDark,
          ),
          Text(
            translationProvider.tr('navigation.promises'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.greenDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.sync,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.greenDark,
          ),
          Text(
            translationProvider.tr('navigation.promises'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.music_note_rounded,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.blueDark,
            ),
            Text(
              'Radio',
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.greenDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.blueDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.music_note_rounded,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.blueDark,
            ),
            Text(
              'Radio',
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.blueDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.language,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.redDark,
            ),
            Text(
              translationProvider.tr('navigation.online_challenge'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.redDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.language,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.redDark,
            ),
            Text(
              translationProvider.tr('navigation.online_challenge'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.grayMedium,
            ),
            Text(
              translationProvider.tr('navigation.news'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.grayMedium,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.grayMedium,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.grayMedium,
            ),
            Text(
              translationProvider.tr('navigation.news'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.grayMedium,
                  ),
            ),
          ],
        ),
        label: '',
      ),
  ];
}

List<BottomNavigationBarItem> getItemsPreach(BuildContext context) {
  final translationProvider = context.read<AppTranslationProvider>();

  return [
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.violetDream,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.bible'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.black,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.bible'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/prayer.png',
            color: StyleColor.greenDark,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.prayer'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.greenDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/prayer.png',
            color: StyleColor.greenDark,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.fitHeight,
          ),
          Text(
            translationProvider.tr('navigation.prayer'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Icon(
              Icons.audiotrack,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.blueDark,
            ),
            Text(
              'Radio',
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.blueDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.blueDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Icon(
              Icons.audiotrack,
              size: StylesApp(context).sizeIconBottomBar,
              color: StyleColor.blueDark,
            ),
            Text(
              'Radio',
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.blueDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    if (ApiConfig.development)
      BottomNavigationBarItem(
        activeIcon: Column(
          children: [
            Image.asset(
              'assets/heat.png',
              color: StyleColor.redDark,
              width: StylesApp(context).sizeIconBottomBar,
              fit: BoxFit.cover,
            ),
            Text(
              translationProvider.tr('navigation.offerings'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: StyleColor.redDark,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        icon: Column(
          children: [
            Image.asset(
              'assets/heat.png',
              color: StyleColor.redDark,
              width: StylesApp(context).sizeIconBottomBar,
              fit: BoxFit.cover,
            ),
            Text(
              translationProvider.tr('navigation.offerings'),
              style: StylesApp(context).textStyleBody10.copyWith(
                    color: StyleColor.redDark,
                  ),
            ),
          ],
        ),
        label: '',
      ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Icon(
            Icons.settings,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.grayMedium,
          ),
          Text(
            translationProvider.tr('navigation.settings'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.grayMedium,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.grayMedium,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Icon(
            Icons.settings,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.grayMedium,
          ),
          Text(
            translationProvider.tr('navigation.settings'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.grayMedium,
                ),
          ),
        ],
      ),
      label: '',
    ),
  ];
}

List<BottomNavigationBarItem> getItemsLibrary(BuildContext context) {
  final translationProvider = context.read<AppTranslationProvider>();

  return [
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.violetDream,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          Image.asset(
            'assets/home.png',
            color: StyleColor.violetDream,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.home'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.violetDream,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          SvgPicture.asset(
            'assets/Shop.svg',
            colorFilter:
                ColorFilter.mode(StyleColor.lavenderMist, BlendMode.srcIn),
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.library'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.black,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          SvgPicture.asset(
            'assets/book.png',
            color: StyleColor.black,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.library'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.black,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          SvgPicture.asset(
            'assets/audioBooks.svg',
            color: StyleColor.greenDark,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.audiobooks'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.greenDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          SvgPicture.asset(
            'assets/audioBooks.svg',
            color: StyleColor.greenDark,
            width: StylesApp(context).sizeIconBottomBar,
            height: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.fitHeight,
          ),
          Text(
            translationProvider.tr('navigation.audiobooks'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.greenDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          SvgPicture.asset(
            'assets/pdf.svg',
            color: StyleColor.redDark,
            width: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.books'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.redDark,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.redDark,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          SvgPicture.asset(
            'assets/pdf.svg',
            color: StyleColor.redDark,
            width: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.books'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.redDark,
                ),
          ),
        ],
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      activeIcon: Column(
        children: [
          SvgPicture.asset(
            'assets/Bag.svg',
            color: StyleColor.grayMedium,
            width: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Icon(
            Icons.settings,
            size: StylesApp(context).sizeIconBottomBar,
            color: StyleColor.grayMedium,
          ),
          Text(
            translationProvider.tr('navigation.my_purchases'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.grayMedium,
                ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              color: StyleColor.grayMedium,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
      icon: Column(
        children: [
          SvgPicture.asset(
            'assets/Bag.svg',
            color: StyleColor.grayMedium,
            width: StylesApp(context).sizeIconBottomBar,
            fit: BoxFit.cover,
          ),
          Text(
            translationProvider.tr('navigation.my_purchases'),
            style: StylesApp(context).textStyleBody10.copyWith(
                  color: StyleColor.grayMedium,
                ),
          ),
        ],
      ),
      label: '',
    ),
  ];
}
