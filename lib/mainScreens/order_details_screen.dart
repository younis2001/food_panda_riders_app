import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/address.dart';
import '../widget/progress_bar.dart';
import '../widget/shipment_address_design.dart';
import '../widget/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
final String? orderID;

OrderDetailsScreen({this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  String orderStatus='';
  String orderByUser="";
  String sellerId="";


  getOrderInfo(){
    FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderID)
        .get()
        .then((value) => {
          orderStatus=value.data()!['status'].toString(),
          orderByUser=value.data()!['orderBy'].toString(),
      sellerId=value.data()!['sellerUID'].toString(),

    });
  }

  @override
  void initState() {
    super.initState();
    getOrderInfo();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:  FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.orderID)
              .get(),
          builder: (c,snapshot)
          {
            Map? dataMap;
            if(snapshot.hasData)
              {
                dataMap=snapshot.data!.data() as Map<String,dynamic>;
                orderStatus=dataMap['status'].toString();
              }
            return snapshot.hasData
                ? Container(
              child: Column(
                children: [
StatusBanner(
  status:dataMap!['isSuccess'] ,
  orderStatus: orderStatus,
),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('€ '+ dataMap['totalAmount'].toString(),
                      style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Order Id: ' + widget.orderID!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Order at: " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap['orderTime']))),
                      style: TextStyle(fontSize: 16,color: Colors.grey),
                    ),
                  ),
                  Divider(thickness: 4,),
                  orderStatus=='ended'
                  ?Image.asset('images/success.jpg')
                      :Image.asset('images/confirm_pick.png'),
                  Divider(thickness: 4,),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(orderByUser)
                    .collection('userAddress')
                    .doc(dataMap['addressID'])
                    .get(),
                    builder: (c,snapshot)
                    {
                      return snapshot.hasData
                          ?ShipmentAddressDesign(
                        model: Address.fromJson(
                            snapshot.data!.data() as Map<String,dynamic>
                        ),
                        orderStatus: orderStatus,
                        orderId:widget.orderID,
                        sellerId:sellerId,
                        orderByUser:orderByUser



                      )
                          :Center(child: CircularProgress(),);
                    }
                    ,
                  )
                ],
              ),
            )
                :Center(child: CircularProgress(),);
          },
        ),
      ),
    );
  }
}
