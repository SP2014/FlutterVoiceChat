import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:voice_chat/models/msg.dart';
import 'package:voice_chat/widgets/bottom_input.dart';
import 'package:voice_chat/widgets/msg_box.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var msgList = [];
  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();

  @override
  void initState() {
    _myPlayer.openAudioSession().then((value) {
      setState(() {
        //_mPlayerIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _myPlayer.closeAudioSession();
    _myPlayer = null;
    super.dispose();
  }

  Future<void> playRecording(String uri) async {
    _myPlayer.startPlayer(
      fromURI: uri,
      codec: Codec.aacADTS,
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return KeyboardSizeProvider(
      smallSize: 500.0,
      child: Scaffold(
          body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 90,
                color: Color.fromRGBO(34, 153, 99, 1),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 58.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ListView.builder(
                      reverse: true,
                      itemCount: msgList.length,
                      itemBuilder: (context, index) {
                        final item = msgList[index];
                        final prevItem = index > 0 ? msgList[index - 1] : null;
                        final bool removeTopMargin =
                            index > 0 && (item.toMe == prevItem.toMe);
                        final double twentyPercent =
                            MediaQuery.of(context).size.width * 0.2;
                        return Container(
                            margin: EdgeInsets.only(
                                left: item.toMe ? 10.0 : twentyPercent,
                                right: item.toMe ? twentyPercent : 10.0,
                                bottom: removeTopMargin ? 0.0 : 5.0,
                                top: 5.0),
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 2.0),
                            width: 100.0,
                            decoration: BoxDecoration(
                                color: item.toMe
                                    ? Colors.white
                                    : Color.fromRGBO(220, 248, 200, 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(51, 51, 51, 0.6),
                                      blurRadius: 0.0,
                                      offset: Offset(0, 0))
                                ]),
                            child: Column(
                              mainAxisAlignment: item.toMe
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      MessageBox(
                                        onClick:
                                            (AnimationController controller) {
                                              
                                          _myPlayer.startPlayer(
                                            fromURI: item.path,
                                            codec: Codec.aacADTS,
                                            whenFinished: () => controller.reverse()
                                          );
                                          // playRecording(item.path)
                                          //     .whenComplete(() {
                                          //       print("i completed");
                                          //   if(controller.isCompleted) controller.reverse();
                                          // });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        item.timestamp,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      !item.toMe
                                          ? Icon(Icons.done_all,
                                              size: 16, color: Colors.grey)
                                          : Container()
                                    ])
                              ],
                            ));
                      }),
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: BottomInput(
                width: width,
                height: height,
                onAudioSend: (String path) {
                  setState(() {
                    msgList.add(Msg(
                        path: path,
                        toMe: false,
                        timestamp: "${DateTime.now().millisecondsSinceEpoch}"));
                  });
                },
                onAudioCancel: () {},
              )),
        ],
      )),
    );
  }
}
