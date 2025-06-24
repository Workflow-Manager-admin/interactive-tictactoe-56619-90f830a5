import 'package:flutter/material.dart';

// Color palette as provided in the requirements
const Color kPrimaryColor = Color(0xFF2196F3);
const Color kSecondaryColor = Color(0xFFFF5722);
const Color kAccentColor = Color(0xFF4CAF50);

// Entry point of the app
void main() {
  runApp(const TicTacToeApp());
}

///
/// PUBLIC_INTERFACE
/// The main app widget initializing the game theme and home page.
///
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          surface: Colors.white,
          background: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black87,
          onBackground: Colors.black87,
          error: Colors.redAccent,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const TicTacToeHomePage(),
    );
  }
}

///
/// PUBLIC_INTERFACE
/// Main page widget for the Tic Tac Toe game UI and logic.
///
class TicTacToeHomePage extends StatefulWidget {
  const TicTacToeHomePage({super.key});

  @override
  State<TicTacToeHomePage> createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  static const int gridSize = 3;
  static final List<List<int>> _winLines = [
    // Rows
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    // Columns
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    // Diagonals
    [0, 4, 8], [2, 4, 6],
  ];

  List<String> _board = List<String>.filled(9, '');
  String _currentPlayer = 'X';
  String _gameResult = '';
  bool _gameOver = false;

  // PUBLIC_INTERFACE
  /// Resets the board for a new game.
  void _startNewGame() {
    setState(() {
      _board = List<String>.filled(9, '');
      _currentPlayer = 'X';
      _gameResult = '';
      _gameOver = false;
    });
  }

  // PUBLIC_INTERFACE
  /// Handles a cell tap to place the player's mark and control the game state.
  void _handleTileTap(int idx) {
    if (_gameOver || _board[idx] != '') return;

    setState(() {
      _board[idx] = _currentPlayer;
      if (_checkWinner(_currentPlayer)) {
        _gameResult = "$_currentPlayer wins!";
        _gameOver = true;
      } else if (!_board.contains('')) {
        _gameResult = "It's a draw!";
        _gameOver = true;
      } else {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  // Checks for a winner for the given player.
  bool _checkWinner(String player) {
    return _winLines.any(
      (line) => line.every((idx) => _board[idx] == player),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive sizing: square board with spacing for controls
              double gridSizePx = constraints.maxWidth < constraints.maxHeight
                  ? constraints.maxWidth * 0.9
                  : constraints.maxHeight * 0.55;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Player turn indicator or game result
                  _buildPlayerIndicator(theme),
                  const SizedBox(height: 20),
                  // Tic tac toe grid board
                  _buildGameBoard(gridSizePx, theme),
                  const SizedBox(height: 30),
                  // Control buttons
                  _buildControlButtons(theme),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // PUBLIC_INTERFACE
  /// Widget: shows current player turn or the final result.
  Widget _buildPlayerIndicator(ThemeData theme) {
    return Column(
      children: [
        if (_gameResult.isEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Player ",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.black.withOpacity(0.75),
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _currentPlayer,
                  key: ValueKey(_currentPlayer),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: _currentPlayer == 'X' ? kPrimaryColor : kSecondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              Text(
                "'s turn",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.black.withOpacity(0.75),
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        if (_gameResult.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _gameResult.contains("wins")
                  ? kAccentColor
                  : kPrimaryColor.withOpacity(0.85),
            ),
            child: Text(
              _gameResult,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  // PUBLIC_INTERFACE
  /// Widget: draws the 3x3 game grid board.
  Widget _buildGameBoard(double gridSizePx, ThemeData theme) {
    return Container(
      width: gridSizePx,
      height: gridSizePx,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 9,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, idx) {
          String val = _board[idx];
          return GestureDetector(
            onTap: () => _handleTileTap(idx),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: val.isEmpty
                    ? Colors.grey.shade200
                    : (val == 'X' ? kPrimaryColor.withOpacity(0.11) : kSecondaryColor.withOpacity(0.10)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: val == ''
                      ? Colors.grey.shade300
                      : (val == 'X' ? kPrimaryColor : kSecondaryColor),
                  width: val == '' ? 1.4 : 2.2,
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: val == ''
                      ? null
                      : Text(
                          val,
                          key: ValueKey(val + idx.toString()),
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            color: val == 'X' ? kPrimaryColor : kSecondaryColor,
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // PUBLIC_INTERFACE
  /// Widget: Restart/Start New Game control button.
  Widget _buildControlButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _startNewGame,
          icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 28),
          label: Text(
            _gameResult.isEmpty ? 'Restart Game' : 'Start New Game',
            style: theme.textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
