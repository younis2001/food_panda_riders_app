import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistantMethods/assistant_methods.dart';
import '../globel/globel.dart';
import '../widget/order_card.dart';
import '../widget/progress_bar.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({Key? key}) : super(key: key);

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          flexibleSpace: Container(

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
          ),
          title: const Text('New Orders',style: TextStyle(fontSize: 45,fontFamily: 'Signatra'),),
          centerTitle: true,

        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          .collection('orders')
          .where('status',isEqualTo: 'normal')
          .orderBy('orderTime',descending: true)
          .snapshots(),
          builder: (c,snapshot)
          {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (c,index)
            {
              return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('items')
                      .where('itemID',whereIn: separateOrdersItemIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>) ["productIDs"]))
                      .where('orderBy', whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                      .orderBy('publishedDate',descending: true)
                      .get(),
                builder: (c,snap)
                {
return snap.hasData
    ?OrderCard(
  itemCount: snap.data!.docs.length,
  data: snap.data!.docs,
  orderID: snapshot.data!.docs[index].id,
  seperateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),
)
    : Center(child: CircularProgress(),);

                },
              );
            }
            )
                :Center(child: CircularProgress(),);
          },
        ),
      ),
    );

  }
}
