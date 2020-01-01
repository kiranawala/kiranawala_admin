import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';

class CustomerMobileLogin extends StatefulWidget {
  @override
  _CustomerMobileLoginState createState() => _CustomerMobileLoginState();
}

class _CustomerMobileLoginState extends State<CustomerMobileLogin> {

  Future<bool> setPhoneNumber(String phoneNumber) async{
  var _preferences = await SharedPreferences.getInstance();
    return _preferences.setString('phoneNumber',phoneNumber);
  }

  // Inside State class.
  String verificationId;
  TextEditingController mobileNumberTextController = TextEditingController();
  TextEditingController smsCodeTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode mobileNumberFocusNode;
  FocusNode smsCodeFocusNode;
  String mobile;
  bool isLoading = false;

  /// Sign in using OTP
  /// Called when the button is clicked after entering the OTP
  /// Called irrespective of whether the mobile is automatically authenticated
  void verifyOTP(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
    otpAuthenticated = true;
    mobileNumber = '+91' + mobile;
    print(mobileNumber);
    firebaseId = user.uid.toString();
    print('firebaseId is ' + firebaseId);

    FirebaseDatabase.instance.
                    reference().
                    child('storeAdmins').   
                    child(mobileNumber).                    
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

                          }
                        }
                        else{
                          isStoreAdmin = false;
                          terminalsAtStore = [];
                          print('Not an Admin');
                        }                        
                      }
                      else
                      {
                        FirebaseDatabase.instance.reference()
                          .child('storeAdmins')
                          .child(mobileNumber)                          
                          .update({
                        'isAdmin':false,
                        'stores':''                        
                      }).then((snapshot){
                        print('Not Admin!!');                        
                      });
                    }
                    showDialog(
                      context: context,
                      builder: (context)
                      {
                          return AlertDialog(
                              title: Text('VERIFYOTP'),
                              content: const Text('OTP Verified Successfully!!', 
                                              style:TextStyle(
                                                color:Colors.black,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0
                                              )),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Continue'),
                                  onPressed: () {
                                    print(mobileNumber);
                                    print(firebaseId);
                                    setPhoneNumber(mobileNumber);
                                    Navigator.of(context).pop();
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return HomePage();
                                        }));
                                  },
                                ),
                              ],
                            );
                      }                                
                    );
            });       
  }

  /// Sends the code to the specified phone number.
  /// Calls PhoneVerificationCompleted only when the user is automatically logged in.
  /// Without the need to enter OTP manually.
  Future<void> sendOTP() async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential credential) {
        FirebaseAuth.instance.signInWithCredential(credential).then((user){
          otpAuthenticated = true;
          mobileNumber = user.phoneNumber;
          setPhoneNumber(mobileNumber);
          firebaseId = user.uid.toString();
          print(mobileNumber);
          print(firebaseId);
          FirebaseDatabase.instance.
                    reference().
                    child('storeAdmins').   
                    child(mobileNumber).                    
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

                          }
                        }
                        else{
                          isStoreAdmin = false;
                          terminalsAtStore = [];
                          print('Not an Admin');
                        }                        
                      }
                      else
                      {
                        FirebaseDatabase.instance.reference()
                          .child('storeAdmins')
                          .child(mobileNumber)                          
                          .update({
                        'isAdmin':false,
                        'stores':''                        
                      }).then((snapshot){
                        print('Not Admin!!');                        
                      });
                    }
                    showDialog(
                      context: context,
                      builder: (context)
                      {
                          return AlertDialog(
                              title: Text("OTP AUTO VERFICATION & SIGN IN WITHCREDENTIAL"),
                              content: Text("SUCCESSFUL!!"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Continue'),
                                  onPressed: () {
                                    print(mobileNumber);
                                    print(firebaseId);
                                    
                                      Navigator.of(context).pop();
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return HomePage();
                                        }));
                                  },
                                ),
                              ],
                            );
                      }                                
                    );
                  });  
      });
    };

    //THIS FUNCTIONS CAPTURES ALL KINDS OF AUTHENTICATION PROBLEMS ON THE SERVER SIDE
    //EVEN BEFORE OTP IS SENT ERROR IS THROWN
     final PhoneVerificationFailed verificationFailed = (AuthException authException) {
    showDialog(
                context: context,
                builder: (context)
                {
                    return AlertDialog(
                      title: Text("Authentication Failed",
                        style:TextStyle(
                          color:Colors.black,
                          fontFamily: "Montserrat",
                          fontSize:12.0,
                          fontWeight:FontWeight.bold
                        ),
                      ),
                      content: Text("Our Servers are busy. Please try again later!!",
                       style:TextStyle(
                                color:Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold
                              ),),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Continue",
                              style:TextStyle(
                                color:Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold
                              ),
                              ),                              
                            onPressed: () {
                              print(mobileNumber);
                              print(firebaseId);
                                Navigator.of(context).pop();
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return HomePage();
                                  }));
                            },
                          ),
                        ],
                      );
                }                                
              );
      print('verfication failed');
      setState(() {
        print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      }
      );
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print('Verification Id is:' + verificationId.toString());
      print("code sent to (+91)" + mobile);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + mobile,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  Widget build(BuildContext context) {
      return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('LOGIN',  
                                    style:TextStyle(
                                      color:Colors.black,
                                      fontFamily: "Montserrat", 
                                      fontWeight:FontWeight.bold,
                                      fontSize:12.0),),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(0.4),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextField(
                      autofocus: true,
                      focusNode: mobileNumberFocusNode,
                      controller: mobileNumberTextController,
                      decoration: InputDecoration(
                        hintText: "Mobile Number",
                        icon: Icon(Icons.contact_phone),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(0.4),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: FlatButton(onPressed: () {
                      if (mobileNumberTextController.text.length != 10) {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: new Text(
                                'Error:10 digits. No Country Code!!',
                                style:TextStyle(
                                color:Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                              duration: new Duration(seconds: 5),
                            )
                        );
                      }
                      else {
                        mobile = mobileNumberTextController.text.toString();
                        mobileNumberTextController.clear();
                        sendOTP();
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: new Text(
                                'OTP SENT. PLEASE CHECK SMS!!', 
                                style:TextStyle(
                                color:Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold
                              ),),
                              duration: new Duration(seconds: 5),
                            )
                        );
                      }
                    },
                      child: Text(
                          'Send OTP',  
                          style:TextStyle(
                          color:Colors.black,
                          fontFamily: "Montserrat",
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold
                          ),
                          ),
                      color: Colors.blue,),
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(0.4),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                      ],
                      controller: smsCodeTextController,
                      focusNode: smsCodeFocusNode,
                      decoration: InputDecoration(
                        hintText: "OTP from SMS Received",
                        icon: Icon(Icons.code),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                ),
              ),
              new FlatButton(
                onPressed: () {
                  verifyOTP(smsCodeTextController.text);
                },
                child: const Text(
                    "Sign In",  
                    style:TextStyle(
                    color:Colors.black,
                    fontFamily: "Montserrat",
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                color: Colors.blue,)
            ],
          ),
        ),
      );
    }    
}
