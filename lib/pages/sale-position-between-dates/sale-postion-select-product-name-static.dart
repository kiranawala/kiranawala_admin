import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-single-store.dart';

List<ProductBasicDetails> productSearchResults = List<ProductBasicDetails>();
List<ProductBasicDetails> products = List<ProductBasicDetails>();
String selectedProductName = '';
int selectedProductCode = 0;

class SelectProductNameStatic extends StatefulWidget {
  @override
  _SelectProductNameStaticState createState() => _SelectProductNameStaticState();
}

class _SelectProductNameStaticState extends State<SelectProductNameStatic> {
  bool retrievingProducts = false;

  @override
  void initState() {
    super.initState();
    products = fullProductBasicDetailsList;
    productSearchResults = fullProductBasicDetailsList;
  }

  @override
  Widget build(BuildContext context) {
    if(retrievingProducts)
      return
        Scaffold(
          appBar:
            AppBar(
              centerTitle: true,
              title:Text(
                'SELECT PRODUCT',
                style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize:24.0,
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
                    child: Text("Retrieving Products.....")
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
          title:Text(
            'Select Product',
            style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize:12.0,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        body:Column(
          children:<Widget>[ 
            
            Expanded(
              flex:2,
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search Product...',
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
                    productSearchResults = [];
                    products.forEach((product){
                      if(product.productName.toLowerCase().contains(value.toLowerCase()))
                      {
                        productSearchResults.add(product);
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
                  itemCount:productSearchResults.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: FlatButton(
                        color:Colors.white,
                        child: Column(
                          children: <Widget>[
                            Text(
                              productSearchResults[index].productName,
                              style: TextStyle(
                                  color:Colors.black,
                                  fontWeight:FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  fontSize:14.0
                              ),
                            ),
                            Text(
                              productSearchResults[index].productPrice.toString(),
                              style: TextStyle(
                                  color:Colors.black,
                                  fontWeight:FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  fontSize:14.0
                              ),
                            ),
                          ],
                        ),

                        onPressed: (){
                          barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
                          barCodeSearchResultsMap[productSearchResults[index].productID] =
                          new ProductBasicDetails(
                            productSearchResults[index].productName,
                            productSearchResults[index].productPrice,
                            productSearchResults[index].productID,
                            productSearchResults[index].productBarCode,
                            productSearchResults[index].productImageURL,
                            productSearchResults[index].productCategory,
                            productSearchResults[index].productBrand,
                            productSearchResults[index].productStatus,
                            productSearchResults[index].productParentStore,
                            productSearchResults[index].productCreationTimeStamp,
                          );
                          selectedProductName = productSearchResults[index].productName;
                          selectedProductCode = productSearchResults[index].productID;
                          print(selectedProductName);
                          print(selectedProductCode);
                          retrievingProducts = false;
                          barCodeSearchResultsMap[productSearchResults[index].productID] = productSearchResults[index];
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(
                            MaterialPageRoute<dynamic>(
                              builder:(BuildContext context){
                                return ShowProductSalePositionSingleStore();
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
      );
    }
  }