import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../shared/constant/constant_values_manager.dart';
import '../../router/app_router.dart';

class IntroView extends StatefulWidget {
  const IntroView({Key? key}) : super(key: key);

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    startDelay();
    startVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;

  startDelay() {
    _timer = Timer(Duration(milliseconds: AppConstants.introDelay), goNext);
  }

  goNext() {
    Navigator.pushReplacementNamed(context, Routes.registerPosRoute);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: bodyContent(context),
    ));
  }

  Widget bodyContent(BuildContext context) {
    return Center(
      child: VideoPlayer(_videoPlayerController),
    );
  }

  void startVideo() {
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/poslixvid.mp4')
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController.play();
          });
  }
}
