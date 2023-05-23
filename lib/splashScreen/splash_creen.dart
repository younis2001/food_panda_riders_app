import 'dart:async';
import 'package:flutter/material.dart ';
import '../authentication/auth_screen.dart';
import '../globel/globel.dart';
import '../mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer(){
    Timer(const Duration(seconds: 8),()async{
      if(firebaseAuth.currentUser!=null){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
      else{

        Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthScreen()));
      }

    }
    );
  }
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'World Largest Online Food App' ,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 24,
                      fontFamily: 'Signatra',
                      letterSpacing: 3),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
