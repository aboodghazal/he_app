class ArticleModel {
  final String id; // Document ID
  final String title;
  final String description;
  final String writer;
  final String category;
  final String? imageURL; // For article image or video thumbnail
  final String? videoURL; // Optional — exists only if it’s a video
  final DateTime date;
  final String? doctorId; // Optional (only for videos)

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.writer,
    required this.category,
    this.imageURL,
    this.videoURL,
    required this.date,
    this.doctorId,
  });

  /// Factory: create model from Firestore document
  factory ArticleModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ArticleModel(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      writer: data['writer'] ?? '',
      category: data['category'] ?? '',
      imageURL: data['imageURL'],
      videoURL: data['videoURL'],
      date: DateTime.tryParse(data['date']?.toString() ?? '') ?? DateTime.now(),
      doctorId: data['doctorId'],
    );
  }

  /// Convert to map for uploading to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'writer': writer,
      'category': category,
      if (imageURL != null) 'imageURL': imageURL,
      if (videoURL != null) 'videoURL': videoURL,
      if (doctorId != null) 'doctorId': doctorId,
      'date': date.toIso8601String(),
    };
  }

  /// Helper to check if this model represents a video
  bool get isVideo => videoURL != null && videoURL!.isNotEmpty;
}
