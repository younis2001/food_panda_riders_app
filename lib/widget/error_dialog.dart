import 'package:flutter/material.dart';
class ErrorDialog extends StatelessWidget {
 final String message;

  const ErrorDialog({super.key, required this.message});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Center(
          child: Text('ok'),
        ),
          style: ElevatedButton.styleFrom(
            primary: Colors.red
          ),
        )
      ],
    );
  }
}
