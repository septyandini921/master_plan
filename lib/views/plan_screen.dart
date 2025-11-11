import '../models/data_layer.dart';
import 'package:flutter/material.dart';
import '../provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({super.key, required this.plan});

  @override
  State createState() => _PlanScreenState();
}

// langkah 5
class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;
  Plan get plan => widget.plan;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  Plan get _currentPlanFromProvider {
    final List<Plan> plans = PlanProvider.of(context).value;
    return plans.firstWhere(
      (p) => p.name == widget.plan.name,
      orElse: () => widget.plan,
    );
  }

  void _updatePlan(Plan updatedPlan) {
    final planNotifier = PlanProvider.of(context);
    final List<Plan> plans = planNotifier.value;

    final int index = plans.indexWhere((p) => p.name == updatedPlan.name);

    if (index != -1) {
      planNotifier.value = List<Plan>.from(plans)..[index] = updatedPlan;
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          Plan currentPlan = _currentPlanFromProvider;

          return Column(
            children: [
              Expanded(child: _buildList(currentPlan)),
              SafeArea(child: Text(currentPlan.completenessMessage)),
            ],
          );
        },
      ),

      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Plan currentPlan = _currentPlanFromProvider;

        int planIndex = planNotifier.value.indexWhere(
          (p) => p.name == currentPlan.name,
        );

        List<Task> updatedTasks = List<Task>.from(currentPlan.tasks)
          ..add(const Task(description: '', complete: false));

        final Plan updatedPlan = Plan(
          name: currentPlan.name,
          tasks: updatedTasks,
        );

        //  (Langkah 7)
        planNotifier.value = List<Plan>.from(planNotifier.value)
          ..[planIndex] = updatedPlan;
      },
    );
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(plan.tasks[index], index, context),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          Plan currentPlan = plan;
          int planIndex = planNotifier.value.indexWhere(
            (p) => p.name == currentPlan.name,
          );
          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(
                  description: task.description,
                  complete: selected ?? false,
                ),
            );
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          Plan currentPlan = plan;
          int planIndex = planNotifier.value.indexWhere(
            (p) => p.name == currentPlan.name,
          );
          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(
              name: currentPlan.name,
              tasks: List<Task>.from(currentPlan.tasks)
                ..[index] = Task(description: text, complete: task.complete),
            );
        },
      ),
    );
  }
}