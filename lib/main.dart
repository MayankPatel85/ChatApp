import 'package:chat_app/screens/show_users_screen.dart';
import 'package:chat_app/screens/splash-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/screens/auth_screen.dart';
import './screens/chat_screen.dart';
import 'constants.dart';
import 'screens/auth_screen.dart';
import 'screens/people_chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'chatApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(backgroundColor: kPrimaryColor),
        ),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
          ShowUsersScreen.routeName: (ctx) => ShowUsersScreen(),
        },
        home: snapshot.connectionState != ConnectionState.done
            ? SplashScreen()
            : StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, authSnapshot) {
                  if (authSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      backgroundColor: kPrimaryColor,
                    ));
                  }
                  if (authSnapshot.hasData) {
                    return PeopleChatScreen();
                  }
                  return AuthScreen();
                },
              ),
      ),
    );
  }
}
