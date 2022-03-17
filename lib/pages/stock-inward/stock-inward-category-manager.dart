import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-home-page.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-name-lookup.dart';
import '../check-if-admin.dart';

class StockInwardCategoryManager extends StatefulWidget {
  @override
  _StockInwardCategoryManagerState createState() => _StockInwardCategoryManagerState();
}

class _StockInwardCategoryManagerState extends State<StockInwardCategoryManager> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(categoryIndexCategoryDetailsMap.length);

    categoryStatus = new Map<int, String>();
    for(int i= 0 ;i < categoryIndexCategoryDetailsMap.length;i++)
      {
        print(categoryIndexCategoryDetailsMap[i]['isActive']);
        categoryStatus[i] = categoryIndexCategoryDetailsMap[i]['isActive'];
      }

    barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
    lookupMap = Map<int,ProductBasicDetails>();

    activeProductBasicDetailsList.forEach((element) {
      barCodeSearchResultsMap[element.productID] = element;
      lookupMap[element.productID] = element;
    });

    barCodeSearchResults = List<ProductBasicDetails>();
    lookupList = List<ProductBasicDetails>();

    barCodeSearchResultsMap.forEach((key, value) {
      barCodeSearchResults.add(value);
      lookupList.add(value);
    });

  }
  @override
  Widget build(BuildContext context) {
    print(homeCategories.length);
    return Scaffold(
      appBar: AppBar(
//        centerTitle: true,
        automaticallyImplyLeading: false,
//        title: Text('KONDAPUR',
//            style:TextStyle(
//                fontFamily: 'Montserrat',
//                fontSize:18.0,
//                fontWeight: FontWeight.bold,
//                color:Colors.white
//            )),
        actions: <Widget>[
          IconButton(
              onPressed:(){
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context){
                          return StockInwardHomePage();
                        }
                    )
                );
              },
              icon:Icon(Icons.home)
          ),
          IconButton(
              onPressed:(){
                print('opening barcode scanner');


                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context){
                          return StockInwardProductNameLookUp();
                        }
                    )
                );
              },
              icon:Icon(Icons.scanner)
          ),
          IconButton(
            onPressed:(){
              print('Adding Product(No BarCode');
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context){
                        return null;
//                        return StockInwardAddNewProductWithoutBarcode();
                      }
                  )
              );

            },
            icon:Icon(Icons.add_box),
            tooltip: 'WITHOUT BARCODE',
          ),
          IconButton(
            onPressed:(){
              print('Adding Product(With BarCode');
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context){
                        return null;
//                        return StockInwardAddNewProductWithBarcode();
                      }
                  )
              );

            },
            icon:Icon(Icons.add_photo_alternate),
            tooltip: 'WITHOUT BARCODE',
          ),
          IconButton(
              onPressed:(){
                print('STARTING PRODUCT SEARCH');

                barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
                lookupMap = Map<int,ProductBasicDetails>();

                fullProductBasicDetailsMap.forEach((key,value) {
                  if(value.productStatus == 'ACTIVE')
                  {
                    barCodeSearchResultsMap[value.productID] = value;
                    lookupMap[value.productID] = value;
                  }
                });

                barCodeSearchResults = List<ProductBasicDetails>();
                lookupList = List<ProductBasicDetails>();

                barCodeSearchResultsMap.forEach((key, value) {
                  barCodeSearchResults.add(value);
                  lookupList.add(value);
                });

                barCodeSearchResults.sort((a,b){
                  return (
                      a.productName.compareTo(b.productName)
                  );
                });

                lookupList.sort((a,b){
                  return (
                      a.productName.compareTo(b.productName)
                  );
                });

                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context){
                          return StockInwardProductNameLookUp();
                        }
                    )
                );
              },
              icon:Icon(Icons.search)
          )
        ],
      ),
      body: ListView.builder(
        itemCount:categoryIndexCategoryDetailsMap.length,
        itemBuilder: (BuildContext context, int index){
          return Row(
            children: <Widget>[
              Expanded(
                flex:9,
                child:  Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FlatButton(
                    color:Colors.blue,
                    child: Text(
                      categoryIndexCategoryDetailsMap[index]['displayName'],
                      style: TextStyle(
                          color:Colors.white,
                          fontWeight:FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize:24.0
                      ),
                    ),
                    onPressed: (){
                      selectedCategoryName = categoryIndexCategoryDetailsMap[index]['categoryName'];
                      Navigator.of(context).pop(selectedCategoryName);
                    },
                  ),
                ),
              ),
              Expanded(
                flex:1,
                child: Switch(
                  value: ((categoryIndexCategoryDetailsMap[index]['isActive'] == "YES")? true:false),
                  onChanged: (value){
                    print(value);
//                    print(categorySearchResults[index].categoryName.toString() + ':' + value.toString());
//                    categoryStatus[index] = value;
                    if(value) {
                      categoryIndexCategoryDetailsMap[index]['isActive'] =
                          "YES";
                    }
                    else {
                      categoryIndexCategoryDetailsMap[index]['isActive'] =
                          "NO";
                    }

                    print(categoryIndexCategoryDetailsMap[index]['isActive']);

                    print(index);

                    FirebaseDatabase.instance
                        .reference()
                        .child('stores')
                        .child(productNode)
                        .child('categoriesMaster')
                        .child(index.toString())
                        .child('isActive')
                        .set(categoryIndexCategoryDetailsMap[index]['isActive'])
                        .then((snapshot) {
                      print('Category Status updated successfully');
                    });
                    setState(() {

                    });
                  },
                  activeTrackColor: Colors.lightGreen,
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.redAccent,
                ),
              ),
            ],

          );
        },
      ),
    );
  }
}


