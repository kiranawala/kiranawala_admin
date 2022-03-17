import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-barcode-lookup.dart';

import '../main.dart';

class AlgoliaApplication {
  static final Algolia algolia = Algolia.init(
    applicationId: '9O18BA0LFN',
    apiKey: '026b89dcc31cb40b79ee51e48974ff05',
  );
}

class AlgoliaSearchPage extends StatefulWidget {
  const AlgoliaSearchPage({Key key}) : super(key: key);
  @override
  _AlgoliaSearchPageState createState() => _AlgoliaSearchPageState();
}

class _AlgoliaSearchPageState extends State<AlgoliaSearchPage> {
  final GlobalKey<ScaffoldState> _searchPageState = GlobalKey<ScaffoldState>();

  TextEditingController searchTextController = TextEditingController();



  Algolia algolia = AlgoliaApplication.algolia;
  AlgoliaQuerySnapshot snap;
  List<AlgoliaObjectSnapshot> AlgoliaSearchResults = new List();



  @override
  void initState()  {
    super.initState();
    searchTextController.text = 'corn flour';
    AlgoliaSearch();


  }

  int productsFound = 0;
  Future<void> AlgoliaSearch() async {
    ///
    /// Perform Query
    ///
    AlgoliaQuery query = algolia.instance.index('dev_PRODS').search(searchTextController.text.toString());

//    // Perform multiple facetFilters
//    query = query.setFacetFilter('status:published');
//    query = query.setFacetFilter('isDelete:false');

    // Get Result/Objects
    snap = await query.getObjects();
    setState(() {
      productsFound = snap.nbHits;
      print("Products Found:" + productsFound.toString());
      print(snap);
      AlgoliaSearchResults = snap.hits;
      AlgoliaSearchResults.forEach((element) {
//        print(element.data);
        print(element.data['name']);
      });
    });


    // Checking if has [AlgoliaQuerySnapshot]
    print('Hits count: ${snap.nbHits}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
        icon:Icon(Icons.keyboard_backspace),
              onPressed: (){
              },
    ),
    title:Text(
    'Search Results',
    style:TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    fontSize: 20.0
    ),
    ),
    centerTitle: true,
    ),

    body:Column(
      children: <Widget>[
        Expanded(
          flex:2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
            child: Container(
              child: TextField(
                controller: searchTextController,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.number,
                style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight:FontWeight.bold,
                  fontSize: 30.0,
                  color:Colors.black,
                ),
                autofocus: true,
                textAlign: TextAlign.center,
                cursorColor: Colors.black,
                cursorWidth: 8.0,
                decoration: InputDecoration(
                    hintText: 'Search String',
                    hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
                onChanged: (value) {
                  AlgoliaSearch();
                },
                onSubmitted: (value){
//                            print('discount submitted');
                },
              ),
            ),
          ),
        ),
Expanded(
  flex:20,
  child:
      ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: AlgoliaSearchResults.length,
              itemBuilder: (BuildContext context, int index){
                return
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color:Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child:Text('SKU:')
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    child:Text(AlgoliaSearchResults[index].data['productcode'].toString())
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child:Text('Barcode:')
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    child:Text(AlgoliaSearchResults[index].data['barcode'].toString())
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child:Text('Name')
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    child:Text(AlgoliaSearchResults[index].data['name'].toString())
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child:Text('MRP')
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    child:Text(AlgoliaSearchResults[index].data['price'].toString())
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child:Text('Category')
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    child:Text(AlgoliaSearchResults[index].data['category'].toString())
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child:Text('Brand')
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    child:Text(AlgoliaSearchResults[index].data['brand'].toString())
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child:Text('Image URL')
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    child:Text(AlgoliaSearchResults[index].data['imageurl'].toString())
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
              }
      ),
    )
    ]
)
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}