import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/authentication/auth_screen.dart';
import '../globel/globel.dart';
import '../mainScreens/home_screen.dart';
import '../widget/customtext_field.dart';
import '../widget/error_dialog.dart';
import '../widget/loading_dialog.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  formValidation(){
    if(emailController.text.isNotEmpty&&passwordController.text.isNotEmpty){
      //login
      loginNow();
    }
    else
    {
      showDialog(context: context, builder: (c){
        return ErrorDialog(message: 'please write email /passwored');
      }
       );
    }
  }
  loginNow()async{
    showDialog(context: context,
        builder: (c){
      return LoadingDialog(
        message: 'checking credentials' ,
      );
        });
    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(email: emailController.text.trim(),
        password: passwordController.text.trim()).then((value) {
          currentUser=value.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c){
        return ErrorDialog(message: error.message.toString());
      }
      );
    });
    if(currentUser!=null)
    {
readDataAndSetDataLocally(currentUser!);

    }
  }
  Future readDataAndSetDataLocally(User currentUser)async
  {
await FirebaseFirestore.instance.collection('riders').
    doc(currentUser.uid).get().then((snapshot) async{
      if ( snapshot.exists){
        await sharedPreferences!.setString('uid', currentUser.uid);
        await sharedPreferences!.setString('email', snapshot.data()!['riderEmail']);
        await sharedPreferences!.setString('name', snapshot.data()!['riderName']);
        await sharedPreferences!.setString('photoUrl', snapshot.data()!['riderAvatarUrl']);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));

      }
      else
        {
          firebaseAuth.signOut();
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (c)=>AuthScreen()));
          showDialog(context: context, builder: (c){
            return ErrorDialog(message: 'no record exists ');
          }
          );
        }

});
  }
 
  

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
         Container(
           alignment: Alignment.bottomCenter,
           padding: EdgeInsets.all(15),
           child: Image.asset('images/signup.png',
           height: 270,),

         ) ,
          Form(
            key:_formKey ,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: 'email',
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: 'password',
                  isObsecre: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: ()
          {
formValidation();


          },
            child:
          Text('Login',
            style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ) ,),
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10)
            ),

          )
          

        ],
      ),
    );
  }
}
