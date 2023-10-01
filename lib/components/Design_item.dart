

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../HomePage.dart';
import 'Directory.dart';
import 'package:path/path.dart' as Path;

class ItemDesign extends StatefulWidget {
  String tittel;
  String downloadUrl;
   ItemDesign({super.key,required this.downloadUrl,required this.tittel});

  @override
  State<ItemDesign> createState() => _ItemDesignState();
}




class _ItemDesignState extends State<ItemDesign> {
  bool showProgress=false;

  bool downloading = false;
  bool fileExits = false;
  double progres = 0;
  late String filePath;
  String fileName = "";
  late CancelToken cancelToken;
   var getPathFile = DirectoryPath();

   cancelDownload(){
     cancelToken.cancel();
     setState(() {
       downloading = false;
     });

   }



   startDownload() async {
     cancelToken = CancelToken();
     var storePath = await getPathFile.getPath();
     filePath = "$storePath/$fileName";
     try{
       await Dio().download(widget.downloadUrl, filePath,onReceiveProgress: (count,total){
         setState(() {
           progres =(count/total);
         });
       },cancelToken:  cancelToken,
       );
       setState(() {
         downloading = false;
         fileExits = true;
       });

     }catch(e){
       setState(() {
         downloading = false;

       });

     }
   }


  checkFileExits() async {
    var storePath =await getPathFile.getPath();
    filePath = "$storePath/$fileName";
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExits = fileExistCheck;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      fileName = Path.basename(widget.downloadUrl);
    });
    checkFileExits();
  }



  @override
  Widget build(BuildContext context) {
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
                Text(widget.tittel??
                    "No Data"),
                fileExits && downloading == false?
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green,
                  ),

                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewer(
                                pdfUrl: filePath, isOffline: true,),
                            ));
                      },
                      child: Text(
                        "Read Offline",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ):
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
                                  onTap: () {
                                    setState(() {
                                      showProgress=true;
                                    });
                                    fileExits && downloading == false?
                                        print("exits"):
                                    startDownload();


                                  }
                                  ,
                                  child: showProgress==false?Text(
                                    "Download",
                                    style: TextStyle(
                                        color:
                                        Colors.white),
                                  ):CircularProgressIndicator(
                                    value: progres,
                                    color: Colors.white,
                                    semanticsLabel: progres.toString(),

                                  ),
                              ),
                          ),
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
                                            pdfUrl: widget.downloadUrl, isOffline: false,),
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
                )
                // if(false)
                 ,
              ],
            ),
          ),
        )
      ],
    );
  }
}
