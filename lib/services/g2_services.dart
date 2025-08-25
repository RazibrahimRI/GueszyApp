import 'package:flutter_gemini/flutter_gemini.dart';

class G2Services {
  final Gemini gemini = Gemini.init(apiKey:'AIzaSyDtLEIyn9l-phVtdG-AZToWUmRFL7dLCqo');
  
  static bool _isApiInUse = false;

  String _getFirstLetter(String? response) {
    if (response == null || response.isEmpty) return '';

    String text = response.toUpperCase();

    for (int i = 0; i < text.length; i++) {
      String char = text[i];

      if (char.compareTo('A') >= 0 && char.compareTo('Z') <= 0) {
        return char;
      }
    }

    return '';
  }

  Future<void> _waitForApi() async {
    while (_isApiInUse) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    _isApiInUse = true;
    await Future.delayed(Duration(seconds: 5));
  }

  void _releaseApi() {
    _isApiInUse = false;
  }

  Future<String> getFirstGuess(int wordLength) async {
    await _waitForApi();

    try {
      final response = await gemini.prompt(
          parts: [Part.text('''
You are playing Hangman.
The word has $wordLength letters.
Suggest ONE single letter (A-Z) that is most likely in the word.
Only return the letter, nothing else.
''')]
      );

      final guess = _getFirstLetter(response?.output);

      if (guess.isNotEmpty) {
        return guess;
      } else {
        return 'E';
      }
    } catch (e) {
      print('Error in getFirstGuess: $e');
      return 'E';
    } finally {
      _releaseApi(); // Always release the lock
    }
  }

  Future<String> getNextGuess(String pattern, String correctLetters, String wrongLetters) async {
    await _waitForApi();

    try {
      String alreadyGuessed = '$correctLetters,$wrongLetters';
      final response = await gemini.prompt(
          parts: [Part.text(
              '''
We are playing Hangman.
The current word pattern is: $pattern
Correct letters so far: $correctLetters
Wrong letters so far: $wrongLetters
Already guessed letters so far: $alreadyGuessed

Suggest ONE new letter (A-Z) that has not been guessed yet.
Return ONLY the letter, nothing else.
'''
          )]
      );

      final guess = _getFirstLetter(response?.output);

      if (guess.isNotEmpty) {
        return guess;
      } else {
        return 'A';
      }
    } catch (e) {
      print('Error in getNextGuess: $e');
      return 'A';
    } finally {
      _releaseApi();
    }
  }
}

