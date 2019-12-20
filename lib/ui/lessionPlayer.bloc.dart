import 'dart:io';

import 'package:english_listening/model/Lession.model.dart';
import 'package:english_listening/ui/lessionGalary.bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

class LessionPlayerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LessionPlayerEventInit extends LessionPlayerEvent {
  final Lession lession;

  LessionPlayerEventInit(this.lession);
  @override
  List<Object> get props => [lession];
}

class LessionPlayerState extends Equatable {
  @override
  List<Object> get props => [];
}

class LessionPlayerStateInitial extends LessionPlayerState {}
// class LessionPlayerStateInitial extends LessionPlayerState {}

class LessionPlayerStateLoaded extends LessionPlayerState {
  final VideoPlayerController controller;
  final double aspectRatio;

  LessionPlayerStateLoaded(this.controller, this.aspectRatio);

  @override
  List<Object> get props => [aspectRatio, controller];
}

class LessionPlayerStateLoading extends LessionPlayerState {}

class LessionPlayerStateError extends LessionPlayerState {
  final String error;

  LessionPlayerStateError(this.error);

  @override
  List<Object> get props => [error];
}

// bloc
class LessionPlayerBloc extends Bloc<LessionPlayerEvent, LessionPlayerState> {
  final LessionGalaryBloc parent;
  VideoPlayerController _controller;
  Lession _lession;

  LessionPlayerBloc(this.parent) : assert(parent != null);

  @override
  LessionPlayerState get initialState => LessionPlayerStateInitial();

  @override
  Stream<LessionPlayerState> mapEventToState(LessionPlayerEvent event) async* {
    try {
      if (event is LessionPlayerEventInit) {
        _lession = event.lession;
        // initialize video player
        await _controller?.dispose();
        _controller = VideoPlayerController.file(File(_lession.path));
        await _controller.initialize();
        print('initialized');
        _controller.play();
        yield LessionPlayerStateLoaded(_controller, _controller.value.aspectRatio);
      }
    } catch (error) {
      yield LessionPlayerStateError(error.toString());
    }
  }
}
