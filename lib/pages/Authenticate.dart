import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ShowTerminalWiseSalePositionStreamBuilder.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
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
    firebaseID = user.uid.toString();   
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('FirebaseID', firebaseID);

    showDialog(
                context: context,
                builder: (context)
                {
                    return AlertDialog(
                        // title: Text('verifyOTP: OTP Verfication Status!!'),
                        content: const Text('OTP Authenticated Successfully!!', 
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

  /// Sends the code to the specified phone number.
  /// Calls PhoneVerificationCompleted only when the user is automatically logged in.
  /// Without the need to enter OTP manually.
  Future<void> sendOTP() async {
    final PhoneVerificationCompleted verificationCompleted = (
      
        AuthCredential credential) {

           showDialog(
                context: context,
                builder: (context)
                {
                    return AlertDialog(
                        title: Text("sendOTP:Mobile Login Status"),
                        content: Text("Phone Verification Completed!!"),
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

        FirebaseAuth.instance.signInWithCredential(credential).then((user){
           showDialog(
                context: context,
                builder: (context)
                {
                    return AlertDialog(
                        title: Text("signInWithCredential:Mobile Login Status"),
                        content: Text("Phone Verification Completed!!"),
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
                      content: Text("Either our Servers are busy or there is a Technical Failure!!",
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
      print('Authenticating.....');

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
                        // mobileNumberTextController.clear();
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
