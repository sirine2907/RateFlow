class FavoritePair {
  final String fromCode;
  final String toCode;

  const FavoritePair(this.fromCode, this.toCode);

  Map<String, String> toJson() => {'from': fromCode, 'to': toCode};

  factory FavoritePair.fromJson(Map<String, dynamic> json) {
    return FavoritePair(json['from'] as String, json['to'] as String);
  }

  @override
  bool operator ==(Object other) =>
      other is FavoritePair && other.fromCode == fromCode && other.toCode == toCode;

  @override
  int get hashCode => Object.hash(fromCode, toCode);
}
