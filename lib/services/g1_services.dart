import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  final Gemini gemini = Gemini.init(apiKey: 'AIzaSyAaU7eoTJs2JRnW-hmMFWJXTwmxUV26iAE');

  Future<String> fetchWord() async {
    try {
      final response = await gemini.prompt(parts: [Part.text('Give me a random English word between 5 and 7 letters. Just the word only.')]
      );

      final word = response?.output?.trim().toUpperCase();

      if (word != null && word.isNotEmpty) {
        return word;
      } else {
        return "ERROR";
      }
    } catch (e) {
      return "ERROR";
    }
  }
}
