import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:painters_schedule/components/update_service_form.dart';

class ShowService extends StatefulWidget {
  Map<String, dynamic> service;
  String idService;

  ShowService(this.service, this.idService);
  @override
  _ShowServiceState createState() => _ShowServiceState();
}

class _ShowServiceState extends State<ShowService> {
  CollectionReference services =
      FirebaseFirestore.instance.collection('services');

  Future<void> deleteService(String id) {
    //função para deletar o serviço caso seja acionado o botão excluir
    return services.doc(id).delete().then((value) {
      Navigator.pop(context);
      return ScaffoldMessenger.of(context).showSnackBar(
          //caso sucesso
          SnackBar(content: Text('Serviço deletado com sucesso')));
    }).catchError((onError) {
      //caso dê erro
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $onError')));
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.idService);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do serviço'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  'Cliente: ${widget.service['name']}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              FittedBox(
                  child: Text(
                'E-mail: ${widget.service['email'] != null ? widget.service['email'] : ''}',
                style: TextStyle(fontSize: 20),
              )),
              FittedBox(
                child: Text(
                  'Endereço: ${widget.service['adress'] != null ? widget.service['adress'] : ''}, ${widget.service['adressNumber'] != null ? widget.service['adressNumber'] : ''} Complemento: ${widget.service['complement'] != null ? widget.service['complement'] : ''}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              FittedBox(
                child: Text(
                  'CEP: ${widget.service['zipCode'] != null ? widget.service['zipCode'] : ''} Cidade: ${widget.service['city'] != null ? widget.service['city'] : ''}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              FittedBox(
                  child: Text(
                'Telefone: ${widget.service['phone'] != null ? widget.service['phone'] : ''}',
                style: TextStyle(fontSize: 20),
              )),
              FittedBox(
                child: Text(
                  'Data: ${widget.service['date'] != null ? widget.service['date'] : ''} Serviço: ${widget.service['service'] != null ? widget.service['service'] : ''}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              FittedBox(
                  child: Text(
                'Observações: ${widget.service['observation'] != null ? widget.service['observation'] : ''}',
                style: TextStyle(fontSize: 20),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //exibe os dois botões presentes na tela, de exclusão e atualização
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      onPressed: () => deleteService(widget
                          .idService), //chama a função para deletar passando o ID
                      child: Text('Excluir'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return UpdateServiceForm(widget
                              .idService); //chama a tela de update do serviço passando o id
                        }),
                      );
                    },
                    child: Text('Alterar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
