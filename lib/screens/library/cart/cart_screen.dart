import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Center(
          child: Text('Mis compras'),
        ),
      ),
    );
  }
}
