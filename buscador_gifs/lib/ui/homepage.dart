import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offset = 0;
  
  String _buildUrl() {
    final _base = "https://api.giphy.com/v1/gifs";
    final _key = "api_key=PtxQlSanoTZJSdv2DVQXgB7BOdmyelxY";
    final _endpoint = _search == null ? "trending" : "search";
    final _urn = _search != null ? "q=$_search&offset=$_offset&lang=pt" : "";
    return "$_base/$_endpoint?$_urn&limit=20&rating=G&$_key";
  }

  Future<Map> _getGifs() async {
    http.Response response;
    response = await http.get(_buildUrl());
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscador de GIF's"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui :)",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting)
                  return Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5,
                    ),
                  );

                if(snapshot.hasError)
                  return Container();

                return _createGifs(context, snapshot);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createGifs(context, snapshot) {
    return Container();
  }
}