import 'package:flutter/material.dart';

class MyDetailNewsPage extends StatefulWidget {

  const MyDetailNewsPage({super.key});

  @override
  State<MyDetailNewsPage> createState() => _MyDetailNewsPageState();
}

class _MyDetailNewsPageState extends State<MyDetailNewsPage> {

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
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 150.0,
              child: Image.asset('assets/images/home_banner.png',
                repeat: ImageRepeat.noRepeat,),
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

            const Padding(
              padding: EdgeInsets.only(left: 40.0, right: 35.0),
              child: Flexible(
                child: Text("Lorem ipsum dolor sit amet data consectetur adipisicin", softWrap: true,
                  style: TextStyle(color: Colors.black, fontSize: 20,
                      fontFamily: 'poppins-semibold'),),
              ),
            ),

            const SizedBox(height: 10,),

            const Padding(
              padding: EdgeInsets.only(left: 40.0, right: 35.0),
              child: Flexible(
                child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
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