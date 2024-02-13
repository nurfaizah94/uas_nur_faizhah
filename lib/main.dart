import 'package:flutter/material.dart';
import 'package:flutter_crud/database_helper.dart';
import 'package:flutter_crud/student.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS Nur',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  String? jurusan;
  final TextEditingController nilaiUASController = TextEditingController();
  final TextEditingController nilaiUTSController = TextEditingController();
  final TextEditingController nilaiTugasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UAS Nur',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Data',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
              ),
            ),
            TextField(
              controller: nimController,
              decoration: InputDecoration(
                labelText: 'NIM',
              ),
            ),
            Row(
              children: [
                Text(
                  'Jurusan:',
                  style: TextStyle(color: Colors.black),
                ),
                Radio<String>(
                  value: 'Sistem Informasi',
                  groupValue: jurusan,
                  onChanged: (value) {
                    setState(() {
                      jurusan = value;
                    });
                  },
                ),
                Text(
                  'Sistem Informasi',
                  style: TextStyle(color: Colors.black),
                ),
                Radio<String>(
                  value: 'Teknik Informatika',
                  groupValue: jurusan,
                  onChanged: (value) {
                    setState(() {
                      jurusan = value;
                    });
                  },
                ),
                Text(
                  'Teknik Informatika',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            TextField(
              controller: nilaiUASController,
              decoration: InputDecoration(
                labelText: 'Nilai UAS',
              ),
            ),
            TextField(
              controller: nilaiUTSController,
              decoration: InputDecoration(
                labelText: 'Nilai UTS',
              ),
            ),
            TextField(
              controller: nilaiTugasController,
              decoration: InputDecoration(
                labelText: 'Nilai Tugas',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addStudent();
                  },
                  child: Text(
                    'Tambah',
                    style: TextStyle(color: const Color.fromARGB(255, 3, 3, 3)),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _deleteAllStudents();
                  },
                  child: Text(
                    'Hapus',
                    style: TextStyle(color: const Color.fromARGB(255, 9, 9, 9)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Daftar Mahasiswa',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: dbHelper.getStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Student>? students = snapshot.data;
                      if (students == null || students.isEmpty) {
                        return Center(child: Text('Tidak ada data mahasiswa'));
                      }
                      return ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          Student student = students[index];
                          double nilaiKeseluruhan = (student.nilaiUAS +
                                  student.nilaiUTS +
                                  student.nilaiTugas) /
                              3;

                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama: ${student.nama}'),
                                Text('NIM: ${student.nim}'),
                                Text('Jurusan: ${student.jurusan}'),
                                Text('Nilai UAS: ${student.nilaiUAS}'),
                                Text('Nilai UTS: ${student.nilaiUTS}'),
                                Text('Nilai Tugas: ${student.nilaiTugas}'),
                                Text(
                                    'Nilai Keseluruhan: ${nilaiKeseluruhan.toStringAsFixed(2)}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteStudent(student.id!);
                              },
                            ),
                            onTap: () {
                              _editStudent(student);
                            },
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addStudent() async {
    double? nilaiUAS = double.tryParse(nilaiUASController.text);
    double? nilaiUTS = double.tryParse(nilaiUTSController.text);
    double? nilaiTugas = double.tryParse(nilaiTugasController.text);

    if (nilaiUAS != null &&
        nilaiUTS != null &&
        nilaiTugas != null &&
        jurusan != null) {
      Student student = Student(
        nama: namaController.text,
        nim: nimController.text,
        jurusan: jurusan!,
        nilaiUAS: nilaiUAS,
        nilaiUTS: nilaiUTS,
        nilaiTugas: nilaiTugas,
      );

      await dbHelper.insertStudent(student);
      setState(() {
        namaController.clear();
        nimController.clear();
        nilaiUASController.clear();
        nilaiUTSController.clear();
        nilaiTugasController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Pastikan semua input sudah diisi dengan benar'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _editStudent(Student student) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Data Mahasiswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: student.nama),
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: TextEditingController(text: student.nim),
              decoration: InputDecoration(labelText: 'NIM'),
            ),
            TextField(
              controller: TextEditingController(text: student.jurusan),
              decoration: InputDecoration(labelText: 'Jurusan'),
            ),
            TextField(
              controller:
                  TextEditingController(text: student.nilaiUAS.toString()),
              decoration: InputDecoration(labelText: 'Nilai UAS'),
            ),
            TextField(
              controller:
                  TextEditingController(text: student.nilaiUTS.toString()),
              decoration: InputDecoration(labelText: 'Nilai UTS'),
            ),
            TextField(
              controller:
                  TextEditingController(text: student.nilaiTugas.toString()),
              decoration: InputDecoration(labelText: 'Nilai Tugas'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Student updatedStudent = Student(
                id: student.id,
                nama: namaController.text,
                nim: nimController.text,
                jurusan: jurusan!,
                nilaiUAS: double.parse(nilaiUASController.text),
                nilaiUTS: double.parse(nilaiUTSController.text),
                nilaiTugas: double.parse(nilaiTugasController.text),
              );
              await dbHelper.updateStudent(updatedStudent);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteAllStudents() async {
    await dbHelper.deleteAllStudents();
    setState(() {});
  }

  void _deleteStudent(int id) async {
    await dbHelper.deleteStudent(id);
    setState(() {});
  }
}
