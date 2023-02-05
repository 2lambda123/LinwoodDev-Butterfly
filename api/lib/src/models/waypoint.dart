import 'dart:ui';

import 'converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'waypoint.g.dart';
part 'waypoint.freezed.dart';

@freezed
class Waypoint with _$Waypoint {
  static const Waypoint origin = Waypoint('', Offset.zero, 1);

  const factory Waypoint(String name, @OffsetJsonConverter() Offset position,
      [double? scale]) = _Waypoint;

  factory Waypoint.fromJson(Map<String, dynamic> json) =>
      _$WaypointFromJson(json);
}
