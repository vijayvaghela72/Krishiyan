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
        automaticallyImplyLeading: false, // Remove default back button
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "DETAIL NEWS",
            style: TextStyle(color: Colors.green, fontFamily: 'poppins-semibold', fontSize: 25),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
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
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0), // Set your desired radius here
      child: widget.imageLink != null && widget.imageLink!.isNotEmpty && widget.imageLink!.startsWith('http')
          ? Image.network(
              widget.imageLink!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/home_banner.png', // Fallback image on error
                  repeat: ImageRepeat.noRepeat,
                  fit: BoxFit.cover,
                );
              },
            )
          : Image.asset(
              'assets/images/home_banner.png', // Fallback to default asset image if no URL
              fit: BoxFit.cover,
              repeat: ImageRepeat.noRepeat,
            ),
    ),
  ),
),


            const SizedBox(height: 10,),

            // // Display meta-information (Reading time, etc.)
            // const Padding(
            //   padding: EdgeInsets.only(left: 40.0, right: 40.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("5min Read", softWrap: true,
            //         style: TextStyle(color: Colors.grey, fontSize: 17,
            //             fontFamily: 'poppins-regular'),),
            //       VerticalDivider(width: 20.0),
            //       Align(
            //         alignment: Alignment.centerRight,
            //         child: Text("17 hours ago", softWrap: true,
            //           style: TextStyle(color: Colors.grey, fontSize: 17,
            //               fontFamily: 'poppins-regular'),),
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 20,),

            // Display the title of the news
            Padding(
              padding: EdgeInsets.only(left: 40.0, right: 35.0),
              child: Text(
                widget.title ?? "No Title", 
                softWrap: true,
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'poppins-semibold'),
              ),
            ),

            const SizedBox(height: 10,),

            // Display the description of the news
            Padding(
              padding: EdgeInsets.only(left: 40.0, right: 35.0),
              child: Text(
                widget.description ?? "No description available.", 
                softWrap: true,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'poppins-regular'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
