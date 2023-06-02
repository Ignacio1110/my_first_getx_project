import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_getx_project/custom_clippers_example/clippers/clipper_3.dart';

import 'clippers/clipper_1.dart';
import 'clippers/clipper_4.dart';

///這個範例用來展示flutter的裁切相關Widget以及CustomPath的裁切
class CustomClippersExample extends StatefulWidget {
  const CustomClippersExample({Key? key}) : super(key: key);

  @override
  State<CustomClippersExample> createState() => _CustomClippersExampleState();
}

class _CustomClippersExampleState extends State<CustomClippersExample> {
  CustomClipper<Path> buttonClipper = ChatBubbleClipper1(
    isSend: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipPath(
        clipper: ChatBubbleClipper1(
          isSend: true,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    width: Get.size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonClipper = ChatBubbleClipper1(
                            isSend: true,
                          );
                        });
                      },
                      child: Text('clip1'),
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonClipper = BubbleClipper3(
                            left: false,
                            top: false,
                          );
                        });
                      },
                      child: Text('clip3'),
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonClipper = ChatBubbleClipper4(
                            isSend: true,
                          );
                        });
                      },
                      child: Text('clip4'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Center(
              child: ClipPath(
                clipper: buttonClipper,
                child: Container(
                  width: 200,
                  height: 80,
                  color: Colors.lightGreenAccent,
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
