# Cantina da Faculdade — Passo a passo para rodar

## 1. Criar o projeto Flutter e copiar os arquivos
```bash
flutter create cantina_app
```
Depois copie para dentro da pasta criada:
- a pasta `lib/` (substitui a original; apague o `main.dart` antigo)
- o `pubspec.yaml` (ou rode `flutter pub add firebase_core cloud_firestore http`)

Use uma versão recente do Flutter (3.35 ou superior), porque o código usa `RadioGroup`.

## 2. Criar o projeto no Firebase (faça isso no DIA 1)
1. Acesse https://console.firebase.google.com e clique em **Adicionar projeto**.
2. No menu **Build > Firestore Database**, clique em **Criar banco de dados**.
   - Escolha **modo de teste** (libera leitura/escrita por 30 dias).
3. Instale as ferramentas (precisa de Node.js):
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
```
4. Dentro da pasta do projeto, rode:
```bash
flutterfire configure
```
   Selecione o projeto e marque a plataforma **Web**. Isso cria o `lib/firebase_options.dart`.

## 3. Rodar
```bash
flutter pub get
flutter run -d chrome
```

## 4. Antes da apresentação
- Cadastre 2 ou 3 pedidos de teste.
- Deixe o console do Firebase aberto em outra aba (Firestore > coleção `pedidos`).
- Teste o CEP 01001000 (Praça da Sé, SP).
- Se der erro de permissão no Firestore, confira as regras: `allow read, write: if true;` (apenas para o trabalho).

## 5. Checklist (RF01 a RF09)
| Código | Onde está no código |
|---|---|
| RF01 | `AppBar` com title/centerTitle/backgroundColor e `TextStyle` em todas as páginas |
| RF02 | `Image.network` com `BoxFit.cover` (home) + `Icon` (menu, receipt) |
| RF03 | `Column`/`Row`, `SingleChildScrollView` e `Stack` + `Positioned` (home_page.dart) |
| RF04 | 3 arquivos em `lib/pages/` com `Navigator.push` e parâmetros (`produto`, `clienteAtual`) |
| RF05 | `PedidoPage` é `StatefulWidget` e o total muda com `setState` |
| RF06 | 6 `TextField` com `TextEditingController` |
| RF07 | `CheckboxListTile` (extras) e `RadioListTile` + `enum Tamanho` |
| RF08 | `add()` em `pedido_page.dart` e `StreamBuilder` com `snapshots()` em `pedidos_page.dart` |
| RF09 | ViaCEP em `services/viacep_service.dart` (pacote `http`) |
