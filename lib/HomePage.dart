import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  String pdfUrl;
   PdfViewer({ required this.pdfUrl,super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

late PdfViewerController _controller ;
final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();


class _PdfViewerState extends State<PdfViewer> {
  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        backgroundColor: Colors.grey.shade500,
        body: SfPdfViewer.network(widget.pdfUrl,
        key: _pdfViewerStateKey,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        controller: _controller,
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          actions: [
            IconButton(onPressed: (){
              _pdfViewerStateKey.currentState!.openBookmarkView();

            }, icon: Icon(Icons.bookmark,
              color: Colors.white,
            )),
            IconButton(onPressed: (){
              _controller.jumpToPage(5);

            }, icon: Icon(Icons.arrow_drop_down_circle,
            color: Colors.white,
            )),
            IconButton(onPressed: (){
              _controller.zoomLevel=1.25;

            }, icon: Icon(Icons.zoom_in,
              color: Colors.white,
            )),
          ],
        ),

      ),




    );
  }
}
