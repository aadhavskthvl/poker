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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF303030), // Nice dark grey
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
  List<String> cardNumbers = [
    'A',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'J',
    'Q',
    'K'
  ];
  List<String> cardSuits = [
    's',
    'h',
    'd',
    'c'
  ]; // Spades, Hearts, Diamonds, Clubs
  int card1Index = 0;
  int card2Index = 0;
  int card1SuitIndex = 0; // Starts with Spades
  int card2SuitIndex = 1; // Starts with Hearts

  void togglePlayer(int index) {
    setState(() {
      activePlayers[index] = !activePlayers[index];
    });
  }

  void changeCard(int cardIndex, bool isNext, bool isNumberChange) {
    setState(() {
      if (isNumberChange) {
        if (cardIndex == 1) {
          card1Index = isNext
              ? (card1Index + 1) % cardNumbers.length
              : (card1Index - 1 + cardNumbers.length) % cardNumbers.length;
        } else {
          card2Index = isNext
              ? (card2Index + 1) % cardNumbers.length
              : (card2Index - 1 + cardNumbers.length) % cardNumbers.length;
        }
      } else {
        if (cardIndex == 1) {
          card1SuitIndex = isNext
              ? (card1SuitIndex + 1) % cardSuits.length
              : (card1SuitIndex - 1 + cardSuits.length) % cardSuits.length;
        } else {
          card2SuitIndex = isNext
              ? (card2SuitIndex + 1) % cardSuits.length
              : (card2SuitIndex - 1 + cardSuits.length) % cardSuits.length;
        }
      }
    });
  }

  Widget swipeableCard(int cardIndex) {
    int numberIndex = cardIndex == 1 ? card1Index : card2Index;
    int suitIndex = cardIndex == 1 ? card1SuitIndex : card2SuitIndex;
    String cardAssetPath =
        'assets/${cardNumbers[numberIndex]}${cardSuits[suitIndex]}.png';

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          changeCard(cardIndex, true, true);
        } else if (details.primaryVelocity! > 0) {
          changeCard(cardIndex, false, true);
        }
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          changeCard(cardIndex, true, false);
        } else if (details.primaryVelocity! < 0) {
          changeCard(cardIndex, false, false);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Image.asset(cardAssetPath, fit: BoxFit.cover, height: 200),
      ),
    );
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
              children: [
                swipeableCard(1), // Card 1
                SizedBox(width: 5), // Reduced space between cards
                swipeableCard(2), // Card 2
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
              onPressed: () {},
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
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
          icon: Icon(icon, size: 50),
          color: color,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 20),
        ),
      ],
    );
  }
}
