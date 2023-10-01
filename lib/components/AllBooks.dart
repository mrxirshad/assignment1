import 'dart:convert';
import 'dart:io';

import 'package:assignment/components/Components_page.dart';
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

class AllBooks extends StatefulWidget {
  String title;

  AllBooks({required this.title, super.key});

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
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

  // Download pdf function
  Future<void> saveFile(String fileName) async {
    var file = File('');

    // Platform.isIOS comes from dart:io
    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/$fileName');
    }
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        const downloadsFolderPath = '/storage/emulated/0/Download/';
        Directory dir = Directory(downloadsFolderPath);
        file = File('${dir.path}/$fileName');
      }
    }
  }

  //download pf]df

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
      body: SingleChildScrollView(
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
                          bool offline=false;
                          printtt(String s) async {
                            print("hello");
                          }

                          String link = chapterList[index]["download_url"];

                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                              offline=await CheckFile.checkFile(link);
                              print("Checking File: $offline");

                            });

                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                  // width: 340,
                                  // width: double.infinity,
                                  height: 85,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(21),
                                      color: Colors.grey.shade200),
                                  child: Column(
                                    children: [
                                      Text(chapterList[index]["title"] ??
                                          "No Data"),
                                      if(!offline)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                // width: 200,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(21),
                                                  color: Colors.green,
                                                ),
                                                child: Center(
                                                    child: InkWell(
                                                        onTap: () async {
                                                          String link =
                                                              chapterList[index]
                                                                  [
                                                                  "download_url"];
                                                          if (!link.isEmpty) {
                                                            String url = link;
                                                            String filename =
                                                                url
                                                                    .split('/')
                                                                    .last;

                                                            final dir =
                                                                await getApplicationDocumentsDirectory();
                                                            String path =
                                                                dir.path +
                                                                    "/" +
                                                                    filename;

                                                            await Dio()
                                                                .download(
                                                                    url, path,
                                                                    onReceiveProgress:
                                                                        (count,
                                                                            total) {},
                                                                    deleteOnError:
                                                                        true)
                                                                .then((value) {
                                                              context.showToast(
                                                                  msg:
                                                                      "Downloaded: $path");
                                                              setState(() {});
                                                              print(path);
                                                            });
                                                          } else {
                                                            context.showToast(
                                                                msg:
                                                                    "Books not found for download");
                                                          }
                                                        },
                                                        child: Text(
                                                          "Download",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ))),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              // width: 150,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(21),
                                                color: Colors.grey.shade500,
                                              ),
                                              child: Center(
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => PdfViewer(
                                                                  pdfUrl: chapterList[
                                                                          index]
                                                                      [
                                                                      "download_url"]),
                                                            ));
                                                      },
                                                      child: Text(
                                                        "Online",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))),
                                            ),
                                          )
                                        ],
                                      ),
                                      if(offline)
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.green,
                                        ),

                                        child: Center(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Text(
                                              "Read Offline",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
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
