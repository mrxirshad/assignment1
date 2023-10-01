import 'package:assignment/Books_Page.dart';
import 'package:assignment/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("PdfViewer"),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center ,
        children: [
          Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              color: Colors.teal,
            ),child: InkWell(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewer(),));
              },
              child: Center(child: Text("PdfViewer",style: TextStyle(color: Colors.white,fontSize: 20),))),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  color: Colors.teal,
                ),child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>BooksPage(),));
                  },
                  child: Center(child: Text("Books",style: TextStyle(color: Colors.white,fontSize: 20),))),
              ),

            ],
          )


        ],

      ),

    );
  }
}
