import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:painters_schedule/components/show_service.dart';

class GetServices extends StatefulWidget {
  final String selectedDate;

  GetServices(this.selectedDate);

  @override
  _GetServicesState createState() => _GetServicesState();
}

class _GetServicesState extends State<GetServices> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _servicesStream = FirebaseFirestore.instance
        .collection('services')
        .where('date', isEqualTo: widget.selectedDate)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _servicesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Algo errado aconteceu');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Carregando...');
        }

        return new ListView(
            children: snapshot.data!.docs.map(
          (DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Card(
              child: TextButton(
                child: ListTile(
                  title: Text(data['service']),
                  subtitle: Text('Cliente: ${data['name']}'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ShowService(data, document.id.toString());
                    }),
                  );
                },
              ),
            );
          },
        ).toList());
      },
    );
  }
}
