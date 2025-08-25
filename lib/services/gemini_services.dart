// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class GeminiService1 {
//   final String apiKey = 'AIzaSyAaU7eoTJs2JRnW-hmMFWJXTwmxUV26iAE';
//   final String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
//
//   Future<String> fetchWord() async {
//     final uri = Uri.parse(
//       '$apiUrl?key=$apiKey',
//     );
//
//     final response = await http.post(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         "contents": [
//           {
//             "parts": [
//               {
//                 "text": "Give me a random English word between 5 and 7 letters. Just reply with one word only."
//               }
//             ]
//           }
//         ]
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final content = data['candidates'][0]['content']['parts'][0]['text'];
//       return content.trim().toUpperCase();
//     } else {
//       print("❌ Gemini API Error: ${response.body}");
//       return "ERROR";
//     }
//   }
// }












// import 'package:flutter_gemini/flutter_gemini.dart';
//
// class G2Services {
//   final Gemini gemini = Gemini.init(apiKey:'AIzaSyDtLEIyn9l-phVtdG-AZToWUmRFL7dLCqo');
//
//   String _getFirstLetter(String? response) {
//     if (response == null || response.isEmpty) return '';
//
//     String text = response.toUpperCase();
//
//     for (int i = 0; i < text.length; i++) {
//       String char = text[i];
//
//       if (char.compareTo('A') >= 0 && char.compareTo('Z') <= 0) {
//         return char;
//       }
//     }
//
//     return '';
//   }
//
//   Future<String> getFirstGuess(int wordLength) async {
//     try {
//       final response = await gemini.prompt(
//           parts: [Part.text('''
// You are playing Hangman.
// The word has $wordLength letters.
// Suggest ONE single letter (A-Z) that is most likely in the word.
// Only return the letter, nothing else.
// ''')]
//       );
//
//       final guess = _getFirstLetter(response?.output);
//
//       if (guess.isNotEmpty) {
//         return guess;
//       } else {
//         return 'E';
//       }
//     } catch (e) {
//       return 'E';
//     }
//   }
//
//   Future<String> getNextGuess(String pattern, String correctLetters, String wrongLetters) async {
//     try {
//       String alreadyGuessed = '$correctLetters,$wrongLetters';
//       final response = await gemini.prompt(
//           parts: [Part.text(
//               '''
// We are playing Hangman.
// The current word pattern is: $pattern
// Correct letters so far: $correctLetters
// Wrong letters so far: $wrongLetters
// Already guessed letters so far: $alreadyGuessed
//
// Suggest ONE new letter (A-Z) that has not been guessed yet.
// Return ONLY the letter, nothing else.
// '''
//           )]
//       );
//
//       final guess = _getFirstLetter(response?.output);
//
//       if (guess.isNotEmpty) {
//         return guess;
//       } else {
//         return 'A'; // Common letter fallback
//       }
//     } catch (e) {
//       return 'A';
//     }
//   }
// }
