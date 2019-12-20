import 'package:english_listening/ui/lessionPlayer.controller.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessionPlayerControllerWidget extends StatelessWidget {
  final LessionPlayerControllerBloc bloc;

  const LessionPlayerControllerWidget({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withAlpha(50),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // prev video
                  bloc?.add(LessionPlayerControllerEventAction(
                      action: LessionPlayerControlAction.Back));
                },
              ),
              IconButton(
                icon: BlocBuilder<LessionPlayerControllerBloc,
                        LessionPlayerControllerState>(
                    bloc: bloc,
                    builder: (context, state) {
                      if (state is LessionPlayerControllerStateSet) {
                        return Icon(state.state == PlayerState.Playing
                            ? Icons.pause
                            : Icons.play_arrow);
                      }
                      return Icon(Icons.refresh);
                    }),
                onPressed: () {
                  // prev video
                  bloc?.add(LessionPlayerControllerEventAction(
                      action: LessionPlayerControlAction.Pause_Play));
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  // prev video
                  bloc?.add(LessionPlayerControllerEventAction(
                      action: LessionPlayerControlAction.Next));
                },
              )
            ],
          )),
        ],
      ),
    );
  }
}
