import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';
import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../main.dart';
import '../../../models/gallery/albums.dart';
import '../../../models/posts/media_model.dart';
import '../../../network/rest_apis.dart';
import '../components/gallery_screen_album_component.dart';
import '../components/gallery_create_album_button.dart';
import 'create_album_screen.dart';
import 'single_album_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  final int? groupId;
  final int? userId;
  final bool canEdit;

  GalleryScreen({Key? key, this.groupId, this.userId, this.canEdit = false}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

List<MediaModel> mediaTypeList = [];

class _GalleryScreenState extends State<GalleryScreen> {
  List<Albums> albumList = [];

  int selectedIndex = 0;
  bool isError = false;
  late Future<List<Albums>> futureAlbum;
  ScrollController scrollCont = ScrollController();
  int mPage = 1;
  bool mIsLastPage = false;
  bool isAlbumEmpty = false;
  bool isRefresh = false;

  @override
  void initState() {
    getMediaList();
    super.initState();
    init();
    setStatusBarColorBasedOnTheme();
    afterBuildCreated(
      () {
        scrollCont.addListener(
          () {
            if (scrollCont.position.pixels == scrollCont.position.maxScrollExtent) {
              if (!mIsLastPage) {
                mPage++;
                futureAlbum = fetchAlbums();
              }
            }
          },
        );
      },
    );
  }

  void init() async {
    mPage = 1;
    futureAlbum = fetchAlbums();
  }

  Future<List<MediaModel>> getMediaList() async {
    appStore.setLoading(true);
    mediaTypeList.clear();

    await getMediaTypes(type: widget.groupId != null ? null : Component.members).then(
      (value) {
        mediaTypeList.addAll(value);
        mediaTypeList.insert(0, MediaModel(title: language.all, type: language.all, allowedType: null, isActive: true));
        if (widget.groupId != null && widget.canEdit) mediaTypeList.insert(1, MediaModel(title: language.myGallery, type: MediaTypes.myGallery, allowedType: null, isActive: true));
        appStore.setLoading(false);
        setState(() {});
      },
    ).catchError(
      (e) {
        toast(e.toString(), print: true);
        appStore.setLoading(false);
        setState(() {});
      },
    );
    return mediaTypeList;
  }

  Future<void> deleteAlbum({required int id}) async {
    ifNotTester(
      () async {
        mPage = 1;
        setState(() {});
        appStore.setLoading(true);
        await deleteMedia(id: id, type: MediaTypes.gallery).then(
          (value) {
            albumList.removeWhere((element) => element.id == id);
            appStore.setLoading(false);
            setState(() {});
            toast(value.message);
          },
        ).catchError(
          (e) {
            toast(e.toString());
            appStore.setLoading(false);
            setState(() {});
          },
        );
      },
    );
  }

  Future<List<Albums>> fetchAlbums() async {
    appStore.setLoading(true);
    if (mPage == 1) albumList.clear();
    await getAlbums(type: selectedIndex == 0 ? "" : mediaTypeList[selectedIndex].type, userId: widget.userId, page: mPage, groupId: widget.groupId == null ? "" : widget.groupId.toString()).then(
      (value) {
        mIsLastPage = value.length != 6;
        albumList.addAll(value);
        if (albumList.isEmpty && selectedIndex == 0) {
          isAlbumEmpty = true;
        }
        appStore.setLoading(false);
        setState(() {});
      },
    ).catchError(
      (e) {
        toast(e.toString(), print: true);
        appStore.setLoading(false);
        isError = true;
        setState(() {});
      },
    );
    return albumList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    setStatusBarColorBasedOnTheme();
    scrollCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.gallery, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Albums>>(
            future: futureAlbum,
            builder: (context, snap) {
              if (snap.hasError || isError) {
                return SizedBox(
                  height: context.height() * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      init();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center(),
                );
              } else if (snap.hasData) {
                return SingleChildScrollView(
                  controller: scrollCont,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HorizontalList(
                        itemCount: mediaTypeList.length,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        itemBuilder: (context, index) {
                          MediaModel item = mediaTypeList[index];
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: selectedIndex == index ? context.primaryColor : context.cardColor,
                              borderRadius: BorderRadius.all(radiusCircular()),
                            ),
                            child: Text(
                              item.title.validate(),
                              style: boldTextStyle(size: 14, color: selectedIndex == index ? context.cardColor : context.primaryColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ).onTap(
                            () {
                              if (selectedIndex != index && !appStore.isLoading) {
                                mPage = 1;
                                selectedIndex = index;
                                setState(() {});

                                if (isAlbumEmpty && !isRefresh) {
                                  //
                                } else {
                                  init();
                                }
                              }
                            },
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          );
                        },
                      ),
                      if (albumList.isEmpty && !appStore.isLoading)
                        SizedBox(
                          height: context.height() * 0.74,
                          child: !widget.canEdit.validate()
                              ? NoDataWidget(
                                  imageWidget: NoDataLottieWidget(),
                                  title: language.noDataFound,
                                  onRetry: () {
                                    init();
                                  },
                                  retryText: '   ${language.clickToRefresh}   ',
                                ).center()
                              : GalleryCreateAlbumButton(
                                  isEmptyList: true,
                                  mediaTypeList: mediaTypeList,
                                  callback: () {
                                    CreateAlbumScreen(mediaTypeList: mediaTypeList, groupID: widget.groupId).launch(context).then(
                                      (value) {
                                        if (value == true) {
                                          init();
                                          isAlbumCreated = false;
                                          isAlbumEmpty = false;
                                          isRefresh = true;
                                        }
                                      },
                                    );
                                  },
                                ),
                        ),
                      if (albumList.isNotEmpty)
                        Column(
                          children: [
                            if (widget.canEdit.validate())
                              GalleryCreateAlbumButton(
                                mediaTypeList: mediaTypeList,
                                isEmptyList: false,
                                callback: () {
                                  CreateAlbumScreen(mediaTypeList: mediaTypeList, groupID: widget.groupId).launch(context).then(
                                    (value) {
                                      if (value == true) {
                                        init();
                                        isAlbumCreated = false;
                                        isAlbumEmpty = false;
                                        isRefresh = true;
                                      }
                                    },
                                  );
                                },
                              ),
                            8.height,
                            GridView.builder(
                              itemCount: albumList.length,
                              padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60, left: 16, right: 16),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 160,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                Albums album = albumList[index];
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    SingleAlbumDetailScreen(
                                      album: album,
                                      canEdit: widget.canEdit,
                                    ).launch(context);
                                  },
                                  child: GalleryScreenAlbumComponent(
                                    album: album,
                                    canDelete: album.canDelete.validate(),
                                    callback: (albumId) {
                                      deleteAlbum(id: albumId);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              } else {
                return Offstage();
              }
            },
          ),
          Positioned(
            bottom: albumList.isNotEmpty && mPage != 1 ? 8 : null,
            width: albumList.isNotEmpty && mPage != 1 ? MediaQuery.of(context).size.width : null,
            child: Observer(builder: (_) => LoadingWidget(isBlurBackground: mPage == 1 ? true : false).center().visible(appStore.isLoading)),
          ),
        ],
      ),
    );
  }
}
