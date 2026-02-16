import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/event_repository.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object> get props => [];
}

class LoadEvents extends DashboardEvent {
  final String userId;
  const LoadEvents(this.userId);
  @override
  List<Object> get props => [userId];
}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final List<Map<String, dynamic>> events;
  const DashboardLoaded(this.events);
  @override
  List<Object> get props => [events];
}
class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final EventRepository _eventRepository;

  DashboardBloc({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(DashboardInitial()) {
    on<LoadEvents>(_onLoadEvents);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final events = await _eventRepository.getEvents(event.userId);
      emit(DashboardLoaded(events));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
