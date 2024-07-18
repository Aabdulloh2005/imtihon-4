


part of 'tadbir_bloc.dart';

sealed class TadbirState {}

final class TadbirInitial extends TadbirState {}

final class TadbirLoading extends TadbirState {}

final class TadbirLoaded extends TadbirState {
  List<Event> events;

  TadbirLoaded({
    required this.events,
  });
}

final class TadbirError extends TadbirState {
  String errorMessage;

  TadbirError({
    required this.errorMessage,
  });
}
