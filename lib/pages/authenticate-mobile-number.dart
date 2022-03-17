import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';
import '../main.dart';

class AuthenticateMobileNumber extends StatefulWidget {
  @override
  _AuthenticateMobileNumberState createState() =>
      _AuthenticateMobileNumberState();
}

class _AuthenticateMobileNumberState extends State<AuthenticateMobileNumber> {
  // Inside State class.
  TextEditingController mobileNumberTextController = TextEditingController();
  TextEditingController smsCodeTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode mobileNumberFocusNode;
  FocusNode smsCodeFocusNode;
  bool isLoading = false;
  String mobileNumberMessage = 'OTP WILL BE SENT TO THIS NUMBER';
  FirebaseAuth _auth = FirebaseAuth.instance;
  String otpMessage = 'MUST BE 6 DIGITS';

  void initState() {
    super.initState();
    authenticating = false;
    otpAuthenticated = false;
    otpAuthenticationFailed = false;
  }

  Future<bool>
  smsOTPDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('OTP',
                textAlign: TextAlign.center,
                style:TextStyle(
                fontFamily: 'Montserrat',
                fontWeight:FontWeight.bold,
                fontSize: 36.0,
                color: Colors.blue)),
            content: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: TextField(
                    textAlign: TextAlign.center,
                    autofocus: true,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 36.0,
                          color: Colors.black),
                    onChanged: (value) {
                      OTP = value;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(otpMessage,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),


            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    elevation:10.0,
                    color:Colors.blue,
                    child: Text('GO BACK',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            fontWeight:FontWeight.bold,
                            color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        otpAuthenticationFailed = false;
                        otpAuthenticated = false;
                        authenticating = false;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    elevation:10.0,
                    color:Colors.blue,
                    child: Text('DONE',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            fontWeight:FontWeight.bold,
                            color: Colors.white)),
                    onPressed: () {
                      if (OTP.length == 6) {
                        print('Signing in with OTP');
                        Navigator.of(context).pop();
                        _signInWithPhoneNumber(OTP);
                      } else {
                        setState(() {
                          otpMessage = 'CANNOT PROCEED WITHOUT OTP';
                        });
                      }
                    },
                  ),
                ),
              )
            ],
            )
          ]
          ));
        });
  }

  Future<bool> smsAuthenticationFailedDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('AUTHENTICATION FAILURE',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0,
                    color: Colors.blue)),
            content: Container(
              height: 85,
              child: Container(
                child: Text('PLEASE TRY AGAIN LATER!!',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        color: Colors.blue)),
              ),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                  child: Text('TRY AGAIN'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  /// Sign in using an sms code as input.
  void _signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
      FirebaseAuth.instance.signInWithCredential(credential).then((FirebaseUser user){

        mobileNumber = mobile;
        firebaseId = user.uid.toString();
        print(firebaseId);
        setMobileNumber(mobileNumber);

        setState(() {
          authenticating = false;
          otpAuthenticated = true;
          otpAuthenticationFailed = false;
        });
    }).catchError((dynamic onError){
        print(onError.toString());
        setState(() {
          otpAuthenticated = false;
          authenticating = false;
          otpAuthenticationFailed = true;
        });
      }
    );



//    checkAndRetrieveCustomerInfo();
  }

  /// Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber() async {
    setState(() {
      authenticating = true;
    });

    //START - MOBILE VERIFICATION SUCCESSFUL
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        mobileNumber = mobile;
        firebaseId = user.uid.toString();
        print(firebaseId);
        setMobileNumber(mobileNumber);
        setState(() {
          authenticating = false;
          otpAuthenticationFailed = false;
          otpAuthenticated = true;
        });
//        checkAndRetrieveCustomerInfo();
      }).catchError((dynamic onError){
        print(onError.toString());
        setState(() {
          authenticating = false;
          otpAuthenticationFailed = true;
          otpAuthenticated = false;
        });
        });
    };

    //END - MOBILE VERFICATION SUCCESSFUL

    //START - MOBILE VERIFICATION FAILED
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('AuthenticateMobileNumber:PhoneVerificationFailed:verification failed');
      print(
          'AuthenticateMobileNumber:PhoneVerificationFailed:AuthException:Code: ${authException.code}. Message: ${authException.message}');
      setState(() {
        authenticating = false;
        otpAuthenticated = false;
        otpAuthenticationFailed = true;
      });
    };
    //END - MOBILE VERIFICATION FAILED

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
        setState(() {
          authenticating = true;
        });
      });
    };

    //START - OTP SENT
    final PhoneCodeSent codeSent =
        (String verId, [int forceResendingToken]) async {
      setState(() {
        authenticating = true;
      });
      verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
        print('Verification Id is:' + verificationId.toString());
        print("code sent to (+91)" + mobile);
      });
    };
    //END - OTP SENT

    //START - PHONE CODE RETRIEVAL FAILED
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verId) {
      verificationId = verId;
      print("time out");
    };

    //END - PHONE CODE RETRIEVAL FAILED

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
    if (authenticating) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              authenticating = false;
              Navigator.of(context).pop();
            },
          ),
          title: Center(
            child: Text(
              'OTP Authentication',
              style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          centerTitle: true,
        ),

        body: Container(
          color: Colors.white,
          child: Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Authenticating"),
              ],
            ),
          ),
        ),
      );
    } else if (!otpAuthenticated) {
      if (otpAuthenticationFailed) {
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: Center(
              child: Text(
                'LOGIN',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
            ),
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
                      child: Text(
                        'VERIFICATION FAILED',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
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
                      child: RaisedButton(
                        elevation: 10.0,
                        child: Text(
                          'TRY AGAIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize: 36.0),
                        ),
                        onPressed: () {
                          setState(() {
                            otpAuthenticationFailed = false;
                            otpAuthenticated = false;
                            authenticating = false;
                          });

                        },
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      else {
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title:  Center(
              child: Text(
                'LOGIN',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
            ),
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
                      child: Text(
                        '10-DIGIT MOBILE NUMBER',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
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
                      child: TextField(
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 36.0),
                        autofocus: true,
                        focusNode: mobileNumberFocusNode,
                        controller: mobileNumberTextController,
                        decoration: InputDecoration(
                          hintText: "",
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
                      child: Text(
                        mobileNumberMessage,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
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
                      child: RaisedButton(
                        elevation:10.0,
                        child: Text(
                          'SEND OTP',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize: 36.0),
                        ),
                        onPressed: () {
                          if (mobileNumberTextController.text.length != 10) {
                            setState(() {
                              mobileNumberMessage = 'ERROR: MUST BE 10 DIGITS';
                            });

                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                'Error:10 digits. No Country Code!!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              duration: new Duration(seconds: 30),
                            ));
                          } else {
                            authenticating = true;
                            mobileNumberMessage =
                            'OTP WILL BE SENT TO THIS NUMBER';
                            mobile = mobileNumberTextController.text.toString();
                            mobileNumberTextController.clear();
                            // FocusScope.of(context).requestFocus(smsCodeFocusNode);
                            _sendCodeToPhoneNumber();
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: new Text(
                                'OTP SENT. PLEASE CHECK SMS!!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              duration: new Duration(seconds: 5),
                            ));
                          }
                        },
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    else
      {
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: Center(
              child: Text(
                'LOGIN',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
            ),
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
                      child: Text(
                        'MOBILE NUMBER VERIFIED',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
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
                      child: Text(
                        mobileNumber,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
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
                      child: RaisedButton(
                        elevation: 10.0,
                        child: Text(
                          'PROCEED',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return ShowAdminHomePage();
                            }
                          ));
                        },
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
  }
}
