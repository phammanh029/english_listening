import 'package:english_listening/model/Lession.model.dart';
import 'package:english_listening/ui/lessionGalary.bloc.dart';
import 'package:english_listening/ui/lessionPlayer.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class LessionPlayer extends StatefulWidget {
  final Lession lession;
  final LessionGalaryBloc parent;

  const LessionPlayer({Key key, this.lession, this.parent}) : super(key: key);
  @override
  _LessionPlayerState createState() => _LessionPlayerState();
}

class _LessionPlayerState extends State<LessionPlayer> {
  LessionPlayerBloc _bloc;
  // transcription controller
  TextEditingController _controller;
  @override
  void initState() {
    _bloc = LessionPlayerBloc(widget.parent);
    _bloc.add(LessionPlayerEventInit(widget.lession));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Player'),
        ),
        body: BlocBuilder<LessionPlayerBloc, LessionPlayerState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is LessionPlayerStateLoaded) {
                return Column(children: [
                  AspectRatio(
                      aspectRatio: state.aspectRatio,
                      child: Stack(children: [
                        VideoPlayer(state.controller),
                        // controller
                      ])),
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
                          ),
                        ),
                        OutlineButton(onPressed: (){
                          // save transciption
                          
                        },)
                      ],
                    ),
                  )
                ]);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
