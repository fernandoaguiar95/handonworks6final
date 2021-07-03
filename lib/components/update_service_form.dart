import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateServiceForm extends StatefulWidget {
  final String idService;

  UpdateServiceForm(this.idService);

  @override
  _UpdateServiceFormState createState() => _UpdateServiceFormState();
}

class _UpdateServiceFormState extends State<UpdateServiceForm> {
  CollectionReference serviceUpdate =
      FirebaseFirestore.instance.collection('services');

  DateTime? _selectedDate = null;
  String serviceValue = 'Pintura';
  Map<String, dynamic> currentService = {};
  bool verifyer = false;

  Future<void> updateService(
    //atualiza o serviço conforme os dados passados no formulário passando
    //as variáveis por parâmetro
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
    return serviceUpdate.doc(widget.idService).update({
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
      Navigator.pop(context);
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Serviço atualizado com sucesso')));
    }).catchError((onError) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $onError')));
    });
  }

  _showDatePicker() {
    showDatePicker(
      //função future/assincrono
      context: context,
      initialDate: _selectedDate!,
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

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        //seleciona o serviço no banco de dados conforme a id passada
        //e coloca os dados nos campos respectivos para edição/alteração
        .collection('services')
        .doc(widget.idService)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        if (!verifyer) {
          setState(() {
            //seta um estado da variavel responsável por preencher os campos
            currentService = documentSnapshot.data() as Map<String, dynamic>;
            verifyer = true;
          });
        }

        if (_selectedDate == null) {
          _selectedDate = DateTime.parse(currentService['date']);
        }
      } else {
        print('Serviço não existe no banco de dados');
      }
    });

    //controllers responsáveis por pegar o texto dos campos e também mostrar o texto que foi pego no banco
    final observationController =
        TextEditingController(text: currentService['observation']);
    final nameController = TextEditingController(text: currentService['name']);
    final emailController =
        TextEditingController(text: currentService['email']);
    final phoneController =
        TextEditingController(text: currentService['phone']);
    final zipCodeController =
        TextEditingController(text: currentService['zipCode']);
    final adressController =
        TextEditingController(text: currentService['adress']);
    final adressNumberController =
        TextEditingController(text: currentService['adressNumber']);
    final complementController =
        TextEditingController(text: currentService['complement']);
    final cityController = TextEditingController(text: currentService['city']);
    final stateController =
        TextEditingController(text: currentService['state']);

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    controller: nameController,
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
                          : DateFormat('dd/MM/y').format(_selectedDate!)),
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
                    value: currentService['service'] == null ||
                            currentService['service'].toString().isEmpty
                        ? serviceValue
                        : currentService['service'].toString(),
                    icon: const Icon(Icons.arrow_downward_sharp),
                    onChanged: (String? newValue) {
                      setState(() {
                        currentService['service'] = newValue!;
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
                            //chama a função para atualiza o serviço passando os dados dos campos
                            if (_formKey.currentState!.validate()) {
                              updateService(
                                currentService['service'].toString(),
                                DateFormat('y-MM-dd')
                                    .format(_selectedDate!)
                                    .toString(),
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
                            'Atualizar',
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
