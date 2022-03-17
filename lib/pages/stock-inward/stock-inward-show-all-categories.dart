import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-category-manager.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-home-page.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-barcode-lookup.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-selected-category-products.dart';
import '../check-if-admin.dart';

class StockInwardShowAllCategories extends StatefulWidget {
  @override
  _StockInwardShowAllCategoriesState createState() => _StockInwardShowAllCategoriesState();
}

class _StockInwardShowAllCategoriesState extends State<StockInwardShowAllCategories> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(homeCategories.length);

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
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context){
                  return StockInwardHomePage();
                }
            )
        );
        return;
      },
      child: Scaffold(
        appBar: AppBar(
//        centerTitle: true,
          automaticallyImplyLeading: false,
//        title: Text('KONDAPUR',
//        style:TextStyle(
//          fontFamily: 'Montserrat',
//          fontSize:18.0,
//          fontWeight: FontWeight.bold,
//          color:Colors.white
//        )),
          actions: <Widget>[
            IconButton(
                onPressed:(){
                  print('Opening Category Manager');
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return StockInwardCategoryManager();
                          }
                      )
                  );
                },
                icon:Icon(Icons.category)
            ),
            IconButton(
                onPressed:(){
                  print('Adding Product(No BarCode');
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return null;
//                            return StockInwardAddNewProductWithoutBarcode();
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
//                            return StockInwardAddNewProductWithBarcode();
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
//                    if(value.productStatus == 'ACTIVE')
//                    {
                      barCodeSearchResultsMap[value.productID] = value;
                      lookupMap[value.productID] = value;
//                    }
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
            itemCount: homeCategories.length,
            itemBuilder: (BuildContext context, int index) {
              List<String> subcategories = [];

//            print(categoryNameCategoryDetailsMap);

              homeCategories[index]['subCategories'].forEach((dynamic entry) {
//              print(entry);
                if(categoryNameCategoryDetailsMap.containsKey(entry['categoryName'].toString()))
                  subcategories.add(entry['categoryName'].toString());
              });
              return buildHomeCategoryWidget(
                  context, homeCategories[index]['displayName'], subcategories);
            }),
      ),
    );
  }
  Widget buildSubCategoryWidget(
      BuildContext context, List<String> subcategories) {

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: subcategories.length,
      itemBuilder: (BuildContext context, int index) {

        return InkWell(
          onTap: () {
            selectedCategory = subcategories[index];
            print(selectedCategory);

            barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
            lookupMap = Map<int,ProductBasicDetails>();

            fullProductBasicDetailsMap.forEach((key,value) {
              if(value.productCategory == selectedCategory && value.productStatus.toUpperCase() == 'ACTIVE')
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

            Navigator.push<dynamic>(context,
                MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                  return StockInwardSelectedCategoryProducts();
                }));
          },
          child: Column(
              children: <Widget>[
            Container(
              // margin: const EdgeInsets.all(5.0),
                width: 150.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blueGrey[300]),
                  image: DecorationImage(
                    image: NetworkImage(
                        categoryNameCategoryDetailsMap[subcategories[index]]
                        ['categoryImage']),

                    fit: BoxFit.contain,
                  ),
                )),
            Container(
              height: 20.0,
              child: Text(
                subcategories[index],
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
                maxLines: 2,
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget buildHomeCategoryWidget(
      BuildContext context, String categoryName, List<String> subcategories) {
    // print('buildHomeCategoryWidgetNew:subcategories');
    // print(subcategories);
    return Column(children: <Widget>[
      const SizedBox(
        height: 10.0,
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Text(categoryName,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              // backgroundColor: Colors.blueGrey
            )),
      ),
      Container(
        // margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: buildSubCategoryWidget(context, subcategories)),
      const SizedBox(
        height: 10.0,
      ),
    ]);
  }
}


