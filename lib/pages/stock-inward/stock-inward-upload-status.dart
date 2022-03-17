import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-all-categories.dart';

class StockInwardUploadStatus extends StatefulWidget {
  @override
  _StockInwardUploadStatusState createState() => _StockInwardUploadStatusState();
}

class _StockInwardUploadStatusState extends State<StockInwardUploadStatus> {
  @override
  Widget build(BuildContext context) {

    if(stockInwardUploadSuccessful)
      {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.keyboard_backspace),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return StockInwardShowAllCategories();
                          }
                      )
                  );
                },


              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('STOCK INWARD UPLOAD',
                  style:TextStyle(
                      fontFamily:'Montserrat',
                      fontSize:18.0,
                      fontWeight:FontWeight.bold,
                      color:Colors.white
                  )
              ),
            ),
            body:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                      'SUCCESS',
                      style:TextStyle(
                          fontFamily:'Montserrat',
                          fontSize:30.0,
                          fontWeight:FontWeight.bold,
                          color:Colors.black
                      )
                  ),
                )
              ],
            )
        );
      }
    else
      {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.keyboard_backspace),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return StockInwardShowAllCategories();
                          }
                      )
                  );
                },


              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('STOCK INWARD UPLOAD',
                  style:TextStyle(
                      fontFamily:'Montserrat',
                      fontSize:18.0,
                      fontWeight:FontWeight.bold,
                      color:Colors.white
                  )
              ),
            ),
            body:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                      'FAILURE',
                      style:TextStyle(
                          fontFamily:'Montserrat',
                          fontSize:30.0,
                          fontWeight:FontWeight.bold,
                          color:Colors.black
                      )
                  ),
                )
              ],
            )
        );
      }

  }
}
