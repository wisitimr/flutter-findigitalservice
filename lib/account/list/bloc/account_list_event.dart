part of 'account_list_bloc.dart';

@immutable
sealed class AccountEvent extends Equatable {
  const AccountEvent();
}

final class AccountStarted extends AccountEvent {
  const AccountStarted();

  @override
  List<Object> get props => [];
}

final class AccountSearchChanged extends AccountEvent {
  const AccountSearchChanged(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

final class AccountDeleteConfirm extends AccountEvent {
  const AccountDeleteConfirm(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class AccountDelete extends AccountEvent {
  const AccountDelete();

  @override
  List<Object> get props => [];
}
