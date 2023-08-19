import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:socialv/debug/GenerateTestUserSig.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socialv/utils/TxUtils.dart';
import 'package:socialv/Trtc/TRTCLiveRoomDemo/model/TRTCLiveRoom.dart';
import 'package:socialv/Trtc/TRTCLiveRoomDemo/model/TRTCLiveRoomDef.dart';
// import 'package:socialv/base/YunApiHelper.dart';
import 'package:socialv/i10n/localization_intl.dart';
import 'package:socialv/Trtc/trtc_sdk_manager.dart';
import 'package:socialv/gami_utils/api_services.dart';
import 'package:socialv/utils/common.dart';




/*
 * 房间列表
 */
class LiveRoomListPage extends StatefulWidget {
  // LiveRoomListPage({Key? key}) : super(key: key);
  const LiveRoomListPage({super.key, required this.controller});

  final ScrollController controller;


  @override
  State<StatefulWidget> createState() => LiveRoomListPageState();
}

class LiveRoomListPageState extends State<LiveRoomListPage> {
  late TRTCLiveRoom trtcLiveRoomServer;
  // List<RoomInfo> roomInfList = [];


  String? userId = TrtcSDKManager.instance.localUser!.userId;
  String? userName = TrtcSDKManager.instance.localUser!.userName;

  List<dynamic> liveList = [];
  List<dynamic> multiRoomList = [];
  List<dynamic> singleRoomList = [];
  List<dynamic> pkRoomList = [];


  openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      TxUtils.showToast(Languages.of(context)!.errorOpenUrl, context);
    }
  }

  @override
  void initState() {
    super.initState();
    //获取数据
    this.getRoomList();
  }

  @override
  dispose() {
    super.dispose();
  }


    void separateRoomsByType() {
    multiRoomList.clear();
    singleRoomList.clear();
    pkRoomList.clear();

    for (var room in liveList) {  if (room['status'] == 'error111') return;

      // final roomId = room['liveId'];

      // if (roomId.startsWith('Room-group-')) {
      //   multiRoomList.add(room);
      //   print('--Added to multiRoomlist');
      // } else if (roomId.startsWith('Room-solo-')) {
      //   singleRoomList.add(room);
      //   print('--Added to singleRoomlist');
      // } else if (roomId.startsWith('Room-invite-') || roomId.startsWith('Room-random-')) {
      //   pkRoomList.add(room);
      //   print('--Added to pkRoomlist');
      // }

      
    }
  }

  getRoomList() async {
    trtcLiveRoomServer = await TRTCLiveRoom.sharedInstance();
    String loginId = userId.toString();
    
    await trtcLiveRoomServer.login(
        GenerateTestUserSig.sdkAppId,
        loginId,
        await GenerateTestUserSig.genTestSig(loginId),
        TRTCLiveRoomConfig(useCDNFirst: false));

    //     isLoading = true;
    // getAllLiveRooms().then((value) {
    //   if (value[0]['status'] == 'error111') liveList = [];
    //   else liveList = value;
    //   print('Live lists ==> $value');
    //   separateRoomsByType();
    // }).catchError((e) {
    //   toast(e.toString());
    // });
    // isLoading = false;
    // setState(() {});
    var liveList = await getAllLiveRooms();
    // var roomIdls = [];
    if (liveList.length!=0) {
      setState(() {
        liveList = liveList;
      });
      return;
    }
  // RoomInfoCallback resp = await trtcLiveRoomServer.getRoomInfos();
  //   if (resp.code == 0) {
  //     setState(() {
  //       liveList = resp.list!;
  //     });
  //   } else {
  //     TxUtils.showErrorToast(resp.desc, context);
  //   }
  }

  goRoomInfoPage( roomInfo) async {
    String? loginUserId = userId;
    if (roomInfo.userId.toString() == loginUserId) {
      Navigator.pushReplacementNamed(
        context,
        "/liveRoom/roomAnchor",
        arguments: {
        'liveId': roomInfo.liveId,
        "userId": roomInfo.userId,
        "roomName": roomInfo.roomName,
        "userName": roomInfo.userName,
        'isHost': roomInfo.isHost, 
        'liveStatus':roomInfo.liveStatus,
        'isNeedCreateRoom': false,
        },
      );
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      "/liveRoom/roomAudience",
      arguments: {
        'liveId': roomInfo.liveId,
        "userId": roomInfo.userId,
        "roomName": roomInfo.roomName,
        "userName": roomInfo.userName,
        'isHost': roomInfo.isHost, 
        'liveStatus':roomInfo.liveStatus,
        'isNeedCreateRoom': true,

      },
    );
  }

  Widget buildRoomInfo(info) {
    return InkWell(
      onTap: () {
        goRoomInfoPage(info);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: NetworkImage(
                    getAvatarUrlFromUserId(info.userId)
                  ),
                  fit: BoxFit.fitWidth,
                )),
          ),
          Positioned(
            left: 10,
            right: 8,
            top: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                  constraints: BoxConstraints(maxWidth: 140),
                  child: Text(
                    Languages.of(context)!.onLineCount(info.memberCount!),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 35,
            left: 8,
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (info.userName == null ? info.ownerId : info.userName)!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 8,
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (info.roomName == null ? "--" : info.roomName)!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int roomCount = liveList.length;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "video interaction",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () async {
              Navigator.pushReplacementNamed(
                context,
                "/index",
              );
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.contact_support,
                color: Colors.black,
              ),
              tooltip: Languages.of(context)!.helpTooltip,
              onPressed: () {
                this.openUrl(
                    'https://cloud.tencent.com/document/product/647/57388');
              },
            ),
          ]),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(
            context,
            "/index",
          );
          return true;
        },
        child: Container(
          child: EasyRefresh(
            header: ClassicalHeader(
              refreshText: Languages.of(context)!.refreshText,
              refreshReadyText: Languages.of(context)!.refreshReadyText,
              refreshingText: Languages.of(context)!.refreshingText,
              refreshedText: Languages.of(context)!.refreshedText,
              showInfo: false,
            ),
            emptyWidget: roomCount <= 0
                ? Center(
                    child: Text(
                      "No video interactive live room",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : null,
            onRefresh: () async {
              print('onRefresh');
              getRoomList();
            },
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //Grid按两列显示
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        var info = liveList[index];
                        return buildRoomInfo(info);
                      },
                      childCount: roomCount,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushReplacementNamed(
            context,
            "/liveRoom/roomAnchor",
            arguments: {
              'isNeedCreateRoom': true,
            },
          )
        },
        tooltip: "Create a Video Live Room",
        child: Icon(Icons.add),
      ),
    );
  }
}
