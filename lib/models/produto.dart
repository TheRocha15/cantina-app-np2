class Produto {
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;

  const Produto({
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
  });
}

const List<Produto> cardapio = [
  Produto(
    nome: 'Hambúrguer Artesanal',
    descricao: 'Pão brioche, carne 150 g, alface e tomate.',
    preco: 18.00,
    imagem:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
  ),
  Produto(
    nome: 'Pizza Individual',
    descricao: 'Massa fina com molho de tomate e muçarela.',
    preco: 22.00,
    imagem:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
  ),
  Produto(
    nome: 'Salada Fit',
    descricao: 'Mix de folhas, tomate cereja e frango grelhado.',
    preco: 16.00,
    imagem:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
  ),
  Produto(
    nome: 'Suco Natural',
    descricao: 'Laranja espremida na hora, sem açúcar.',
    preco: 8.00,
    imagem:
        'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=800',
  ),
];
