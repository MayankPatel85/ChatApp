import 'dart:io';

import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/authentication_buttons/auth_button.dart';
import 'package:chat_app/widgets/authentication_buttons/submit_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  bool _isHidden = true;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    final _auth = FirebaseAuth.instance;
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (isValid) {
      _formKey.currentState.save();
      try {
        if (_authMode == AuthMode.Signup) {
          final authResult = await _auth.createUserWithEmailAndPassword(
              email: _userEmail, password: _userPassword);
          FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user.uid)
              .set({
            'username': _userName,
            'email': _userEmail,
          });
        }
        await _auth.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
      } on FirebaseAuthException catch (e) {
        showErrorBox(e.message);
      } catch (e) {
        showErrorBox('Something Went Wrong.');
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> showErrorBox(String errorMessage) async {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: Text('Something went wrong'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Something went wrong'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _authMode == AuthMode.Login ? 'Welcome Back' : 'Hello',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SvgPicture.asset(
                _authMode == AuthMode.Login
                    ? 'assets/icons/login.svg'
                    : 'assets/icons/signup.svg',
                height: size.height * 0.4,
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthButton(
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                        ),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (_authMode == AuthMode.Signup)
                      AuthButton(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter username',
                            icon: Icon(
                              Icons.person_add,
                              color: kPrimaryColor,
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 5) {
                              return 'Username should be at least 4 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userName = value;
                          },
                        ),
                      ),
                    AuthButton(
                      child: TextFormField(
                        cursorColor: kPrimaryColor,
                        controller: passwordController,
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          suffixIcon: GestureDetector(
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: kPrimaryColor,
                            ),
                            onTap: () {
                              setState(() {
                                _isHidden = !_isHidden;
                              });
                            },
                          ),
                        ),
                        onSaved: (value) {
                          _userPassword = value;
                        },
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Password should be at least 6 characters long.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: _isLoading
                    ? CircularProgressIndicator()
                    : SubmitButton(
                        title: _authMode == AuthMode.Login ? 'Login' : 'SignUp',
                        bgColor: kPrimaryColor,
                        textColor: Colors.white,
                        press: _trySubmit,
                      ),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: kPrimaryColor),
                onPressed: () {
                  _switchAuthMode();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_authMode == AuthMode.Login
                        ? 'Don\'t have an account'
                        : 'Already have an account'),
                    Text(_authMode == AuthMode.Login ? 'Sign Up' : 'Login'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
