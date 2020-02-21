import 'package:flutter/material.dart';
import 'PickupItemsChallan.dart' as chal;
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PDFScreen extends StatelessWidget {

  final String path;

  const PDFScreen({Key key, this.path}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    
    return PDFViewerScaffold(
      path: path,
    );
  }
  

}
