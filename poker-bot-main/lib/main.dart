import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poker Hand Evaluator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PokerHandPage(title: 'Poker Hand Evaluator'),
    );
  }
}

class PokerHandPage extends StatefulWidget {
  const PokerHandPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PokerHandPage> createState() => _PokerHandPageState();
}

class _PokerHandPageState extends State<PokerHandPage> {
  final List<bool> activePlayers = List<bool>.generate(5, (_) => true);
  int currentRaise = 0;

  void togglePlayer(int index) {
    setState(() {
      activePlayers[index] = !activePlayers[index];
    });
  }

  Widget playerIcon(int index) {
    return GestureDetector(
      onTap: () => togglePlayer(index),
      child: Icon(
        activePlayers[index] ? Icons.person : Icons.person_off,
        size: 50,
        color: activePlayers[index] ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> submitData() async {
    // Create the request data
    final requestData = {
      'card': 'assets/As.png', // Replace this with your card widget source name
      'players': activePlayers.where((player) => player).length.toString(),
      'raise': currentRaise.toString(),
    };


    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse('http://localhost:3000/submitData'), // Replace this with your server URL
        body: requestData,
      );

      // Check the status code for a successful response
      if (response.statusCode == 200) {
        print('Data submitted successfully');
      } else {
        print('Failed to submit data');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text('Raise Probability: XX% | Check Probability: XX%'),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) => playerIcon(index)),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset('assets/As.png', // Card 1
                        fit: BoxFit.cover, height: 200)),// Card 1
                SizedBox(width: 10),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset('assets/Ah.png', // Card 1
                        fit: BoxFit.cover, height: 200)),// Card 1
                SizedBox(width: 10), // Card 2
              ],
            ),
            const SizedBox(height: 50),
            Text('Current Highest Raise: $currentRaise'),
            const SizedBox(height: 50),
            Slider(
              min: 0,
              max: 1000,
              divisions: 200,
              label: currentRaise.toString(),
              value: currentRaise.toDouble(),
              onChanged: (double value) {
                setState(() {
                  currentRaise = value.round();
                });
              },
            ),
            const SizedBox(height: 50),
            ButtonWithText(
              color: Colors.blue,
              icon: Icons.play_arrow,
              label: 'Submit',
              onPressed: submitData,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 50), // Increase the size here
          color: color,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 20), // Increase the font size here
        ),
      ],
    );
  }
}







