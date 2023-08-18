import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../models/posts/media_model.dart';
import '../components/album_upload_component.dart';
import '../components/create_album_component.dart';

class CreateAlbumScreen extends StatefulWidget {
  final List<MediaModel> mediaTypeList;
  final int? groupID;

  const CreateAlbumScreen({Key? key, required this.mediaTypeList, this.groupID}) : super(key: key);

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

MediaModel? selectedAlbumMedia;
bool isAlbumCreated=false;

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  PageController _pageController = PageController(initialPage: 0);
  List<Widget> createAlbumWidgets = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    createAlbumWidgets.addAll(
      [
        CreateAlbumComponent(
          mediaTypeList: widget.mediaTypeList,
          groupId: widget.groupID,
          onNextPage: (int nextPageIndex) {
            _pageController.animateToPage(nextPageIndex, duration: const Duration(milliseconds: 250), curve: Curves.linear);
            setState(() {});
          },
        ),
        AlbumUploadScreen(),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.createAlbum, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {

            finish(context,isAlbumCreated);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
        ),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: createAlbumWidgets,
        ),
      ),
    );
  }
}
