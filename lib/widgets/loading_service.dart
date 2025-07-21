import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class LoadingService {
  static final LoadingService _instance = LoadingService._internal();
  factory LoadingService() => _instance;
  LoadingService._internal();

  OverlayEntry? _overlayEntry;

  void showLoading(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          LoadingIndicator(),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideLoading() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
