import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

part 'position.g.dart';

@HiveType(typeId: 0)
class Position extends Equatable {
  @HiveField(0)
  final int x;

  @HiveField(1)
  final int y;

  const Position(this.x, this.y);

  Position copyWith({int? x, int? y}) {
    return Position(x ?? this.x, y ?? this.y);
  }

  Position translate(int dx, int dy) {
    return Position(x + dx, y + dy);
  }

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => 'Position(x: $x, y: $y)';
}