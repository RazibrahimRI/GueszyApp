import 'package:flutter/material.dart';
import '../services/g1_services.dart';


class Gueszy extends StatefulWidget {
  const Gueszy({super.key});

  @override
  State<Gueszy> createState() => _GueszyState();
}

class _GueszyState extends State<Gueszy> {
  final geminiAI = GeminiService();
  final TextEditingController controller = TextEditingController();

  String Word = '';
  final Set<String> guessedLetters = {};
  int tries = 0;
  final int maxTries = 6;
  bool loading = true;
  String message = '';
  bool gameOver = false;
  bool showDescription = false;

  @override
  void initState() {
    super.initState();
    getNewWord();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> getNewWord() async {
    setState(() {
      loading = true;
      guessedLetters.clear();
      tries = 0;
      message = '';
      gameOver = false;
    });

    final word = await geminiAI.fetchWord();
    setState(() {
      Word = word.toUpperCase();
      loading = false;
    });
  }

  void _handleGuess(String input) {
    final guess = input.toUpperCase();

    if (gameOver || guess.isEmpty) return;

    setState(() {
      if (guess.length == 1) {
        // Single letter guess
        if (!guessedLetters.contains(guess)) {
          guessedLetters.add(guess);
          if (!Word.contains(guess)) {
            tries++;
          }
        }
      } else {
        // Full word guess
        if (guess == Word) {
          guessedLetters.addAll(Word.split(''));
        } else {
          tries++;
        }
      }

      if (Word.split('').every((c) => guessedLetters.contains(c))) {
        message = " You won!";
        gameOver = true;
      } else if (tries >= maxTries) {
        message = " You lost! The word was: $Word";
        gameOver = true;
      }

      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: Text("Getting your word ready...", style: TextStyle(fontSize: 18))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gueszy"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
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
                child: Text('''
Welcome To Gueszy.
A random word will generated and your task is to guess the letter and figure out the word.
Good Luck.
              ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text("Lives left: ${maxTries - tries}", style: const TextStyle(fontSize: 18)),

              const SizedBox(height: 24),

              // Display hidden word with underscores
              Wrap(
                spacing: 10,
                children: Word.split('').map((letter) {
                  return Text(
                    guessedLetters.contains(letter) ? letter : '_',
                    style: const TextStyle(fontSize: 36, letterSpacing: 2),
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),

              if (!gameOver) ...[
                const Text(
                  "Guess a letter or the full word",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Enter guess",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _handleGuess(controller.text),
                  child: const Text("Submit",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              if (message.isNotEmpty)
                Text(message, style: const TextStyle(fontSize: 20)),

              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: getNewWord,
                child: const Text("Play Again",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
