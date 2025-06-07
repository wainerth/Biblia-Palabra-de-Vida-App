
import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class modalTextFormatSizeWidget extends StatefulWidget {
  const modalTextFormatSizeWidget({
    super.key,
  });

  @override
  State<modalTextFormatSizeWidget> createState() =>
      _modalTextFormatSizeWidgetState();
}

class _modalTextFormatSizeWidgetState extends State<modalTextFormatSizeWidget> {
  ModelData selectedItem = ModelData(label: "Roboto", value: "1");
  double fontSize = 0.5;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            spacing: 10,
            children: [
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CustomDropdownBottomWidget(
            items: [
              ModelData(label: "Roboto", value: "1"),
              ModelData(label: "Erica One", value: "2"),
              ModelData(label: "Aclonica", value: "3"),
              ModelData(label: "All sane", value: "4"),
            ],
            selectedItem: selectedItem,
            onChanged: (ModelData? newValue) {
              setState(() {
                selectedItem = newValue!;
              });
            },
            hintText: "Tipo de fuente",
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  flex: 0,
                  child: Icon(
                    Icons.text_decrease,
                    color: StyleColor.turquoise,
                  )),
              Expanded(
                flex: 1,
                child: Slider(
                    activeColor: Colors.grey,
                    inactiveColor: Colors.grey,
                    thumbColor: StyleColor.orange,
                    value: fontSize,
                    onChanged: (value) {
                      setState(() {
                        fontSize = value;
                      });
                    }),
              ),
              Expanded(
                  flex: 0,
                  child: Icon(
                    Icons.text_increase_rounded,
                    color: StyleColor.turquoise,
                  ))
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}