class Channel {
  final String id;
  final String name;
  final String logoUrl;
  final String streamUrl;
  final String? category;

  Channel({required this.id, required this.name, required this.logoUrl, required this.streamUrl, this.category});

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      category: json['category'] as String?,
    );
  }
}
