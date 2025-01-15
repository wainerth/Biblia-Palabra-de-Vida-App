import 'dart:async';

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPrayerScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  const RequestPrayerScreen({
    super.key,
    required this.args,
  });

  @override
  State<RequestPrayerScreen> createState() => _RequestPrayerScreenState();
}

class _RequestPrayerScreenState extends State<RequestPrayerScreen> {
  final TextEditingController requestController = TextEditingController();
  final TextEditingController _recipientName = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  List<DropdownMenuEntry> options = [];
  List<Map<String, dynamic>> peticiones = [
    {
      "id": "1",
      'options': [
        "Sanidad de enfermedad",
        "Quitar dolencias",
        "Recuperación tras una operación",
        "Recuperación tras un accidente",
        "Libre de depresión",
        "Libre de ansiedad ",
        "Otro",
      ],
    },
    {
      "id": "2",
      'options': [
        "Estoy desesperado necesito paz",
        "Me siento muy depresivo necesito paz",
        "A veces me siento depresivo necesito paz",
        "Por Liberación",
        "Por Libertad",
        "Otro"
      ]
    },
    {
      "id": "3",
      'options': [
        "Unidad y armonía familiar",
        "Protección y seguridad de la familia",
        "Sabiduría en la crianza ",
        "Salvación y vida espiritual de la familia",
        "Provisión y bienestar familia",
        "Reconciliación familiar",
        "Libertad de un familiar",
        "Otro"
      ],
    },
    {
      "id": "4",
      "options": [
        "Protección por seguridad física",
        "Protección Riesgo de contagio",
        "Protección de enemigos",
        "Protección de la iglesia",
        "Protección de la familia",
        "Libertad",
        "Otro"
      ]
    },
    {
      "id": "5",
      "options": [
        "Librar de problemas en el trabajo",
        "conseguir empleo estable",
        "Por un asenso laboral",
        "Dirección ante cambio de empleo",
        "sabiduría en el trabajo",
        "Otro"
      ]
    },
    {
      "id": "6",
      "options": [
        "Mejora en las finanzas ",
        "Ayuda para salir de deudas",
        "Sabiduría en la administración",
        "Bendición en negocios y proyectos",
        "Protección y estabilidad financiera",
        "Otro"
      ]
    },
    {
      "id": "7",
      "options": [
        "Liberación de la adicción",
        "Fortaleza para resistir la tentación",
        "Restauración emocional y espiritual",
        "Apoyo para reconstruir relaciones",
        "Perseverancia en la recuperación",
        "Otro"
      ]
    },
    {
      "id": "8",
      "options": [
        "Liberación espiritual",
        "Crecimiento espiritual",
        "Fortaleza en la fe",
        "Dirección y propósito",
        "Protección espiritual",
        "Avivamiento y servicio",
        "Otro"
      ]
    },
    {
      "id": "9",
      "options": [
        "Fortaleza en momentos duelo",
        "Relaciones interpersonales",
        "Por éxito en metas personales",
        "Gratitud y dirección futura",
        "Otro"
      ]
    }
  ];

  List<DropdownMenuEntry> generarOpcionesDropdown(String id) {
    final categoria = peticiones.firstWhere((p) => p['id'] == id);

    // Convertir JSArray<dynamic> a List<String>
    final options = List<String>.from(categoria["options"]);

    return options.map((key) {
      return DropdownMenuEntry(
        style: ButtonStyle(iconSize: WidgetStatePropertyAll(25.0)),
        label: key,
        value: key.toLowerCase().replaceAll(' ', '_'),
      );
    }).toList();
  }

  @override
  void initState() {
    options = generarOpcionesDropdown(widget.args["value"]);
    if (kDebugMode) {
      print(options);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.args);
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(color: Color(0XFF12CBC4)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeadScreenNotAvatar(
                  title: "Pedidos de Oración\n ${widget.args['label']}",
                  onRoute: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 46.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: _buildDropdown(context),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: TextField(
                    style: StylesApp(context).textStyleBody4,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: StylesApp(context).hintStyle,
                      hintText: "Nombre de por quien Orar",
                    ),
                    controller: _recipientName,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 281.0,
                      maxHeight: 281.0,
                    ),
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 6.0,
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: null,
                          style: StylesApp(context).textStyleBody4,
                          decoration: InputDecoration(
                            hintText: 'Describe tu pedido de oración...',
                            hintStyle: StylesApp(context).textStyleHintText,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: AudioRecorderWidget(),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonThemeWidget(
                  text: "Enviar",
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  width: 239.0,
                  height: 41.0,
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 0.0, bottom: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFFFF8DD),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 27,
                                        bottom: 39.0,
                                        left: 16.0,
                                        right: 16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            textAlign: TextAlign.center,
                                            "Petición Enviada con Éxito ",
                                            style: StylesApp(context)
                                                .textStyleTitleOrange),
                                        SizedBox(
                                          height: 21.0,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Tu petición de oración ha sido enviada a la comunidad de oración, quienes van a orar por tu petición.",
                                          style: StylesApp(context)
                                              .textStyleBody16
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 21.0,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Por favor te pedimos que creas en el poder de Dios, si le buscamos el es bueno misericordioso para perdonarnos y darnos una respuesta que sea para bendicion de nuestras vidas.",
                                          style: StylesApp(context)
                                              .textStyleBody16
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 21.0,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          'Juan 3:16 "De tal manera amó Dios al mundo, que ha dado a su Hijo unigénito, para que todo aquel que en él cree, no se pierda, mas tenga vida eterna"',
                                          style: StylesApp(context)
                                              .textStyleBody16
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: ButtonThemeWidget(
                                      text: "Aceptar",
                                      buttonStyle:
                                          StylesApp(context).btnWidgetSmall,
                                      width: 239.0,
                                      height: 41.0,
                                      onPressed: () {
                                        Navigator.popAndPushNamed(context, '/prayerPage');
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 34.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenu _buildDropdown(BuildContext context) {
    return DropdownMenu(
      initialSelection: "Seleccione una opción",
      controller: requestController,
      dropdownMenuEntries: options,
      enableFilter: true,
      requestFocusOnTap: true,
      hintText: "Tipo de Pedido",
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        hintStyle: StylesApp(context).textStyleHintText,
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      width: double.infinity,
      onSelected: (option) {
        setState(() {
          if (kDebugMode) {
            print(option);
          }
        });
      },
      // textStyle: StylesApp(context).textStyleBody4,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        elevation: WidgetStatePropertyAll(4.0),
        padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
      ),
    );
  }
}

class AudioRecorderWidget extends StatefulWidget {
  const AudioRecorderWidget({
    super.key,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;
  StreamSubscription<PlayerState>? _playerStateChangeSubscription;

  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  double volume = 0.5;
  Duration? _duration;
  Duration? _position;
  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';
  String? _audioPath;

  Future<bool> _hasMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  Future<void> initRecorder() async {
    try {
      if (await _hasMicrophonePermission()) {
        await _soundRecorder.openRecorder();
      } else {
        if (kDebugMode) {
          print('Microphone permission denied');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      _isRecorderInitialized = true;
    });
  }

  Future<void> startRecording() async {
    try {
      setState(() {
        _isRecording = true;
      });
      await _soundRecorder.startRecorder(toFile: 'audio.aac');
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Codec not supported: $e');
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de codificación'),
              content: Text('El codec seleccionado no es compatible.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al iniciar la grabación: $e');
      }
    }
  }

  Future<void> stopRecording() async {
    final path = await _soundRecorder.stopRecorder();
    if (kDebugMode) {
      print('Record finished: $path');
    }
    setState(() {
      _isRecording = false;
      _isPlaying = false;
      _audioPath = path;
    });
  }

  void _playAudio() async {
    audioPlayer.setVolume(volume);
    await audioPlayer.play(DeviceFileSource(_audioPath!));
    setState(() {
      _isPlaying = true;
    });
  }

  void _pauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _initStreams() {
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _playerCompleteSubscription = audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
      });
    });

    _playerStateChangeSubscription =
        audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() => _isPlaying = true);
      } else if (state == PlayerState.paused) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void initState() {
    initRecorder();
    _initStreams();
    super.initState();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 0,
              child: TweenAnimationBuilder(
                tween: Tween(begin: 1.0, end: 1.2),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                onEnd: () {
                  setState(() {});
                },
                child: IconButton(
                  iconSize: 35.0,
                  onPressed: _isRecording ? stopRecording : startRecording,
                  icon: Icon(
                    Icons.mic,
                    color: _isRecording ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 36,
                  maxHeight: 36.0,
                ),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0XFF8ADF85),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 0,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        iconSize: 24.0,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _isPlaying ? _pauseAudio : _playAudio,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Slider(
                        value: (_position != null &&
                                _duration != null &&
                                _position!.inMilliseconds > 0 &&
                                _position!.inMilliseconds <
                                    _duration!.inMilliseconds)
                            ? _position!.inMilliseconds /
                                _duration!.inMilliseconds
                            : 0.0,
                        onChanged: (value) {
                          final duration = _duration;
                          if (duration == null) return;
                          final position = value * duration.inMilliseconds;
                          audioPlayer
                              .seek(Duration(milliseconds: position.round()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Text.rich(
          style: TextStyle(color: Colors.white),
          TextSpan(
            text: _position != null
                ? '$_positionText / $_durationText'
                : _duration != null
                    ? _durationText
                    : '0:00:00 / 0:00:00',
          ),
        )
      ],
    );
  }
}
