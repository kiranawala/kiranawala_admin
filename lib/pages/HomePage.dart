import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/CustomerMobileLogin.dart';
import 'package:kiranawala_admin/pages/nila-point-of-sale.dart';
import 'package:kiranawala_admin/pages/ShowTerminalWiseSalePositionStreamBuilder.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BarcodeScan.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   
  String _phoneNumber;

   Future<bool> setPhoneNumber(String phoneNumber) async{
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.setString('phoneNumber',phoneNumber);
  }

  @override 
  void initState()
  {
    super.initState();   
    isStoreAdmin = false;
    getPhoneNumber().then((value){
      // print(value);
      _phoneNumber = value;
      // print(_phoneNumber);
          if(_phoneNumber == '')
          {
            showDialog(
              context: context,
              builder: (context)
              {
                  return AlertDialog(
                      title: Text('MOBILE NUMBER FROM LOCAL STORAGE'),
                      content: Text("NOT AVAILABLE"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Continue'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            FirebaseAuth.instance.currentUser().then((value) {  
                              // print('current user is ' + value.toString());
                              if (value == null) {        
                                // print("Not a Authenticated Firebase User!!");
                                logMessage = 'Not a Authenticated Firebase User!!';
                                currentUser = '';   
                                isStoreAdmin = false;
                                terminalsAtStore = [];  
                                showDialog(
                                      context: context,
                                      builder: (context)
                                      {
                                          return AlertDialog(
                                              title: Text('FIREBASE AUTHENTICATION'),
                                              content: Text("NOT A Authenticated Firebase User!!"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Continue'),
                                                  onPressed: () {
                                                      Navigator.of(context).pop();
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                          return CustomerMobileLogin();
                                                        }));
                                                  },
                                                ),
                                              ],
                                            );
                                      }                                
                                    );   
                              }
                              else
                              {
                                currentUser = value.toString();
                                _phoneNumber = value.phoneNumber;
                                // print(currentUser);
                                // print(_phoneNumber);
                                setPhoneNumber(_phoneNumber);

                                showDialog(
                                      context: context,
                                      builder: (context)
                                      {
                                          return AlertDialog(
                                              title: Text('FIREBASE AUTHENTICATION'),
                                              content: Text("USER AUTHENTICATED!!" + '\n' + currentUser + '\n' + _phoneNumber),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Continue'),
                                                  onPressed: () {
                                                    // Navigator.of(context).pop();
                                                    FirebaseDatabase.
                                                        instance.
                                                        reference().
                                                        child('storeAdmins').   
                                                        child(_phoneNumber).                    
                                                        once().
                                                        then((snapshot){
                                                          print(snapshot.value);  
                                                          if(snapshot != null && snapshot.value != null){
                                                            if(snapshot.value['isAdmin'])
                                                            {
                                                              isStoreAdmin = true;
                                                              // print('Admin logged in');
                                                              if(snapshot.value['stores'] != null)
                                                              {
                                                                String stores = snapshot.value['stores'].toString();
                                                                terminalsAtStore = stores.split(',');
                                                                // print(terminalsAtStore);
                                                                // print('Admin is authorized for these stores' + stores);
                                                                logMessage = 'Admin' + _phoneNumber + 'is authorized for these stores' + stores;
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context)
                                                                  {
                                                                      return AlertDialog(
                                                                          title: Text('ADMIN STATUS CHECK!!'),
                                                                          content: Text("ALREADY A STORE ADMIN FOR " + stores),
                                                                          actions: <Widget>[
                                                                            FlatButton(
                                                                              child: Text('Continue'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();

                                                                                setState(() {
                                                                                  isStoreAdmin = true;
                                                                                });
                                                                                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                //     return ShowTerminalWiseSalePosition();
                                                                                //   }));
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                  }                                
                                                                );
                                                              }
                                                            }
                                                            else{
                                                           
                                                              // print('Not an Admin');
                                                              logMessage = 'Not Admin';
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context)
                                                                  {
                                                                      return AlertDialog(
                                                                          title: Text('ADMIN STATUS CHECK!!'),
                                                                          content: Text("NOT ADMIN"),
                                                                          actions: <Widget>[
                                                                            FlatButton(
                                                                              child: Text('Continue'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                  setState(() {
                                                                                    isStoreAdmin = false;  
                                                                                    terminalsAtStore = [];
                                                                                  });     
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                  }                                
                                                                );
                                                            }                        
                                                          }
                                                          else
                                                          {
                                                            // setState(() {
                                                            //   isStoreAdmin = false;  
                                                            //   terminalsAtStore = [];
                                                            // });     
                                                            FirebaseDatabase.instance.reference()
                                                              .child('storeAdmins')
                                                              .child(_phoneNumber)                          
                                                              .update({
                                                            'isAdmin':false,
                                                            'stores':''                        
                                                          }).then((snapshot){
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context)
                                                                  {
                                                                      return AlertDialog(
                                                                          title: Text('ADMIN STATUS CHECK!!'),
                                                                          content: Text("NOT ADMIN"),
                                                                          actions: <Widget>[
                                                                            FlatButton(
                                                                              child: Text('Continue'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                  setState(() {
                                                                                    isStoreAdmin = false;  
                                                                                    terminalsAtStore = [];
                                                                                  });     
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                  }                                
                                                                );             
                                                          });
                                                        }
                                                        });
                                                  },
                                                ),
                                              ],
                                            );
                                      }                                
                                    );     
                              }              
                            });
                          },
                        ),
                      ],
                    );
              }                                
            );
    }
    else{
      showDialog(
                context: context,
                builder: (context)
                {
                    return AlertDialog(
                        title: Text('MOBILE NUMBER FROM LOCAL STORAGE'),
                        content: Text("AVAILABLE!! " + _phoneNumber),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Continue'),
                            onPressed: () {
                              FirebaseDatabase.
                                instance.
                                reference().
                                child('storeAdmins').   
                                child(_phoneNumber).                    
                                once().
                                then((snapshot){
                                  // print(snapshot.value);  
                                  if(snapshot != null && snapshot.value != null){
                                    if(snapshot.value['isAdmin'])
                                    {
                                      isStoreAdmin = true;
                                      // print('Admin logged in');
                                      if(snapshot.value['stores'] != null)
                                      {
                                        String stores = snapshot.value['stores'].toString();
                                        terminalsAtStore = stores.split(',');
                                        // print(terminalsAtStore);
                                        // print('Admin is authorized for these stores' + stores);
                                        logMessage = 'Admin' + _phoneNumber + 'is authorized for these stores' + stores;
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (context)
                                          {
                                              return AlertDialog(
                                                  title: Text('ADMIN STATUS CHECK!!'),
                                                  content: Text("ADMIN FOR " + stores),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Continue'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        setState(() {
                                                          isStoreAdmin = true;
                                                        });
                                                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                        //     return ShowTerminalWiseSalePosition();
                                                        //   }));
                                                      },
                                                    ),
                                                  ],
                                                );
                                          }                                
                                        );
                                      }
                                    }
                                    else{
                                                                      
                                      
                                      // print('Not an Admin');
                                      logMessage = 'Not Admin';
                                        showDialog(
                                          context: context,
                                          builder: (context)
                                          {
                                              return AlertDialog(
                                                  title: Text('ADMIN STATUS CHECK!!'),
                                                  content: Text("NOT ADMIN"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Continue'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                         setState(() {
                                                          isStoreAdmin = false;  
                                                          terminalsAtStore = [];
                                                        });     
                                                      },
                                                    ),
                                                  ],
                                                );
                                          }                                
                                        );
                                    }                        
                                  }
                                  else
                                  {
                                 
                                    FirebaseDatabase.instance.reference()
                                      .child('storeAdmins')
                                      .child(_phoneNumber)                          
                                      .update({
                                    'isAdmin':false,
                                    'stores':''                        
                                  }).then((snapshot){
                                        showDialog(
                                          context: context,
                                          builder: (context)
                                          {
                                              return AlertDialog(
                                                  title: Text('ADMIN STATUS CHECK!!'),
                                                  content: Text("NOT ADMIN"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Continue'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                         setState(() {
                                                          isStoreAdmin = false;  
                                                          terminalsAtStore = [];
                                                        });     
                                                      },
                                                    ),
                                                  ],
                                                );
                                          }                                
                                        );             
                                  });
                                }
                                });
                            },
                          ),
                        ],
                      );
                }                                
              ); 
    }
    });   
}


Future<String> getPhoneNumber() async{
var _preferences = await SharedPreferences.getInstance();
    var phoneNumber = _preferences.getString('phoneNumber');
    // print(phoneNumber);
    if(phoneNumber == null)    
    {
      // print('phone number is null.returning empty string!!');
      return '';    
    }
    else
    {
      // print('phone number found' + phoneNumber.toString());
      return phoneNumber.toString();
    }
}

  @override
  Widget build(BuildContext context) {
    if(isStoreAdmin)
    return 
    Container(color: Colors.white,
    child:Column(      
      mainAxisAlignment:MainAxisAlignment.center,
      children:<Widget>[      
      Container(
        width:MediaQuery.of(context).size.width,
        decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: FlatButton(
          color: Colors.blue,
          child: Text(
            'ONLINE ORDERS',
            style:TextStyle(
              fontFamily: 'Montserrat', 
              fontSize: 14.0,
              color:Colors.white,
              ),
            textAlign: TextAlign.left,
            ),
          onPressed: (){
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowOrderCount()));
          },
        ),
      ),
      Container(
        decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(5.0))),
        width:MediaQuery.of(context).size.width,
        child: FlatButton(
          color: Colors.blue,
          child: Text(
            'TERMINAL SALES',
            style:TextStyle(
              fontFamily: 'Montserrat', 
              fontSize: 14.0,
              color:Colors.white,
              ),
            textAlign: TextAlign.left,
            ),
          onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ShowTerminalWiseSalePosition();
              }));                   
          }
        ),
      )  ,
      Container(
        decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(5.0))),
        width:MediaQuery.of(context).size.width,
        child: FlatButton(
          color: Colors.blue,
          child: Text(
            'PRODUCT MANAGER',
            style:TextStyle(
              fontFamily: 'Montserrat', 
              fontSize: 14.0,
              color:Colors.white,
              ),
            textAlign: TextAlign.left,
            ),
          onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BarcodeScan();
              }));                   
          }
        ),
      )  ,
            Container(
        decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(5.0))),
        width:MediaQuery.of(context).size.width,
        child: FlatButton(
          color: Colors.blue,
          child: Text(
            'NILA POINT-OF-SALE',
            style:TextStyle(
              fontFamily: 'Montserrat', 
              fontSize: 14.0,
              color:Colors.white,
              ),
            textAlign: TextAlign.left,
            ),
          onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NilaPointOfSale();
              }));                   
          }
        ),
      )  ,

      //  Container(
      //   decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(5.0))),
      //   width:MediaQuery.of(context).size.width,
      //   child: FlatButton(
      //     color: Colors.blue,
      //     child: Text(
      //       'Font Size Picker Test',
      //       style:TextStyle(
      //         fontFamily: 'Montserrat', 
      //         fontSize: 14.0,
      //         color:Colors.white,
      //         ),
      //       textAlign: TextAlign.left,
      //       ),
      //     onPressed: (){
      //         Navigator.push(context, MaterialPageRoute(builder: (context) {
      //           return FontSizePickerTest();
      //         }));                   
      //     }
      //   ),
      // )  ,
      // Container(
      //   decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(5.0))),
      //   width:MediaQuery.of(context).size.width,
      //   child: FlatButton(
      //     color: Colors.blue,
      //     child: Text(
      //       'Category Sale Position',
      //       style:TextStyle(
      //         fontFamily: 'Montserrat', 
      //         fontSize: 14.0,
      //         color:Colors.white,
      //       ),
      //       textAlign: TextAlign.left,
      //       ),
      //     onPressed: (){
      //         Navigator.push(context, MaterialPageRoute(builder: (context) {
      //           return ShowAuthorizedTerminals();
      //         }));                   
      //     }
      //   ),
      // ) ,
      //  Container(
      //   decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(5.0))),
      //   width:MediaQuery.of(context).size.width,
      //   child: FlatButton(
      //     color: Colors.blue,
      //     child: Text(
      //       'Product Sale Position',
      //       style:TextStyle(
      //         fontFamily: 'Montserrat', 
      //         fontSize: 14.0,
      //         color:Colors.white,
      //       ),
      //       textAlign: TextAlign.left,
      //       ),
      //     onPressed: (){
      //         Navigator.push(context, MaterialPageRoute(builder: (context) {
      //           return ShowAuthorizedTerminals();
      //         }));                   
      //     }
      //   ),
      // )         
    ]));
    else
    {
      return Container(
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
                child: Text("Checking Admin Status...")
              ),
            ],
          ),
        ),
      );
    }
  }
}