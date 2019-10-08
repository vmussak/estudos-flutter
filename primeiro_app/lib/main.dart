import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
      title: "Aplicativo e pá",
      home: Home()
    )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _pessoas = 0;
  String _texto = "Pode entrar! :D";

  void _alterarQuantidadePessoas(int quantidade) {
    setState(() {
      _pessoas += quantidade;

      if(_pessoas > 10)
        _texto = "LOTADAÇO";
      else if (_pessoas < 0)
        _texto = "WTF?";
      else
        _texto = "Pode entrar! :D";

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
        Image.asset(
          "images/fundo.png",
          fit: BoxFit.cover,
          height: 1080,
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Pessoas: $_pessoas",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  child: Text(
                    "+1",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  onPressed: () {
                    _alterarQuantidadePessoas(1);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  child: Text(
                    "-1",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  onPressed: () {
                    _alterarQuantidadePessoas(-1);
                  },
                ),
              )
            ]),
            Text(_texto,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontStyle: FontStyle.italic))
          ],
        )
      ]);
  }
}