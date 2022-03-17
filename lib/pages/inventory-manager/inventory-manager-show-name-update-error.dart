import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';

class ShowNameUpdateError extends StatefulWidget {
  @override
  _ShowNameUpdateErrorState createState() => _ShowNameUpdateErrorState();
}

class _ShowNameUpdateErrorState extends State<ShowNameUpdateError> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context){
              return ProductLookupResults();
            }
          )
        );
        return;
      },
      child:Scaffold(
        body:Container(
          color:Colors.white,
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('PRODUCT NAME UPDATE FAILED'),
                Text('Please try again')
          ],
        )
      )
      )
    );
  }
}
