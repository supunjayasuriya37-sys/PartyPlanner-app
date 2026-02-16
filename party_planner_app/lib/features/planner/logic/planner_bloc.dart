import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/ai_service.dart';

// Events
abstract class PlannerEvent extends Equatable {
  const PlannerEvent();
  @override
  List<Object> get props => [];
}

class GeneratePlan extends PlannerEvent {
  final String prompt;
  const GeneratePlan(this.prompt);
  @override
  List<Object> get props => [prompt];
}

class ResetPlanner extends PlannerEvent {}

// States
abstract class PlannerState extends Equatable {
  const PlannerState();
  @override
  List<Object> get props => [];
}

class PlannerInitial extends PlannerState {}
class PlannerLoading extends PlannerState {}
class PlannerLoaded extends PlannerState {
  final String plan;
  const PlannerLoaded(this.plan);
  @override
  List<Object> get props => [plan];
}
class PlannerError extends PlannerState {
  final String message;
  const PlannerError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  final AIService _aiService;

  PlannerBloc({required AIService aiService})
      : _aiService = aiService,
        super(PlannerInitial()) {
    on<GeneratePlan>(_onGeneratePlan);
    on<ResetPlanner>((event, emit) => emit(PlannerInitial()));
  }

  Future<void> _onGeneratePlan(GeneratePlan event, Emitter<PlannerState> emit) async {
    emit(PlannerLoading());
    try {
      final plan = await _aiService.generateEventPlan(event.prompt);
      emit(PlannerLoaded(plan));
    } catch (e) {
      emit(PlannerError(e.toString()));
    }
  }
}
