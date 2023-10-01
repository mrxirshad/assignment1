import 'dart:convert';
import 'dart:io';

import 'package:assignment/components/Components_page.dart';
import 'package:assignment/components/Design_item.dart';
import 'package:assignment/services/CheckFile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../HomePage.dart';
import 'checkPermissions.dart';

class AllBooks extends StatefulWidget {
  String title;

  AllBooks({required this.title, super.key});

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {

  bool isPermission = false;
  var chekAllPermission = CheckPermission();

  checkPermission() async {
    var Permission = await chekAllPermission.isStoragePermission();
    if(Permission){
      setState(() {
        isPermission = true;
      });
    }
  }




  bool isLoading = false;
  List<dynamic> chapterList = [];

  //API CALL TO GET ALL CHAPTER DATAre
  // method for get api call declaration
  getBookChapterCall() async {
    isLoading = true;
    setState(() {});
    final response = await http.get(Uri.parse(
        'https://www.eschool2go.org/api/v1/project/ba7ea038-2e2d-4472-a7c2-5e4dad7744e3?path=Environmental%20Education'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // ReadOffline =jsonDecode(response.body);
      // print("AllBooks"+ReadOffline.toString());

      chapterList = jsonDecode(response.body);
      print("Book Data" + chapterList.toString());
      setState(() {
        isLoading = false;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  //download pf]df

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getBookChapterCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body:
      SingleChildScrollView(
        child: Column(children: [

          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  height: 700,
                  child: Container(
                    child: ListView.builder(
                        itemCount: chapterList.length,
                        itemBuilder: (context, index)  {


                          return ItemDesign(
                              downloadUrl: chapterList[
                              index]
                              [
                              "download_url"],
                              tittel: chapterList[index]["title"]);
                        }),
                  ),
                )
        ]),
      ),
    );

    // Future OpenFile({required String url, String? fileName})async{
    //   final name = fileName?? url.split("/").last;
    //   //final file = await downloadedFile(url,name);
    //   final file = await downloadedFile(url, name);
    //   if(file== null)return;
    //   print("path: ${file.path}");
    //   OpenFile.open(file.path);
    //
    // }
    // Future<File?> downloadedFile(String url, String name)async{
    //   final appStorage = await getApplicationDocumentsDirectory();
    //   final file = File("${appStorage.path})/$name");
    //   try{
    //     final response = await Dio().get(
    //       url,
    //       options: Options(
    //         responseType: ResponseType.bytes,
    //         followRedirects: false,
    //       ),
    //     );
    //     final raf = file.openSync(mode: FileMode.write);
    //     raf.writeByteSync(response.data);
    //     await raf.close();
    //     return file;
    //   }
    //   catch (e){
    //     return null;
    //   }
    // }
  }
}
