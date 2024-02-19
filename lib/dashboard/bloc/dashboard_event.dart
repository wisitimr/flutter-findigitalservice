part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

final class DashboardStarted extends DashboardEvent {
  const DashboardStarted(this.provider);

  final AppProvider provider;

  @override
  List<Object> get props => [];
}
