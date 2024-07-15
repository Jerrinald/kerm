part of 'admin_form_bloc.dart';

abstract class AdminFormEvent extends Equatable {
  const AdminFormEvent();

  @override
  List<Object> get props => [];
}

class FormSubmitEvent extends AdminFormEvent {
  final int id;
  final void Function() onSuccess;
  final void Function(String errorMessage) onError;

  const FormSubmitEvent({
    required this.id,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object> get props => [onSuccess, onError, id];
}

class FormNewSubmitEvent extends AdminFormEvent {
  final VoidCallback onSuccess;
  final Function(String) onError;

  const FormNewSubmitEvent({required this.onSuccess, required this.onError});

  @override
  List<Object> get props => [onSuccess, onError];
}

class FormResetEvent extends AdminFormEvent {
  const FormResetEvent();
}

class InitEvent extends AdminFormEvent {
  final int id;

  InitEvent({required this.id});
}

class InitNewEvent extends AdminFormEvent {
  const InitNewEvent();
}

class NameChanged extends AdminFormEvent {
  const NameChanged({required this.name});
  final BlocFormItem name;
  @override
  List<Object> get props => [name];
}

class DescriptionChanged extends AdminFormEvent {
  const DescriptionChanged({required this.description});
  final BlocFormItem description;
  @override
  List<Object> get props => [description];
}

class EmailChanged extends AdminFormEvent {
  const EmailChanged({required this.email});
  final BlocFormItem email;
  @override
  List<Object> get props => [email];
}

class TransportActiveChanged extends AdminFormEvent {
  final bool transportActive;

  const TransportActiveChanged({required this.transportActive});

  @override
  List<Object> get props => [transportActive];
}

class InitAddEmail extends AdminFormEvent {
  const InitAddEmail();
}

class FetchEmailSuggestions extends AdminFormEvent {
  final String query;
  final int eventId;

  const FetchEmailSuggestions({required this.query, required this.eventId});

  @override
  List<Object> get props => [query];
}

class FormParticipantSubmitEvent extends AdminFormEvent {
  final int eventId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  FormParticipantSubmitEvent({required this.eventId, required this.onSuccess, required this.onError});
  @override
  List<Object> get props => [onSuccess, onError];
}

class RemoveParticipant extends AdminFormEvent {
  final int participantId;
  final int eventId;
  final bool active;

  RemoveParticipant({required this.participantId, required this.eventId, required this.active});
}