import 'package:flutter/material.dart';
import '../Utils/Colors.dart';
import 'package:photo_view/photo_view.dart';


class Preview extends StatefulWidget {
  final String original;
  Preview(this.original);


  @override
  _PreviewState createState() => _PreviewState(original);
}

class _PreviewState extends State<Preview> {
  String original;
  _PreviewState(this.original);
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Image Preview'),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        // padding: EdgeInsets.all(deviceWidth* .05),
        child: PhotoView(
          imageProvider: NetworkImage(original),
          // filterQuality: FilterQuality.high,
        )
      ),
    );
  }
}
