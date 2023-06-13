import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class game_page3 extends StatefulWidget {
  const game_page3({Key? key}) : super(key: key);

  @override
  State<game_page3> createState() => _game_page3tate();
}

class _game_page3tate extends State<game_page3> with WidgetsBindingObserver {
  bool staus = false;
  bool musicplay = false;
  bool replay = false;
  int cnt = 0;
  List<String> someImages = [];
  String show_image = "";
  String answer = "";
  List anslist = [];
  List bottomlist = [];
  bool win = false;

  // int imgnum = 3;
  List filled_anslist = [];
  Map map = {};
  FlutterTts flutterTts = FlutterTts();
  AudioPlayer myplayer = AudioPlayer();
  List<String> clear_level = [];
  int random_num = 0;
  SharedPreferences? pref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getpref();
    getimageslist();
    // initPlay();
    // Play_music();
    // paush_music();
    // close_music();
  }

  Future<void> initPlay() async {
    print("play music");
    await myplayer.setAsset("music_player/easy-lifestyle-137766.mp3");
    // myplayer.setLoopMode(LoopMode.one);
  }

  Future<void> Play_music() async {
    await myplayer.play();
  }

  Future<void> paush_music() async {
    await myplayer.pause();
  }

  Future<void> stop_music() async {
    await myplayer.stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print("state===$state");
    if (state == AppLifecycleState.paused) {
      paush_music();
    } else if (state == AppLifecycleState.resumed) {
      Play_music();
      // initPlay().then((value) => Play_music());
    }
  }

  int a = -1;

  Future<void> getimageslist() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('myImages/'))
        .where((String key) => key.contains('.jpg'))
        .toList();

    setState(() {
      someImages = imagePaths;
    });
    print("==$someImages");
    random_num = Random().nextInt(someImages.length);
    print("ranodom_num==$random_num");
    // imgnum = random_num;

    clear_level = pref!.getStringList("levelnum") ?? [];
    print("clear level list==$clear_level");

    while (clear_level.contains("$random_num")) {
      print("object");
      random_num = Random().nextInt(someImages.length);
      print("new random num===$random_num");
      if (clear_level.length == someImages.length) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Yupp!"),
              content: Text("You have Done this game "),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                "Are you sure, you want to Reply this game"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    print("object  hear");
                                    Navigator.pop(context);
                                    setState(() {
                                      clear_level.clear();
                                      pref!.setStringList(
                                          "levelnum", clear_level);
                                      print("list==$clear_level");
                                      getimageslist();
                                    });
                                  },
                                  child: Text("yes")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    exit(0);
                                  },
                                  child: Text("No"))
                            ],
                          );
                        },
                      );
                      // Navigator.pop(context);
                      // exit(0);
                    },
                    child: Text("OK"))
              ],
            );
            // return Lottie.asset("Animation/winner.json");
          },
        );
        break;
      }
    }

    show_image = someImages[random_num];
    // show_image = someImages[imgnum];
    // show_image = "myImages/apple.jpg";
    print("imges==$show_image");

    staus = true;
    answer = show_image.split("/")[1].split("\.")[0];
    print("answer==$answer");
    anslist = answer.split("");
    print("anslist=$anslist");

    filled_anslist = List.filled(anslist.length, "");

    String abcd = "abcdefghijklmnopqrstuvwxyz";
    List abcdlist = [];
    abcdlist = abcd.split("");
    print("abcdlist==$abcdlist");
    abcdlist.shuffle();
    print("abcdlist shuffle=$abcdlist");

    bottomlist = abcdlist.getRange(0, 10 - anslist.length).toList();
    bottomlist.addAll(anslist);
    bottomlist.shuffle();
    bottomlist.insert(5, "");
    bottomlist.insert(11, "");
    print("bottomlist 3==$bottomlist");

    print("anslist-----$anslist");

    staus = true;

  }

  bool ansindex = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> getpref() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height -
        MediaQuery
            .of(context)
            .padding
            .top -
        MediaQuery
            .of(context)
            .padding
            .bottom;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    print('w = $width');
    print('h = $height');
    print("appbar height = $kToolbarHeight");
    print("height = ${height}");
    print("height = ${height * 0.5}");
    if (staus) {
      return SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              if (win) Lottie.asset("Animation/125119-confeti.json"),
              Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                        height: min(height * 0.5, width * 0.6),
                        width: min(height * 0.5, width * 0.6),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("$show_image"),
                                fit: BoxFit.fill))),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Flexible(
                          child: Container(
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.black)),
                            // width: anslist.length*width*0.07,
                            width: anslist.length *
                                max(height * 0.1, width * 0.07),
                            // width: max(height * 0.5, width * 0.5),
                            // width: max(height*0.5, width*0.45),
                            // width: anslist.length == 3
                            //     ? max(height * 0.3, width * 0.25)
                            //     : anslist.length == 4
                            //         ? max(height * 0.37, width * 0.27)
                            //         : anslist.length == 5
                            //             ? max(height * 0.5, width * 0.4)
                            //             : anslist.length == 6
                            //                 ? max(height*0.5, width*0.45)
                            //                 : anslist.length == 7
                            //                     ? max(height * 0.6, width * 0.5)
                            //                     : anslist.length == 8
                            //                         ? max(height * 0.65,
                            //                             width * 0.6)
                            //                         : anslist.length == 9
                            //                             ? max(height * 0.65, width * 0.7)
                            //                             : max(height * 0.65, width * 0.8),
                            // height: max(height * 0.08, width * 0.08),
                            // height: max(height * 0.095, width * 0.07),
                            // height:anslist.length == 3
                            //     ? max(height * 0.1, width * 0.08)
                            //     : anslist.length == 4
                            //     ? max(height * 0.09, width * 0.065)
                            //     : anslist.length == 5
                            //     ? max(height * 0.1, width * 0.1)
                            //     : anslist.length == 6
                            //     ? max(height * 0.095, width * 0.07)
                            //     : anslist.length == 7
                            //     ? max(height * 0.08, width * 0.07)
                            //     : anslist.length == 8
                            //     ? max(height * 0.075,
                            //     width * 0.075)
                            //     : anslist.length == 9
                            //     ? max(height * 0.075,
                            //     width * 0.075)
                            //     : max(height * 0.075,
                            //     width * 0.075),
                            // 2. idea
                            // anslist na length accroding height width fix karava mate row levi pade ane ani andar container ni fix height-width aapi devani,
                            //jem anslist ni length vadhse tem box add thata jase size ek j raheshe.
                            margin: EdgeInsets.only(
                                top: height * 0.05, bottom: height * 0.03),
                            child: GridView.builder(
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: filled_anslist.length,
                                  crossAxisSpacing: 5),
                              itemCount: filled_anslist.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      for (int i = 0;
                                      i < filled_anslist.length;
                                      i++) {
                                        if (filled_anslist != "") {
                                          if (bottomlist[map[index]] == "") {
                                            print(
                                                "${filled_anslist[index]}  === $index");
                                            bottomlist[map[index]] =
                                            filled_anslist[index];
                                            filled_anslist[index] = "";
                                          }
                                          if (filled_anslist != anslist) {
                                            win = false;
                                          }
                                          if(filled_anslist.contains('')){
                                            bb=false;
                                          }
                                          // if(filled_anslist.contains('')&&!listEquals(filled_anslist, anslist)) {
                                          //   print("+++??");
                                          //   bb=false;
                                          // } else{
                                          //   print("&&&&");
                                          //   bb=true;
                                          // }
                                          print(
                                              "filled anslist==$filled_anslist");
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    // color: anslist[index]==filled_anslist[index]  && ansindex? Colors.green : Colors.yellow,
                                      color:
                                      bb?Colors.red:anslist[index] == filled_anslist[index]
                                          ? Colors.green
                                          : Colors.yellow,

                                      child: Center(
                                  child: Text(
                                  filled_anslist[index]
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: max(
                                          height * 0.03, width * 0.022)),
                                )),
                                )
                                ,
                                );
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            // height: min(height*0.3, height*0.4),width: max(height*0.2, height*0.9),
                            height: max(height * 0.19, width * 0.14),
                            width: max(height * 0.5, width * 0.35),
                            child: GridView.builder(
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing:
                                  min(height * 0.01, width * 0.01),
                                  crossAxisSpacing:
                                  min(height * 0.01, width * 0.01),
                                  crossAxisCount: 6),
                              itemCount: bottomlist.length,
                              itemBuilder: (context, index) {
                                if (index == 5) {
                                  return InkWell(
                                    onTap: () {
                                      print("click");
                                      flutterTts.speak(answer);
                                      cnt++;
                                      if (cnt > 2) {
                                        flutterTts.speak(anslist.toString());
                                      }
                                    },
                                    child: Container(
                                      color: Colors.orange,
                                      child: Icon(Icons.volume_up),
                                    ),
                                  );
                                } else if (index == 11) {
                                  return InkWell(
                                    onTap: () {
                                      print("object");
                                      setState(() {
                                        a = filled_anslist.indexOf("");
                                        print("a===$a");
                                      });
                                    },
                                    child: Container(
                                      color: Colors.orange,
                                      child: Icon(Icons.lightbulb),
                                    ),
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      print('log: $filled_anslist === $anslist');
                                      setState(() {
                                        for (int i = 0;
                                        filled_anslist[i] != "";
                                        i++) {
                                          if (filled_anslist[i] == anslist[i]) {
                                            ansindex = true;
                                          } else {
                                            ansindex = false;
                                            break;
                                          }
                                        }
                                        for (int i = 0;
                                        i < anslist.length;
                                        i++) {
                                          if (filled_anslist[i] == "") {
                                            filled_anslist[i] =
                                            bottomlist[index];
                                            map[i] = index;
                                            print("map==$map");
                                            bottomlist[index] = "";
                                            if (listEquals(
                                                filled_anslist, anslist)) {
                                              win = true;
                                              a = -1;
                                              clear_level.add("$random_num");
                                              pref!.setStringList(
                                                  "levelnum", clear_level);
                                              Future.delayed(
                                                  Duration(seconds: 2))
                                                  .then((value) {
                                                print("val==$value");
                                                getimageslist();
                                                win = false;
                                              });
                                              // showDialog(
                                              //   context: context,
                                              //   builder: (context) {
                                              //     Future.delayed(Duration(
                                              //             seconds: 2))
                                              //         .then((value) {
                                              //       Navigator.pop(context);
                                              //     });
                                              //     return Lottie.asset(
                                              //         "Animation/9651-winner (1).json");
                                              //   },
                                              // );
                                              // Lottie.asset('Animation/125119-confeti.json');
                                              print("won");
                                            }
                                            break;
                                          }
                                        }
                                        if(!listEquals(filled_anslist, anslist)) {
                                          if(filled_anslist.contains('')) {
                                            bb=false;
                                          } else {
                                            bb=true;
                                          }
                                        }
                                        // if(filled_anslist.contains('')&&!listEquals(filled_anslist, anslist)) {
                                        //   print("+++??");
                                        //   bb=false;
                                        // } else if(!listEquals(filled_anslist, anslist)){
                                        //   print("&&&&");
                                        //   bb=true;
                                        // }
                                      });
                                    },
                                    child: Container(
                                      color: a != -1 &&
                                          bottomlist[index] == anslist[a]
                                          ? Colors.pink
                                          : Colors.indigo,
                                      child: Center(
                                        child: Text(
                                            bottomlist[index]
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: max(height * 0.03,
                                                    width * 0.022))),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
  bool bb = false;
}
