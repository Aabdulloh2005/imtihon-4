part of 'tadbir_bloc.dart';

sealed class TadbirEvent {}

final class FetchTadbirEvent extends TadbirEvent {}

final class FetchMyTadbirEvent extends TadbirEvent {}

final class AddTadbirEvent extends TadbirEvent {
  final Event event;

  AddTadbirEvent({
    required this.event,
  });
}

final class EditTadbirEvent extends TadbirEvent {
  final Event event;

  EditTadbirEvent({
    required this.event,
  });
}

final class DeleteTadbirEvent extends TadbirEvent {
  String id;

  DeleteTadbirEvent({
    required this.id,
  });
}
