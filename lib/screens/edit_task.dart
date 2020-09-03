import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:piton_todo/database/DBProvider.dart';
import 'package:piton_todo/models/todo_model.dart';
import 'package:piton_todo/screens/home.dart';

class EditTask extends StatefulWidget {
  // Düzenleme ikonuna tıklayarak ilgilendiğmiz todo verileri
  final Todo editTodo;

  const EditTask({Key key, this.editTodo}) : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _titleEt, _descEt, _typeEt;
  bool _checkBoxValue;

  // Zaten olan bir todoyu girilen bilgilerle değiştirir
  updateTodo(int todoId) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Sınıf aracılığıyla todoyu düzenler
      Todo todo = Todo(
        id: todoId,
        title: _titleEt,
        desc: _descEt,
        type: _typeEt ?? widget.editTodo.type,
        checked: _checkBoxValue ? 1 : 0,
      );
      // veritabanında ilgili todoyu bulup verileri günceller
      DBProvider.db.update(todo);
      // Anasayfa yönlendirir, bütün navigatörleri uygulamadan siler
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    }
  }

  // İlgili todoyu veritabanından siler ve anasayfa yönlendirir
  deleteTodo(int todoId) {
    DBProvider.db.delete(todoId);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
  }

  @override
  // sayfa yüklenirken çalışan fonksiyon
  void initState() {
    super.initState();
    // Checkbox boş olmaması ve ilgili komponentin sayfa yüklenirken
    // gerekli değeri atamamızı sağlar
    setState(() {
      // checkbox değerini sayfadan aldığımız değere eşitledik
      _checkBoxValue = (widget.editTodo.checked == 1) ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task: " + widget.editTodo.id.toString()),
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
                      initialValue: widget.editTodo.title,
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
                      initialValue: widget.editTodo.desc,
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
                        initialValue: widget.editTodo.type,
                        items: ["Günlük", "Haftalık", "Aylık"],
                        hint: Text("Görev tipi seçiniz"),
                        onChanged: (value) => _typeEt = value,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: CheckboxListTile(
                    title: Text("Görev tamamlandı"),
                    value: _checkBoxValue,
                    onChanged: (newValue) {
                      setState(() {
                        _checkBoxValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () => updateTodo(widget.editTodo.id),
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.blue),
                        child: Center(
                          child: Text(
                            'Görevi Güncelle',
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
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () => deleteTodo(widget.editTodo.id),
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.blue),
                        child: Center(
                          child: Text(
                            'Görevi Sil',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
