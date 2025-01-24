 import 'package:biblia_palabra_de_vida_app/models/data_preach.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

  class VideoPlayerWidget extends StatefulWidget {
    final DataPreach data;
    const VideoPlayerWidget({super.key, required this.data});

    @override
    State<VideoPlayerWidget> createState() => _VideoPlayerScreenState();
  }

  class _VideoPlayerScreenState extends State<VideoPlayerWidget> {
    late VideoPlayerController _controller;
    late Future<void> _initializeVideoPlayerFuture;

    @override
    void initState() {
      super.initState();
      _controller = VideoPlayerController.network(widget.data.urlVideo);
      _initializeVideoPlayerFuture = _controller.initialize();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarHeaderWidget(
                  title: "Predicas",
                  styleText: StylesApp(context).textStyleBody7,
                  backColor: StyleColor.turquoise,
                  textButtonColor: Colors.white,
                  buttonColor: StyleColor.orange,
                  onRoute: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    constraints: BoxConstraints(minHeight: 213),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.data.author.replaceAll('.', '.\n'),
                                  style: StylesApp(context).textStyleBody14.copyWith(color: StyleColor.turquoise),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${widget.data.date}",
                                    style: StylesApp(context).textStyleBody12.copyWith(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.data.title,
                            style: StylesApp(context).textStyleBody16.copyWith(color: StyleColor.orange),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Referencias",
                    style: StylesApp(context).textStyleBody14.copyWith(color: StyleColor.turquoise),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonThemeWidget(
                        text: "Hebreos 11:6",
                        buttonStyle: StylesApp(context).btnSecondary.copyWith(
                            maximumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity)),
                            minimumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity))),
                        width: MediaQuery.sizeOf(context).width,
                        height: StylesApp(context).btnSizeSmall.height,
                      ),
                      ButtonThemeWidget(
                        text: "Salmo 34:17",
                        buttonStyle: StylesApp(context).btnSecondary.copyWith(
                            maximumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity)),
                            minimumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity))),
                        width: MediaQuery.sizeOf(context).width,
                        height: StylesApp(context).btnSizeSmall.height,
                      ),
                      ButtonThemeWidget(
                        text: "Gálatas 6:2-8",
                        buttonStyle: StylesApp(context).btnSecondary.copyWith(
                            maximumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity)),
                            minimumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity))),
                        width: MediaQuery.sizeOf(context).width,
                        height: StylesApp(context).btnSizeSmall.height,
                      ),
                      ButtonThemeWidget(
                        text: "Mateo 18:20-30",
                        buttonStyle: StylesApp(context).btnSecondary.copyWith(
                            maximumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity)),
                            minimumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity))),
                        width: MediaQuery.sizeOf(context).width,
                        height: StylesApp(context).btnSizeSmall.height,
                      ),
                      ButtonThemeWidget(
                        text: "Salmo 46:10",
                        buttonStyle: StylesApp(context).btnSecondary.copyWith(
                            maximumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity)),
                            minimumSize: WidgetStatePropertyAll(Size(double.infinity, double.infinity))),
                        width: MediaQuery.sizeOf(context).width,
                        height: StylesApp(context).btnSizeSmall.height,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      );
    }
  }