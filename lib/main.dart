import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Grade Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: SafeArea(
          child: GradeCalculatorScreen(),
        ),
      ),
    );
  }
}

class GradeCalculatorScreen extends StatefulWidget {
  const GradeCalculatorScreen({super.key});

  @override
  State<GradeCalculatorScreen> createState() => _GradeCalculatorScreenState();
}

class _GradeCalculatorScreenState extends State<GradeCalculatorScreen> {
  // Text editing controllers to track inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  // Screen state variables
  String _gradeResult = "";
  String _resultMessage = "Enter the student details.";
  String _errorMessage = "";

  @override
  void dispose() {
    _nameController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  void _calculateGrade() {
    final String studentName = _nameController.text;
    final double? marks = double.tryParse(_marksController.text);

    setState(() {
      _errorMessage = "";
      _gradeResult = "";

      if (studentName.trim().isEmpty) {
        _errorMessage = "Please enter the student's name.";
      } else if (marks == null) {
        _errorMessage = "Please enter valid numerical marks.";
      } else if (marks < 0 || marks > 100) {
        _errorMessage = "Marks must be between 0 and 100.";
      } else {
        // Calculate Grade
        String grade;
        if (marks >= 85) {
          grade = "A+";
        } else if (marks >= 75) {
          grade = "A";
        } else if (marks >= 65) {
          grade = "B";
        } else if (marks >= 55) {
          grade = "C";
        } else if (marks >= 45) {
          grade = "D";
        } else {
          grade = "F";
        }

        // Determine Status
        final String status = (marks >= 45) ? "Pass" : "Fail";

        _gradeResult = grade;
        _resultMessage = "$studentName obtained ${_formatMarks(marks)} marks.\n"
            "Grade: $grade\n"
            "Result: $status";
      }
    });
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _marksController.clear();
      _gradeResult = "";
      _resultMessage = "Enter the student details.";
      _errorMessage = "";
    });
  }

  String _formatMarks(double marks) {
    if (marks % 1.0 == 0.0) {
      return marks.toInt().toString();
    } else {
      return marks.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Student Grade Calculator",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              "Enter the name and marks to calculate the grade.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28.0),
            
            // Student Name Input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Student Name',
                hintText: 'Example: Kamal',
              ),
              maxLines: 1,
              onChanged: (_) {
                if (_errorMessage.isNotEmpty) {
                  setState(() => _errorMessage = "");
                }
              },
            ),
            const SizedBox(height: 16.0),
            
            // Marks Input
            TextField(
              controller: _marksController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Marks',
                hintText: 'Enter marks from 0 to 100',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              maxLines: 1,
              inputFormatters: [
                // Allows up to 3 digits followed by an optional 2-place decimal point
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
              ],
              onChanged: (_) {
                if (_errorMessage.isNotEmpty) {
                  setState(() => _errorMessage = "");
                }
              },
            ),
            const SizedBox(height: 24.0),
            
            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _calculateGrade,
                    child: const Text("Calculate"),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetForm,
                    child: const Text("Reset"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28.0),
            
            // Result Card
            Card(
              elevation: 4.0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Result",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (_gradeResult.isNotEmpty) ...[
                      const SizedBox(height: 12.0),
                      Text(
                        _gradeResult,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                    const SizedBox(height: 12.0),
                    Text(
                      _resultMessage,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
