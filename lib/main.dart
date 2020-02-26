import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dataDocs = [];
  var indexNumber;
  var items;
  List list = new List();

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {

    dataDocs.add(document);

    print('index_number ${document['index_number']} ');

    return ListTile(
        title: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            document['name'],
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        Container(
          decoration: const BoxDecoration(color: Color(0xffddddff)),
          padding: const EdgeInsets.all(10.0),
          child: FlatButton(
            onPressed: () {
              document.reference.updateData({'votes': document['votes'] + 1});
            },
            child: Text(
              document['votes'].toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              document.reference.delete();
            })
      ],
    )

    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Data store'),
      ),
      body:
      StreamBuilder(

          stream: Firestore.instance.collection('bandnames').snapshots(),
          builder: (context, snapshot) {

            print('snapshot $snapshot');
            if (!snapshot.hasData) return const Text('Loading...');

           items =  snapshot.data.documents;
           list = items.map((DocumentSnapshot docsnapshot){
             return docsnapshot.data;
           }).toList();

           print('items $list');
           print('length of list ${list.length}');

           /*for(int i =0 ; i<list.length;i++){

           }*/

           print('check items ${items[0]['name']}');

            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, index) {
                indexNumber = index;
                return _buildListItem(
                    context, snapshot.data.documents[indexNumber]);
              },
            );

          }),
    );
  }
}

class UserTask {
}
