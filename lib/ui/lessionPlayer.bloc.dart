import 'dart:io';

import 'package:english_listening/model/Lession.model.dart';
import 'package:english_listening/services/database_service.dart';
import 'package:english_listening/ui/lessionGalary.bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

class LessionPlayerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LessionPlayerEventUninit extends LessionPlayerEvent {}

class LessionPlayerEventUpdateTranscription extends LessionPlayerEvent {
  final String transcription;

  LessionPlayerEventUpdateTranscription(this.transcription);
  @override
  List<Object> get props => [transcription];
}

class LessionPlayerEventInit extends LessionPlayerEvent {
  final String lessionPath;

  LessionPlayerEventInit(this.lessionPath);
  @override
  List<Object> get props => [lessionPath];
}

class LessionPlayerState extends Equatable {
  @override
  List<Object> get props => [];
}

class LessionPlayerStateInitial extends LessionPlayerState {}
// class LessionPlayerStateInitial extends LessionPlayerState {}

class LessionPlayerStateLoaded extends LessionPlayerState {
  final VideoPlayerController controller;
  final String transcription;
  // final double aspectRatio;

  LessionPlayerStateLoaded(this.controller, this.transcription);

  @override
  List<Object> get props => [controller, transcription];
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
        final instance = await DatabaseService.instance;
        _lession = await instance.getLession(event.lessionPath);
        print(_lession.transcript);
        // initialize video player
        await _controller?.dispose();
        _controller = VideoPlayerController.file(File(_lession.path));
        await _controller.initialize();
        // print('initialized');
        _controller.play();
        yield LessionPlayerStateLoaded(_controller, _lession.transcript);
      }

      if (event is LessionPlayerEventUpdateTranscription) {
        _lession = _lession.copyWith(transcript: event.transcription);
        // do udpdate to database
        final instance = await DatabaseService.instance;
        await instance.updateLession(_lession);

        yield LessionPlayerStateLoaded(_controller, _lession.transcript);
      }

      if (event is LessionPlayerEventUninit) {
        await _controller?.dispose();
      }
    } catch (error) {
      yield LessionPlayerStateError(error.toString());
    }
  }
}
