import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-no-barcode.dart';

import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-request-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-select-category.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-select-brand.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';


bool searchingBarCode = true;
String productLookupStore = '';
double salePositionForRequestedProduct = 0.0;
double stockInwardForRequestedProduct = 0.0;
double stockPositionForRequestedProduct = 0.0;

class ProductLookUp extends StatefulWidget {
  @override
  _ProductLookUpState createState() => _ProductLookUpState();
}

class _ProductLookUpState extends State<ProductLookUp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    productBrands = List<String>();
    productBrands.add('DURACELL');
    productBrands.add('LIJJAT');
    productBrands.add('SGR(777) FOODS');
    productBrands.add('LASER');
    productBrands.add('JABSONS');
    productBrands.add('SNACATAC');
    productBrands.add('DS SPICES');
    productBrands.add('ZYDUS WELLNESS');
    productBrands.add('HENNA GROUP');
    productBrands.add('DWIBHASHI');
    productBrands.add('LOHIYA');
    productBrands.add('PEPSI');
    productBrands.add('TOP RAMEN');
    productBrands.add('WEIKFIELD');
    productBrands.add('CONTINENTAL');
    productBrands.add('HATSUN');
    productBrands.add('AMUL');
    productBrands.add('CADBURY');
    productBrands.add('TIP-TOP KIRANA');
    productBrands.add('TIP-TOP HOMECARE');
    productBrands.add('PARLE');
    productBrands.add('EVEREST');
    productBrands.add('MTR');
    productBrands.add('BAMBINO');
    productBrands.add('SHANTI NAMKEENS');
    productBrands.add('MILKY MIST');
    productBrands.add('ID FRESH');
    productBrands.add('GRB');
    productBrands.add('PATANJALI');
    productBrands.add('BRITANNIA');
    productBrands.add('NIVEA');
    productBrands.add('FEM');
    productBrands.add('LOTUS');
    productBrands.add('BANJARAS');
    productBrands.add('NYCIL');
    productBrands.add('DENVER');
    productBrands.add('PARK AVENUE');
    productBrands.add('FOGG');
    productBrands.add('NAVRATNA');
    productBrands.add('DERMI COOL');
    productBrands.add('PRIYA');
    productBrands.add('LION');
    productBrands.add('GOLDDROP');
    productBrands.add('FREEDOM');
    productBrands.add('FORTUNE');
    productBrands.add('LOREAL');
    productBrands.add('VIJAYA');
    productBrands.add('HALDIRAMS');
    productBrands.add('HERITAGE');
    productBrands.add('KIRANAWALA');
    productBrands.add('UNIBIC');
    productBrands.add('KWALITY WALLS');
    productBrands.add('CYCLE');
    productBrands.add('SCTOCH-BRITE');
    productBrands.add('LG');
    productBrands.add('INDULEKHA');
    productBrands.add('BISLERI');
    productBrands.add('KINGFISHER');
    productBrands.add('MOGU MOGU');
    productBrands.add('SCHWEPPES');
    productBrands.add('DUKES');
    productBrands.add('PARRYS');
    productBrands.add('NESTLE');
    productBrands.add('FUNFOODS');
    productBrands.add('TATA');
    productBrands.add('ANOYA');
    productBrands.add('EVEREADY');
    productBrands.add('NIPPO');
    productBrands.add('LOTTE');
    productBrands.add('EPIGAMIA');
    productBrands.add('SUGAR FREE');
    productBrands.add('SRILALITHA');
    productBrands.add('INDIA GATE');
    productBrands.add('KOHINOOR');
    productBrands.add('DAAWAT');
    productBrands.add('PAMPERS');
    productBrands.add('MAMY POKO');
    productBrands.add('DURGA GHEE');
    productBrands.add('KELLOGGS');
    productBrands.add('AGROTECH');
    productBrands.add('UNANI');
    productBrands.add('HERSHEYS');
    productBrands.add('COLGATE-PALMOLIVE');
    productBrands.add('SCJOHNSON');
    productBrands.add('JOHNSONS');
    productBrands.add('SPENCERS');
    productBrands.add('CREATIVE MARKETING');
    productBrands.add('KARACHI BAKERY');
    productBrands.add('PROCTER & GAMBLE');
    productBrands.add('CELLO');
    productBrands.add('MONTEX');
    productBrands.add('NATRAJ');
    productBrands.add('APSARA');
    productBrands.add('CAMLIN');
    productBrands.add('LUXOR');
    productBrands.add('LINC');
    productBrands.add('DOMYOS');
    productBrands.add('GURU');
    productBrands.add('VICKY');
    productBrands.add('M-SEAL');
    productBrands.add('NANDINI');
    productBrands.add('PIDILITE');
    productBrands.add('PRIME QUALITY');
    productBrands.add('UNILEVER');
    productBrands.add('CAVINKARE');
    productBrands.add('RECKITT BENCKISER');
    productBrands.add('PERFETTI');
    productBrands.add('VCARE');
    productBrands.add('NISSINS');
    productBrands.add('VINI');
    productBrands.add('DABUR');
    productBrands.add('ITC');
    productBrands.add('HIMALAYA');
    productBrands.add('FLAIR');
    productBrands.add('PCI');
    productBrands.add('AVA');
    productBrands.add('EMAMI');
    productBrands.add('ECOF');
    productBrands.add('BAULI');
    productBrands.add('WRIGLEY');
    productBrands.add('MARS');
    productBrands.add('JYOTHY LABS');
    productBrands.add('GLAXO SMITHKLINE');
    productBrands.add('RASNA');
    productBrands.add('AJAY');
    productBrands.add('BUDWEISER');
    productBrands.add('STREAX');
    productBrands.add('AMRUTANJAN');
    productBrands.add('KEO KARPIN');
    productBrands.add('BAJAJ');
    productBrands.add('AMBICA');
    productBrands.add('VANESA');
    productBrands.add('RUCHI SOYA');
    productBrands.add('FERRARI');
    productBrands.add('WIPRO');
    productBrands.add('CAPITAL FOODS');
    productBrands.add('KARNATAKA SOAPS');
    productBrands.add('MARINO');
    productBrands.add('MARICO');
    productBrands.add('SWASTIK');
    productBrands.add('ANURAG');
    productBrands.add('LASER');
    productBrands.add('RED BULL');
    productBrands.add('HECTOR BEVERAGES');
    productBrands.add('ASWINI');
    productBrands.add('VICCO');
    productBrands.add('HEERA');

    productBrands.sort((dynamic a, dynamic b) {
      return a.compareTo(b);
    });


    productCategories = List<String>();
    productCategories.add('BREAD, CEREALS & OATS');
    productCategories.add('LEAFY VEG');
    productCategories.add('NON-LEAFY VEG');
    productCategories.add('LOOSE GROCERY');
    productCategories.add('FROZEN VEG');
    productCategories.add('FRUITS');
    productCategories.add('DALS');
    productCategories.add('WHOLE SPICES');
    productCategories.add('POWDERED SPICES');
    productCategories.add('BLENDED SPICES');
    productCategories.add('SOFT DRINKS');
    productCategories.add('ATTA');
    productCategories.add('RAVA');
    productCategories.add('RICE');
    productCategories.add('NOODLES & VERMICELLI');
    productCategories.add('SALT, SUGAR & JAGGERY');
    productCategories.add('COOKING PASTES');
    productCategories.add('MILK SHAKES');
    productCategories.add('FRUIT JUICES');
    productCategories.add('DRY FRUITS & NUTS');
    productCategories.add('TEA, COFFEE & WHITENERS');
    productCategories.add('COOKING OILS, DALDA & GHEE');
    productCategories.add('INSTANT FOOD & READY-TO-COOK');
    productCategories.add('STATIONERY & PARTY NEEDS');
    productCategories.add('BAKING');
    productCategories.add('SPREADS & SAUCES');
    productCategories.add('PICKLES');
    productCategories.add('FABRIC CARE');
    productCategories.add('ORAL CARE');
    productCategories.add('BATH & SHOWER');
    productCategories.add('FEMININE HYGIENE');
    productCategories.add('DISHWASH');
    productCategories.add('PEST CONTROL');
    productCategories.add('POOJA ITEMS');
    productCategories.add('HAIR CARE');
    productCategories.add('SHAVING NEEDS');
    productCategories.add('BEAUTY & MAKE-UP');
    productCategories.add('SURFACE & TOILET CLEANERS');
    productCategories.add('FRESH DAIRY & PRODUCTS');
    productCategories.add('PAPADS & FRYUMS');
    productCategories.add('HANDWASH & SANITIZER');
    productCategories.add('AIR FRESHENERS');
    productCategories.add('MEDICINES & SUPPLEMENTS');
    productCategories.add('WATER');
    productCategories.add('SNACKS');
    productCategories.add('ICE CREAMS & FROZEN DESSERTS');
    productCategories.add('HEALTH & NUTRITION DRINKS');
    productCategories.add('SHOE CARE');
    productCategories.add('DISPOSABLES');
    productCategories.add('CLEANING ACCESSORIES');
    productCategories.add('PAANWAALA');
    productCategories.add('PET CARE');
    productCategories.add('PLASTIC & STEEL WARE');
    productCategories.add('ELECTRICAL ACCESSORIES');

    productCategories.sort((dynamic a, dynamic b) {
      return a.compareTo(b);
    });

    salePositionForRequestedProduct = 0;
    stockInwardForRequestedProduct = 0;
    stockPositionForRequestedProduct = 0;
  }

  void getProductDetails()
  {

    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .orderByChild('barcode')
        .equalTo(barCodeToSearch)
        .once()
        .then((snapshot) {
      print(snapshot);
      print(snapshot.value);
      if (snapshot.value != null) {
//        barCodeSearchResults = new List<ProductBasicDetails>();
//        barCodeSearchResultsMap = new Map<int, ProductBasicDetails>();
        snapshot.value.forEach((dynamic key, dynamic value) {
          print(value);
          print(key);
          barCodeSearchResultsMap[num.parse(key)] = new ProductBasicDetails(
            value['title'],
            value['price'],
            value['productcode'],
            value['barcode'],
            value['imageurl'],
            value['category'],
            value['brand'],
            'N/A',
            'N/A',
            'N/A'
            );
        });
        print(barCodeSearchResultsMap);
        print(barCodeSearchResultsMap.length);

        barCodeSearchResultsMap.forEach((key, value) {
          barCodeSearchResults.add(value);
        });

          setState(() {
            searchingBarCode = false;
          });
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ProductLookupResults();
                  }
              )
          );
      }
      else
        {
          setState(() {
            searchingBarCode = false;
          });
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ProductLookupResults();
                  }
              )
          );
        }
    });





        }

  Future scan() async {
    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    try {
      barCodeToSearch = (await BarcodeScanner.scan()).toString();
      print('Scanned BarCode:' + barCodeToSearch);

      print(barCodeToSearch);
      if (barCodeToSearch.length > 0) {
        getProductDetails();
      }
    } on PlatformException catch (e) {
      print('Platform Exception');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera Access Denied');
        setState(() {
          searchingBarCode = false;
//          Navigator.of(context).pop();
//          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//              builder:(BuildContext context){
//                return ProductLookUp();
//              }));
        });
      } else {
        print('Scan Error. Not Camera Access Error');
        setState(() {
          searchingBarCode = false;
//          Navigator.of(context).pop();
//          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//              builder:(BuildContext context){
//                return ProductLookUp();
//              }));
        });

      }
    } on FormatException {
      print('Scan Format Exception');
      setState(() {
        searchingBarCode = false;
//        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return ProductLookUp();
//            }));
      });
    } catch (e) {
      print('Error Caught in Catch Statement');
      setState(() {
        searchingBarCode = false;
//        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return ProductLookUp();
//            }));
      });
    }
  }

  Future getBarCode() async {

    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    barCodeToSearch = await Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return ProductLookUpRequestBarCode();
        }));
    print(barCodeToSearch);
    if (barCodeToSearch != null && barCodeToSearch.length > 0) {
      getProductDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    {

//      if(productDiscountDetailsAtAllStoresAvailable && productStockPositionAtAllStoresAvailable)
//        {
          return
            WillPopScope(
                onWillPop:(){
                  setState(() {
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return ShowAdminHomePage();
                            }
                        )
                    );
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                    builder:(BuildContext context){
//                      return CheckIfAdmin();
//                    }));
                  });
                  return;
                },
                child:Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      title: Text(
                        'PRODUCT MANAGER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            fontFamily: 'Montserrat'),
                      ),
                      leading: IconButton(icon:Icon(Icons.keyboard_backspace),
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                    builder:(BuildContext context){
                                      return ShowAdminHomePage();
                                    }
                                )
                            );
                          }),

                    ),
                    body: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Container(
                                width:MediaQuery.of(context).size.width,
                                padding:EdgeInsets.all(8.0),
                                child:
//                                Text(storeIdNameMap[productNode],
                                                        Text('KIRANAWALA_STORE_11',

                        style:TextStyle(
                                      fontSize: 18.0,
                                      color:Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width:MediaQuery.of(context).size.width,
                                  padding:EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border:Border.all(color:Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  child:
                                  Text(' PRODUCT LOOKUP',
                                    style:TextStyle(
                                        fontSize: 18.0,
                                        color:Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  elevation: 4.0,
                                  onPressed: scan,
                                  child: Text('SCAN BARCODE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  elevation: 4.0,
                                  onPressed: () {
                                    getBarCode();
                                  },
                                  child: Text('ENTER BARCODE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  elevation: 4.0,
                                  onPressed: () {
//                                retrievingProductDetails = true;
                                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                                        builder:(BuildContext context){
                                          return InventoryManagerProductNameLookUp();
                                        }
                                    )).then((dynamic code){
                                      if(code != null)
                                      {
                                        setState(() {
                                        });
                                        print(code.toString());
                                      }
                                    });
                                  },
                                  child: Text('SEARCH NAME',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  elevation: 4.0,
                                  onPressed: () {
//                                retrievingProductDetails = true;
                                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                                        builder:(BuildContext context){
                                          return SelectProductCategory();
                                        }
                                    )).then((dynamic code){
                                      if(code != null)
                                      {
                                        setState(() {
                                        });
                                        print(code.toString());
                                      }
                                    });
                                  },
                                  child: Text('SEARCH BY CATEGORY',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  elevation: 4.0,
                                  onPressed: () {
//                                retrievingProductDetails = true;
                                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                                        builder:(BuildContext context){
                                          return SelectProductBrand();
                                        }
                                    )).then((dynamic code){
                                      if(code != null)
                                      {
                                        setState(() {
                                        });
                                        print(code.toString());
                                      }
                                    });
                                  },
                                  child: Text('SEARCH BY BRAND',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width:MediaQuery.of(context).size.width,
                                  padding:EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  child:
                                  Text('NEW PRODUCT',
                                    style:TextStyle(
                                        fontSize: 18.0,
                                        color:Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  elevation: 4.0,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push<dynamic>(
                                        MaterialPageRoute<dynamic>(
                                            builder:(BuildContext context){
                                              return InventoryManagerAddNewProductWithBarcode();
                                            }
                                        )
                                    );
                                  },
                                  child: Text('ADD PRODUCT(BARCODE)',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  elevation: 4.0,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push<dynamic>(
                                      MaterialPageRoute<dynamic>(
                                        builder:(BuildContext context){
                                          return InventoryManagerAddNewProductWithoutBarcode();
                                        }
                                      )
                                    );
                                  },
                                  child: Text('ADD PRODUCT(NO BARCODE)',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                width: MediaQuery
//                                    .of(context)
//                                    .size
//                                    .width,
//                                child: RaisedButton(
//                                  color: Colors.blue,
//                                  elevation: 4.0,
//                                  onPressed: () {
////                                retrievingProductDetails = true;
//                                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                                        builder:(BuildContext context){
//                                          return ProductNameLookUp();
//                                        }
//                                    )).then((dynamic code){
//                                      if(code != null)
//                                      {
//                                        setState(() {
//                                        });
//                                        print(code.toString());
//                                      }
//                                    });
//                                  },
//                                  child: Text('SEARCH BY ONLINE STATUS',
//                                    style: TextStyle(
//                                        color: Colors.white,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 18.0,
//                                        fontFamily: 'Montserrat'
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ),
                          ]),
                    )
                ));
//        }
//      else
//        {
//          return Container(
//            color: Colors.white,
//            child: Dialog(
//              child: new Row(
//                mainAxisSize: MainAxisSize.min,
//                children: [
//                  Expanded(
//                      flex:2,
//                      child: new CircularProgressIndicator()
//                  ),
//                  SizedBox(width:10.0),
//                  Expanded(
//                      flex:12,
//                      child: Text("Retrieving Stock Position...,",
//                          style:TextStyle(
//                            fontFamily: 'Montserrat',
//                            fontSize:12.0,
//                            fontWeight: FontWeight.bold,
//                          )
//                      )
//                  ),
//                ],
//              ),
//            ),
//          );
//        }


    }
  }
}
