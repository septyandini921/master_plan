import 'package:flutter/material.dart';
import 'package:master_plan/models/plan.dart';
import 'package:master_plan/views/plan_screen.dart';
import '../provider/plan_provider.dart';

// --- LANGKAH 9: Buat screen baru (StatefulWidget) ---
class PlanCreatorScreen extends StatefulWidget {
  const PlanCreatorScreen({super.key});

  @override
  State<PlanCreatorScreen> createState() => _PlanCreatorScreenState();
}

class _PlanCreatorScreenState extends State<PlanCreatorScreen> {
  // --- LANGKAH 10: Tambahkan TextEditingController ---
  final textController = TextEditingController();

  // --- LANGKAH 11: Method build ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Plans Nimas Septiandini')),
      body: Column(
        children: [
          _buildListCreator(),
          Expanded(child: _buildMasterPlans()),
        ],
      ),
    );
  }

  // --- LANGKAH 12: Widget _buildListCreator (Input Field) ---
  Widget _buildListCreator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        color: Theme.of(context).cardColor,
        elevation: 10,
        child: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Add a plan',
            contentPadding: EdgeInsets.all(20),
          ),
          onEditingComplete: addPlan, // Panggil method addPlan saat Enter
        ),
      ),
    );
  }

  // --- LANGKAH 13: void addPlan() ---
  void addPlan() {
    final text = textController.text;
    if (text.isEmpty) {
      return;
    }

    final plan = Plan(name: text, tasks: const []);
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    planNotifier.value = List<Plan>.from(planNotifier.value)..add(plan);
    textController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});
  }

  // --- LANGKAH 14: Widget _buildMasterPlans (Menampilkan Daftar Rencana) ---
  Widget _buildMasterPlans() {
    return ValueListenableBuilder<List<Plan>>(
      valueListenable: PlanProvider.of(context),
      builder: (context, plans, child) {
        if (plans.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.note, size: 100, color: Colors.grey),
              Text(
                'Anda belum memiliki rencana apapun.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          );
        }

        return ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return ListTile(
              title: Text(plan.name),
              subtitle: Text(plan.completenessMessage),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PlanScreen(plan: plan)),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}