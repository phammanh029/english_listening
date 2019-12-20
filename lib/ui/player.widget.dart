import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoPlayer extends StatefulWidget {
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  void initState() {
    // _controller = VideoPlayerController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      builder: (context, state){
        return AspectRatio(child: VideoPlayer(),);
      },
    );
  }
}