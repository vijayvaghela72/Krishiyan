import 'package:flutter/material.dart';

class DetailNewsPage extends StatefulWidget {

  String? title, description, imageLink;

  DetailNewsPage({super.key, required this.title, required this.description, required this.imageLink});

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "DETAIL NEWS",
            style: TextStyle(color: Colors.green, fontFamily: 'poppins-semibold', fontSize: 25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 150.0,
                child: Image.asset('assets/images/home_banner.png',
                  repeat: ImageRepeat.noRepeat,),
              ),
            ),
            // Center(child: Text("Detail News", style: TextStyle(color: Color(0xFF3dc33b), fontSize: 30,
            //     fontFamily: 'poppins-medium'),)),
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.only(left: 40.0, right: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("5min Read", softWrap: true,
                    style: TextStyle(color: Colors.grey, fontSize: 17,
                        fontFamily: 'poppins-regular'),),
                  VerticalDivider(width: 20.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("17 hours ago", softWrap: true,
                      style: TextStyle(color: Colors.grey, fontSize: 17,
                          fontFamily: 'poppins-regular'),),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 40.0, right: 35.0),
              child: Flexible(
                child: Text(widget.title ?? "", softWrap: true,
                  style: TextStyle(color: Colors.black, fontSize: 20,
                      fontFamily: 'poppins-semibold'),),
              ),
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.only(left: 40.0, right: 35.0),
              child: Flexible(
                child: Text(widget.description ?? "",
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey, fontSize: 20,
                      fontFamily: 'poppins-regular'),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}