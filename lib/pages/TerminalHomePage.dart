import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/CustomerMobileLogin.dart';
import 'package:kiranawala_admin/pages/ShowTerminalWiseSalePositionStreamBuilder.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TerminalHomePage extends StatefulWidget {
  @override
  _TerminalHomePageState createState() => _TerminalHomePageState();
}

class _TerminalHomePageState extends State<TerminalHomePage> {

   
  String _phoneNumber;

   Future<bool> setPhoneNumber(String phoneNumber) async{
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.setString('phoneNumber',phoneNumber);
  }

  @override 
  void initState()
  {
    super.initState();   
     setPhoneNumber('').then((value){
      if(value){
                 showDialog(
              context: context,
              builder: (context)
              {
                  return AlertDialog(
                      title: Text('RESET MOBILE NUMBER'),
                      content: Text("SUCCESSFUL!!"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Continue'),
                          onPressed: () {
                              FirebaseAuth.instance.signOut().then((onValue){
                                Navigator.of(context).pop();   
                                  getPhoneNumber().then((value){
      print(value);
      _phoneNumber = value;
      print(_phoneNumber);
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
                              print('current user is ' + value.toString());
                              if (value == null) {        
                                print("Not a Authenticated Firebase User!!");
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
                                print(currentUser);
                                print(_phoneNumber);
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
                                                              print('Admin logged in');
                                                              if(snapshot.value['stores'] != null)
                                                              {
                                                                String stores = snapshot.value['stores'].toString();
                                                                terminalsAtStore = stores.split(',');
                                                                print(terminalsAtStore);
                                                                print('Admin is authorized for these stores' + stores);
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
                                                                                // Navigator.of(context).pop();
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                    return ShowTerminalWiseSalePosition();
                                                                                  }));
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                  }                                
                                                                );
                                                              }
                                                            }
                                                            else{
                                                              isStoreAdmin = false;
                                                              terminalsAtStore = [];
                                                              print('Not an Admin');
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
                                  print(snapshot.value);  
                                  if(snapshot != null && snapshot.value != null){
                                    if(snapshot.value['isAdmin'])
                                    {
                                      isStoreAdmin = true;
                                      print('Admin logged in');
                                      if(snapshot.value['stores'] != null)
                                      {
                                        String stores = snapshot.value['stores'].toString();
                                        terminalsAtStore = stores.split(',');
                                        print(terminalsAtStore);
                                        print('Admin is authorized for these stores' + stores);
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
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                            return ShowTerminalWiseSalePosition();
                                                          }));
                                                      },
                                                    ),
                                                  ],
                                                );
                                          }                                
                                        );
                                      }
                                    }
                                    else{
                                      isStoreAdmin = false;
                                      terminalsAtStore = [];
                                      print('Not an Admin');
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
                              });                        
                          },
                        ),
                      ],
                    );
              }                                
            );   
      }
      else
      {
        showDialog(
          context: context,
          builder: (context)
          {
            return AlertDialog(
              title: Text('RESET MOBILE NUMBER'),
              content: Text("NOT SUCCESSFUL!!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.of(context).pop();
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
    print(phoneNumber);
    if(phoneNumber == null)    
    {
      print('phone number is null.returning empty string!!');
      return '';    
    }
    else
    {
      print('phone number found' + phoneNumber.toString());
      return phoneNumber.toString();

    }
    
}




  @override
  Widget build(BuildContext context) {
    return 
    Container(color: Colors.white,
    child:Column(
      
      mainAxisAlignment:MainAxisAlignment.center,
      children:<Widget>[      
      FlatButton(
        color: Colors.blue,
        child: Text(
          'Online Orders',
          style:TextStyle(fontFamily: 'Montserrat', fontSize: 12.0),
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
      FlatButton(
        color: Colors.blue,
        child: Text(
          'Sale Position',
          style:TextStyle(fontFamily: 'Montserrat', fontSize: 12.0),
          textAlign: TextAlign.left,
          ),
        onPressed: (){
          print(currentUser);
          print(isStoreAdmin);
          print(terminalsAtStore);
          if(isStoreAdmin)
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ShowTerminalWiseSalePosition();
                            }));
          else
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CustomerMobileLogin();
                            }));
        }           
      )     
    ]));
  }
}