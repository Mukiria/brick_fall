// lib/widgets/board.dart
/// 8x8 Game Board - CustomPainter rendering with animations

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/design/design_system.dart';
import '../engine/engine.dart' as engine;

/// Cell data for rendering
class BoardCell {
  final bool occupied;
  final int color;
  final double animationProgress;
  final engine.Offset position;
  final AnimationState animationState;

  const BoardCell({
    required this.occupied,
    required this.color,
    required this.animationProgress,
    required this.position,
    required this.animationState,
  });

  BoardCell copyWith({
    bool? occupied,
    int? color,
    double? animationProgress,
    engine.Offset? position,
    AnimationState? animationState,
  }) {
    return BoardCell(
      occupied: occupied ?? this.occupied,
      color: color ?? this.color,
      animationProgress: animationProgress ?? this.animationProgress,
      position: position ?? this.position,
      animationState: animationState ?? this.animationState,
    );
  }
}

enum AnimationState {
  idle,
  appearing,
  clearing,
  shaking,
  locking,
}

/// Board configuration
class BoardConfig {
  final int rows;
  final int cols;
  final double cellSize;
  final double spacing;
  final Duration animationDuration;
  final Curve animationCurve;

  const BoardConfig({
    this.rows = 8,
    this.cols = 8,
    this.cellSize = 40,
    this.spacing = 2,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
  });

  double get boardWidth => cols * cellSize + (cols - 1) * spacing;
  double get boardHeight => rows * cellSize + (rows - 1) * spacing;
}

/// Main Board Widget
class GameBoard extends ConsumerStatefulWidget {
  final BoardConfig config;
  final List<List<BoardCell>> cells;
  final VoidCallback? onRepaint;
  final bool showGridLines;
  final Color? gridLineColor;
  final double gridLineWidth;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const GameBoard({
    super.key,
    this.config = const BoardConfig(),
    required this.cells,
    this.onRepaint,
    this.showGridLines = true,
    this.gridLineColor,
    this.gridLineWidth = 1,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  ConsumerState<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends ConsumerState<GameBoard> with TickerProviderStateMixin {
  late final List<List<AnimationController>> _cellControllers;
  late final List<List<Animation<double>>> _cellAnimations;
  final _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _cellControllers = List.generate(
      widget.config.rows,
      (r) => List.generate(
        widget.config.cols,
        (c) => AnimationController(
          duration: widget.config.animationDuration,
          vsync: this,
        ),
      ),
    );

    _cellAnimations = List.generate(
      widget.config.rows,
      (r) => List.generate(
        widget.config.cols,
        (c) => CurvedAnimation(
          parent: _cellControllers[r][c],
          curve: widget.config.animationCurve,
        ),
      ),
    );

    // Start initial animations
    _staggeredEntrance();
  }

  void _staggeredEntrance() {
    for (int r = 0; r < widget.config.rows; r++) {
      for (int c = 0; c < widget.config.cols; c++) {
        final delay = Duration(milliseconds: (r * widget.config.cols + c) * 30);
        Future.delayed(delay, () {
          if (mounted) {
            _cellControllers[r][c].forward();
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant GameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onRepaint != null) {
      widget.onRepaint!();
    }
    _updateAnimations(oldWidget);
  }

  void _updateAnimations(GameBoard oldWidget) {
    for (int r = 0; r < widget.config.rows; r++) {
      for (int c = 0; c < widget.config.cols; c++) {
        final oldCell = r < oldWidget.cells.length && c < oldWidget.cells[r].length
            ? oldWidget.cells[r][c]
            : null;
        final newCell = widget.cells[r][c];

        if (oldCell != null && newCell != null) {
          if (!oldCell.occupied && newCell.occupied) {
            _cellControllers[r][c].forward(from: 0);
          } else if (oldCell.occupied && !newCell.occupied) {
            _cellControllers[r][c].reverse();
          } else if (oldCell.animationState != newCell.animationState) {
            switch (newCell.animationState) {
              case AnimationState.clearing:
                _cellControllers[r][c].forward(from: 0);
                break;
              case AnimationState.shaking:
                _shakeCell(r, c);
                break;
              case AnimationState.locking:
                _cellControllers[r][c].forward(from: 0);
                break;
              default:
                break;
            }
          }
        }
      }
    }
  }

  void _shakeCell(int row, int col) {
    _cellControllers[row][col].forward(from: 0).then((_) {
      _cellControllers[row][col].reverse();
    });
  }

  @override
  void dispose() {
    for (final row in _cellControllers) {
      for (final controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gridColor = widget.gridLineColor ?? theme.colorScheme.outlineVariant.withValues(alpha: 0.3);

    return RepaintBoundary(
      key: _repaintKey,
      child: Center(
        child: Container(
          width: widget.config.boardWidth,
          height: widget.config.boardHeight,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: gridColor, width: widget.gridLineWidth),
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg),
            child: CustomPaint(
              size: Size(widget.config.boardWidth, widget.config.boardHeight),
              painter: _BoardPainter(
                config: widget.config,
                cells: widget.cells,
                animations: _cellAnimations,
                gridColor: gridColor,
                gridLineWidth: widget.gridLineWidth,
                showGridLines: widget.showGridLines,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter for the board
class _BoardPainter extends CustomPainter {
  final BoardConfig config;
  final List<List<BoardCell>> cells;
  final List<List<Animation<double>>> animations;
  final Color gridColor;
  final double gridLineWidth;
  final bool showGridLines;

  _BoardPainter({
    required this.config,
    required this.cells,
    required this.animations,
    required this.gridColor,
    required this.gridLineWidth,
    required this.showGridLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    _drawBackground(canvas, size);

    // Draw cells
    for (int r = 0; r < config.rows; r++) {
      for (int c = 0; c < config.cols; c++) {
        _drawCell(canvas, r, c);
      }
    }

    // Draw grid lines on top
    if (showGridLines) {
      _drawGridLines(canvas, size);
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawCell(Canvas canvas, int row, int col) {
    final cell = cells[row][col];
    final animation = animations[row][col];
    final progress = animation.value;

    final x = col * (config.cellSize + config.spacing);
    final y = row * (config.cellSize + config.spacing);

    final rect = Rect.fromLTWH(x, y, config.cellSize, config.cellSize);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(config.cellSize * 0.1),
    );

    // Calculate animated properties
    final scale = 0.8 + 0.2 * progress;
    final animatedRect = Rect.fromLTWH(
      x + (config.cellSize * (1 - scale) / 2),
      y + (config.cellSize * (1 - scale) / 2),
      config.cellSize * scale,
      config.cellSize * scale,
    );
    final animatedRRect = RRect.fromRectAndRadius(
      animatedRect,
      Radius.circular(config.cellSize * 0.1 * scale),
    );

    final paint = Paint()..style = PaintingStyle.fill;

    if (cell.occupied) {
      // Draw occupied cell
      paint.color = Color(cell.color);
      canvas.drawRRect(animatedRRect, paint);

      // Draw highlight
      paint.color = Colors.white.withValues(alpha: 0.2 * progress);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      canvas.drawRRect(animatedRRect, paint);
      paint.style = PaintingStyle.fill;

      // Draw inner glow
      paint.color = Colors.white.withValues(alpha: 0.1 * progress);
      canvas.drawRRect(animatedRRect.deflate(config.cellSize * 0.1), paint);
    } else {
      // Draw empty cell
      paint.color = gridColor.withValues(alpha: 0.1);
      canvas.drawRRect(rrect, paint);

      // Draw subtle border
      paint.color = gridColor.withValues(alpha: 0.3);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 0.5;
      canvas.drawRRect(rrect, paint);
      paint.style = PaintingStyle.fill;
    }

    // Draw animation state effects
    switch (cell.animationState) {
      case AnimationState.clearing:
        _drawClearEffect(canvas, animatedRRect, progress);
        break;
      case AnimationState.shaking:
        _drawShakeEffect(canvas, animatedRRect, progress);
        break;
      case AnimationState.locking:
        _drawLockEffect(canvas, animatedRRect, progress);
        break;
      default:
        break;
    }
  }

  void _drawClearEffect(Canvas canvas, RRect rect, double progress) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.8 * (1 - progress));
    canvas.drawRRect(rect, paint);

    // Expanding ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white.withValues(alpha: 1 - progress);
    final expandedRect = rect.inflate(config.cellSize * progress * 0.5);
    canvas.drawRRect(expandedRect, ringPaint);
  }

  void _drawShakeEffect(Canvas canvas, RRect rect, double progress) {
    // Shake is handled by the animation controller itself
  }

  void _drawLockEffect(Canvas canvas, RRect rect, double progress) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.amber.withValues(alpha: progress);
    canvas.drawRRect(rect, paint);

    // Lock icon
    if (progress > 0.5) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '🔒',
          style: TextStyle(
            fontSize: config.cellSize * 0.5,
            color: Colors.amber,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          rect.left + (rect.width - textPainter.width) / 2,
          rect.top + (rect.height - textPainter.height) / 2,
        ),
      );
    }
  }

  void _drawGridLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = gridLineWidth
      ..style = PaintingStyle.stroke;

    // Vertical lines
    for (int c = 0; c <= config.cols; c++) {
      final x = c * (config.cellSize + config.spacing) - config.spacing / 2;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (int r = 0; r <= config.rows; r++) {
      final y = r * (config.cellSize + config.spacing) - config.spacing / 2;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _BoardPainter &&
        oldDelegate.cells != cells &&
        oldDelegate.config != config;
  }
}

/// Convenience widget for creating a board from engine state
class EngineBoard extends ConsumerWidget {
  final engine.Board board;
  final BoardConfig config;
  final VoidCallback? onRepaint;
  final engine.Piece? currentPiece;
  final engine.Piece? ghostPiece;
  final bool showGhost;

  const EngineBoard({
    super.key,
    required this.board,
    this.config = const BoardConfig(),
    this.onRepaint,
    this.currentPiece,
    this.ghostPiece,
    this.showGhost = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cells = _buildCells(board, currentPiece, ghostPiece);
    return GameBoard(
      config: config,
      cells: cells,
      onRepaint: onRepaint,
    );
  }

  List<List<BoardCell>> _buildCells(
    engine.Board board,
    engine.Piece? currentPiece,
    engine.Piece? ghostPiece,
  ) {
    final cells = List.generate(
      config.rows,
      (r) => List.generate(
        config.cols,
        (c) => BoardCell(
          occupied: false,
          color: 0,
          animationProgress: 1.0,
          position: engine.Offset(c, r),
          animationState: AnimationState.idle,
        ),
      ),
    );

    // Draw locked cells
    for (int r = 0; r < board.height; r++) {
      for (int c = 0; c < board.width; c++) {
        if (board.isOccupied(c, r)) {
          final color = board.getColor(c, r);
          if (r < config.rows && c < config.cols) {
            cells[r][c] = BoardCell(
              occupied: true,
              color: color,
              animationProgress: 1.0,
              position: engine.Offset(c, r),
              animationState: AnimationState.idle,
            );
          }
        }
      }
    }

    // Draw ghost piece
    if (showGhost && ghostPiece != null) {
      for (final block in ghostPiece.blocks) {
        final x = ghostPiece.x + block.dx;
        final y = ghostPiece.y + block.dy;
        if (x >= 0 && x < config.cols && y >= 0 && y < config.rows) {
          cells[y][x] = cells[y][x].copyWith(
            occupied: true,
            color: ghostPiece.color,
            animationProgress: 0.5,
            animationState: AnimationState.idle,
          );
        }
      }
    }

    // Draw current piece
    if (currentPiece != null) {
      for (final block in currentPiece.blocks) {
        final x = currentPiece.x + block.dx;
        final y = currentPiece.y + block.dy;
        if (x >= 0 && x < config.cols && y >= 0 && y < config.rows) {
          cells[y][x] = BoardCell(
            occupied: true,
            color: currentPiece.color,
            animationProgress: 1.0,
            position: engine.Offset(x, y),
            animationState: AnimationState.locking,
          );
        }
      }
    }

    return cells;
  }
}

/// Pre-built board configurations
class BoardPresets {
  static BoardConfig classic({double cellSize = 40}) => BoardConfig(
    rows: 8,
    cols: 8,
    cellSize: cellSize,
  );

  static BoardConfig tetris({double cellSize = 30}) => BoardConfig(
    rows: 20,
    cols: 10,
    cellSize: cellSize,
  );

  static BoardConfig compact({double cellSize = 24}) => BoardConfig(
    rows: 8,
    cols: 8,
    cellSize: cellSize,
    spacing: 1,
  );

  static BoardConfig large({double cellSize = 50}) => BoardConfig(
    rows: 8,
    cols: 8,
    cellSize: cellSize,
    spacing: 4,
  );
}