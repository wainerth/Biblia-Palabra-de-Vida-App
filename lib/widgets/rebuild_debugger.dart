import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';

class RebuildDebugger extends StatelessWidget {
  final String name;

  const RebuildDebugger({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('🔄 $name REBUILT - ${DateTime.now().millisecondsSinceEpoch}');
    }
    return SizedBox.shrink();
  }
}

// Úsalo en tu build:
