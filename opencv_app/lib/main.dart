
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opencv_app/detection/detection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const OpenCVApp());
}

class OpenCVApp extends StatelessWidget {
  const OpenCVApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ColorChecker',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'Инструкция',
            textAlign: TextAlign.center,
            style: TextStyle(height: 5, fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
          ),
          const Text(
            '1. Расположите тест-полоску на шаблоне, как показано на рисунке:',
            style: TextStyle(height: 1.5, fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
          ),
          Image.asset("assets/drawable/line_sm.png"),
          const Text(
            '2. Расположите телефон над шаблоном с тест-полоской, как показано на рисунке: ',
            style: TextStyle(height: 1.5, fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
          ),
          Image.asset("assets/drawable/camera_sm.png", height: 250),
          const Text(
            '3. Фотографирование тест-полоски выполняется автоматически',
            style: TextStyle(height: 1.5, fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: MaterialButton(
                color: Colors.red,
                child: const Text('Начать тестирование'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return const DetectionPage();
                  }));
                },
              ),
            ),
          ),
        ]
      ) ,
    );
  }
}
