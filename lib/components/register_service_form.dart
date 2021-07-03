import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterServiceForm extends StatefulWidget {
  RegisterServiceForm({Key? key}) : super(key: key);

  @override
  _RegisterServiceFormState createState() => _RegisterServiceFormState();
}

class _RegisterServiceFormState extends State<RegisterServiceForm> {
  DateTime _selectedDate = DateTime.now();
  String serviceValue = 'Pintura';
  String customerValue = '';

  final serviceController = TextEditingController();
  final observationController = TextEditingController();
  final dateController = TextEditingController();
  final customerController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final zipCodeController = TextEditingController();
  final adressController = TextEditingController();
  final adressNumberController = TextEditingController();
  final complementController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  CollectionReference services =
      FirebaseFirestore.instance.collection('services');

  Future<void> addService(
    //função que adiciona um novo serviço
    String service,
    String date,
    String observation,
    String name,
    String email,
    String phone,
    String zipCode,
    String adress,
    String adressNumber,
    String complement,
    String city,
    String state,
  ) {
    return services.add({
      'service': service,
      'date': date,
      'observation': observation,
      'name': name,
      'email': email,
      'phone': phone,
      'zipCode': zipCode,
      'adress': adress,
      'adressNumber': adressNumber,
      'complement': complement,
      'city': city,
      'state': state,
    }).then((value) {
      Navigator.pop(context);
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Serviço cadastrado com sucesso')));
    }).catchError((onError) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $onError')));
    });
  }

  _showDatePicker() {
    showDatePicker(
      //função future/assincrono
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
    //será chamanda somente quando o usuário selecionar data
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de cliente'),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          //form deve conter os campos: cliente, data do serviço, tipo de serviço, observações
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                    },
                    controller: customerController,
                    decoration: InputDecoration(
                      hintText: 'Cliente',
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                            },
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: 'Telefone',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(
                            controller: zipCodeController,
                            decoration: InputDecoration(
                              hintText: 'CEP',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  TextField(
                    controller: adressController,
                    decoration: InputDecoration(
                      hintText: 'Endereço',
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TextField(
                            controller: adressNumberController,
                            decoration: InputDecoration(
                              hintText: 'Nº',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(
                            controller: complementController,
                            decoration: InputDecoration(
                              hintText: 'Complemento',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TextField(
                            controller: cityController,
                            decoration: InputDecoration(
                              hintText: 'Cidade',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(
                            controller: stateController,
                            decoration: InputDecoration(
                              hintText: 'UF',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(_selectedDate == null
                          ? 'Nenhuma data selecionada'
                          : 'Data: ${DateFormat('dd/MM/y').format(_selectedDate)}'),
                      TextButton(
                        onPressed: _showDatePicker,
                        child: Text(
                          'Selecionar data',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Serviço:'),
                  DropdownButtonFormField(
                    value: serviceValue,
                    icon: const Icon(Icons.arrow_downward_sharp),
                    onChanged: (String? newValue) {
                      setState(() {
                        serviceValue = newValue!;
                      });
                    },
                    items: <String>['Pintura', 'Lixar', 'Pintura e lixar']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: observationController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Observações',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //chama a função para adicionar um novo serviço passando os dados por parâmetro
                            if (_formKey.currentState!.validate()) {
                              addService(
                                serviceValue,
                                DateFormat('y-MM-dd').format(_selectedDate),
                                observationController.text,
                                nameController.text,
                                emailController.text,
                                phoneController.text,
                                zipCodeController.text,
                                adressController.text,
                                adressNumberController.text,
                                complementController.text,
                                cityController.text,
                                stateController.text,
                              );
                            }
                          },
                          child: Text(
                            'Cadastrar',
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
