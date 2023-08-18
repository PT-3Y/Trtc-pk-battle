import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFScreen extends StatefulWidget {
  final String docURl;

  const PDFScreen({required this.docURl});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text(widget.docURl.split('/').last, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
      ),
      body: SfPdfViewer.network(widget.docURl),
    );
  }
}
