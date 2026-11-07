# Trabalho NP2 — Desenvolvimento Mobile

**Curso:** Tecnologia em Análise e Desenvolvimento de Sistemas
**Grupo:** Matheus Felipe Rocha e Victor Hugo da Silva

## Tema e objetivo
**Cantina da Faculdade (delivery).** Aplicativo em Flutter em que o aluno consulta o cardápio, monta o pedido escolhendo tamanho e adicionais, informa o endereço de entrega e acompanha a lista de pedidos em tempo real, salva no Cloud Firestore.

## Integrantes e papéis
| Integrante | Papel |
|---|---|
| Matheus Felipe Rocha — RA: R8481H9 | Coordenação, interface e navegação (aulas 01 a 05); revisão da parte do colega |
| Victor Hugo da Silva — RA: R845HF4 | Formulário, Firebase/Firestore e recurso adicional ViaCEP (aulas 06 a 09); revisão da parte do colega |

*Grupo de dois integrantes, com divisão de papéis combinada previamente com o professor.*

## Recurso adicional: API REST com ViaCEP
**Descrição:** ao digitar o CEP no formulário, o app consulta o serviço ViaCEP com o pacote `http` e preenche automaticamente rua, bairro e cidade.

**Justificativa:** é gratuito, funciona no Chrome sem configuração extra, cabe no prazo de duas semanas e melhora diretamente o formulário exigido.

**Fontes de pesquisa:**
- https://viacep.com.br
- https://pub.dev/packages/http
- https://docs.flutter.dev/cookbook/networking/fetch-data

**Dificuldades encontradas:** [descrevam aqui, por exemplo: tratar CEP inexistente, converter o JSON, atualizar a tela com setState após a resposta assíncrona].
