import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomTabBarViewScrollPhysics extends ScrollPhysics {
  const CustomTabBarViewScrollPhysics({super.parent});

  @override
  CustomTabBarViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomTabBarViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.1, // Reduce la masa para mayor velocidad
        stiffness: 300.0,
        ratio: 1.1,
      );
}
