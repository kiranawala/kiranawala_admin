import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-options.dart';

Map<dynamic, dynamic> discountDetails = Map<dynamic, dynamic>();


class InventoryManagerChangeDiscount extends StatefulWidget {
  @override
  _InventoryManagerChangeDiscountState createState() => _InventoryManagerChangeDiscountState();
}

class _InventoryManagerChangeDiscountState extends State<InventoryManagerChangeDiscount> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(skuToUpdate);
    print(fullProductBasicDetailsMap[skuToUpdate].productBarCode);
    print(fullProductBasicDetailsMap[skuToUpdate].productName);
    discountValue = (fullProductDiscountMap[skuToUpdate]!=null ?double.parse(fullProductDiscountMap[skuToUpdate].discount.toString()):0);
    discountType = (fullProductDiscountMap[skuToUpdate]!=null ?fullProductDiscountMap[skuToUpdate].discountType.toString():'%');
    discountStartDate = (fullProductDiscountMap[skuToUpdate]!=null ?fullProductDiscountMap[skuToUpdate].discountStartDate.toString():'N/A');
    discountEndDate = (fullProductDiscountMap[skuToUpdate]!=null ?fullProductDiscountMap[skuToUpdate].discountEndDate.toString():'N/A');

//    print(fullProductDiscountMap[skuToUpdate].discount);
//    print(fullProductDiscountMap[skuToUpdate].discountType);
//    print(fullProductDiscountMap[skuToUpdate].discountStartDate);
//    print(fullProductDiscountMap[skuToUpdate].discountEndDate);
//    print(fullProductDiscountMap[skuToUpdate].discountStatusChangeTimeStamp);

//    discountSelected = (productDiscountDetailsMap[selectedProduct.productID] != null)?
//    productDiscountDetailsMap[selectedProduct.productID]['discountType'].toString():
//    'PERCENT';
//
//    discountValue = (productDiscountDetailsMap[selectedProduct.productID] != null)?
//    double.parse(productDiscountDetailsMap[selectedProduct.productID]['discount'].toString()):
//    0;
//
//    discountStartDate = (productDiscountDetailsMap[selectedProduct.productID] != null)?
//    productDiscountDetailsMap[selectedProduct.productID]['discountStartDate'].toString():
//    DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
//
//
//    discountEndDate = (productDiscountDetailsMap[selectedProduct.productID] != null)?
//    productDiscountDetailsMap[selectedProduct.productID]['discountEndDate'].toString():
//    DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(builder: (BuildContext context) {
            return ProductUpdateOptions();
          }));
          return;
        },
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.keyboard_backspace),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                            return ProductUpdateOptions();
                          }));
                    })),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                  builder:(BuildContext context){
                                    return RequestDiscountValue();
                                  }
                              )
                          );
                        },
                        child: Text(
                                    discountValue.toString(),
//                                      (productDiscountDetailsMap[selectedProduct.productID] != null)?
//                                      productDiscountDetailsMap[selectedProduct.productID]['discount'].toString():
//                                      'N/A',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)))),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                        onPressed: () {
                          Future<void> future =  showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return BottomSheet(
                                    onClosing: () {
                                    },
                                    builder: (BuildContext context) {
                                      return ShowDiscountTypes();
                                    });
                              });
                          future.then((void value) => {
                            setState(() {
                            })
                          });
                        },
                        child: Text(
                          discountType,
//                            (productDiscountDetailsMap[selectedProduct.productID] != null)?
//                        productDiscountDetailsMap[selectedProduct.productID]['discountType'].toString():
//                        'N/A',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)))),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              onConfirm: (date) {
//                                productDiscountDetailsMap[selectedProduct.productID]['discountStartDate'] =
//                                    DateFormat('dd-MM-yyyy').format(date);
                                discountStartDate = DateFormat('dd-MM-yyyy').format(date);
                                setState(() {});
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Text(
                          discountStartDate,
//                            (productDiscountDetailsMap[selectedProduct.productID] != null)?
//                            productDiscountDetailsMap[selectedProduct.productID]['discountStartDate'].toString():
//                            'N/A',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)))),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
                              onConfirm: (date) {
//                                productDiscountDetailsMap[selectedProduct.productID]['discountEndDate'] =
//                                    DateFormat('dd-MM-yyyy').format(date);
                                discountEndDate = DateFormat('dd-MM-yyyy').format(date);
                                setState(() {});
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Text(
                          discountEndDate,
//                            (productDiscountDetailsMap[selectedProduct.productID] != null)?
//                            productDiscountDetailsMap[selectedProduct.productID]['discountEndDate'].toString():
//                            'N/A',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)))),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          discountDetails = <dynamic, dynamic>{
                            'productCode':skuToUpdate,
                            'discountType':discountType,
                            'discount':discountValue,
                            'discountStartDate':discountStartDate,
                            'discountEndDate':discountEndDate,
                            'isDiscountActive':true,
                            'statusChangeTimeStamp':DateFormat('dd-MM-yyyy-HH:mm:ss').format(DateTime.now())
                          };

                          String startDateString = discountStartDate.substring(6,10) + '-' + discountStartDate.substring(3,5) + '-' + discountStartDate.substring(0,2) + ' ' + '00:00:00.000';
                          String endDateString = discountEndDate.substring(6,10) + '-' + discountEndDate.substring(3,5) + '-' + discountEndDate.substring(0,2) + ' ' + '00:00:00.000';
//                          print(endDateString);
                          DateTime endDate = DateTime.parse(endDateString);
                          DateTime startDate = DateTime.parse(startDateString);

//                          print(endDate);
//                          print(endDate.compareTo(DateTime(2020,8,1)));

                          if(discountTypes.indexOf(discountDetails['discountType']) != -1
                            &&  (discountDetails['discount'] > 0
                                  && endDate.compareTo(startDate) >= 0)
                          )
                            {

                              fullProductDiscountMap[skuToUpdate]= ProductDiscountDetails(
                                double.parse(discountDetails['discount'].toString()),
                                discountDetails['discountStartDate'].toString(),
                                discountDetails['discountEndDate'].toString(),
                                discountDetails['discountStatusChangeTimeStamp'].toString(),
                                discountDetails['isDiscountActive'],
                                discountDetails['discountType'].toString(),
                                int.parse(discountDetails['productCode'].toString()),
                              );

                              FirebaseDatabase.instance
                              .reference()
                              .child('stores')
                              .child(inventoryNode)
                              .child('discounts')
                              .child(skuToUpdate.toString())
                              .set(discountDetails)
                              .then((result){
                                print('Discount Details added successfully');

                              }
                              );
                              print(discountDetails);
                              Navigator.of(context).pop();
//                              Navigator.of(context).push<dynamic>(
//                                  MaterialPageRoute<dynamic>(
//                                      builder: (BuildContext context){
//                                        return ProductStockPositionSearchResults();
//                                      }
//                                  )
//                              );
                            }
                        },
                        child: Text('CONFIRM',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)))),
              ],
            )));
  }
}

class ShowDiscountTypes extends StatefulWidget {
  @override
  _ShowDiscountTypesState createState() => _ShowDiscountTypesState();
}

class _ShowDiscountTypesState extends State<ShowDiscountTypes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child:RaisedButton(
              color:Colors.blue,
              onPressed: (){
                discountType = discountTypes[0];
//                fullProductDiscountMap[skuToUpdate].discountType= discountType[0];
                Navigator.of(context).pop();
              },
              child: Text(
                discountTypes[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            )
          ),
          Container(
            width:MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              child:RaisedButton(
                color:Colors.blue,
                onPressed: (){
                  discountType = discountTypes[1];
//                  productDiscountDetailsMap[selectedProduct.productID]['discountType']= discountType[1];
                  Navigator.of(context).pop();
                },
                child: Text(
                  discountTypes[1],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}


class RequestDiscountValue extends StatefulWidget {
//  final String displayMessage;
//  RequestStockInwardQty(this.displayMessage);
  @override
  _RequestDiscountValueState createState() => _RequestDiscountValueState();
}

class _RequestDiscountValueState extends State<RequestDiscountValue> {
  double inputValue = 0;
  TextEditingController discountValueTextController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(barCodeSearchResultsMap[skuToUpdate].productName.toString());
    print(barCodeSearchResultsMap[skuToUpdate].productBarCode.toString());
    print(barCodeSearchResultsMap[skuToUpdate].productPrice.toString());
    print(barCodeSearchResultsMap[skuToUpdate].productCategory.toString());
    print(barCodeSearchResultsMap[skuToUpdate].productBrand.toString());
  }
  @override
  Widget build(BuildContext context) {

    return
      WillPopScope(
        onWillPop:(){
          Navigator.of(context).pop();
//          Navigator.of(context).push<dynamic>(
//            MaterialPageRoute<dynamic>(
//              builder: (BuildContext context){
//                return AddProductDiscount();
//              }
//            )
//          );
          return;
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon:Icon(Icons.keyboard_backspace),
                tooltip: 'Go Back',
                onPressed: (){
                  Navigator.of(context).pop();
//                  Navigator.of(context).push<dynamic>(
//                      MaterialPageRoute<dynamic>(
//                          builder: (BuildContext context){
//                            return AddProductDiscount();
//                          }
//                      )
//                  );
                },
              ),
            ),
            body:Container(
                width:MediaQuery.of(context).size.width,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(barCodeSearchResultsMap[skuToUpdate].productBarCode.toString(),
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight:FontWeight.bold,
                            fontSize: 24.0,
                            color:Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(barCodeSearchResultsMap[skuToUpdate].productName.toUpperCase(),
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight:FontWeight.bold,
                            fontSize: 24.0,
                            color:Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight:FontWeight.bold,
                            fontSize: 24.0,
                            color:Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text('DISCOUNT VALUE',
                            style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight:FontWeight.bold,
                              fontSize: 24.0,
                              color:Colors.black,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        child: TextField(
                          controller: discountValueTextController,
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
                            hintText: discountValue.toString(),
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold)),
                          onChanged: (value) {
//                            print (discountValueTextController.text);
//                              print('discount changed');
//                            print(value);
//                            print(discountValue);
//                            if(value.isEmpty){
//                              print('value is empty');
//                              discountValue = 0;
//                              print(discountValue);
//                            }
//                            else
//                              {
//                                discountValue = double.parse(value);
//                                print(discountValue);
//                              }
                          },
                          onSubmitted: (value){
//                            print('discount submitted');
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                            color:Colors.blue,
                            onPressed:(){
//                              print(discountValue);
//                              print();
                             if(discountValueTextController.text.length > 0 && double.parse(discountValueTextController.text.toString()) > 0)
                               {
                                 discountValue = double.parse(discountValueTextController.text.toString());
//                                 productDiscountDetailsMap[selectedProduct.productID]['discount'] = double.parse(discountValueTextController.text.toString());
                                 print(discountValue);
                                 print('Discount Value is valid');
                                 Navigator.of(context).pop();
//                                 Navigator.of(context).push<dynamic>(
//                                   MaterialPageRoute<dynamic>(
//                                     builder: (BuildContext context){
//                                       return AddProductDiscount();
//                                     }
//                                   )
//                                 );
                               }
                            },
                            child:Text('CONFIRM',
                                style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight:FontWeight.bold,
                                  fontSize: 24.0,
                                  color:Colors.white,
                                ))
                        ),
                      ),
                    )
                  ],
                )

            )
        ),
      );

  }
}
