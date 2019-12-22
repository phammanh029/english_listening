class Lession {
  final String path; // file path
  final String transcript;
  final String thumbnail;

  const Lession(
      {this.path, this.transcript, this.thumbnail}); // video stranscript

  Lession copyWith({String transcript, String thumbnail}) {
    return Lession(
        path: this.path, transcript: transcript, thumbnail: this.thumbnail);
  }

  static Lession fromJson(Map<String, dynamic> jsonData) => Lession(
      path: jsonData['path'],
      thumbnail: jsonData['thumbnail'],
      transcript: jsonData['transcripton']);

  Map<String, dynamic> toJson() =>
      {'path': path, 'transcription': transcript, 'thumbnail': thumbnail};
}
