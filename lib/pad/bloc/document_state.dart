part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

class DocumentLoadInProgress extends DocumentState {}

class DocumentLoadSuccess extends DocumentState {
  final AppDocument document;
  final String currentPad;

  const DocumentLoadSuccess(this.document, {this.currentPad});

  @override
  List<Object> get props => [document];
}

class DocumentLoadFailure extends DocumentState {}
