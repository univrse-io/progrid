import 'package:intl/intl.dart';

enum DrawingStatus {
  incomplete,
  completed,
  submitted;

  @override
  String toString() => toBeginningOfSentenceCase(name);
}
