part of 'index.dart';

class Spacing extends StatelessWidget {
  final double rem;
  final Color? color;

  const Spacing({required this.rem, super.key, this.color});
  const Spacing.$1({super.key, this.color}) : rem = 0.125;
  const Spacing.$2({super.key, this.color}) : rem = 0.25;
  const Spacing.$3({super.key, this.color}) : rem = 0.5;
  const Spacing.$4({super.key, this.color}) : rem = 0.75;
  const Spacing.$5({super.key, this.color}) : rem = 1;
  const Spacing.$6({super.key, this.color}) : rem = 1.5;
  const Spacing.$7({super.key, this.color}) : rem = 2;
  const Spacing.$8({super.key, this.color}) : rem = 2.5;
  const Spacing.$9({super.key, this.color}) : rem = 3;
  const Spacing.$10({super.key, this.color}) : rem = 4;
  const Spacing.$11({super.key, this.color}) : rem = 5;
  const Spacing.$12({super.key, this.color}) : rem = 6;
  const Spacing.$13({super.key, this.color}) : rem = 10;

  double get px => rem * 16;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: px,
        child: ColoredBox(color: color ?? Colors.transparent),
      );
}
