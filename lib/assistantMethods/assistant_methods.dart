import 'package:cloud_firestore/cloud_firestore.dart';
import '../globel/globel.dart';

separateItemIDs()
{
  List<String>separateItemIDsList=[],defaultItemList=[];
  int i= 0;
  defaultItemList=sharedPreferences!.getStringList('userCart')!;

  for(i;i<defaultItemList.length;i++)
    {
      String item= defaultItemList[i].toString();
      var pos=item.lastIndexOf(":");
      String getItemId= (pos !=-1) ? item.substring(0,pos) : item;

      print('\n this is itemsID now =' + getItemId);
      separateItemIDsList.add(getItemId);
    }
  print('\n this is Items List now = ');
  print(separateItemIDsList);

  return separateItemIDsList;
}
separateOrdersItemIDs(orderIDs)
{
  List<String>separateItemIDsList=[],defaultItemList=[];
  int i= 0;
  defaultItemList=List<String>.from(orderIDs);

  for(i;i<defaultItemList.length;i++)
  {
    String item= defaultItemList[i].toString();
    var pos=item.lastIndexOf(":");
    String getItemId= (pos !=-1) ? item.substring(0,pos) : item;

    print('\n this is itemsID now =' + getItemId);
    separateItemIDsList.add(getItemId);
  }
  print('\n this is Items List now = ');
  print(separateItemIDsList);

  return separateItemIDsList;
}


separateItemQuantities()
{
  List<int>separateItemQuantityList=[];
  List<String>defaultItemList=[];
  int i= 1;
  defaultItemList=sharedPreferences!.getStringList('userCart')!;

  for(i;i<defaultItemList.length;i++)
  {
    String item= defaultItemList[i].toString();

    List<String> listItemsCharacters=item.split(':').toList();
var quanNumber=int.parse(listItemsCharacters[1].toString());
    print('\n this is Quantities Niumber =' + quanNumber.toString());
    separateItemQuantityList.add(quanNumber);
  }
  print('\n this is Items List now = ');
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

separateOrderItemQuantities(orderIDs)
{
  List<String>separateItemQuantityList=[];
  List<String>defaultItemList=[];
  int i= 1;
  defaultItemList=List<String>.from(orderIDs);

  for(i;i<defaultItemList.length;i++)
  {
    String item= defaultItemList[i].toString();

    List<String> listItemsCharacters=item.split(':').toList();
    var quanNumber=int.parse(listItemsCharacters[1].toString());
    print('\n this is Quantities Niumber =' + quanNumber.toString());
    separateItemQuantityList.add(quanNumber.toString());
  }
  print('\n this is Items List now = ');
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

clearCartNow(context)
{
  sharedPreferences!.setStringList('userCart', ['garbageValue']);
  List<String>? emptyList=sharedPreferences!.getStringList('userCart');
  FirebaseFirestore.instance
  .collection('users')
  .doc(firebaseAuth.currentUser!.uid)
  .update({'userCart':emptyList}).then((value)
  {
    sharedPreferences!.setStringList('userCart', emptyList!);

  }
  );


}