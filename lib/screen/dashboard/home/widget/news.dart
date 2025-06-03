import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/helper/app_global.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/home/widget/detail_news.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  update() {
    if (mounted) {
      setState(() {});
    }
  }

  getData() async {
    showLoading();
    await homeProvider!.getNewsDetails(update);
    stopLoading();
  }

  String convertToDirectImageUrl(String fileUrl) {
    // Extract the file ID from the Google Drive URL
    RegExp regExp = RegExp(r"file/d/([a-zA-Z0-9-_]+)");
    Match? match = regExp.firstMatch(fileUrl);

    if (match != null) {
      String fileId = match.group(1)!;
      return "https://drive.google.com/uc?id=$fileId"; // Construct the direct image URL
    }
    return fileUrl; // Return the original URL if it doesn't match the expected format
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(
          child: DotsIndicator(
            dotsCount: homeProvider!.imageSliders.length,
            position: currentIndex.toDouble(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFC4C4C4).withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        buildTranslate("latestNews")!,
                        softWrap: true,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'poppins-medium'),
                      )),
                      const VerticalDivider(width: 1.0),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeProvider!.newsListData.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final newsData = homeProvider!.newsListData[index];
                    String truncatedTitle = newsData.title ?? '';
                    bool isLongTitle = truncatedTitle.length > 50;
                    if (isLongTitle) {
                      truncatedTitle = truncatedTitle.substring(0, 50) + '...';
                    }

                    String truncatedDescription = newsData.description ?? '';
                    bool isLongDescription = truncatedDescription.length > 60;
                    if (isLongDescription) {
                      truncatedDescription =
                          truncatedDescription.substring(0, 60) + '.....';
                    }
                    return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => DetailNewsPage(
                                  title: newsData.title,
                                  description: newsData.description,
                                  imageLink: convertToDirectImageUrl(
                                      newsData.imageURL.toString()))),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: "poppins-medium",
                                          ),
                                          children: [
                                            TextSpan(text: truncatedTitle),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 10.0),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "poppins-regular",
                                            color: Colors.grey,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: truncatedDescription),
                                            if (isLongDescription)
                                              TextSpan(
                                                text: " Read more",
                                                style: TextStyle(
                                                  color: Colors.green.shade300,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailNewsPage(
                                                              title: newsData
                                                                  .title,
                                                              description: newsData
                                                                  .description,
                                                              imageLink:
                                                                  newsData
                                                                      .imageURL,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 50,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        convertToDirectImageUrl(
                                            newsData.imageURL.toString()),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Column(
                                            children: [
                                              Icon(Icons.error,
                                                  color: Colors.red),
                                              Text('Image not found',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 10)
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              AppGlobal.convertToCustomDateFormat(
                                  newsData.createdAt.toString()),
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'poppins-medium'),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 80,
        ),
      ],
    );
  }
}
