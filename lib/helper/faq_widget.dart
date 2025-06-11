import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FaqWidget extends StatefulWidget {
  String question;
  String answer;
  FaqWidget({super.key, required this.question, required this.answer});

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  bool isCardVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (isCardVisible) {
                  isCardVisible = false;
                } else {
                  isCardVisible = true;
                }
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(17),
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor: const Color(0xFF02792A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'How many growth stages in Maize crop?',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14, fontFamily: 'poppins-medium'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'assets/images/down_arrow_white.png',
                          height: 20, width: 20,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                isCardVisible
                    ? const SizedBox(
                        height: 20,
                      )
                    : Container(),
                isCardVisible
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFFd3d3d3), width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFd3d3d3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(15)),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20.0, right: 10.0, left: 10.0),
                                child: Text(
                                  "Four stages Germination & establishment phase, "
                                  "Vegetative stage, Flowering Stage, Maturity Stage.",
                                  softWrap: true,
                                  style: TextStyle(
                                      // color: Color(0xFF666666),
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontFamily: 'poppins-regular'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
