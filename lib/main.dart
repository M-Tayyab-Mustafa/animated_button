import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnimatedButton(),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({super.key});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _animation;
  late Animation<double> buttonWidthTween;
  late Animation<double> downloadingOrNotTween;
  late Animation<double> downloadingTween;
  bool animationCompleted = false;

  final double buttonInitialWidth = 100;
  final double buttonHeight = 50;
  final double buttonEndWidth = 45;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    buttonWidthTween = Tween<double>(begin: buttonInitialWidth, end: buttonEndWidth).animate(CurvedAnimation(parent: _animation, curve: const Interval(0.0, 0.1)));
    downloadingOrNotTween = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animation, curve: const Interval(0.0, 0.1)));
    downloadingTween = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animation, curve: const Interval(0.1, 1)));
    _animation.addStatusListener(_statusChecking);
    _animation.addListener(_update);
  }

  _statusChecking(status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        animationCompleted = true;
      });
    }
  }

  _update() {
    setState(() {
      //ToDo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
                  height: buttonHeight,
                  child: GestureDetector(
                    onTap: () {
                      _animation.forward();
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: buttonHeight,
                            width: buttonHeight,
                            child: CircularProgressIndicator(
                              value: downloadingTween.value,
                              color: Colors.blue,
                              strokeWidth: 5,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: buttonHeight * 0.9,
                            width: buttonWidthTween.value,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(buttonHeight),
                              boxShadow: const [
                                BoxShadow(blurRadius: 3),
                              ],
                            ),
                            child: Center(
                              child: downloadingOrNotTween.value == 0
                                  ? Text(
                                      'Download',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                    )
                                  : animationCompleted
                                      ? const Icon(Icons.done)
                                      : const Icon(Icons.download),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Gap(10),
            if (animationCompleted)
              GestureDetector(
                onTap: () {
                  setState(() {
                    animationCompleted = false;
                    _animation.reset();
                  });
                },
                child: Container(
                  height: buttonHeight * 0.9,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(buttonHeight),
                    boxShadow: const [
                      BoxShadow(blurRadius: 3),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    'Reset',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  )),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}
