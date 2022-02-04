import 'package:flutter/material.dart';
import 'package:security_storage/security_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _value = 'Unknown';
  final _formKey = GlobalKey<FormState>();
  final keyController = TextEditingController();
  final valueController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final securityStorages = Map<String, SecurityStorage>();
  var promptInfo;

  @override
  void initState() {
    super.initState();
    promptInfo = AndroidPromptInfo(
        title: "Ingresa tu huella digital para desbloquear",
        description: "pacífico seguros",
        negativeButton: "Cancelar",
        subtitle: "loguin biometrico");
  }

  _displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin Security Storage app'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        controller: keyController,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Nombre de llave';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: valueController,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Valor de llave';
                          }
                          return null;
                        },
                      )
                    ])),
                ElevatedButton(
                  onPressed: () async {
                    var result = await SecurityStorage.canAuthenticate();
                    _displaySnackBar(context, result.toString());
                  },
                  child: Text('canAuthenticate'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (keyController.value.text.isNotEmpty) {
                      var name = keyController.value.text;
                      var storage = await SecurityStorage.init(name,
                          androidPromptInfo: promptInfo,
                          options: StorageInitOptions());
                      if (storage == null) {
                        print('No se pudo inicializar el storage');
                      } else {
                        securityStorages[name] = storage;
                        _displaySnackBar(context, 'init storage');
                      }
                    }
                  },
                  child: Text('inicializar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() == true) {
                      var name = keyController.value.text;
                      try {
                        if (securityStorages[name] == null) {
                          throw new Exception('No hay un almacenamiento');
                        }
                        await (securityStorages[name]
                            ?.write(valueController.value.text));
                        _displaySnackBar(context, 'Guardando data');
                      } catch (error) {
                        _displaySnackBar(context, error.toString());
                      }
                    }
                  },
                  child: Text('guardar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (keyController.value.text.isNotEmpty) {
                      var name = keyController.value.text;
                      try {
                        if (securityStorages[name] == null) {
                          throw new Exception('No hay un almacenamiento');
                        }
                        var value = await securityStorages[name]?.read();
                        _displaySnackBar(context, "El valor es: $value");
                      } catch (e) {
                        _displaySnackBar(context, e.toString());
                      }
                    }
                  },
                  child: Text('Leer'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (keyController.value.text.isNotEmpty) {
                      var name = keyController.value.text;
                      try {
                        if (securityStorages[name] == null) {
                          throw new Exception('No hay un almacenamiento');
                        }
                        await securityStorages[name]?.delete();
                        _displaySnackBar(
                            context, "El valor es: $name fue eliminado");
                      } catch (e) {
                        _displaySnackBar(context, e.toString());
                      }
                    }
                  },
                  child: Text('Eliminar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
