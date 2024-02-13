class Student {
  final int? id;
  final String nama;
  final String nim;
  final String jurusan;
  final double nilaiUAS;
  final double nilaiUTS;
  final double nilaiTugas;

  Student({
    this.id,
    required this.nama,
    required this.nim,
    required this.jurusan,
    required this.nilaiUAS,
    required this.nilaiUTS,
    required this.nilaiTugas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'jurusan': jurusan,
      'nilai_uas': nilaiUAS,
      'nilai_uts': nilaiUTS,
      'nilai_tugas': nilaiTugas,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      nama: map['nama'],
      nim: map['nim'],
      jurusan: map['jurusan'],
      nilaiUAS: map['nilai_uas'],
      nilaiUTS: map['nilai_uts'],
      nilaiTugas: map['nilai_tugas'],
    );
  }
}
