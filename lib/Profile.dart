import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 22, 40, 1),
        title: Text("Feedback"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Feedback/Suggestions',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              minLines: 15,
              maxLines: 15,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Text here..',
                hintStyle: TextStyle(color:
                Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                child: Text('SUBMIT',style: TextStyle(fontSize: 20),),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
