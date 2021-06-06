import 'dart:ui';
import 'package:evamp_saanga/res/colors.dart';
import 'package:evamp_saanga/screen/ProfileDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evamp_saanga/login_bloc/login_bloc.dart';
import 'package:evamp_saanga/login_bloc/login_event.dart';
import 'package:evamp_saanga/login_bloc/login_state.dart';
import 'package:evamp_saanga/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late LoginBloc _loginBloc;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();

    _loginBloc = LoginBloc(authService: AuthService());
    _emailController.addListener(_emailChangedListened);
    _passwordController.addListener(_passwordChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 30),
          height: size.height,
          color: Colors.blue.shade700,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'e',
                  style: TextStyle(
                      fontSize: 80.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 60,
                  width: size.height * 0.07,
                  child: Divider(
                    color: LprimaryColor,
                    thickness: 2,
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    'Welcome to \nDemo App\nLogin',
                    style: TextStyle(
                        fontSize: 40.0,
                        color: LprimaryColor,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                BlocProvider<LoginBloc>(
                  create: (context) => _loginBloc,
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      //Lsitening for changes in the Bloc. If the state is in submitting then showing the loading snackbar
                      if (state.isSubmitting) {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            duration: Duration(days: 365),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Logging in...',
                                  style: TextStyle(color: Colors.white),
                                ),
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              ],
                            ),
                            backgroundColor: Colors.blue,
                          ));
                      }
                      //If user has successfully logged in then move to the next screen
                      if (state.isSuccess) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileDetail()));
                      }
                      //If the authentication from the API failed means the state is now at failure state then show the error snackbar
                      if (state.isFailure) {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign-in failed!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            backgroundColor: Colors.redAccent,
                          ));
                      }
                    },
                    child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                      return Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.white, width: 1))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enter Your Email',
                                    style: TextStyle(color: LprimaryColor),
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: LprimaryColor),
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.email,
                                        color: Colors.blue.shade200,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    validator: (val) => val!.isNotEmpty
                                        ? null
                                        : 'Please enter a password.',
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Colors.white70))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enter Password',
                                    style: TextStyle(color: LprimaryColor),
                                  ),
                                  TextFormField(
                                    style: TextStyle(color: LprimaryColor),
                                    obscureText: hidePassword,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.password,
                                        color: Colors.blue.shade200,
                                      ),
                                      suffixIcon: GestureDetector(
                                          onTap: () => setState(() =>
                                              hidePassword = !hidePassword),
                                          child: hidePassword
                                              ? Icon(
                                                  Icons.visibility_off,
                                                  color: Colors.blue.shade200,
                                                )
                                              : Icon(
                                                  Icons.visibility,
                                                  color: Colors.blue.shade200,
                                                )),
                                      // labelText: 'Enter Password',
                                      border: InputBorder.none,
                                    ),
                                    validator: (val) => val!.isNotEmpty
                                        ? null
                                        : 'Please enter a password.',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              width: size.width,
                              child: MaterialButton(
                                  height: size.height * 0.07,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: Colors.blue,
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate()) {
                                      //Dispatching an event to the BLoC that the bloc will perform operations to accordingly.
                                      if (_emailController.text.contains(RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'))) {
                                        _loginBloc
                                            .add(LoginWithCredentialsPressed(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        ));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Email is not valid",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    } else {}
                                  }),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _emailChangedListened() {
    //Dispatching an event to the Bloc that is Email has changed
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _passwordChangedListener() {
    //Dispatching an event to the Bloc that is Password has changed
    _loginBloc.add(LoginPasswordChange(password: _passwordController.text));
  }
}
