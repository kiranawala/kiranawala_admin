import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class InventoryManagerUpdateProductLookupImage extends StatefulWidget {
  @override
  _InventoryManagerUpdateProductLookupImageState createState() => _InventoryManagerUpdateProductLookupImageState();
}

FirebaseStorage storage;
final Firestore fb = Firestore.instance;

class _InventoryManagerUpdateProductLookupImageState extends State<InventoryManagerUpdateProductLookupImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final Firestore fireStore = Firestore.instance;
    fireStore.collection('files').reference().getDocuments().then((QuerySnapshot) {
      if(QuerySnapshot != null)
        {
          if(QuerySnapshot.documents != null)
            {
              print(QuerySnapshot.documents.length);
            }
        }
    });
//    final StorageReference storageRef =
//    FirebaseStorage.instance.ref().child('Gallery').child('Images');
//    storageRef.listAll().then((dynamic result) {
//      print("result is $result");
//    });
    return Scaffold(

      body: Container(
//        padding: EdgeInsets.all(10.0),
//        child: FutureBuilder<dynamic>(
//          future: getImages(),
//          builder: (context, AsyncSnapshot<dynamic> snapshot) {
////            print(snapshot);
////            print(snapshot.connectionState);
//            print(snapshot.data.documents);
//            print(snapshot.data.documents.length);
//            if (snapshot.connectionState == ConnectionState.done) {
//              return ListView.builder(
//                  shrinkWrap: true,
//                  itemCount: snapshot.data.documents.length,
//                  itemBuilder: (BuildContext context, int index) {
//                    return ListTile(
//                      contentPadding: EdgeInsets.all(8.0),
//                      title:
//                      Text(snapshot.data.documents[index].data["name"]),
//                      leading: Image.network(
//                          snapshot.data.documents[index].data["url"],
//                          fit: BoxFit.fill),
//                    );
//                  });
//            } else if (snapshot.connectionState == ConnectionState.none) {
//              return Text("No data");
//            }
//            return CircularProgressIndicator();
//          },
//        ),
      ),
    );
  }
    /// code here
    Future<QuerySnapshot> getImages() {
    return fb.collection('oshop-21421.appspot.com/files').getDocuments();
    }
  }
