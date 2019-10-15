import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController pesoController = new TextEditingController();
  TextEditingController alturaController = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _infoText = "Informe seus dados!";

  void _resetFields() {
    pesoController.text = "";
    alturaController.text = "";
    setState(() {
     _infoText = "Informe seus dados!";
     _formKey = GlobalKey<FormState>();
    });
  }

  void _calcularImc() {
    double peso = double.parse(pesoController.text);
    double altura = double.parse(alturaController.text) / 100;
    double imc = peso / (altura * altura);
    String imcText = imc.toStringAsPrecision(3);
    setState(() {
      if(imc < 18.5) {
        _infoText = "Na capa da gaita, no pó da rabiola, no resto do kisuco, na tripa da linguiça ($imcText)";
      }
      else if (imc < 25) {
        _infoText = "Não fez mais que a obrigação ($imcText)";
      }
      else if (imc < 30) {
        _infoText = "Tem pochete ($imcText)";
      }
      else if (imc < 40) {
        _infoText = "Só joga e come ($imcText)";
      }
      else
        _infoText = "Meu amigo!!! ($imcText)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person_outline, size: 120, color: Colors.green),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso (kg)",
                  labelStyle: TextStyle(color: Colors.green)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
                controller: pesoController,
                validator: (value) {
                  if(value.isEmpty) 
                    return "Insira seu peso.";
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Altura (cm)",
                  labelStyle: TextStyle(color: Colors.green)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
                controller: alturaController,
                validator: (value) {
                  if(value.isEmpty) 
                    return "Insira sua altura.";
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      if(_formKey.currentState.validate())
                        _calcularImc();
                    },
                    child: Text("Calcular", style: TextStyle(color: Colors.white, fontSize: 25),),
                    color: Colors.green,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
              )
            ],
          ),
        ), 
      ),
    );
  }
}
