import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/reset-store-status.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';

import '../main.dart';
import 'select-store.dart';

class ResetStore extends StatefulWidget {
  @override
  _ResetStoreState createState() => _ResetStoreState();
}

class _ResetStoreState extends State<ResetStore> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:getTextWidget('RESET STORE', 20.0, Colors.white),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon:Icon(Icons.keyboard_backspace),
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
              return ShowHomePage();
            }));
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: getTextWidget('RESET STORE', 20.0, Colors.black))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: getTextWidget(selectedStore, 20.0, Colors.white))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                  width: MediaQuery.of(context).size.width,
                  child: Center(child: getTextWidget('ARE YOU SURE?', 20.0, Colors.black))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  color:Colors.blue,
                  onPressed: (){
                    FirebaseDatabase
                        .instance
                        .reference()
                        .child('stores')
                        .child(selectedStore)
                        .remove()
                        .then((value) {
                          print(selectedStore + ' HAS BEEN RESET');
                          storeResetSuccessful = true;
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                            builder: (BuildContext context){
                              return ResetStoreStatus();
                            }
                          ));
                        }).catchError((dynamic error) {
                          print(selectedStore + ' COULD NOT BE RESET');
                          storeResetSuccessful = false;
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                              builder: (BuildContext context){
                                return ResetStoreStatus();
                              }
                          ));
                        });
                  },
                  child:Center(child: getTextWidget('YES', 20.0, Colors.white))
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  color:Colors.blue,
                  onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return ShowHomePage();
                          }
                      ));
                  },
                  child:Center(child: getTextWidget('NO', 20.0, Colors.white))
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: getTextWidget('', 20.0, Colors.black))),
            ),
          ],
        ),
      ),
    );
  }
}
