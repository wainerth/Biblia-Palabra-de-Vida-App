import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';

class ProgressControls extends StatelessWidget {
  final double fontSize;
  final double currentValue;
  final double maxValue;
  final ValueChanged<double> onFontSizeChanged;
  final bool isTablet;

  const ProgressControls({
    super.key,
    required this.fontSize,
    required this.currentValue,
    required this.maxValue,
    required this.onFontSizeChanged,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return _buildTabletControls(context);
    }
    return _buildMobileControls(context);
  }

  Widget _buildMobileControls(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 9),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Slider(
                  activeColor: Colors.blueGrey,
                  inactiveColor: Colors.grey,
                  thumbColor: Colors.teal,
                  min: 12.0,
                  max: 20.0,
                  value: fontSize,
                  onChanged: onFontSizeChanged,
                ),
              ),
              Text(
                "Aa",
                style: StylesApp(context)
                    .textStyleBody14
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 278.0),
            child: Column(
              children: [
                Text(
                  "${currentValue.toInt()}/${maxValue.toInt()}",
                  style: StylesApp(context)
                    .textStyleBody14
                    .copyWith(color: Colors.black),
                ),
                LinearProgressIndicator(
                  value: currentValue / maxValue,
                  backgroundColor: Color(0xFFC4C4C4),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0XFFF27728)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletControls(BuildContext context) {
    return Column(
      children: [
       
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: currentValue / maxValue,
                backgroundColor: Color(0xFFC4C4C4),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0XFFF27728)),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Progreso", style: StylesApp(context).textStyleBody14.copyWith(
                    fontSize: 14.0,
                    color:  Colors.grey[600]
                  ),),
                  Text("${currentValue.toInt()}/${maxValue.toInt()}", style: StylesApp(context).textStyleBody14.copyWith(
                    fontSize: 14.0,
                    color:  Colors.grey[600]
                  ),),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),

         Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tamaño del texto",
                style: StylesApp(context)
                    .textStyleBody14
                    .copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.text_decrease, size: 20, color: Colors.grey[600]),
                  SizedBox(width: 12),
                  Expanded(
                    child: Slider(
                      activeColor: Colors.blueGrey,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.teal,
                      min: 12.0,
                      max: 20.0,
                      value: fontSize,
                      onChanged: onFontSizeChanged,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.text_increase, size: 20, color: Colors.grey[600]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
