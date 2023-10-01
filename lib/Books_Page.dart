import 'dart:convert';

import 'package:assignment/components/AllBooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {


  //create A list
  bool isLoading=false;
  Map<String, dynamic> bookData={};

  List<Map<String, dynamic>> listBook=[];

  //
  mapToList(){
    Iterable<MapEntry<String, dynamic>> entries = bookData.entries;
    for (final entry in entries) {
      // print('(${entry.key}, ${entry.value})');
      listBook.add(entry.value);
      print(entry.value);

    }
    print( listBook);

    // listBook=bookData.toList((e) => e.value
  }

  // method for get api call declaration
  getBookDataCall() async {
    isLoading=true;
    setState(() {

    });
    final response = await http.get(Uri.parse('https://www.eschool2go.org/api/v1/project/ba7ea038-2e2d-4472-a7c2-5e4dad7744e3'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      bookData=jsonDecode(response.body);
      print( "Book Data"+bookData.toString());
      mapToList();
      setState(() {
        isLoading=false;

      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  asyncMethod() async {
     await getBookDataCall();
     mapToList();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //api call
    print("Calling api");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getBookDataCall();

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        // ListView.builder(
        //   itemCount: bookData.length,
        //     itemBuilder:   ( context, index){
        //     return Text("Book");
        //
        // })
        isLoading?Center( child: CircularProgressIndicator(),):
        GridView.builder(
          

            // crossAxisCount: 3,
            //  mainAxisSpacing: 11,
            //  crossAxisSpacing: 11,
          itemBuilder:  (context, index){
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.blue.shade100,
              ),child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllBooks(title: listBook[index]["name"],),));

                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    CircleAvatar(  child:  Text(listBook[index]["name"].substring(0, 1)),),
                    Text(listBook[index]["name"]),
                    // Text("Data"),
                  ],
                )),

            );
          }, gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
          itemCount: bookData.length,
          

          // gridDelegate: null,
          
        ),
      ),
    );

  }
}
