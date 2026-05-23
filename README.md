# To-Do List com Firebase

Um aplicativo de gerenciamento de tarefas desenvolvido em **Flutter**.  
O projeto conta com um sistema completo de autenticação de usuários e persistência de dados utilizando o **Firebase**.

---

## Funcionalidades Principais

- **Autenticação Segura:** Criação de conta e login de usuários com validação através do Firebase Auth.
- **Gerenciamento de Tarefas (CRUD):**
  - Adicionar novas tarefas com títulos personalizados.
  - Editar títulos de tarefas já existentes.
  - Marcar tarefas como concluídas (aplicando efeito visual de texto riscado).
  - Excluir tarefas.
- **Atualização em Tempo Real:** A lista de tarefas se atualiza instantaneamente na tela quando um dado é modificado.
- **Interface:** Cards customizados, campos de texto padronizados e plano de fundo degradê.

---

## Tecnologias Utilizadas

- **Flutter & Dart:** Framework e linguagem base para construção do aplicativo multiplataforma.
- **Firebase Authentication:** Cadastro, login e gerenciamento de sessões dos usuários.
- **Cloud Firestore / Firebase Realtime Database:** Banco de dados NoSQL para armazenar e sincronizar tarefas.

---

## Autenticação e Base de Dados

### Autenticação
- Cadastro com e-mail e senha (mínimo de 6 caracteres).
- Persistência de sessão ativa após login.
- Acesso à `HomeScreen` apenas após validação bem-sucedida.

### Base de Dados
Cada documento de tarefa armazena:
- `id`: Identificador único da tarefa.
- `titulo`: Texto descritivo da atividade.
- `pronto`: Booleano indicando se a tarefa foi concluída.
- `userId`: ID exclusivo do usuário, garantindo que **um usuário nunca veja ou altere tarefas de outro**.

---

## Estrutura do Projeto

```text
lib/
├── models/
│   └── todo_model.dart       # Modelo de dados da tarefa
├── screens/
│   ├── login_screen.dart     # Tela de login
│   ├── register_screen.dart  # Tela de cadastro
│   └── home_screen.dart      # Painel principal
├── services/
│   ├── auth_service.dart     # Comunicação com Firebase Auth
│   └── database_service.dart # Regras de negócio e Streams do banco
└── widgets/
    └── todo_item_widget.dart # Estrutura visual dos itens da lista
```
---

## Como Executar o Projeto

1. Certifique-se de ter o Flutter instalado em sua máquina (`flutter doctor`).
2. Clone este repositório: `git clone https://github.com/VitorKavaharada/ToDo_Flutter_FireBase.git`
3. Acesse a pasta do projeto: `cd ToDo_Flutter_FireBase-main`
4. Instale as dependências: `flutter pub get`
5. Execute o projeto: `flutter run`
