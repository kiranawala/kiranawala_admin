import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/reset-store.dart';
import 'package:kiranawala_admin/pages/select-store.dart';

import 'request-name.dart';
import 'show-lyrics.dart';

//List<Map<String, String>> actors = List<Map<String, String>>();

class SinimaHomePage extends StatefulWidget {
  @override
  _SinimaHomePageState createState() => _SinimaHomePageState();
}

class _SinimaHomePageState extends State<SinimaHomePage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: getTextWidget('ADMIN OPTIONS', 20.0, Colors.black))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  requestNameAndAddToSINIMA('PRODUCERS');
                },
                child: Center(
                    child: getTextWidget(
                        'ADD PRODUCER',
                        20.0,
                        Colors.white))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  requestNameAndAddToSINIMA('DIRECTORS');
                },
                child: Center(
                    child: getTextWidget(
                        'ADD DIRECTOR',
                        20.0,
                        Colors.white))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  requestNameAndAddToSINIMA('SINGERS');
                },
                child: Center(
                    child: getTextWidget(
                        'ADD SINGER',
                        20.0,
                        Colors.white))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  requestNameAndAddToSINIMA('LYRICISTS');
                },
                child: Center(
                    child: getTextWidget(
                        ''
                        'ADD LYRICIST',
                        20.0,
                        Colors.white))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  requestNameAndAddToSINIMA('BANNERS');
                },
                child: Center(
                    child: getTextWidget(
                        ''
                        'ADD BANNER',
                        20.0,
                        Colors.white))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  requestNameAndAddToSINIMA('MUSIC-DIRECTORS');
                },
                child: Center(
                    child: getTextWidget(
                        'ADD MUSIC DIRECTOR',
                        20.0,
                        Colors.white))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  requestNameAndAddToSINIMA('ACTORS');
                },
                child: Center(
                    child: getTextWidget(
                        'ADD ACTOR',
                        20.0,
                        Colors.white))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  requestNameAndAddToSINIMA('MOVIES');
                },
                child: Center(
                    child: getTextWidget(
                        'ADD MOVIE',
                        20.0,
                        Colors.white))),
          ),
        ],
      ),
    );
  }

  void requestNameAndAddToSINIMA(String type){
    Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) {
              return RequestName();
            })).then((dynamic name) {
      if (name != null) {
        print(name.toString());
        FirebaseDatabase.instance
            .reference()
            .child('SINIMA')
            .child(type)
            .once()
            .then((snapshot) {
          if (snapshot != null &&
              snapshot.value != null) {
            print(snapshot.value);
            List<Map<String, String>> names = List<Map<String, String>>();
            List<dynamic> actorsList = snapshot.value;
            actorsList.forEach((dynamic element) {
              print(element['name']);
              names.add({
                'name':element['name']
              });
            });
            names.add({'name':name});
            print(names);
            FirebaseDatabase
                .instance
                .reference()
                .child('SINIMA')
                .child(type)
                .set(names);
          } else {
            List<Map<String, String>> names = List<Map<String, String>>();
            names.add(<String, String>{
              'name': name
            });
            print(names);
            FirebaseDatabase
                .instance
                .reference()
                .child('SINIMA')
                .child(type)
                .set(names);
          }
        });
      }
    });

    }
}
