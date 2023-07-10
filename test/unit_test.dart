import 'package:flutter_test/flutter_test.dart';

String capitalizeFirstLetters(String input) {
  List<String> words = input.split(' ');

  for (int i = 0; i < words.length; i++) {
    String word = words[i];

    if (word.isNotEmpty) {
      String capitalizedWord =
          word[0].toUpperCase() + word.substring(1).toLowerCase();
      words[i] = capitalizedWord;
    }
  }

  return words.join(' ');
}

void main() {
  test('Checking Capitalization', () {
    String str="german shepard";
    String expectedStr = "German Shepard";

    String resultStr = capitalizeFirstLetters(str);

    expect(resultStr, equals(expectedStr));
  });
}
