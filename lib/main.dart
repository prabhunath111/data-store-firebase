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

            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                indexNumber = index;
                return _buildListItem(
                    context, snapshot.data.documents[indexNumber]);
              },
            );
          }),
    );
  }
}
