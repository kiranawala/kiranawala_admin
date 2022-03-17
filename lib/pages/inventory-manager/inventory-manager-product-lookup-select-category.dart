import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';

import '../show-admin-home-page.dart';
//import 'package:kiranawala_admin/pages/inventory-manager/stock-inward-product-lookup-results.dart';


class SelectProductCategory extends StatefulWidget {
  @override
  _SelectProductCategoryState createState() => _SelectProductCategoryState();
}

class _SelectProductCategoryState extends State<SelectProductCategory> {

  bool retrievingProductsForSelectedCategory = false;

//  List<String> productCategories = List<String>();

  @override
  void initState() {
    // TODO: implement initState

    categorySearchResults = productCategories;
//    print("getActiveCategoriesFromStore:storeId");
//    print(selectedStoreDetails.storeId);

//      productCategories = [];
//      productCategories.add('BREAD, CEREALS & OATS');
//      productCategories.add('LEAFY VEG');
//      productCategories.add('NON-LEAFY VEG');
//      productCategories.add('LOOSE GROCERY');
//      productCategories.add('FROZEN VEG');
//      productCategories.add('FRUITS');
//      productCategories.add('DALS');
//      productCategories.add('WHOLE SPICES');
//      productCategories.add('POWDERED SPICES');
//      productCategories.add('BLENDED SPICES');
//      productCategories.add('SOFT DRINKS');
//      productCategories.add('ATTA');
//      productCategories.add('RAVA');
//      productCategories.add('RICE');
//      productCategories.add('NOODLES & VERMICELLI');
//      productCategories.add('SALT, SUGAR & JAGGERY');
//      productCategories.add('COOKING PASTES');
//      productCategories.add('MILK SHAKES');
//      productCategories.add('FRUIT JUICES');
//      productCategories.add('DRY FRUITS & NUTS');
//      productCategories.add('TEA, COFFEE & WHITENERS');
//      productCategories.add('COOKING OILS, DALDA & GHEE');
//      productCategories.add('INSTANT FOOD & READY-TO-COOK');
//      productCategories.add('STATIONERY & PARTY NEEDS');
//      productCategories.add('BAKING');
//      productCategories.add('SPREADS & SAUCES');
//      productCategories.add('PICKLES');
//      productCategories.add('FABRIC CARE');
//      productCategories.add('ORAL CARE');
//      productCategories.add('BATH & SHOWER');
//      productCategories.add('FEMININE HYGIENE');
//      productCategories.add('DISHWASH');
//      productCategories.add('PEST CONTROL');
//      productCategories.add('POOJA ITEMS');
//      productCategories.add('HAIR CARE');
//      productCategories.add('SHAVING NEEDS');
//      productCategories.add('BEAUTY & MAKE-UP');
//      productCategories.add('SURFACE & TOILET CLEANERS');
//      productCategories.add('FRESH DAIRY & PRODUCTS');
//      productCategories.add('PAPADS & FRYUMS');
//      productCategories.add('HANDWASH & SANITIZER');
//      productCategories.add('AIR FRESHENERS');
//      productCategories.add('MEDICINES & SUPPLEMENTS');
//      productCategories.add('WATER');
//      productCategories.add('SNACKS');
//      productCategories.add('ICE CREAMS & FROZEN DESSERTS');
//      productCategories.add('HEALTH & NUTRITION DRINKS');
//      productCategories.add('SHOE CARE');
//      productCategories.add('DISPOSABLES');
//      productCategories.add('CLEANING ACCESSORIES');
//      productCategories.add('PAANWAALA');
//      productCategories.add('PET CARE');
//      productCategories.add('PLASTIC & STEEL WARE');
//      productCategories.add('ELECTRICAL ACCESSORIES');
//
//      productCategories.sort((dynamic a, dynamic b) {
//            return a.compareTo(b);
//          });

//      categoryNameCategoryDetailsMap = <String, dynamic>{};
//      categoryIndexCategoryDetailsMap = <int, dynamic>{};
//      homeCategoryNameCategoryDetailsMap = <String, dynamic>{};
//      homeCategories = <dynamic>[];
//      FirebaseDatabase.instance
//          .reference()
//          .child('stores')
//          .child('KIRANAWALA_STORE_11')
//          .child('categoriesMaster')
//          .once()
//          .then((snapshot) {
//        if (snapshot != null && snapshot.value != null) {
////        print("getActiveCategoriesFromStore:snapshot.value");
////        print(snapshot.value.length);
////        print(snapshot.value);
//          List<dynamic> categoryListSnapshot = snapshot.value;
//          int i = 0;
//          categoryListSnapshot.forEach((dynamic categoryDetails) {
////            print(categoryDetails);
////            print(categoryDetails['categoryId']);
////            print(categoryDetails['categoryName']);
//            if (categoryDetails['categoryName'] != null )
//              {
//                productCategories.add(categoryDetails['categoryName']);
//              }
//          });
//
////          categories.sort((dynamic a, dynamic b) {
////            return a.categoryName.compareTo(b.categoryName);
////          });

              categorySearchResults.sort((dynamic a, dynamic b) {
            return a.compareTo(b);
          });

          print(categorySearchResults);
          setState(() {

          });
//        }
//      });
  }

  void retrieveProductForSelectedCategory()
  {
    setState(() {
      retrievingProductsForSelectedCategory = true;
    });

    barCodeSearchResults = List<ProductBasicDetails>();
    barCodeSearchResultsMap = Map<int, ProductBasicDetails>();


    FirebaseDatabase.instance.reference().child('stores/KIRANAWALA_STORE_11/products').orderByChild('category').equalTo(selectedCategory).once().then((snapshot){
      print(snapshot);
      if(snapshot != null && snapshot.value != null)
      {
        print(snapshot.value);
        print(snapshot.value.length);
        barCodeSearchResults = List<ProductBasicDetails>();
        barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
        snapshot.value.forEach((dynamic key, dynamic value){
          print(value);
          barCodeSearchResultsMap[value['productcode']] = ProductBasicDetails(
              value['title'],
              value['price'],
              value['productcode'],
              value['barcode'],
              value['imageurl'],
              value['category'],
              value['brand'],
              'ACTIVE',
              'POS_11',
              'N/A'
          );
        });
        print(barCodeSearchResultsMap.length.toString());
      }

      setState(() {
        retrievingProductsForSelectedCategory = false;
      });

      Navigator.of(context).pop();
      Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context){
                return ProductLookupResults();
              }
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if(retrievingProductsForSelectedCategory)
      return
        Scaffold(
          appBar:
          AppBar(
            title:Text(
                'SELECT CATEGORY',
                style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize:12.0,
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          body:
          Container(
            color: Colors.white,
            child: Dialog(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      flex:2,
                      child: new CircularProgressIndicator()
                  ),
                  SizedBox(width:10.0),
                  Expanded(
                      flex:12,
                      child: Text("Retrieving Products...",
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:12.0,
                            fontWeight: FontWeight.bold,
                          )
                      )
                  ),
                ],
              ),
            ),
          ),
        );
    else
      return
        Scaffold(appBar:
        AppBar(
          centerTitle: true,
          title:Text(
              'SELECT CATEGORY',
              style:TextStyle(
                fontFamily: 'Montserrat',
                fontSize:24.0,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
            body:Column(
                children:<Widget>[

                  Expanded(
                    flex:2,
                    child:
                    TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'Search Category...',
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:24.0,
                              fontWeight: FontWeight.bold,
                              color:Colors.black
                          )
                      ),
                      onChanged: (value){
//                        print(value);
                        if(value.isNotEmpty)
                        {
                          categorySearchResults = [];
                          productCategories.forEach((category){
                            if(category.toLowerCase().contains(value.toLowerCase()))
                            {
                              categorySearchResults.add(category);
                            }
                          });
                          setState(() {

                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex:20,
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.purple),
                      child: ListView.builder(
                        itemCount:categorySearchResults.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FlatButton(
                              color:Colors.blue,
                              child: Text(categorySearchResults[index],
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24.0,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.white
                                  )),
                              onPressed: (){
                                selectedCategory = categorySearchResults[index];
                                print(selectedCategory);
                                retrieveProductForSelectedCategory();

                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ]
              //  DropdownButton(
              //     hint: Text('Select Brand'), // Not necessary for Option 1
              //     value: selectedBrand,
              //     onChanged: (newValue) {
              //       setState(() {
              //         selectedBrand = newValue;
              //       });
              //     },
              //     underline: Container(
              //             height: 2,
              //             color: Colors.deepPurpleAccent,
              //           ),
              //     items: brands.map((Brand brand) {
              //       return DropdownMenuItem(
              //         child: new Text(brand.brandName),
              //         value: brand,
              //       );
              //     }).toList(),
              //   ),
            )
        );
  }
}