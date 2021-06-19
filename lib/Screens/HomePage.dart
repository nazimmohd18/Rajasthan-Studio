import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Favourites.dart';
import '../Utils/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'Preview.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var data;
  int page = 1;
  Future<Map> getImageList() async {
    final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?page=$page&per_page=40'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              "563492ad6f91700001000001c1e28d8660704a3eaa7b713a5fbeb07c",
        });

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print('Data from ImageList: ' + data["photos"].toString());
      setState(() {
        _favourite = data["photos"][0]["liked"];
      });
      // print(data["Response"].length);
      return data;
    } else {
      throw Exception("Unable to load Images");
    }
  }

  // Stream ? image;

  late bool _favourite;



 StreamController ? streamController;
  StreamController ? stream2;
  loadImage() async {
    getImageList().then((newValue) {
      stream2!.add(newValue);
    });
  }




  @override
  void initState() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  stream2 = StreamController();
  loadImage();

  // image = getImageList();
    super.initState();
  }

  @override
  void dispose() {
    // subscription!.cancel();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Rajasthan Studio'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: white,
        onPressed: () {
          Get.to(()=>Favourites());
        },
        child: Icon(
          Icons.favorite,
          size: 28,
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: StreamBuilder(
          stream: stream2!.stream,
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center( child:
                      _connectionStatus.toString() == 'ConnectivityResult.none' ?
              Card(
                    color: white,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Text(
                        'No Internet !',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: black),
                      ),
                    ),
              ) :           Image.asset("assets/images/loader1.gif", height: 150),

                  )
                  : ListView.builder(
            itemCount: data["photos"].length,
                      padding: EdgeInsets.all(deviceWidth * .025),
                      itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){
                  Get.to(()=>Preview(data["photos"][index]["src"]["portrait"]));
                },
                child: Card(
                  // elevation: 5,
                  color: Colors.white60,
                  child: Stack(children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.all(deviceWidth * .025),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(5),

                        image: DecorationImage(
                           image: NetworkImage(data["photos"][index]["src"]["original"].toString()),
                     fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(.25), BlendMode.darken))
                      ),
                      width: deviceWidth,
                      height: deviceWidth * .5,
                      child: Padding(
                        padding: EdgeInsets.all(deviceWidth * .015),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Photographer : ',
                              style: TextStyle(
                                  color: white,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              data["photos"][index]["photographer"].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: white),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _favourite = !_favourite;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(deviceWidth * .025),
                            padding: EdgeInsets.all(deviceWidth * .015),
                            decoration: BoxDecoration(
                                border: Border.all(color: white),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    topRight: Radius.circular(5))),
                            child: _favourite
                                ? Icon(
                              Icons.favorite,
                              color: white,
                            )
                                : Icon(
                              Icons.favorite_outline,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
                      }

                      // physics: BouncingScrollPhysics(),


                    ),
        ),
      ),
    );
  }

}
