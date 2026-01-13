import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with TickerProviderStateMixin {
  String output = "0";
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void buttonPressed(String buttonText) {
    HapticFeedback.lightImpact(); // iOS-like haptic feedback
    _scaleController.forward().then((_) => _scaleController.reverse());

    setState(() {
      if (buttonText == "AC") {
        _output = "0";
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
      } else if (["+", "-", "×", "÷"].contains(buttonText)) {
        num1 = double.parse(_output);
        operand = buttonText;
        _output = "0";
      } else if (buttonText == ".") {
        if (!_output.contains(".")) _output += buttonText;
      } else if (buttonText == "=") {
        num2 = double.parse(_output);
        if (operand == "+") _output = (num1 + num2).toString();
        else if (operand == "-") _output = (num1 - num2).toString();
        else if (operand == "×") _output = (num1 * num2).toString();
        else if (operand == "÷") {
          _output = num2 == 0 ? "Error" : (num1 / num2).toString();
        }
        num1 = num2 = 0.0;
        operand = "";
      } else {
        _output = _output == "0" ? buttonText : _output + buttonText;
      }

      output = _output == "Error"
          ? "Error"
          : _output.endsWith('.00')
          ? _output.replaceAll('.00', '')
          : double.tryParse(_output)?.toStringAsFixed(8) ?? _output;
    });
  }

  Color getButtonColor(String buttonText) {
    switch (buttonText) {
      case "=":
        return const Color(0xFFAFB42B); // Yellow (iOS equals)
      case "÷":
      case "×":
      case "-":
      case "+":
        return const Color(0xFFFF9F0A); // Orange (iOS operators)
      case "AC":
        return const Color(0xFFA6A6A6); // Light gray (iOS AC)
      case ".":
        return const Color(0xFF343434); // Dark gray (iOS dot)
      default:
        return const Color(0xFF343434); // Dark gray (iOS numbers)
    }
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => buttonPressed(buttonText),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(6),
                height: 74,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: getButtonColor(buttonText),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: getButtonColor(buttonText).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: buttonText == "0" ? 32 : 28,
                    color: buttonText == "AC" ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display Section
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(right: 24, bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      operand.isNotEmpty ? _output : "",
                      style: const TextStyle(
                        fontSize: 28,
                        color: Color(0xFF8E8E93),
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      output,
                      style: const TextStyle(
                        fontSize: 92,
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Button Grid
            Column(
              children: [
                Row(children: [buildButton("AC"), buildButton("÷")]),
                Row(children: [buildButton("7"), buildButton("8"), buildButton("9"), buildButton("×")]),
                Row(children: [buildButton("4"), buildButton("5"), buildButton("6"), buildButton("-")]),
                Row(children: [buildButton("1"), buildButton("2"), buildButton("3"), buildButton("+")]),
                Row(
                  children: [
                    Expanded(flex: 2, child: buildButton("0")),
                    buildButton("."),
                    buildButton("="),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
