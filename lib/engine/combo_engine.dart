// lib/engine/combo_engine.dart
/// ComboEngine - Tracks combo chains, back-to-back bonuses

import 'types.dart';

class ComboEngine {
  int _combo = 0;
  bool _backToBack = false;
  LineClearType? _lastClearType;
  bool _lastWasTSpin = false;

  ComboEngine();

  /// Current combo count
  int get combo => _combo;

  /// Whether last clear was back-to-back (Tetris or T-spin)
  bool get backToBack => _backToBack;

  /// Last clear type
  LineClearType? get lastClearType => _lastClearType;

  /// Whether last clear was a T-spin
  bool get lastWasTSpin => _lastWasTSpin;

  /// Process a line clear
  ComboResult processClear({
    required int linesCleared,
    required bool isTSpin,
    required bool isMiniTSpin,
  }) {
    if (linesCleared == 0) {
      // No lines cleared - reset combo
      _combo = 0;
      _lastClearType = null;
      _lastWasTSpin = false;
      return ComboResult(
        combo: 0,
        backToBack: false,
        comboBonus: 0,
        isBackToBack: false,
      );
    }

    final clearType = LineClearType.fromCount(linesCleared);
    final isMajorClear = clearType == LineClearType.tetris || isTSpin;
    
    // Check back-to-back
    bool backToBackBonus = false;
    if (_backToBack && isMajorClear) {
      backToBackBonus = true;
    }
    
    _backToBack = isMajorClear;
    _lastClearType = clearType;
    _lastWasTSpin = isTSpin;
    
    if (linesCleared > 0) {
      _combo++;
    } else {
      _combo = 0;
    }

    return ComboResult(
      combo: _combo,
      backToBack: _backToBack,
      comboBonus: _combo > 0 ? _combo * 50 : 0,
      isBackToBack: backToBackBonus,
    );
  }

  /// Reset combo (piece placed without line clear)
  void reset() {
    _combo = 0;
    _backToBack = false;
    _lastClearType = null;
    _lastWasTSpin = false;
  }

  /// Reset combo only (keep back-to-back for next clear)
  void resetComboOnly() {
    _combo = 0;
  }

  /// Get combo display text
  String getComboText() {
    if (_combo <= 1) return '';
    return '${_combo}x COMBO!';
  }

  /// Get back-to-back text
  String? getBackToBackText() {
    if (!_backToBack) return null;
    return 'BACK-TO-BACK!';
  }

  /// Serialize
  Map<String, dynamic> toJson() => {
        'combo': _combo,
        'backToBack': _backToBack,
        'lastClearType': _lastClearType?.name,
        'lastWasTSpin': _lastWasTSpin,
      };

  /// Deserialize
  factory ComboEngine.fromJson(Map<String, dynamic> json) {
    final engine = ComboEngine();
    engine._combo = json['combo'] as int;
    engine._backToBack = json['backToBack'] as bool;
    engine._lastClearType = json['lastClearType'] != null
        ? LineClearType.values.firstWhere((e) => e.name == json['lastClearType'])
        : null;
    engine._lastWasTSpin = json['lastWasTSpin'] as bool;
    return engine;
  }
}

/// Result of processing a clear
class ComboResult {
  final int combo;
  final bool backToBack;
  final int comboBonus;
  final bool isBackToBack;

  const ComboResult({
    required this.combo,
    required this.backToBack,
    required this.comboBonus,
    required this.isBackToBack,
  });
}