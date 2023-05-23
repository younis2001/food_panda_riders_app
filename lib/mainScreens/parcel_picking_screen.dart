import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/assistantMethods/get_current_location.dart';
import 'package:foodpanda_riders_app/globel/globel.dart';
import 'package:foodpanda_riders_app/mainScreens/parcel_delivering_screen.dart';
import 'package:foodpanda_riders_app/maps/map_utils.dart';
class ParcelPickingScreen extends StatefulWidget {
 String? purchaserId;
 String? sellerId;
 String? getOrderID;
 double? purchaserLat;
 double? purchaserLng;
 String? purchaserAddress;
 ParcelPickingScreen({
   this.purchaserId
   ,this.sellerId,
   this.getOrderID,
   this.purchaserLat,
   this.purchaserLng,
   this.purchaserAddress
});

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {

  double? sellerLat, sellerLng;

  getSellerData() async
  {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((DocumentSnapshot)
    {
      sellerLat = DocumentSnapshot.data()!["lat"];
      sellerLng = DocumentSnapshot.data()!["lng"];
    });
  }


  @override
  void initState() {

    super.initState();
    getSellerData();
  }

  confirmParcelHasBeenPicked(getOrderId,sellerId,purchaserId,purchaserAddress,purchaserLat,purchaserLng)
  {

    FirebaseFirestore.instance
        .collection('orders')
        .doc(getOrderId)
        .update({
      'status':'delivering',
      'address':completeAddress,
      'lat':position!.latitude,
      'lng':position!.longitude
    });
Navigator.push(context, MaterialPageRoute(builder: (c)=>ParcelDeliveringScreen(
  purchaserId:purchaserId,
  purchaserAddress:purchaserAddress,
  purchaserLat:purchaserLat,
  purchaserLng:purchaserLng,
  sellerId:sellerId,
  getOrderId:getOrderId
)));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/confirm1.png',width: 350,),
          SizedBox(height: 5,),
          GestureDetector(
            onTap: ()
            {
MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, sellerLat, sellerLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/restaurant.png',width: 50,),
                SizedBox(height: 7,),
                Column(
                  children: [
                    SizedBox(height: 12,),

                    Text('Show Cafe/ Restaurant Location',
                    style: TextStyle(
                      fontFamily: "Signatra",
                      fontSize: 18,
                      letterSpacing: 2
                    ),),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: ()
                {
                  UserLocation uLocation=UserLocation();
                  uLocation.getCurrentLocation();
confirmParcelHasBeenPicked(
    widget.getOrderID,
    widget.sellerId,
    widget.purchaserId,
    widget.purchaserAddress,
    widget.purchaserLat,
    widget.purchaserLng);
                },
                child: Container(
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
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been Picked - confirmed",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
