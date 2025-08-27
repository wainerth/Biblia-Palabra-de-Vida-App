import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DialogFavoriteVerseWidget extends StatefulWidget {
  final List<FavoriteVerse> favoriteVerses;
  final PaginationInfo? paginationInfo;
  final BibleTheme currentTheme;
  final String versionId;
  final void Function(String verseId)? onDeleted;
  const DialogFavoriteVerseWidget(
      {super.key,
      required this.currentTheme,
      required this.versionId,
      required this.favoriteVerses,
      required this.paginationInfo,
      this.onDeleted});

  @override
  State<DialogFavoriteVerseWidget> createState() =>
      _DialogFavoriteVerseWidgetState();
}

class _DialogFavoriteVerseWidgetState extends State<DialogFavoriteVerseWidget> {
  bool loading = false;
  List<FavoriteVerse> _favoriteVerses = [];
  List<int> itemsPerPage = [
    5,
    10,
    15,
    25,
    50,
    100,
  ];
  int itemPerPageValue = 50;
  PaginationInfo pagination = PaginationInfo(
    currentPage: 1,
    totalPages: 1,
    itemsPerPage: 50,
    totalItems: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );

  @override
  void initState() {
    setState(() {
      _favoriteVerses = widget.favoriteVerses;
      pagination = widget.paginationInfo!;
      itemPerPageValue = widget.paginationInfo!.itemsPerPage;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: widget.currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarHeaderWidget(
              backColor: StyleColor.turquoise,
              buttonColor: StyleColor.orange,
              textButtonColor: Colors.white,
              title: 'Versículos Favoritos',
              styleText: StylesApp(context).textStyleBody7,
              onRoute: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: loading
                  ? LoadingIndicator()
                  : _favoriteVerses.isEmpty
                      ? SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "No hay Versículos agregados a favorito...",
                                  style: StylesApp(context)
                                      .textStyleBody18
                                      .copyWith(
                                          color: widget.currentTheme.textColor),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Para agregar un versículo, presione sobre el \nnúmero del versículo",
                                  style: StylesApp(context)
                                      .textStyleBody10
                                      .copyWith(
                                          color: widget.currentTheme.textColor),
                                ),
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _favoriteVerses.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 6.0, left: 4.0, right: 4.0, bottom: 6.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: widget.currentTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        StyleColor.black.withValues(alpha: .25),
                                    spreadRadius: 2.0,
                                    offset: Offset(0, 2.0),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: -15,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 20.0,
                                          onPressed: () => copyToClipboard(
                                            context,
                                            CopyModelVerse(
                                              book: Book(
                                                  modernName:
                                                      _favoriteVerses[index]
                                                          .book
                                                          .modernName),
                                              chapter: ChapterModel(
                                                chapter: _favoriteVerses[index]
                                                    .chapter
                                                    .chapter,
                                              ),
                                              verse: VerseModel(
                                                verse: _favoriteVerses[index]
                                                    .verse
                                                    .verse,
                                                text: _favoriteVerses[index]
                                                    .verse
                                                    .text,
                                              ),
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.file_copy_rounded,
                                            color:
                                                widget.currentTheme.buttonColor,
                                          ),
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 20.0,
                                          onPressed: () => shareVerse(
                                            context,
                                            CopyModelVerse(
                                              book: Book(
                                                modernName:
                                                    _favoriteVerses[index]
                                                        .book
                                                        .modernName,
                                              ),
                                              chapter: ChapterModel(
                                                chapter: _favoriteVerses[index]
                                                    .chapter
                                                    .chapter,
                                              ),
                                              verse: VerseModel(
                                                verse: _favoriteVerses[index]
                                                    .verse
                                                    .verse,
                                                text: _favoriteVerses[index]
                                                    .verse
                                                    .text,
                                              ),
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.share_rounded,
                                            color: StyleColor.turquoise,
                                          ),
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 20.0,
                                          onPressed: () => deleteFavorite(
                                              _favoriteVerses[index].verse.id),
                                          icon: Icon(
                                            Icons.delete_forever_outlined,
                                            color: StyleColor.turquoise,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 22,
                                      ),
                                      Center(
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: _favoriteVerses[index]
                                                .book
                                                .modernName,
                                            style: StylesApp(context)
                                                .textStyleBody16
                                                .copyWith(
                                                    color:
                                                        StyleColor.turquoise),
                                          ),
                                          TextSpan(
                                            text:
                                                "  ${_favoriteVerses[index].chapter.chapter}:${_favoriteVerses[index].verse.verse}",
                                            style: StylesApp(context)
                                                .textStyleBody14
                                                .copyWith(
                                                    color: widget.currentTheme
                                                        .textColor),
                                          )
                                        ])),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          '"${_favoriteVerses[index].verse.text}"',
                                          style: StylesApp(context)
                                              .textStyleBody12
                                              .copyWith(
                                                  color: widget
                                                      .currentTheme.textColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            CustomPagination(
              pagination: PaginationInfo(
                  currentPage: pagination.currentPage,
                  itemsPerPage: pagination.itemsPerPage,
                  totalPages: pagination.totalPages,
                  hasPreviousPage: pagination.hasPreviousPage,
                  hasNextPage: pagination.hasNextPage,
                  totalItems: pagination.totalItems),
              itemPerPageValue: itemPerPageValue,
              currentTheme: widget.currentTheme,
              onPageChanged: (newPage, newPerPage) async {
                setState(() {
                  itemPerPageValue = newPerPage;
                });
                await _loadData(newPage, newPerPage);
              },
              itemsPerPage: itemsPerPage, // Opcional: personaliza los valores
            ),
          ],
        ),
      ),
    );
  }

  deleteFavorite(verseId) async {
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.currentUser;
    final responseDelete = await deleteVerseFavorite(userData!.userId, verseId);
    if (responseDelete.error != null) {
      LoadingService().hideLoading();
      await showCustomDialog(context,
          message: responseDelete.error!, dialogType: DialogType.error);
      return;
    } else {
      await _loadData(pagination.currentPage, itemPerPageValue);
      widget.onDeleted!(verseId);
    }

    LoadingService().hideLoading();
  }

  _loadData(int newPage, int newPerPage) async {
    setState(() {
      _favoriteVerses = [];
      loading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.currentUser;
    final responseFavorite = await getFavoriteVerseByUser(
        newPage, newPerPage, widget.versionId, null, userData!.userId);

    if (responseFavorite.data != null && responseFavorite.data.length > 0) {
      setState(() {
        _favoriteVerses = responseFavorite.data['data']
            .map<FavoriteVerse>((favorite) => FavoriteVerse.fromJson(favorite))
            .toList();

        pagination = PaginationInfo.fromJson(
            removeTypename(responseFavorite.data["meta"]));
      });
    }
    setState(() {
      loading = false;
    });
  }
}
