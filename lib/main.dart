import 'package:flutter/material.dart';
import 'package:painters_schedule/components/register_service_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:painters_schedule/models/get_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  List _services = [];

  _showDatePicker() {
    //abre o calendário para selecionar a data
    showDatePicker(
      //função future/assincrono
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        //armazena a data selecionada em uma variavel
        _selectedDate = pickedDate;
        print('Selecionou');
      });
    });
    //será chamanda somente quando o usuário selecionar data
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(widget.title),
    );

    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

//constroi a tela do aplicativo
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          children: [
            Container(
              //calendario
              height: availableHeight * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Selecione a data'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          //exibe a data seleciona
                          '${DateFormat('dd/MM/y').format(_selectedDate)}',
                          style: TextStyle(
                            fontSize: 35,
                          ),
                        ),
                        //chama a função que mostra o calendário para selecionar a data
                        onPressed: _showDatePicker,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              //lista de serviços
              height: availableHeight * 0.7,
              child: GetServices(DateFormat('y-MM-dd').format(_selectedDate)),
              //chama o widget responsável por exibir os serviços conforme a data selecionada
              //passando a data selecionada no calendário
            ),
          ],
        ),
      ),
      //botão para cadastrar novo serviço
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              //botão que chama a tela para cadastrar um novo serviço
              return RegisterServiceForm();
            }),
          );
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
