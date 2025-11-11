import 'package:flutter/material.dart';
import 'package:master_plan/models/plan.dart';
import './provider/plan_provider.dart';
import './views/plan_screen.dart';
import 'views/plan_creator_screen.dart';

void main() => runApp(MasterPlanApp());

class MasterPlanApp extends StatelessWidget {
  const MasterPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlanProvider(
      notifier: ValueNotifier<List<Plan>>(const []), 
      child: const MaterialApp(
        home: PlanCreatorScreen(), 
      ),
    );
  }
}