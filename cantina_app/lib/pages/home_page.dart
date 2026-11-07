import 'package:flutter/material.dart';

import '../models/produto.dart';
import 'pedido_page.dart';

/// PÁGINA 1 - Tela inicial: banner (Stack/Positioned), cardápio (Column/Row)
/// e SingleChildScrollView. (aulas 01 a 05)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cantina da Faculdade',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack + Positioned: banner com texto sobre a imagem
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.orange.shade200,
                    child: const Icon(Icons.restaurant, size: 60),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    color: Colors.black54,
                    child: const Text(
                      'Peça sem sair da sala de aula!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.menu_book, color: Colors.deepOrange),
                  SizedBox(width: 8),
                  Text(
                    'Cardápio do dia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
            for (final produto in cardapio) _CartaoProduto(produto: produto),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CartaoProduto extends StatelessWidget {
  final Produto produto;
  const _CartaoProduto({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                produto.imagem,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(Icons.fastfood, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(produto.descricao,
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${produto.preco.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navegação com passagem de parâmetro (aula 05)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PedidoPage(produto: produto),
                            ),
                          );
                        },
                        child: const Text('Pedir'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
