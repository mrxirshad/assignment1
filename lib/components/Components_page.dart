import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewerPdf extends StatefulWidget {
  String UrlPdf;
  ViewerPdf({ required this.UrlPdf,super.key});

  @override
  State<ViewerPdf> createState() => _ViewerPdfState();
}

late PdfViewerController _controller ;
final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();


class _ViewerPdfState extends State<ViewerPdf> {
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
        body: SfPdfViewer.network(widget.UrlPdf,
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