import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// PÁGINA 3 - Lista de pedidos em tempo real (aula 09: snapshots + StreamBuilder).
class PedidosPage extends StatelessWidget {
  final String clienteAtual; // parâmetro recebido do formulário

  const PedidosPage({super.key, required this.clienteAtual});

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('pedidos')
        .orderBy('criadoEm', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos em tempo real',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Voltar ao cardápio',
            icon: const Icon(Icons.home),
            onPressed: () =>
                Navigator.of(context).popUntil((rota) => rota.isFirst),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.orange.shade100,
            padding: const EdgeInsets.all(12),
            child: Text(
              'Pedido de $clienteAtual registrado com sucesso!',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('Nenhum pedido ainda.'));
                }
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final p = docs[i].data() as Map<String, dynamic>;
                    final extras = [
                      if (p['queijoExtra'] == true) 'queijo',
                      if (p['baconExtra'] == true) 'bacon',
                    ].join(', ');
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.deepOrange,
                          child: Icon(Icons.receipt_long, color: Colors.white),
                        ),
                        title: Text('${p['produto']} (${p['tamanho']})'),
                        subtitle: Text(
                          'Cliente: ${p['cliente']}\n'
                          '${p['rua']}, ${p['numero']} - ${p['bairro']}, ${p['cidade']}'
                          '${extras.isEmpty ? '' : '\nExtras: $extras'}',
                        ),
                        isThreeLine: true,
                        trailing: Text(
                          'R\$ ${(p['total'] as num).toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
