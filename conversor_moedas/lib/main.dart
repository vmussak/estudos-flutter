import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const API_URL = "https://api.hgbrasil.com/finance?key=34b34cc8";

void main() async {

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        prefixStyle: TextStyle(color: Colors.amber)
      )
    )
  ));
}

Future<Map> buscarConversoes() async {
  http.Response response = await http.get(API_URL);
  return json.decode(response.body);
}

Widget message(String text) {
  return Center(
    child: Text(
      text,
      style: TextStyle(color: Colors.amber, fontSize: 25),
      textAlign: TextAlign.center,
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController realController = TextEditingController();
  TextEditingController dollarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  double dollar;
  double euro;

  Widget textField(String label, String prefix, TextEditingController controller, Function onChanged) {
    return TextField(
      controller: controller,
      onChanged: (String text){
        text.isEmpty ? _clearAll() : onChanged(text);
      },
      //TextInputType.numberWithOptions(decimal: true) pra funcionar do IOS
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
      ),
      style: TextStyle(
        color: Colors.amber,
        fontSize: 25
      ),
    );
  }

  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }

  _realChange(String text) {
    double real = double.parse(text);
    dollarController.text = (real / dollar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  _dollarChange(String text) {
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
  }

  _euroChange(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor de moedas"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
        future: buscarConversoes(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting)
            return message("Carregando...");

          if(snapshot.hasError)
            return message("Ocorreu um erro :(");

          dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
          euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
            
          return SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.monetization_on, color: Colors.amber, size: 150),
                textField("Reais", "R\$ ", realController, _realChange),
                Divider(),
                textField("Dólares", "U\$ ", dollarController, _dollarChange),
                Divider(),
                textField("Euros", "€ ", euroController, _euroChange),
              ],
            ),
          );
        },
      ),
    );
  }
}