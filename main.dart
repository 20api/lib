import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zvrdkiodlaynignlafwa.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2cmRraW9kbGF5bmlnbmxhZndhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE5NDQ2NDgsImV4cCI6MjA4NzUyMDY0OH0.6Do5GXK8hRszvqWPUhSBpIxW4ZiSDMBu9OygzqoQM3o',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final supabase = Supabase.instance.client;

  final nameController = TextEditingController();
  final regController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  Future<void> signUp() async {
    if (nameController.text.isEmpty ||
        regController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {
      showMessage("All fields are mandatory");
      return;
    }

    if (passwordController.text != confirmController.text) {
      showMessage("Passwords do not match");
      return;
    }

    try {
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'name': nameController.text.trim(),
          'registration': regController.text.trim(),
        },
      );

      if (response.user != null) {
        showMessage("Account created successfully");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      showMessage("Signup failed: ${e.toString()}");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SignUp Page")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Welcome to Student Sign Up",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name with initials",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: regController,
                decoration: const InputDecoration(
                  labelText: "Registration Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signUp,
                  child: const Text("Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Homepage")),
      body: const Center(
        child: Text(
          "Welcome to Homepage!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/////pubspec yaml///////
name: form
description: Student Signup App with Supabase
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <3.3.0"

dependencies:
  flutter:
    sdk: flutter

  supabase_flutter: ^2.3.4

  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true

////////////Cal//////////

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TipCalculatorUI(),
    );
  }
}

class TipCalculatorUI extends StatefulWidget {
  const TipCalculatorUI({super.key});

  @override
  State<TipCalculatorUI> createState() => _TipCalculatorUIState();
}

class _TipCalculatorUIState extends State<TipCalculatorUI> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController billController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();

  String selectedTip = "10";
  String greetingMessage = "Hi Customer, your total bill for today is";
  String totalAmount = "Rs. 0.00";

  // CALCULATION
  void calculateTip() {
    if (nameController.text.isEmpty ||
        billController.text.isEmpty ||
        peopleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    double bill = double.parse(billController.text);
    int people = int.parse(peopleController.text);
    double tipPercent = double.parse(selectedTip);

    double tipAmount = (bill * tipPercent) / 100;
    double totalForOnePerson = bill + tipAmount;

    // MULTIPLICATION LOGIC
    double finalTotal = totalForOnePerson * people;

    setState(() {
      greetingMessage =
          "Hi ${nameController.text}, your total bill for $people people is";
      totalAmount = "Rs. ${finalTotal.toStringAsFixed(2)}";
    });
  }

  //CLEAR FUNCTION
  void clearAll() {
    nameController.clear();
    billController.clear();
    peopleController.clear();

    setState(() {
      selectedTip = "10";
      greetingMessage = "Hello, ur total bill for today is";
      totalAmount = "Rs. 0.00";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CAL"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // RESULT
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      greetingMessage,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      totalAmount,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // INPUT CARD
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Customer Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: billController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Bill Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedTip,
                      decoration: const InputDecoration(
                        labelText: "Tip Percentage",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: "5", child: Text("5%")),
                        DropdownMenuItem(value: "10", child: Text("10%")),
                        DropdownMenuItem(value: "15", child: Text("15%")),
                        DropdownMenuItem(value: "20", child: Text("20%")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedTip = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: peopleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of People",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: peopleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Mobile number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            //BUTTONS
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculateTip,
                child: const Text("Calculate Tip"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: clearAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: const Text("Clear All"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/////////////////////////interface///////////////

