import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-daily-sale-between-dates.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-single-store.dart';

import '../check-if-admin.dart';

class SalePositionShowDailySaleBetweenDateSelectStore extends StatefulWidget {
  @override
  _SalePositionShowDailySaleBetweenDateSelectStoreState createState() => _SalePositionShowDailySaleBetweenDateSelectStoreState();
}

class _SalePositionShowDailySaleBetweenDateSelectStoreState extends State<SalePositionShowDailySaleBetweenDateSelectStore> {
  List<String> storeSearchResults = stores;
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: (){
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context){
                    return SalePositionShowDailySaleBetweenDates();
                  }
              )
          );
          return;
        },
        child: Scaffold(appBar:
        AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context){
                        return SalePositionShowDailySaleBetweenDates();
                      }
                  )
              );
            },
          ),
          title:Text('SELECT STORE',
              style:TextStyle(
                fontSize:20.0,
                color:Colors.white
              ),
          ),
        ),
            body:Column(
                children:<Widget>[
                  Expanded(
                    flex:2,
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'Search Store...',
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:24.0,
                              fontWeight: FontWeight.bold,
                              color:Colors.black
                          )
                      ),
                      onChanged: (value){
                        print(value);
                        if(value.isNotEmpty)
                        {
                          storeSearchResults = [];
                          stores.forEach((x){
                            if(x.toLowerCase().contains(value.toLowerCase()))
                            {
                              storeSearchResults.add(x);
                              print(storeSearchResults);
                            }
                          });
                        }
                        else
                        {
                          storeSearchResults = stores;
                        }
                        setState(() {

                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex:20,
                    child: Container(
                      child: ListView.builder(
                        itemCount:storeSearchResults.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FlatButton(
                              color:Colors.blue,
                              child: Text(
                                storeSearchResults[index],
                                style: TextStyle(
                                    color:Colors.white,
                                    fontWeight:FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    fontSize:24.0
                                ),
                              ),
                              onPressed: (){
                                selectedStore = storeSearchResults[index];
                                print('Seleced Store:' + selectedStore);
                                Navigator.of(context).pop();
                                Navigator.of(context).push<dynamic>(
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context){
                                      return SalePositionShowDailySaleBetweenDates();
                                    }
                                  )
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ]
            )
        ),
      );  }
}
