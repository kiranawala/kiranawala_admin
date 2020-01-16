import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/main.dart';

class SearchProductByName extends StatefulWidget {
  @override
  _SearchProductByNameState createState() => _SearchProductByNameState();
}

class _SearchProductByNameState extends State<SearchProductByName> {
  // String barcode = "";  
  bool productsAvailable = false;
  List<Map> fullProductList = [];
  Map productsMap = {};
  String scanStatus = '';
  Map scannedProduct = {};

  int productCode = 0;
  String productName = '';
  String productCategory = '';
  String productBrand = '';
  double productPrice = 0.0;
  double productStockPosition = 0.0;
  String productImageURL = '';
  String productBarcode = '';

  String barcodeMessage = '';
  String searchString = '';

  String updatedStockPosition = '0';
  String receivedStock = '0';
  String updateStockPositionMessage = 'CANNOT BE ZERO';
  String receivedStockMessage = 'CANNOT BE ZERO';

  List<ProductStockPosition> productsForBrand = new List();
  bool retrievingData = false;

  String newProductName = '';
  String newProductNameMessage = '';
  String newProductPrice = '';
  String newProductPriceMessage = '';
  int nextProductCode = 0;
  List<ProductStockPosition> nameSearchResults = [];

  @override 
  void initState() {
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {  
    if(retrievingData)
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:Text('SEARCH PRODUCT NAME'),
          leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back, color: Colors.orange),
            onPressed: () => Navigator.of(context).pop(),
          ), 
          centerTitle: true,
        ),
      body: 
      Container(
        color: Colors.white,
        child: Dialog(
          child: Row(
            children: [
              new CircularProgressIndicator(),
              new Text("Getting Products....."),
            ],
          ),
        ),
      )
      );
    else
      return Scaffold(
        appBar: AppBar(
          title:Text('Code Scanner'),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
////START////SEARCH PRODUCT BY NAME////
              Row(
                children: <Widget>[
                  Expanded(
                    flex:2,
                    child:TextField(
                      autofocus: true,
                      onChanged: (value){
                        this.searchString = value;
                      },
                    ),
                  ),
                  Expanded(
                    flex:2,
                    child:RaisedButton(
                      color:Colors.blue,
                      child: Text('Search'),
                      textColor:Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: (){
                                              try
                                              {
                                                scanStatus = barCodeToSearch + ' is not in the system';

                                                nameSearchResults = [];
                                                allProducts.forEach((product){
                                                  if(product.productName.toLowerCase().contains(searchString.toLowerCase()))
                                                  {

                                                    int productCode = 0;
                                                    double productInventoryTillDate = 0.0;
                                                    double productSalePositionTillDate = 0.0;
                                                    double productStockPosition = 0.0;
                                                    productCode = int.parse(product.productID.toString());
                                                    productBarcode = product.productBarCode.toString();
                                                    productName = product.productName.toString();                                    
                                                    productPrice = double.parse(product.productPrice.toString());                                    
                                                    productCategory = product.productCategory.toString();                                    
                                                    productBrand = product.productBrand.toString();                                    
                                                    productImageURL = product.productImageURL.toString();                                    

                                                    if(productSalePositionTillDateMap[productCode] != null)
                                                    {
                                                      productSalePositionTillDate = double.parse(productSalePositionTillDateMap[productCode].toString());
                                                    }        
                                                    else
                                                    {
                                                      productSalePositionTillDateMap[productCode] = 0.0;
                                                    }

                                                    if(productInventoryTillDateMap[productCode] != null)
                                                    {
                                                      productInventoryTillDate = double.parse(productInventoryTillDateMap[productCode].toString());
                                                    }
                                                    else
                                                    {
                                                      productInventoryTillDateMap[productCode] = 0.0;
                                                    }

                                                    productStockPosition = productInventoryTillDate - productSalePositionTillDate;

                                                    nameSearchResults.add(new ProductStockPosition(
                                                        product.productName.toString(), 
                                                        double.parse(product.productPrice.toString()), 
                                                        int.parse(product.productID.toString()), 
                                                        product.productBarCode.toString(), 
                                                        product.productImageURL.toString(), 
                                                        product.productCategory.toString(), 
                                                        product.productBrand.toString(),
                                                        productInventoryTillDate,                                              
                                                        productSalePositionTillDate,                                              
                                                        productStockPosition
                                                        // double.parse(product.productStockPosition.toString()), 
                                                      )
                                                    );
                                                  } 
                                                });
                                                
                                                nameSearchResults.sort((a,b){
                                                  return a.productName.compareTo(b.productName);
                                                });

                                                print(nameSearchResults);
                                                print(nameSearchResults.length);
                                                setState(() {                                    
                                                });

                                                // Navigator.of(context).pop();                                      
                                              } on PlatformException catch(e){
                                                  setState(() {
                                                    barCodeToSearch = 'Unknown error: $e';  
                                                  });                           
                                                }                      
                                                catch(e){
                                                  setState(() {
                                                    barCodeToSearch = 'Unknown error:$e';
                                                  });
                                                }
                      }                      
                    ),
                  ),
                ],  
              ),
              Expanded(
                flex:2,
                  child: Text(barcodeMessage,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        color: Colors.blue)),
            ),
            Expanded(
              flex:24,
              child: GestureDetector(
                  onTap:(){},
                  child: Container(
                  child: 
                  ListView.builder(    
                    scrollDirection: Axis.vertical,    
                    itemCount: nameSearchResults.length,
                    itemBuilder: (BuildContext context, int index){
                      return 
                        Container(   
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                          height: 400.0,
                              child: Column(children: <Widget>[
                                Expanded(
                                  flex:16,                          
                                    child: Container(
                                      alignment: Alignment.center,
                                      width:MediaQuery.of(context).size.width,
                                      child:Image.network(nameSearchResults[index].productImageURL.toString(),
                                            fit: BoxFit.contain,),
                                    ),
                                  ),
                                Expanded(
                                  flex:4,
                                  child: Container(
                                    child: Text(
                                      nameSearchResults[index].productName.toString(),
                                      textAlign: TextAlign.center,
                                      style:TextStyle(
                                        // backgroundColor: Colors.blue,
                                        color:Colors.green,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                      )
                                    ),
                                  )
                                ),
                                Expanded(
                                  flex:2,
                                  child: Container(                           
                                    child: Text(
                                      'Rs.'+ nameSearchResults[index].productPrice.toString() +'/-',
                                      style:TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                      )
                                    ),
                                  ),
                                ),                                                               
                              ])
                          );
                  }
                )
            ),
              ),
          ),                          
        ]
      )
    )
  );
  
  }
}