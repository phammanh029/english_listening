import 'dart:io';

import 'package:english_listening/model/Lession.model.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:video_player/video_player.dart';

class LessionGalaryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LessionGalaryEventAddMediaQueues extends LessionGalaryEvent {
  // add new video to LessionGalary list
  final List<String> items;

  LessionGalaryEventAddMediaQueues({this.items});
  @override
  List<Object> get props => [items];
}

class LessionGalaryEventInit extends LessionGalaryEvent {}

class LessionGalaryEventViewLession extends LessionGalaryEvent {
  final Lession lession;

  LessionGalaryEventViewLession(this.lession);

  @override
  List<Object> get props => [lession];
}

class LessionGalaryEventRemoveMediaQueues extends LessionGalaryEvent {
  // remove video to LessionGalary list
}

// STATE
class LessionGalaryState extends Equatable {
  @override
  List<Object> get props => [];
}

class LessionGalaryStateInitial extends LessionGalaryState {}

class LessionGalaryStateLoading extends LessionGalaryState {}

class LessionGalaryStateViewItem extends LessionGalaryState {
  final Lession lession;
  final double aspectRatio;

  LessionGalaryStateViewItem({this.lession, this.aspectRatio});
  @override
  List<Object> get props => [aspectRatio, lession];
}

class LessionGalaryStateMediasSet extends LessionGalaryState {
  final List<Lession> lessions;

  LessionGalaryStateMediasSet(this.lessions);
  @override
  List<Object> get props => [lessions];
}

class LessionGalaryStateError extends LessionGalaryState {
  final String error;

  LessionGalaryStateError(this.error);

  @override
  List<Object> get props => [error];
}

// BLOC
class LessionGalaryBloc extends Bloc<LessionGalaryEvent, LessionGalaryState> {
  List<Lession> _lessions = [];
  @override
  LessionGalaryState get initialState => LessionGalaryStateInitial();

  @override
  Stream<LessionGalaryState> mapEventToState(LessionGalaryEvent event) async* {
    try {
      if (event is LessionGalaryEventInit) {
        // @TODO load from database
        yield LessionGalaryStateLoading();
        await Future.delayed(Duration(seconds: 2));
        yield LessionGalaryStateMediasSet(_lessions);
      }
      if (event is LessionGalaryEventAddMediaQueues) {
        yield LessionGalaryStateLoading();
        // add to list of current file
        _lessions = [
          ..._lessions,
          ...(event.items ?? [])
              .map((item) => Lession(path: item, transcript: ''))
              .toList()
        ];
        yield LessionGalaryStateMediasSet(_lessions);
      }

      if (event is LessionGalaryEventViewLession) {
        // do set controller

        // do display video
      }
    } catch (error) {
      yield LessionGalaryStateError(error.toString());
    }
  }
}
