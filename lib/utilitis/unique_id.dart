import 'dart:math';

String generateUniqueId() {
  final random = Random();
  int number = random.nextInt(90000000) +
      10000000; // Random number between 10000000 and 99999999

  return number.toString();
}
