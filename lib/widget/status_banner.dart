import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;
  StatusBanner({
    this.status,
    this.orderStatus
});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;
    status! ? iconData =Icons.done : Icons.cancel;
    status! ? message = 'Successful' : message = 'UnSuccessful';


    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin:  FractionalOffset(0.0, 0.0),
            end:  FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
      ),
      height: 40,
      child: Row(mainAxisAlignment:MainAxisAlignment.center ,
        
        children: [
GestureDetector(
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
  },
  child: Icon(Icons.arrow_back,color: Colors.white,),
),
          SizedBox(
            width: 20,
          ),
          Text(
            orderStatus =="ended" ? "parcel Delivered ${message}"
                : 'Order Placed ${message}',
            style:TextStyle(color: Colors.white) ,

          ),
          SizedBox(width: 5,),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Icon(iconData,color: Colors.white,
            size: 14,),

          )
        ],
      ),
    );

  }
}
