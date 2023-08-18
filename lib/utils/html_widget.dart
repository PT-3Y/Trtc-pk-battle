import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/table_view_widget.dart';
import 'package:socialv/components/vimeo_embed_widget.dart';
import 'package:socialv/components/youtube_embed_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blog/screens/blog_detail_screen.dart';
import 'package:socialv/screens/post/screens/pdf_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';

import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;
  final double fontSize;
  final int? blogId;

  HtmlWidget({this.postContent, this.color, this.fontSize = 14.0, this.blogId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (postContent.validate().contains('youtube_url')) YoutubeComponent(postContent: postContent.validate()),
        Html(
          data: postContent.validate(),
          onLinkTap: (s, _, __) {
            if (s!.split('/').last.contains('.pdf')) {
              PDFScreen(docURl: s).launch(context);
            } else {
              log(s);
              if (s.contains('?user_id=')) {
                MemberProfileScreen(memberId: s.splitAfter('?user_id=').toInt()).launch(context);
              } else {
                openWebPage(context, url: s);
              }
            }
          },
          onAnchorTap: (s, _, __) async {
            if (s!.split('/').last.contains('.pdf')) {
              PDFScreen(docURl: s).launch(context);
            } else {
              log(s);
              if (s.contains('?user_id=')) {
                MemberProfileScreen(memberId: s.splitAfter('?user_id=').toInt()).launch(context);
              } else {
                if (blogId != null) {
                  appStore.setLoading(true);
                  await wpPostById(postId: blogId.validate()).then((value) {
                    appStore.setLoading(false);
                    BlogDetailScreen(blogId: blogId.validate(), data: value).launch(context);
                  }).catchError((e) {
                    toast(language.canNotViewPost);
                    appStore.setLoading(false);
                  });
                } else {
                  openWebPage(context, url: s);
                }
              }
            }
          },
          style: {
            "table": Style(backgroundColor: color ?? transparentColor, lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            "tr": Style(border: Border(bottom: BorderSide(color: Colors.black45.withOpacity(0.5))), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            "th": Style(padding: HtmlPaddings.zero, backgroundColor: Colors.black45.withOpacity(0.5), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT)),
            "td": Style(padding: HtmlPaddings.zero, alignment: Alignment.center, lineHeight: LineHeight(ARTICLE_LINE_HEIGHT)),
            'embed': Style(
                color: color ?? transparentColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: FontSize(fontSize),
                lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
                padding: HtmlPaddings.zero),
            'strong': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'a': Style(
              color: Colors.blue,
              // color: color ?? context.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: FontSize(fontSize),
              lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
              padding: HtmlPaddings.zero,
              textDecoration: TextDecoration.none,
            ),
            'div': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'figure': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), padding: HtmlPaddings.zero, margin: Margins.zero, lineHeight: LineHeight(ARTICLE_LINE_HEIGHT)),
            'h1': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'h2': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'h3': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'h4': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'h5': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'h6': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'p': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), textAlign: TextAlign.justify, lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'ol': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'ul': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'strike': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'u': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'b': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'i': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'hr': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'header': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'code': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'data': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'body': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'big': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), lineHeight: LineHeight(ARTICLE_LINE_HEIGHT), padding: HtmlPaddings.zero),
            'blockquote': Style(
                border: Border.all(),
                backgroundColor: Colors.grey.withOpacity(0.5),
                color: color ?? textPrimaryColorGlobal,
                fontSize: FontSize(fontSize),
                lineHeight: LineHeight(ARTICLE_LINE_HEIGHT),
                padding: HtmlPaddings.zero),
            'audio': Style(color: color ?? textPrimaryColorGlobal, fontSize: FontSize(fontSize), padding: HtmlPaddings.zero),
            'img': Style(width: Width(context.width()), padding: HtmlPaddings.only(bottom: 8), fontSize: FontSize(fontSize)),
            'li': Style(
              color: color ?? textPrimaryColorGlobal,
              fontSize: FontSize(fontSize),
              listStyleType: ListStyleType.disc,
              listStylePosition: ListStylePosition.outside,
            ),
          },
          extensions: [
            TagExtension(
              tagsToExtend: {'blockquote'},
              builder: (extensionContext) {
                return Offstage();
              },
            ),
            TagExtension(
              tagsToExtend: {'embed'},
              builder: (extensionContext) {
                var videoLink = extensionContext.parser.htmlData.text.splitBetween('<embed>', '</embed');

                if (videoLink.contains('yout')) {
                  return YouTubeEmbedWidget(videoLink.replaceAll('<br>', '').toYouTubeId());
                } else if (videoLink.contains('vimeo')) {
                  return VimeoEmbedWidget(videoLink.replaceAll('<br>', ''));
                } else {
                  return Offstage();
                }
              },
            ),
            TagExtension(
              tagsToExtend: {'figure'},
              builder: (extensionContext) {
                if (extensionContext.innerHtml.contains('yout')) {
                  return YouTubeEmbedWidget(extensionContext.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').toYouTubeId());
                } else if (extensionContext.innerHtml.contains('vimeo')) {
                  return VimeoEmbedWidget(extensionContext.innerHtml.splitBetween('<div class="wp-block-embed__wrapper">', "</div>").replaceAll('<br>', '').splitAfter('com/'));
                } else if (extensionContext.innerHtml.contains('audio')) {
                  //return AudioPostWidget(postString: extensionContext.innerHtml);
                } else if (extensionContext.innerHtml.contains('twitter')) {
                  String t = extensionContext.innerHtml.splitAfter('<div class="wp-block-embed__wrapper">').splitBefore('</div>');
                  // return TweetWebView(tweetUrl: t);
                } else {
                  return Offstage();
                }
                return Offstage();
              },
            ),
            TagExtension(
              tagsToExtend: {'iframe'},
              builder: (extensionContext) {
                if (extensionContext.attributes['src'].validate().toYouTubeId().isNotEmpty) {
                  return YouTubeEmbedWidget(extensionContext.attributes['src'].validate().toYouTubeId());
                } else {
                  return Offstage();
                }
              },
            ),
            TagExtension(
              tagsToExtend: {'img'},
              builder: (extensionContext) {
                String img = '';
                if (extensionContext.attributes.containsKey('src')) {
                  img = extensionContext.attributes['src'].validate();
                } else if (extensionContext.attributes.containsKey('data-src')) {
                  img = extensionContext.attributes['data-src'].validate();
                }
                if (img.isNotEmpty) {
                  return CachedNetworkImage(
                    imageUrl: img,
                    width: context.width(),
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
                    //OpenPhotoViewer(photoImage: img).launch(context);
                  });
                } else {
                  return Offstage();
                }
              },
            ),
            TagWrapExtension(
              tagsToWrap: {"table"},
              builder: (child) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.open_in_full_rounded),
                        onPressed: () async {
                          await TableViewWidget(child).launch(context);
                          setOrientationPortrait();
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: child,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class YoutubeComponent extends StatefulWidget {
  final String? postContent;

  const YoutubeComponent({this.postContent});

  @override
  State<YoutubeComponent> createState() => _YoutubeComponentState();
}

class _YoutubeComponentState extends State<YoutubeComponent> {
  String videoId = '';

  @override
  void initState() {
    super.initState();

    extractDivAttributes(widget.postContent.validate());
  }

  void extractDivAttributes(String htmlText) {
    RegExp regExp = RegExp(r'"youtube_url":"([^"]+)"');
    Match? match = regExp.firstMatch(htmlText);

    if (match != null) {
      String youtubeURL = match.group(1)!;
      youtubeURL = json.decode('"$youtubeURL"');
      videoId = youtubeURL.toYouTubeId();
    } else {
      print('YouTube URL not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return YouTubeEmbedWidget(videoId);
  }
}
