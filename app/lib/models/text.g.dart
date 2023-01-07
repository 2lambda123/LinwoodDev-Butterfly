// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DefinedSpanProperty _$$DefinedSpanPropertyFromJson(Map json) =>
    _$DefinedSpanProperty(
      size: (json['size'] as num?)?.toDouble() ?? 12,
      color: json['color'] as int? ?? kColorBlack,
      fontWeight: json['fontWeight'] as int? ?? 3,
      lineThrough: json['lineThrough'] as bool? ?? false,
      underline: json['underline'] as bool? ?? false,
      overline: json['overline'] as bool? ?? false,
      italic: json['italic'] as bool? ?? false,
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0,
      decorationColor: json['decorationColor'] as int? ?? kColorBlack,
      decorationStyle: $enumDecodeNullable(
              _$TextDecorationStyleEnumMap, json['decorationStyle']) ??
          TextDecorationStyle.solid,
      decorationThickness:
          (json['decorationThickness'] as num?)?.toDouble() ?? 1,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DefinedSpanPropertyToJson(
        _$DefinedSpanProperty instance) =>
    <String, dynamic>{
      'size': instance.size,
      'color': instance.color,
      'fontWeight': instance.fontWeight,
      'lineThrough': instance.lineThrough,
      'underline': instance.underline,
      'overline': instance.overline,
      'italic': instance.italic,
      'letterSpacing': instance.letterSpacing,
      'decorationColor': instance.decorationColor,
      'decorationStyle':
          _$TextDecorationStyleEnumMap[instance.decorationStyle]!,
      'decorationThickness': instance.decorationThickness,
      'type': instance.$type,
    };

const _$TextDecorationStyleEnumMap = {
  TextDecorationStyle.solid: 'solid',
  TextDecorationStyle.double: 'double',
  TextDecorationStyle.dotted: 'dotted',
  TextDecorationStyle.dashed: 'dashed',
  TextDecorationStyle.wavy: 'wavy',
};

_$NamedSpanProperty _$$NamedSpanPropertyFromJson(Map json) =>
    _$NamedSpanProperty(
      json['name'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$NamedSpanPropertyToJson(_$NamedSpanProperty instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.$type,
    };

_$UndefinedSpanProperty _$$UndefinedSpanPropertyFromJson(Map json) =>
    _$UndefinedSpanProperty(
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$UndefinedSpanPropertyToJson(
        _$UndefinedSpanProperty instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$DefinedParagraphProperty _$$DefinedParagraphPropertyFromJson(Map json) =>
    _$DefinedParagraphProperty(
      span: json['span'] == null
          ? const DefinedSpanProperty()
          : DefinedSpanProperty.fromJson(
              Map<String, dynamic>.from(json['span'] as Map)),
      alignment: $enumDecodeNullable(
              _$HorizontalAlignmentEnumMap, json['alignment']) ??
          HorizontalAlignment.left,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DefinedParagraphPropertyToJson(
        _$DefinedParagraphProperty instance) =>
    <String, dynamic>{
      'span': instance.span.toJson(),
      'alignment': _$HorizontalAlignmentEnumMap[instance.alignment]!,
      'type': instance.$type,
    };

const _$HorizontalAlignmentEnumMap = {
  HorizontalAlignment.left: 'left',
  HorizontalAlignment.center: 'center',
  HorizontalAlignment.right: 'right',
  HorizontalAlignment.justify: 'justify',
};

_$NamedParagraphProperty _$$NamedParagraphPropertyFromJson(Map json) =>
    _$NamedParagraphProperty(
      json['name'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$NamedParagraphPropertyToJson(
        _$NamedParagraphProperty instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.$type,
    };

_$UndefinedParagraphProperty _$$UndefinedParagraphPropertyFromJson(Map json) =>
    _$UndefinedParagraphProperty(
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$UndefinedParagraphPropertyToJson(
        _$UndefinedParagraphProperty instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$_AreaProperty _$$_AreaPropertyFromJson(Map json) => _$_AreaProperty(
      paragraph: json['paragraph'] == null
          ? const ParagraphProperty.undefined()
          : ParagraphProperty.fromJson(
              Map<String, dynamic>.from(json['paragraph'] as Map)),
      alignment:
          $enumDecodeNullable(_$VerticalAlignmentEnumMap, json['alignment']) ??
              VerticalAlignment.top,
    );

Map<String, dynamic> _$$_AreaPropertyToJson(_$_AreaProperty instance) =>
    <String, dynamic>{
      'paragraph': instance.paragraph.toJson(),
      'alignment': _$VerticalAlignmentEnumMap[instance.alignment]!,
    };

const _$VerticalAlignmentEnumMap = {
  VerticalAlignment.top: 'top',
  VerticalAlignment.center: 'center',
  VerticalAlignment.bottom: 'bottom',
};

_$_TextSpan _$$_TextSpanFromJson(Map json) => _$_TextSpan(
      text: json['text'] as String? ?? '',
      property: json['property'] == null
          ? const SpanProperty.undefined()
          : SpanProperty.fromJson(
              Map<String, dynamic>.from(json['property'] as Map)),
    );

Map<String, dynamic> _$$_TextSpanToJson(_$_TextSpan instance) =>
    <String, dynamic>{
      'text': instance.text,
      'property': instance.property.toJson(),
    };

_$_ParagraphProperty _$$_ParagraphPropertyFromJson(Map json) =>
    _$_ParagraphProperty(
      textProperty: json['textProperty'] == null
          ? const ParagraphProperty.undefined()
          : ParagraphProperty.fromJson(
              Map<String, dynamic>.from(json['textProperty'] as Map)),
      textSpans: (json['textSpans'] as List<dynamic>?)
              ?.map(
                  (e) => TextSpan.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_ParagraphPropertyToJson(
        _$_ParagraphProperty instance) =>
    <String, dynamic>{
      'textProperty': instance.textProperty.toJson(),
      'textSpans': instance.textSpans.map((e) => e.toJson()).toList(),
    };

_$_TextArea _$$_TextAreaFromJson(Map json) => _$_TextArea(
      areaProperty: json['areaProperty'] == null
          ? const AreaProperty()
          : AreaProperty.fromJson(
              Map<String, dynamic>.from(json['areaProperty'] as Map)),
      textParagraphs: (json['textParagraphs'] as List<dynamic>?)
              ?.map((e) =>
                  TextParagraph.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_TextAreaToJson(_$_TextArea instance) =>
    <String, dynamic>{
      'areaProperty': instance.areaProperty.toJson(),
      'textParagraphs': instance.textParagraphs.map((e) => e.toJson()).toList(),
    };

_$_TextStyleSheet _$$_TextStyleSheetFromJson(Map json) => _$_TextStyleSheet(
      name: json['name'] as String? ?? '',
      spanProperties: (json['spanProperties'] as Map?)?.map(
            (k, e) => MapEntry(
                k as String,
                DefinedSpanProperty.fromJson(
                    Map<String, dynamic>.from(e as Map))),
          ) ??
          const {},
      paragraphProperties: (json['paragraphProperties'] as Map?)?.map(
            (k, e) => MapEntry(
                k as String,
                DefinedParagraphProperty.fromJson(
                    Map<String, dynamic>.from(e as Map))),
          ) ??
          const {},
    );

Map<String, dynamic> _$$_TextStyleSheetToJson(_$_TextStyleSheet instance) =>
    <String, dynamic>{
      'name': instance.name,
      'spanProperties':
          instance.spanProperties.map((k, e) => MapEntry(k, e.toJson())),
      'paragraphProperties':
          instance.paragraphProperties.map((k, e) => MapEntry(k, e.toJson())),
    };
