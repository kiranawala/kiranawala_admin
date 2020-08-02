import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';

class ShowLyrics extends StatefulWidget {
  @override
  _ShowLyricsState createState() => _ShowLyricsState();
}

class _ShowLyricsState extends State<ShowLyrics> {
  String lyrics = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    FirebaseStorage
//        .instance
//        .getReferenceFromUrl('gs://oshop-21421.appspot.com/SINIMA')
//        .then((value){
//          StorageReference storageRef = value;
//          storageRef.child('song-1.txt').getData(10000000).then((value){
//            print('getData:');
//            print(String.fromCharCodes(value));
//            lyrics = String.fromCharCodes(value);
//            setState(() {
//
//            });
//          });
//
//    });

    final ref = FirebaseStorage.instance
        .ref()
        .child('SINIMA')
        .child('song-1.txt').getDownloadURL().then((dynamic value){
          print(value);
          if(value != null)
            {
              print(value);
              DefaultCacheManager().getSingleFile(value).then((dynamic fetchedFile){
                print(fetchedFile.toString());
//                File file = new File(fetchedFile.path.toString());
//                    file.readAsLines().then((lines){
//                      lines.forEach((l) => print(l));
//                });
//
//              rootBundle.loadString(fetchedFile.path.toString()).then((value){
//                print(value);
//              });

                Stream<List<int>> stream = new File(fetchedFile.path.toString()).openRead();
                StringBuffer buffer = new StringBuffer();
                stream
                    .transform(utf8.decoder)
                    .transform(LineSplitter())
                    .listen((data) {
//                  print("Received: $data");
                  buffer.write(data + '\n');
                },
                    onDone: (){
                      print(buffer.toString());
                      lyrics = buffer.toString();
                      setState(() {
                      });
                    } ,
                    onError: (dynamic e) => print(e));
              });
            }
    });
//
//    var url = Uri.parse(await ref.ge);
//    print(url);
//
//    FirebaseStorage.instance.ref().child('SINIMA').getBucket().then((value){
//      print(value);
//    });
//    FirebaseDatabase
//        .instance
//        .reference()
//        .child('nilas1-pos1')
//        .child('song')
//        .once()
//        .then((songSnapshot){
//          print(songSnapshot);
//       if(songSnapshot != null && songSnapshot.value != null)
//         {
//           print(songSnapshot.value);
//           lyrics = songSnapshot.value;
//           setState(() {
//
//           });
//         }
//    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('LYRICS'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon:Icon(Icons.keyboard_backspace),
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder: (BuildContext context){
                return ShowHomePage();
              }
            ));
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                lyrics,
                style:TextStyle(
                    fontSize: 20.0,
                color:Colors.black
                )
//                  style: TextStyle(fontFamily:'Kohinoor-Bold'),
            ),
          )
        ],
      ),
    );
  }
}
