import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';

import '../main.dart';

class ResetStoreStatus extends StatefulWidget {
  @override
  _ResetStoreStatusState createState() => _ResetStoreStatusState();
}

class _ResetStoreStatusState extends State<ResetStoreStatus> {
  @override
  Widget build(BuildContext context) {
    if(storeResetSuccessful)
      return Container(
        color:Colors.white,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:  CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: getTextWidget('RESET SUCCESSFUL', 20.0, Colors.black))),
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
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: getTextWidget('GO HOME', 20.0, Colors.white))),
              ),
            ),
          ],
        )
      );
    else
      {
        return Container(
            color:Colors.white,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:  CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: getTextWidget('RESET FAILED', 20.0, Colors.black))),
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
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: getTextWidget('GO BACK', 20.0, Colors.white))),
                  ),
                ),
              ],
            )
        );
      }
  }
}
