import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../services/viacep_service.dart';
import 'pedidos_page.dart';

enum Tamanho { pequeno, medio, grande }

/// PÁGINA 2 - Formulário do pedido (aulas 06, 07, 08, 09 + recurso extra).
class PedidoPage extends StatefulWidget {
  final Produto produto; // parâmetro recebido da Home

  const PedidoPage({super.key, required this.produto});

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final _nomeController = TextEditingController();
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _numeroController = TextEditingController();

  bool _queijoExtra = false;
  bool _baconExtra = false;
  Tamanho _tamanho = Tamanho.medio;

  bool _buscandoCep = false;
  bool _salvando = false;
  String _mensagemCep = '';

  // Preço muda conforme as escolhas -> setState (aula 06)
  double get _total {
    double base = widget.produto.preco;
    switch (_tamanho) {
      case Tamanho.pequeno:
        base *= 0.8;
        break;
      case Tamanho.medio:
        break;
      case Tamanho.grande:
        base *= 1.3;
        break;
    }
    if (_queijoExtra) base += 3;
    if (_baconExtra) base += 4;
    return base;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  // RECURSO EXTRA: ao completar 8 dígitos consulta o ViaCEP
  Future<void> _aoMudarCep(String valor) async {
    final digitos = valor.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.length != 8) {
      setState(() => _mensagemCep = '');
      return;
    }
    setState(() {
      _buscandoCep = true;
      _mensagemCep = '';
    });
    final endereco = await ViaCepService().buscar(digitos);
    if (!mounted) return;
    setState(() {
      _buscandoCep = false;
      if (endereco == null) {
        _mensagemCep = 'CEP não encontrado';
      } else {
        _ruaController.text = endereco.rua;
        _bairroController.text = endereco.bairro;
        _cidadeController.text = endereco.cidade;
        _mensagemCep = 'Endereço preenchido automaticamente';
      }
    });
  }

  Future<void> _salvarPedido() async {
    if (_nomeController.text.trim().isEmpty ||
        _cepController.text.trim().isEmpty ||
        _numeroController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, CEP e número.')),
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      // Aula 09: gravação com add()
      await FirebaseFirestore.instance.collection('pedidos').add({
        'cliente': _nomeController.text.trim(),
        'produto': widget.produto.nome,
        'tamanho': _tamanho.name,
        'queijoExtra': _queijoExtra,
        'baconExtra': _baconExtra,
        'cep': _cepController.text.trim(),
        'rua': _ruaController.text.trim(),
        'numero': _numeroController.text.trim(),
        'bairro': _bairroController.text.trim(),
        'cidade': _cidadeController.text.trim(),
        'total': double.parse(_total.toStringAsFixed(2)),
        'criadoEm': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      // Navega para a lista passando o nome do cliente (parâmetro)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PedidosPage(clienteAtual: _nomeController.text.trim()),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pedido: ${widget.produto.nome}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Seus dados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Digite seu nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              onChanged: _aoMudarCep,
              decoration: InputDecoration(
                labelText: 'CEP',
                hintText: 'Somente números (8 dígitos)',
                border: const OutlineInputBorder(),
                suffixIcon: _buscandoCep
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : const Icon(Icons.search),
              ),
            ),
            if (_mensagemCep.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(_mensagemCep,
                    style: const TextStyle(color: Colors.blueGrey)),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _ruaController,
              decoration: const InputDecoration(
                labelText: 'Rua',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _numeroController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _bairroController,
                    decoration: const InputDecoration(
                      labelText: 'Bairro',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cidadeController,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                border: OutlineInputBorder(),
              ),
            ),
            const Divider(height: 32),
            const Text('Tamanho',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioGroup<Tamanho>(
              groupValue: _tamanho,
              onChanged: (valor) {
                if (valor != null) setState(() => _tamanho = valor);
              },
              child: const Column(
                children: [
                  RadioListTile<Tamanho>(
                      title: Text('Pequeno (-20%)'), value: Tamanho.pequeno),
                  RadioListTile<Tamanho>(
                      title: Text('Médio'), value: Tamanho.medio),
                  RadioListTile<Tamanho>(
                      title: Text('Grande (+30%)'), value: Tamanho.grande),
                ],
              ),
            ),
            const Text('Adicionais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('Queijo extra (+ R\$ 3,00)'),
              value: _queijoExtra,
              onChanged: (v) => setState(() => _queijoExtra = v ?? false),
            ),
            CheckboxListTile(
              title: const Text('Bacon extra (+ R\$ 4,00)'),
              value: _baconExtra,
              onChanged: (v) => setState(() => _baconExtra = v ?? false),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  'R\$ ${_total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _salvando ? null : _salvarPedido,
                icon: const Icon(Icons.check),
                label: Text(_salvando ? 'Salvando...' : 'Confirmar pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
