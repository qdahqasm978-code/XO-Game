import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لعبة X O',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
        ),
      ),
      home: const TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  // لوحة اللعبة مكونة من 9 خانات
  List<String> board = List.filled(9, '');

  // دور اللاعب حالياً ('X' أو 'O')
  bool isXTurn = true;

  // النقاط
  int scoreX = 0;
  int scoreO = 0;

  // النص المعروض للتنبيه
  String statusMessage = 'دور اللاعب: X';

  // التحقق من فائز أو تعادل
  bool isGameOver = false;

  void _tapped(int index) {
    if (board[index] != '' || isGameOver) return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';

      if (_checkWinner(board[index])) {
        statusMessage = '🎉 الفائز هو اللاعب ${board[index]}!';
        isGameOver = true;
        if (board[index] == 'X') {
          scoreX++;
        } else {
          scoreO++;
        }
      } else if (!board.contains('')) {
        statusMessage = '🤝 تعادل!';
        isGameOver = true;
      } else {
        isXTurn = !isXTurn;
        statusMessage = 'دور اللاعب: ${isXTurn ? 'X' : 'O'}';
      }
    });
  }

  bool _checkWinner(String player) {
    // خطوط الفوز الممكنة
    List<List<int>> winLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // صفوف
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // أعمدة
      [0, 4, 8], [2, 4, 6]             // أقطار
    ];

    for (var line in winLines) {
      if (board[line[0]] == player &&
          board[line[1]] == player &&
          board[line[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void _resetBoard() {
    setState(() {
      board = List.filled(9, '');
      isGameOver = false;
      isXTurn = true;
      statusMessage = 'دور اللاعب: X';
    });
  }

  void _resetScores() {
    _resetBoard();
    setState(() {
      scoreX = 0;
      scoreO = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لعبة X O'),
        centerTitle: true,
        backgroundColor: const Color(0xFF16213E),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // لوحة النتائج
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreBoard('اللاعب X', scoreX, Colors.cyan),
                _buildScoreBoard('اللاعب O', scoreO, Colors.pinkAccent),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // حالة اللعبة
          Text(
            statusMessage,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // شبكة اللعبة (3x3)
          Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
              itemCount: 9,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _tapped(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: board[index] == 'X'
                              ? Colors.cyan
                              : Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),

          // أزرار التحكم
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _resetBoard,
                icon: const Icon(Icons.refresh),
                label: const Text('جولة جديدة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 15),
              OutlinedButton.icon(
                onPressed: _resetScores,
                icon: const Icon(Icons.delete_outline),
                label: const Text('تصفير النتيجة'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard(String title, int score, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          '$score',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
