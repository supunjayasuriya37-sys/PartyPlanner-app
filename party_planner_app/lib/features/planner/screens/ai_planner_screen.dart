import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/service_locator.dart';
import '../logic/planner_bloc.dart';

class AIPlannerScreen extends StatefulWidget {
  const AIPlannerScreen({super.key});

  @override
  State<AIPlannerScreen> createState() => _AIPlannerScreenState();
}

class _AIPlannerScreenState extends State<AIPlannerScreen> {
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlannerBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Event Planner'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: 'Describe your event (e.g., Birthday party for 10 kids)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              BlocBuilder<PlannerBloc, PlannerState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is PlannerLoading
                          ? null
                          : () {
                              if (_promptController.text.isNotEmpty) {
                                context
                                    .read<PlannerBloc>()
                                    .add(GeneratePlan(_promptController.text));
                                FocusScope.of(context).unfocus();
                              }
                            },
                      child: state is PlannerLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Generate Plan'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<PlannerBloc, PlannerState>(
                  builder: (context, state) {
                    if (state is PlannerLoaded) {
                      return SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(state.plan),
                        ),
                      );
                    } else if (state is PlannerError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const Center(
                        child: Text('Enter a description to get a plan!'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
