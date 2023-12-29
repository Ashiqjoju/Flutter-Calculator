import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        primaryColor: Colors.grey[900],
        hintColor: Colors.redAccent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.redAccent, fontSize: 36.0, fontWeight: FontWeight.normal),
        ),
      ),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  double _result = 0.0;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        try {
          Parser p = Parser();
          ContextModel cm = ContextModel();
          String sanitizedInput = _input.replaceAll('x', '*').replaceAll('%', '/100');
          Expression exp = p.parse(sanitizedInput);
          _result = exp.evaluate(EvaluationType.REAL, cm);
          _input = _result.toString();
        } catch (e) {
          _result = 0;
          _input = 'Error';
        }
      } else if (buttonText == 'C') {
        _input = '';
        _result = 0;
      } else {
        _input += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[900],
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Handle click action here
                print("Text Clicked!");
              },
              splashColor: Colors.white.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                child: Text(
                  'Calculator',
                  style: GoogleFonts.sacramento(
                    textStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(bottom: 45.0, right: 25.0),
                child: Text(
                  _input,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(1, 1),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2, 2),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: Offset(3, 3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),


            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CalculatorButton('C', _onButtonPressed),
                CalculatorButton('*', _onButtonPressed),
                CalculatorButton('%', _onButtonPressed),
                CalculatorButton(
                  '/',
                  _onButtonPressed,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CalculatorButton('7', _onButtonPressed),
                CalculatorButton('8', _onButtonPressed),
                CalculatorButton('9', _onButtonPressed),
                CalculatorButton(
                  '*',
                  _onButtonPressed,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CalculatorButton('4', _onButtonPressed),
                CalculatorButton('5', _onButtonPressed),
                CalculatorButton('6', _onButtonPressed),
                CalculatorButton(
                  '-',
                  _onButtonPressed,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CalculatorButton('1', _onButtonPressed),
                CalculatorButton('2', _onButtonPressed),
                CalculatorButton('3', _onButtonPressed),
                CalculatorButton(
                  '+',
                  _onButtonPressed,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CalculatorButton(
                  '^',
                  _onButtonPressed,
                ),
                CalculatorButton('0', _onButtonPressed),
                CalculatorButton('.', _onButtonPressed),
                CalculatorButton(
                  '=',
                  _onButtonPressed,
                  color: Colors.redAccent,
                  textColor: Colors.white, // Set the text color to white
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorButton extends StatefulWidget {
  final String buttonText;
  final Function(String) onButtonPressed;
  final Color? color;
  final Color? textColor;

  CalculatorButton(this.buttonText, this.onButtonPressed, {this.color, this.textColor});

  @override
  _CalculatorButtonState createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onButtonPressed(widget.buttonText);
        },
        onTapDown: (_) {
          _animationController.forward();
        },
        onTapCancel: () {
          _animationController.reverse();
        },
        onTapUp: (_) {
          _animationController.reverse();
        },
        splashColor: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30.0),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: widget.color ?? Colors.grey[900],
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.buttonText,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: widget.textColor ?? Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
