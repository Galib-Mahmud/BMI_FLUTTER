import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cli/loginpage.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String selectedGender = 'Male';
  bool isMetric = false;
  double? bmi;

  void calculateBMI() {
    final weight = double.tryParse(_weightController.text) ?? 0;

    double heightInMeters;

    final feet = double.tryParse(_feetController.text) ?? 0;
    final inches = double.tryParse(_inchesController.text) ?? 0;
    final totalInches = (feet * 12) + inches;
    heightInMeters = totalInches * 0.0254;

    if (heightInMeters <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid height and weight")),
      );
      return;
    }

    double mass = weight;
    double calculatedBmi = mass / pow(heightInMeters, 2);
    String category = getBmiCategory(calculatedBmi);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("BMI Result"),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
                _clearInputs();
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Your BMI is:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              calculatedBmi.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: getCategoryColor(category),
              ),
            ),
            const SizedBox(height: 20),
            bmiProgressBar(calculatedBmi),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => showBmiTable(),
              child: const Text("View BMI Table"),
            ),
          ],
        ),
      ),
    );
  }

  void _clearInputs() {
    _feetController.clear();
    _inchesController.clear();
    _weightController.clear();
  }

  Widget bmiProgressBar(double bmi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("BMI Range", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Stack(
          children: [
            Row(
              children: [
                _barSegment(Colors.orange, flex: 2),
                _barSegment(Colors.green, flex: 3),
                _barSegment(Colors.amber, flex: 2),
                _barSegment(Colors.red, flex: 2),
              ],
            ),
            Positioned(
              left: (bmi < 40 ? bmi : 40) / 40 * MediaQuery.of(context).size.width * 0.8,
              top: 0,
              child: const Icon(Icons.arrow_drop_down, size: 30, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget _barSegment(Color color, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 14,
        color: color,
      ),
    );
  }

  void showBmiTable() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("BMI Categories"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text("Underweight"), trailing: Text("< 18.5")),
            ListTile(title: Text("Normal"), trailing: Text("18.5 - 24.9")),
            ListTile(title: Text("Overweight"), trailing: Text("25 - 29.9")),
            ListTile(title: Text("Obese"), trailing: Text("30+")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  String getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Underweight': return Colors.orange;
      case 'Normal': return Colors.green;
      case 'Overweight': return Colors.amber;
      case 'Obese': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget genderButton(String gender, IconData icon, Color color) {
    bool isSelected = selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : [],
          ),
          child: Column(
            children: [
              Icon(icon, size: 36, color: isSelected ? Colors.white : color),
              const SizedBox(height: 8),
              Text(gender, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputCard({required String label, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          child,
        ]),
      ),
    );
  }
  LogOut()async{
    FirebaseAuth.instance.signOut().then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const Text("Select Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(children: [
              genderButton('Male', Icons.male, Colors.blue),
              const SizedBox(width: 10),
              genderButton('Female', Icons.female, Colors.pink),
              const SizedBox(width: 10),
              genderButton('3rd Gender', Icons.transgender, Colors.purple),
            ]),
            const SizedBox(height: 20),
            inputCard(
              label: "Height (ft/in)",
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _feetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Feet", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _inchesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Inches", border: OutlineInputBorder()),
                  ),
                ),
              ]),
            ),
            inputCard(
              label: "Weight (kg)",
              child: TextField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: "e.g. 65", border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Calculate BMI", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: LogOut,
        icon: Icon(Icons.logout),
        label: Text("Logout",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal,

      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,


    );
  }
}
