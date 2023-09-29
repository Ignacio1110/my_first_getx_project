import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimateExample extends StatefulWidget {
  const AnimateExample({Key? key}) : super(key: key);

  @override
  State<AnimateExample> createState() => _AnimateExampleState();
}

class _AnimateExampleState extends State<AnimateExample>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    audioPlayer.eventStream.listen(audioPlayCallback);
    super.initState();
  }

  AudioPlayer audioPlayer = AudioPlayer();
  playMusic() async {
    await audioPlayer.stop();
    await audioPlayer.play(AssetSource('sounds/第一關跳房子.mp3'));
  }

  audioPlayCallback(event) {
    print('audio event: $event');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'ready to start',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
            ).animate(),
            ElevatedButton(
              onPressed: () {
                playMusic();
              },
              child: Text(
                'start countdown',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
