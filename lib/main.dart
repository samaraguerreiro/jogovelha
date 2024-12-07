import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const JogoDaVelha(),
    );
  }
}

class JogoDaVelha extends StatefulWidget {
  const JogoDaVelha({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JogoDaVelhaState createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  // Tabuleiro do jogo
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameOver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildBoard(),
          ),
          const SizedBox(height: 20),
          Text(
            gameOver
                ? 'Fim de jogo! Reinicie para jogar novamente.'
                : 'Vez do jogador: $currentPlayer',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text('Reiniciar Jogo'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Cria o tabuleiro
  Widget _buildBoard() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _markTile(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                board[index],
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  // Marca o espaço no tabuleiro
  void _markTile(int index) {
    if (!gameOver && board[index].isEmpty) {
      setState(() {
        board[index] = currentPlayer;
        if (_checkWinner(currentPlayer)) {
          _showWinnerDialog(currentPlayer);
          gameOver = true;
        } else if (!board.contains('')) {
          _showWinnerDialog('Empate');
          gameOver = true;
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  // Reinicia o jogo
  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameOver = false;
    });
  }

  // Verifica vencedor
  bool _checkWinner(String player) {
    const List<List<int>> winningPositions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
      [0, 4, 8], [2, 4, 6], // Diagonais
    ];

    for (var positions in winningPositions) {
      if (board[positions[0]] == player &&
          board[positions[1]] == player &&
          board[positions[2]] == player) {
        return true;
      }
    }
    return false;
  }

  // Exibe o vencedor
  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(winner == 'Empate' ? 'Empate!' : 'Vencedor: $winner'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
