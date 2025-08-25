import 'package:flutter/material.dart';
import 'package:prototypet1/services/g2_services.dart';

class ReverseGueszy extends StatefulWidget {
  const ReverseGueszy({super.key});

  @override
  State<ReverseGueszy> createState() => _ReverseGueszyState();
}

class _ReverseGueszyState extends State<ReverseGueszy> {
  final service = G2Services();
  final TextEditingController controller = TextEditingController();

  String myWord = '';
  String currentGuess = '';
  final Set<String> correctLetters = {};
  final Set<String> wrongLetters = {};
  int aiTries = 0;
  bool gameStarted = false;
  bool gameOver = false;
  String message = '';
  bool loading = false;
  bool showDescription = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _startGame() {
    final word = controller.text.trim().toUpperCase();
    if (word.isEmpty) return;

    setState(() {
      myWord = word;
      gameStarted = true;
      correctLetters.clear();
      wrongLetters.clear();
      aiTries = 0;
      gameOver = false;
      message = '';
    });
    controller.clear();
    _getAiGuess();
  }

  Future<void> _getAiGuess() async {
    setState(() => loading = true);

    final guess = correctLetters.isEmpty && wrongLetters.isEmpty
        ? await service.getFirstGuess(myWord.length)
        : await service.getNextGuess(_getPattern(), correctLetters.join(','), wrongLetters.join(','));

    setState(() {
      currentGuess = guess;
      loading = false;
    });
  }

  void _processGuess(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        correctLetters.add(currentGuess);
      } else {
        wrongLetters.add(currentGuess);
        aiTries++;
      }

      if (myWord.split('').every((c) => correctLetters.contains(c))) {
        message = "AI Won! The word was: $myWord";
        gameOver = true;
      } else if (aiTries >= 6) {
        message = "You Won! The word was: $myWord";
        gameOver = true;
      }
    });

    if (!gameOver) _getAiGuess();
  }

  String _getPattern() {
    return myWord.split('').map((letter) => correctLetters.contains(letter) ? letter : '_').join(' ');
  }

  void _newGame() {
    setState(() {
      gameStarted = false;
      myWord = '';
      correctLetters.clear();
      wrongLetters.clear();
      aiTries = 0;
      gameOver = false;
      message = '';
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gameStarted == false) {
      return Scaffold(
        appBar: AppBar(
          title: Text("-Gueszy"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                  setState(() {
                    showDescription = !showDescription;
                  });
                }, icon: Icon(Icons.info_outline)),
                Visibility(
                  visible: showDescription,
                  child: Text('''Welcome to Reverse Gueszy.
In this game your task is to write a random single word.               
                ''',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      )
                  ),
                ),
                const Text("Think of a word, let AI guess it!", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(hintText: "Enter your word", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _startGame, child: const Text("Start Game", style: TextStyle(color: Colors.black),)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text("AI Guessing"), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("AI Lives: ${6 - aiTries}", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text(_getPattern(), style: const TextStyle(fontSize: 32, letterSpacing: 4)),
                const SizedBox(height: 30),

                if (loading) const Text("AI thinking...", style: TextStyle(fontSize: 16)),

                if (currentGuess.isNotEmpty && !gameOver && !loading) ...[
                  Text("AI guessed: $currentGuess", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () => _processGuess(true), child: const Text("Yes",style: TextStyle(color: Colors.black))),
                      ElevatedButton(onPressed: () => _processGuess(false), child: const Text("No",style: TextStyle(color: Colors.black))),
                    ],
                  ),
                ],

                const SizedBox(height: 20),
                if (message.isNotEmpty) Text(message, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                OutlinedButton(onPressed: _newGame, child: const Text("New Game",style: TextStyle(color: Colors.black))),
              ],
            ),
          ),
        ),
      );
    }
  }



