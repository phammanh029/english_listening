import 'package:english_listening/ui/lessionPlayer.bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:video_player/video_player.dart';

enum LessionPlayerControlAction { Back, Next, Pause_Play }
enum PlayerState { Loading, Paused, Playing, Stoped }

class LessionPlayerControllerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LessionPlayerControllerEventAction extends LessionPlayerControllerEvent {
  final LessionPlayerControlAction action;

  LessionPlayerControllerEventAction({this.action});
  @override
  List<Object> get props => [action];
}

class LessionPlayerControllerState extends Equatable {
  @override
  List<Object> get props => [];
}

class LessionPlayerControllerStateError extends LessionPlayerControllerState {
  final String error;

  LessionPlayerControllerStateError(this.error);
  @override
  List<Object> get props => [error];
}

class LessionPlayerControllerStateSet extends LessionPlayerControllerState {
  final PlayerState state;

  LessionPlayerControllerStateSet(this.state);
  @override
  List<Object> get props => [state];
}

class LessionPlayerControllerBloc
    extends Bloc<LessionPlayerControllerEvent, LessionPlayerControllerState> {
  PlayerState _currentState = PlayerState.Playing;

  final VideoPlayerController videoController;

  LessionPlayerControllerBloc({this.videoController})
      : assert(videoController != null);

  @override
  LessionPlayerControllerState get initialState =>
      LessionPlayerControllerStateSet(_currentState);

  @override
  Stream<LessionPlayerControllerState> mapEventToState(
      LessionPlayerControllerEvent event) async* {
    try {
      if (event is LessionPlayerControllerEventAction) {
        switch (event.action) {
          case LessionPlayerControlAction.Back:
            // go back
            break;
          case LessionPlayerControlAction.Next:
            // nect
            break;
          case LessionPlayerControlAction.Pause_Play:
            // play / pause
            if (_currentState != PlayerState.Playing) {
              _currentState = PlayerState.Playing;
            } else {
              _currentState = PlayerState.Paused;
            }
            switch (_currentState) {
              case PlayerState.Playing:
                videoController?.play();
                break;
              case PlayerState.Paused:
                videoController?.pause();
                break;
              default:
                break;
            }
            yield LessionPlayerControllerStateSet(_currentState);
            break;
        }
      }
    } catch (error) {
      yield LessionPlayerControllerStateError(error.toString());
    }
  }
}
