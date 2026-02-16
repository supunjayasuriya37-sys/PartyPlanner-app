import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/service_locator.dart';
import '../../auth/logic/auth_bloc.dart';
import '../data/event_repository.dart';
import '../logic/dashboard_bloc.dart';
import '../widgets/event_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current user from AuthBloc to load events
    final authState = context.read<AuthBloc>().state;
    String? userId;
    if (authState is AuthAuthenticated) {
      userId = authState.user.uid;
    }

    return BlocProvider(
      create: (context) => DashboardBloc(
        eventRepository: getIt<EventRepository>(),
      )..add(LoadEvents(userId ?? '')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LoggedOut());
              },
            ),
          ],
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is DashboardLoaded) {
              if (state.events.isEmpty) {
                return const Center(child: Text('No events found. Plan one!'));
              }
              return ListView.builder(
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return EventCard(
                    event: event,
                    onTap: () {
                      // TODO: Navigate to event details
                    },
                  );
                },
              );
            }
            return const Center(child: Text('Welcome to PartyPlanner!'));
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push('/planner');
          },
          label: const Text('Plan Event'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
