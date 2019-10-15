import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _todoList = [];
   Map<String, dynamic> _todoRemoved;
   int _todoRemovedPosition;

  TextEditingController tarefaController = TextEditingController();

  void _adicionarTarefa(){
    Map<String, dynamic> _todo = Map();
    _todo["titulo"] = tarefaController.text;
    _todo["ok"] = false;
    tarefaController.text = "";
    setState(() {
      _todoList.add(_todo); 
    });
    _salvarDados();
  }

  Future<File> _buscarArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/data.json");
  }

  Future<File> _salvarDados() async {
    String data = json.encode(_todoList);
    final file = await _buscarArquivo();
    return file.writeAsString(data);
  }

  Future<String> _buscarDados() async {
    try {
      final file = await _buscarArquivo();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if(a["ok"] && !b["ok"]) return 1;
        else if (!a["ok"] && b["ok"]) return -1;
        else return 0;
      }); 
      _salvarDados();
    });
  }

  @override
  void initState() {
    super.initState();

    _buscarDados().then((dados){
      setState(() {
       _todoList = json.decode(dados); 
      });
    });
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]["titulo"]),
        value: _todoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_todoList[index]["ok"] ? Icons.check : Icons.error),
        ), 
        onChanged: (bool value) {
          setState(() {
            _todoList[index]["ok"] = value;
          });
          _salvarDados();
        },
      ),
      onDismissed: (direction){
        setState(() {
          _todoRemoved = Map.from(_todoList[index]);
          _todoRemovedPosition = index;
          _todoList.removeAt(index);
          _salvarDados();

          final snack = SnackBar(
            content: Text("Tarefa \"${_todoRemoved["titulo"]}\" removida."),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: (){
                setState(() {
                  _todoList.insert(_todoRemovedPosition, _todoRemoved);
                  _salvarDados();
                });
              },
            ),
            duration: Duration(seconds: 3),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);

        });
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: tarefaController,
                    decoration: InputDecoration(
                      labelText: "Nova tarefa",
                      labelStyle: TextStyle(
                        color: Colors.blueAccent
                      )
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("+"),
                  textColor: Colors.white,
                  onPressed: _adicionarTarefa,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _todoList.length,
                itemBuilder: buildItem,
              ),
              onRefresh: _refresh,
            ),
          ),
        ],
      ),
    );
  }
}

