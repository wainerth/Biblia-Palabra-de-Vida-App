import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CardTeachingWidget extends StatefulWidget {
  final TeachingModel data;
  final void Function()? onTap;
  const CardTeachingWidget({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  State<CardTeachingWidget> createState() => _CardTeachingWidgetState();
}
class _CardTeachingWidgetState extends State<CardTeachingWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.sizeOf(context).width,
          child: Column(children: [
            Container(
                width: MediaQuery.sizeOf(context).width,
                constraints: BoxConstraints(minHeight: 150, maxHeight: 150),
                child: Image.network(
                    '${GraphQLConfig.urlServidor}${widget.data.img.urlImg}')
                //Image.asset("assets/ensenanza.jpeg"),
                ),
            SizedBox(
              height: 8.0,
            ),
            Text(widget.data.title)
          ])),
    );
  }
}