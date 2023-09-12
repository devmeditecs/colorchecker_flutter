import 'package:flutter/material.dart';
import 'package:opencv_app/main.dart';

class ResultsPage extends StatelessWidget {
  final List<double> _arucos;
  const ResultsPage(this._arucos, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            const Text(
              'Результаты тестирования',
              textAlign: TextAlign.center,
              style: TextStyle(height: 5, fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
            ),
            Expanded(
              child:ListView.separated(
                // padding: const EdgeInsets.all(8),
                itemCount: _arucos.length ~/ 3,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 200,
                      color: Colors.white10,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              width: 45,
                              color: Color.fromRGBO(_arucos[index * 3].round(), _arucos[index * 3 + 1].round(), _arucos[index * 3 + 2].round(), 1.0),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'Индикатор №${index+1}',
                                  style: TextStyle(height: 1.5, fontSize: 17, color: Colors.black, decoration: TextDecoration.none),
                                ),
                                Text(
                                  'Класс: ${index}',
                                  style: TextStyle(height: 1.5, fontSize: 10, color: Colors.black, decoration: TextDecoration.none),
                                ),
                                Text(
                                  'Код цвета: ${_arucos[index * 3].round()}, ${_arucos[index * 3 + 1].round()}, ${_arucos[index * 3 + 2].round()}',
                                  style: TextStyle(height: 1.5, fontSize: 10, color: Colors.black, decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                          ]
                      )
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              )
            ),
            MaterialButton(
              color: Colors.red,
              child: const Text('Начать тестирование'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HomePage()));
              },
            )
          ],
        )
    );
  }
}
