import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models/wp_embedded_model.dart';
import 'package:socialv/models/posts/wp_comments_model.dart';
import 'package:socialv/models/posts/wp_post_response.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blog/components/blog_comment_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:socialv/utils/html_widget.dart';

class BlogDetailScreen extends StatefulWidget {
  final int blogId;
  final WpPostResponse data;

  BlogDetailScreen({required this.blogId, required this.data});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  bool fetchBlog = false;
  WpPostResponse blog = WpPostResponse();
  TextEditingController message = TextEditingController();
  TextEditingController password = TextEditingController();

  List<WpCommentModel> commentList = [];
  late Future<List<WpCommentModel>> future;

  ScrollController _scrollController = ScrollController();

  int mPage = 1;
  bool mIsLastPage = false;

  List<String> tags = [];
  String category = '';

  @override
  void initState() {
    if (!widget.data.content!.protected.validate() && widget.data.content!.rendered.validate().isNotEmpty) future = getComments();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage && commentList.isNotEmpty) {
          mPage++;
          future = getComments();
        }
      }
    });

    blog = widget.data;
    getTags();
    setState(() {});
  }

  void getTags() {
    blog.embedded!.wpTerms!.forEach((element) {
      element.forEach((e) {
        WpTermsModel terms = WpTermsModel.fromJson(e);
        if (terms.taxonomy.validate() == 'category') {
          category = terms.name.validate();
        } else if (terms.taxonomy.validate() == 'post_tag') {
          tags.add(terms.name.validate());
        }
      });
    });

    setState(() {});
  }

  Future<List<WpCommentModel>> getComments() async {
    appStore.setLoading(true);
    await getBlogComments(id: widget.blogId, page: mPage).then((value) {
      if (mPage == 1) commentList.clear();
      mIsLastPage = value.length != PER_PAGE;
      commentList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return commentList;
  }

  Future<void> getBlog({String? password}) async {
    appStore.setLoading(true);
    await wpPostById(postId: widget.blogId.validate(), password: password).then((value) {
      future = getComments();
      blog = value;
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      toast(language.canNotViewPost);
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('', style: boldTextStyle(size: 20)),
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
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(blog.title!.rendered.validate(), style: boldTextStyle()),
                16.height,
                if (blog.embedded != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '${blog.embedded!.author!.first.name.validate()} ', style: secondaryTextStyle(size: 14, fontFamily: fontFamily)),
                        if (blog.embedded!.author!.first.is_user_verified.validate())
                          WidgetSpan(
                            child: Image.asset(ic_tick_filled, height: 16, width: 16, color: blueTickColor, fit: BoxFit.cover),
                          ),
                        TextSpan(text: '  |  ${convertToAgo(blog.date.validate())}  |', style: secondaryTextStyle(size: 14, fontFamily: fontFamily)),
                        TextSpan(text: '  $category', style: secondaryTextStyle(size: 14, fontFamily: fontFamily, color: context.primaryColor))
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                if (tags.isNotEmpty)
                  Row(
                    children: [
                      Text('${language.tags}: ', style: boldTextStyle(size: 14)),
                      Wrap(
                        children: tags.map((e) {
                          return Text('$e, ', style: secondaryTextStyle());
                        }).toList(),
                      ),
                    ],
                  ).paddingSymmetric(vertical: 16),
                if (blog.content!.protected.validate() && blog.content!.rendered.validate().isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language.protectedPostText, style: secondaryTextStyle()),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: context.width() * 0.6,
                            child: TextField(
                              controller: password,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              maxLines: 1,
                              decoration: inputDecorationFilled(
                                context,
                                label: language.password,
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                fillColor: context.cardColor,
                              ),
                              onSubmitted: (text) async {
                                await getBlog(password: text);
                              },
                            ),
                          ),
                          TextButton(
                            child: Text(language.apply, style: primaryTextStyle(color: context.primaryColor)),
                            onPressed: () async {
                              await getBlog(password: password.text);
                            },
                          ).expand(),
                        ],
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cachedImage(blog.embedded!.featuredMedia!.first.source_url.validate()).cornerRadiusWithClipRRect(commonRadius),
                      16.height,
                      HtmlWidget(postContent: getPostContent(blog.content!.rendered.validate())),
                      Divider(),
                      if (blog.comment_status == 'open')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (commentList.isNotEmpty)
                              Container(
                                width: context.width() - 32,
                                decoration: BoxDecoration(color: context.cardColor),
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(language.comments, style: boldTextStyle(size: 18)),
                                    AnimatedListView(
                                      padding: EdgeInsets.all(8),
                                      itemCount: commentList.length,
                                      slideConfiguration: SlideConfiguration(
                                        delay: 80.milliseconds,
                                        verticalOffset: 300,
                                      ),
                                      itemBuilder: (context, index) {
                                        WpCommentModel comment = commentList[index];
                                        return BlogCommentComponent(
                                          comment: comment,
                                          onDelete: () {
                                            commentList.removeAt(index);
                                            setState(() {});
                                          },
                                          onUpdate: (value) {
                                            commentList[index] = value;
                                            setState(() {});
                                          },
                                        );
                                      },
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                    ),
                                  ],
                                ),
                              ),
                            if (blog.sv_is_comment_open.validate())
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  16.height,
                                  Text(language.leaveAReply, style: boldTextStyle()),
                                  16.height,
                                  AppTextField(
                                    controller: message,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    textFieldType: TextFieldType.MULTILINE,
                                    textStyle: boldTextStyle(),
                                    minLines: 5,
                                    maxLines: 5,
                                    decoration: inputDecorationFilled(context, fillColor: context.cardColor, label: language.message),
                                  ),
                                  16.height,
                                  appButton(
                                    width: context.width() / 2 - 20,
                                    context: context,
                                    text: language.submit.capitalizeFirstLetter(),
                                    onTap: () {
                                      ifNotTester(() {
                                        if (!appStore.isLoading) {
                                          addBlogComment(postId: blog.id.validate(), content: message.text.trim()).then((value) {
                                            message.clear();
                                            commentList.add(value);
                                            setState(() {});
                                          }).catchError((e) {
                                            toast(e.toString());
                                            log('Error: ${e.toString()}');
                                          });
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
          Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
