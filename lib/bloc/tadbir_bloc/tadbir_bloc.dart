import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiro_app/data/models/event.dart';
import 'package:tadbiro_app/data/repositories/tadbir_repository.dart';

part 'tadbir_event.dart';
part 'tadbir_state.dart';

class TadbirBloc extends Bloc<TadbirEvent, TadbirState> {
  final TadbirRepository _tadbirRepository;
  TadbirBloc(TadbirRepository tadbirrepository)
      : _tadbirRepository = tadbirrepository,
        super(TadbirInitial()) {
    on<FetchTadbirEvent>(_fetchTadbir);
    on<FetchMyTadbirEvent>(_fetchMyEvents);
    on<AddTadbirEvent>(_addTadbir);
  }

  void _fetchTadbir(FetchTadbirEvent event, Emitter<TadbirState> emit) async {
    emit(TadbirLoading());

    try {
      await emit.forEach(
        _tadbirRepository.fetchEvents(),
        onData: (data) {
          print("tushti");
          final event = data.docs;
          List<Event> list = [];
          for (var i in event) {
            list.add(Event.fromQuerySnapshot(i));
          }
          return TadbirLoaded(events: list);
        },
      );
    } catch (e) {
      emit(TadbirError(errorMessage: "Error fetch qilishda:   $e"));
    }
  }

  void _addTadbir(AddTadbirEvent event, Emitter<TadbirState> emit) async {
    emit(TadbirLoading());

    try {
      _tadbirRepository.addEvent(event.event);
    } catch (e) {
      emit(TadbirError(errorMessage: "Error qo'shishda  -  $e"));
    }
  }

  void _fetchMyEvents(
      FetchMyTadbirEvent event, Emitter<TadbirState> emit) async {
    emit(TadbirLoading());

    try {
      await emit.forEach(
        _tadbirRepository.fetchMyEvents(),
        onData: (data) {
          print("tushti");
          final event = data.docs;
          List<Event> list = [];
          for (var i in event) {
            list.add(Event.fromQuerySnapshot(i));
          }
          return TadbirLoaded(events: list);
        },
      );
    } catch (e) {
      emit(TadbirError(errorMessage: "Error fetch qilishda:   $e"));
    }
  }
}
