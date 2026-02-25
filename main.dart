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
/////////CAL2////

import 'package:flutter/material.dart';

void main() {
  runApp(const AppHome());
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: countApp(),
    );
  }
}

class countApp extends StatefulWidget {
  const countApp({super.key});
  @override
  State<countApp> createState() => _countAppState();
}

class _countAppState extends State<countApp> {
  final TextEditingController billController = TextEditingController();

  double tipPecentage = 0.0;
  double tipAmount = 0.0;
  double billAmount = 0.0;

  void calTipPer() {
    // get bill from user input
    double bill = double.tryParse(billController.text) ?? 0;
    setState(() {
      tipAmount = bill * tipPecentage / 100;
      billAmount = bill + tipAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tip Calculator",
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 236, 235, 235),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 3, 50, 69),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Card
            Card(
              //color: const Color.fromARGB(233, 12, 122, 120),
              shadowColor: const Color.fromARGB(255, 67, 51, 5),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Text(
                      "Bill Amount",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextField(
                      controller: billController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(255, 168, 15, 15),
                        hintText: "Enter Bill amount",
                        hoverColor: Colors.amber,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // 2. Card
            Card(
              //color: const Color.fromARGB(233, 12, 122, 120),
              shadowColor: const Color.fromARGB(255, 67, 51, 5),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      "Tip Percentage: ${tipPecentage.toInt()}%",
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Slider(
                      value: tipPecentage,
                      onChanged: (value) {
                        setState(() {
                          tipPecentage = value;
                        });
                      },
                      min: 0,
                      max: 50,
                      divisions: 50,
                      label: "${tipPecentage.toInt()}",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: calTipPer,
                child: const Text(
                  "Calculate",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // 4. Card
            Card(
              //color: const Color.fromARGB(233, 12, 122, 120),
              shadowColor: const Color.fromARGB(255, 67, 51, 5),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      "TiP: \$${tipAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      "Bill: \$${billAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 0, 0),
                      ),
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


/////////////////////////interface///////////////

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
      home: StudentHousePage(),
    );
  }
}

class StudentHousePage extends StatelessWidget {
  const StudentHousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// APP BAR WITH MULTIPLE SELECTION AREAS
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "House Meet",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Home",
                style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Houses",
                style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Events",
                style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Results",
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE BANNER
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage("images/pngt.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            const Text(
              "Select Your House",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// HOUSE BUTTONS
            _houseButton("Red House"),
            _houseButton("Blue House"),
            _houseButton("Green House"),
            _houseButton("Yellow House"),
          ],
        ),
      ),
    );
  }

  /// SIMPLE HOUSE BUTTON
  Widget _houseButton(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.grey,
          foregroundColor: Colors.black,
        ),
        child: Text(name),
      ),
    );
  }
}

////pubspec yaml////////

name: game_explore_ui
description: A modern game explore UI built with Flutter
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^3.0.0

flutter:

  uses-material-design: true

  assets:
    - images/pngt.jpg


///////interface2///////

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
      home: PizzaHome(),
    );
  }
}

class PizzaHome extends StatefulWidget {
  const PizzaHome({super.key});

  @override
  State<PizzaHome> createState() => _PizzaHomeState();
}

class _PizzaHomeState extends State<PizzaHome> {
  int cheeseCount = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "hello",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ///  ROW
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      "https://.....",
                      height: 90,
                    ),
                    Image.network(
                      "https:......",
                      height: 90,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            const Text(
              "Customize Your Order",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// MAIN PIZZA IMAGE
            Image.network(
              "https://....",
              height: 180,
            ),

            const SizedBox(height: 30),

            ///  COUNTER CARD
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "how much",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        Text(
                          "$cheeseCount",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            setState(() {
                              cheeseCount++;
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
      ),
    );
  }
}

///pubspec//
name: pizza_order_app
description: A simple stateful Flutter pizza order UI
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true




