// import 'package:english_listening/model/Lession.model.dart';
import 'package:english_listening/ui/lessionGalary.bloc.dart';
import 'package:english_listening/ui/lessionPlayer.bloc.dart';
import 'package:english_listening/ui/lessionPlayer.controller.bloc.dart';
import 'package:english_listening/ui/lessionPlayerController.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class LessionPlayer extends StatefulWidget {
  final String lessionPath;
  final LessionGalaryBloc parent;

  const LessionPlayer({Key key, this.lessionPath, this.parent})
      : super(key: key);
  @override
  _LessionPlayerState createState() => _LessionPlayerState();
}

class _LessionPlayerState extends State<LessionPlayer> {
  LessionPlayerBloc _bloc;
  // transcription controller
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _bloc = LessionPlayerBloc(widget.parent);
    _bloc.add(LessionPlayerEventInit(widget.lessionPath));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.add(LessionPlayerEventUninit());
    _bloc?.close();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Player'),
        ),
        body: BlocListener<LessionPlayerBloc, LessionPlayerState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is LessionPlayerStateLoaded) {
              // set transcription text
              print('test: ${state.transcription}');
              _controller?.dispose();
              _controller = TextEditingController(text: state.transcription);
            }
          },
          child: BlocBuilder<LessionPlayerBloc, LessionPlayerState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is LessionPlayerStateLoaded) {
                  return Column(children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: state.controller.value.aspectRatio > 0
                                ? state.controller.value.aspectRatio
                                : 4.0 / 3,
                            child: VideoPlayer(state.controller),
                            // controller
                          ),
                          LessionPlayerControllerWidget(
                            bloc: LessionPlayerControllerBloc(
                                videoController: state.controller),
                          )
                        ],
                      ),
                    ),
                    // edit text controller
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                            controller: _controller,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              labelText: 'Transciption',
                            ),
                          )),
                          OutlineButton(
                            onPressed: () {
                              // save transciption
                              _bloc.add(LessionPlayerEventUpdateTranscription(
                                  _controller?.text));
                            },
                            child: Text('Submit'),
                          )
                        ],
                      ),
                    )
                  ]);
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }
}
