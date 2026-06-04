import 'package:biblia_palabra_de_vida_app/config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class InfoModalWidget extends StatefulWidget {
  final PrayerModel dataSeleccionada;
  const InfoModalWidget({
    super.key,
    required this.dataSeleccionada,
  });

  @override
  State<InfoModalWidget> createState() => _InfoModalWidgetState();
}

class _InfoModalWidgetState extends State<InfoModalWidget> {
  final ScrollController _scrollController = ScrollController();

  // Función para determinar si es tablet
  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Configuración adaptativa para tablet
    final double dialogWidth = isTablet
        ? (screenWidth * 0.7).clamp(500.0, 800.0)
        : screenWidth - 24; // Para móvil: ancho completo menos márgenes

    final double dialogHeight = isTablet
        ? (screenHeight * 0.8).clamp(400.0, 900.0)
        : screenHeight * 0.9;

    return Dialog(
      insetPadding: isTablet
          ? EdgeInsets.symmetric(
              horizontal: (screenWidth - dialogWidth) / 2,
              vertical: (screenHeight - dialogHeight) / 2,
            )
          : EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0, bottom: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Color(0XFFFFF8DD),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: _buildDialogContent(context, dialogWidth),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, double dialogWidth) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 30.0 : 16.0,
                vertical: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con título
                  Center(
                    child: Text(
                      "Respuesta de Pedidos de Oración",
                      textAlign: TextAlign.center,
                      style: StylesApp(context).textStyleTitleOrange.copyWith(
                            fontSize: isTablet ? 24 : null,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 30.0 : 21.0),

                  // Información principal en columnas para tablet
                  isTablet
                      ? _buildTabletInfoLayout(context)
                      : _buildMobileInfoLayout(context),

                  SizedBox(height: isTablet ? 30.0 : 21.0),
                  // Sección de mensaje
                  _buildMessageSection(context),

                  SizedBox(height: isTablet ? 25.0 : 12.0),

                  // Audio de respuesta (si existe)
                  if (widget.dataSeleccionada.responser != null &&
                      widget.dataSeleccionada.responser!.audioResponse != null)
                    Column(
                      children: [
                        Text(
                          "Audio de Respuesta",
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: StyleColor.orange,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(height: 10),
                        AudioPlayerWidget(
                          pathUrl:
                              "${GraphQLConfig.endpoint}${widget.dataSeleccionada.responser?.audioResponse!.url}",
                          showImage: false,
                        ),
                      ],
                    ),

                  SizedBox(height: isTablet ? 30.0 : 21.0),

                  // Botón de cierre
                  Center(
                    child: ButtonThemeWidget(
                      text: "Cerrar",
                      buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                            textStyle: WidgetStatePropertyAll(
                              TextStyle(fontSize: isTablet ? 16 : null),
                            ),
                          ),
                      width: isTablet ? 300.0 : 239.0,
                      height: isTablet ? 50.0 : 41.0,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  SizedBox(height: isTablet ? 20.0 : 34.0),
                ],
              ),
            ),
          ),
        ),

        // Botón de cerrar (X)
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            iconSize: isTablet ? 30.0 : 25.0,
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Layout de información para tablet
  Widget _buildTabletInfoLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda - Información básica
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: "Fecha y hora",
                  value: widget.dataSeleccionada.requestDate,
                ),
                SizedBox(height: 15),
                _buildInfoRow(
                  icon: Icons.person,
                  label: "Solicitante",
                  value: widget.dataSeleccionada.requestedBy,
                ),
                SizedBox(height: 15),
                _buildInfoRow(
                  icon: Icons.handshake,
                  label: "Pide por",
                  value: widget.dataSeleccionada.prayedFor,
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 20),

        // Columna derecha - Categorías y detalles
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Categorías",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: StyleColor.blueDark,
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: StyleColor.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: StyleColor.orange),
                      ),
                      child: Text(
                        widget.dataSeleccionada.prayerCategory.name.trim(),
                        style: TextStyle(
                          fontSize: 14,
                          color: StyleColor.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: StyleColor.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: StyleColor.blue),
                      ),
                      child: Text(
                        widget.dataSeleccionada.prayerSubType.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: StyleColor.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Descripción",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: StyleColor.blueDark,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    widget.dataSeleccionada.prayerDetails,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),
                if (widget.dataSeleccionada.audioPrayer != null) ...[
                  SizedBox(height: isTablet ? 30.0 : 21.0),
                  Container(
                    child: Column(
                      children: [
                        if (widget.dataSeleccionada.audioPrayer != null) ...[
                          SizedBox(height: 15),
                          Text(
                            "Audio de la Petición",
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  color: StyleColor.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 10),
                          AudioPlayerWidget(
                            pathUrl:
                                "${GraphQLConfig.endpoint}${widget.dataSeleccionada.audioPrayer!.url}",
                            showImage: false,
                          ),
                        ],
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Layout de información para móvil
  Widget _buildMobileInfoLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem("Fecha hora:", widget.dataSeleccionada.requestDate),
        SizedBox(height: 10),
        _buildInfoItem("Solicitante:", widget.dataSeleccionada.requestedBy),
        SizedBox(height: 10),
        _buildInfoItem("Pide por:", widget.dataSeleccionada.prayedFor),
        SizedBox(height: 10),
        Text.rich(
          softWrap: true,
          TextSpan(
            children: [
              TextSpan(
                text: "Oración por: ",
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: StyleColor.orange,
                    ),
              ),
              TextSpan(
                text: widget.dataSeleccionada.prayerCategory.name.trim(),
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: Colors.black,
                    ),
              ),
              TextSpan(
                text: " / ",
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: StyleColor.orange,
                    ),
              ),
              TextSpan(
                text: widget.dataSeleccionada.prayerSubType.name,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        _buildInfoItem("Descripción:", widget.dataSeleccionada.prayerDetails),
        if (widget.dataSeleccionada.audioPrayer != null) ...[
          SizedBox(height: 15),
          Text(
            "Audio de la Petición",
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: StyleColor.orange,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 10),
          AudioPlayerWidget(
            pathUrl:
                "${GraphQLConfig.endpoint}${widget.dataSeleccionada.audioPrayer!.url}",
            showImage: false,
          ),
        ],
      ],
    );
  }

  // Sección de mensaje (compartida para ambos layouts)
  Widget _buildMessageSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mensaje",
            style: StylesApp(context).textStyleBodyOrange15.copyWith(
                  fontSize: isTablet ? 18 : null,
                  fontWeight: FontWeight.w700,
                ),
          ),

          SizedBox(height: 20),

          // Mensaje del sistema (si existe)
          if (widget.dataSeleccionada.statusRequest != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mensaje del Sistema",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget
                        .dataSeleccionada.statusRequest.messageSystems!.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[900],
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),

          // Respuesta del intercesor (si existe)
          if (widget.dataSeleccionada.responser != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Respuesta del Intercesor",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.dataSeleccionada.responser!.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[900],
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Referencia bíblica (si existe)
                if (widget.dataSeleccionada.responser?.text != null)
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.dataSeleccionada.responser?.bookName ?? ""} '
                          '${widget.dataSeleccionada.responser?.chapter ?? ""}:'
                          '${widget.dataSeleccionada.responser?.verse ?? ""}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.amber[900],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '"${widget.dataSeleccionada.responser?.text}"',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.brown[800],
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // Widget auxiliar para filas de información en tablet
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: StyleColor.orange, size: 20),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para items de información en móvil
  Widget _buildInfoItem(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: StyleColor.orange,
                ),
          ),
          TextSpan(
            text: " $value",
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
