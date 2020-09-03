import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:piton_todo/database/DBProvider.dart';
import 'package:piton_todo/models/todo_model.dart';
import 'package:piton_todo/screens/home.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _titleEt, _descEt, _typeEt;

  // Bilgileri girilen verileri  veritabanına ekler ve anasayfa yönlendirir
  submit() {
    // formun bilgilerini doğrular
    if (_formKey.currentState.validate()) {
      // bütün bilgileri gerekli değişkenlere atar
      _formKey.currentState.save();
      // Yeni bir görev oluşturur Todo sınıfı aracılığıyla
      Todo todo = Todo(
        title: _titleEt,
        desc: _descEt,
        type: _typeEt,
        checked: 0,
      );
      //veritabanına ekler
      DBProvider.db.insert(todo);
      // Bütün navigatorleri uygulamadan siler ve anasayfa yollar
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      maxLength: 50,
                      onSaved: (input) => _titleEt = input,
                      decoration: InputDecoration(hintText: 'Başlık'),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      maxLength: 255,
                      onSaved: (input) => _descEt = input,
                      decoration: InputDecoration(hintText: 'Açıklama'),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: DropDown(
                        items: ["Günlük", "Haftalık", "Aylık"],
                        hint: Text("Görev tipi seçiniz"),
                        onChanged: (value) => _typeEt = value,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () => submit(),
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.blue),
                        child: Center(
                          child: Text(
                            'Kaydet',
                            style: TextStyle(
                                letterSpacing: 2.0,
                                fontFamily: 'FirSans',
                                fontSize: 17.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
