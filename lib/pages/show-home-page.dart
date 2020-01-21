import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'BarcodeScan.dart';
import 'CustomerMobileLogin.dart';
import 'ShowTerminalWiseSalePositionStreamBuilder.dart';
import 'nila-point-of-sale.dart';

class ShowHomePage extends StatefulWidget {
  @override
  _ShowHomePageState createState() => _ShowHomePageState();
}

class _ShowHomePageState extends State<ShowHomePage> {

  String _phoneNumber;

  Future<bool> setPhoneNumber(String phoneNumber) async{
  var _preferences = await SharedPreferences.getInstance();
  return _preferences.setString('phoneNumber',phoneNumber);
  }

  void initState()
  {
    super.initState();   
    isStoreAdmin = false;
    getPhoneNumber().then((value){
      _phoneNumber = value;

      if(_phoneNumber == '')
      {
        FirebaseAuth.instance.currentUser().then((value) 
        {                                
          if (value == null) {                                        
            logMessage = 'Not a Authenticated Firebase User!!';
            currentUser = '';   
            isStoreAdmin = false;
            terminalsAtStore = [];                                 
            Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CustomerMobileLogin();
              }));
          }
          else
          {
            currentUser = value.toString();
            _phoneNumber = value.phoneNumber;                              
            setPhoneNumber(_phoneNumber);
            FirebaseDatabase.
                instance.
                reference().
                child('storeAdmins').   
                child(_phoneNumber).                    
                once().
                then((snapshot){
                  print(snapshot.value);  
                  if(snapshot != null && snapshot.value != null)
                  {
                    if(snapshot.value['isAdmin'])
                    {
                      isStoreAdmin = true;
                      if(snapshot.value['stores'] != null)
                      {
                        String stores = snapshot.value['stores'].toString();
                        terminalsAtStore = stores.split(',');
                        print('Admin' + _phoneNumber + 'is authorized for these stores' + stores);
                        setState(() {
                          isStoreAdmin = true;
                        });
                      }
                    }
                    else
                    {
                      logMessage = 'Not Admin';                                                                
                      setState(() {
                        isStoreAdmin = false;  
                        terminalsAtStore = [];
                      });
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
                  }).then((snapshot)
                    {                                                                
                      setState(() {
                        isStoreAdmin = false;  
                        terminalsAtStore = [];
                      });     
                    },
                  );
                }                  
              });                                                 
          }              
        });
    }
    else
    {
      FirebaseDatabase.
        instance.
        reference().
        child('storeAdmins').   
        child(_phoneNumber).                    
        once().
        then((snapshot)
        {
          if(snapshot != null && snapshot.value != null)
          {
            if(snapshot.value['isAdmin'])
            {
              isStoreAdmin = true;
              if(snapshot.value['stores'] != null)
              {
                String stores = snapshot.value['stores'].toString();
                terminalsAtStore = stores.split(',');
                print('Admin' + _phoneNumber + 'is authorized for these stores' + stores);
               
                setState(() {
                  isStoreAdmin = true;
                });
              }
            }
            else
            {
              setState(() {
                isStoreAdmin = false;  
                terminalsAtStore = [];
              });     
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
              }).then((snapshot)
                {
                  setState(() {
                    isStoreAdmin = false;  
                    terminalsAtStore = [];
                  }); 
                });
          }
        });
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
    // return Container(
    //   color:Colors.white,

    // );
    if(isStoreAdmin )
    {
    return 
    Scaffold(
      appBar: AppBar(title:Text('KIRANAWALA')),
      body:
      Container(
    child:Column(      
      mainAxisAlignment:MainAxisAlignment.center,
      children:<Widget>[      
      Container(
        width:MediaQuery.of(context).size.width,
        decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: FlatButton(
          color: Colors.blue,
          child: Text(
            'Online Orders',
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
            'Terminal Sale Position',
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
            'NILA Point-Of-Sale',
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
    ]
  )
)
    );

      


    }    
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
                child: Text("Checking User Credentials.......")
              ),
            ],
          ),
        ),
      );
      
    }
    
    
  }
}