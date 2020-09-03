import 'package:piton_todo/database/DBProvider.dart';

// Görevler için sürekli kod yazmaktansa bir sınıf oluşturduk
class Todo {
  int id; // otomatik atama
  String title; // başlık
  String desc; // açıklama
  String type; // tipi
  int checked; // kontrol tiki

  Todo({this.id, this.title, this.desc, this.type, this.checked});

  Map<String, dynamic> toMap() {
    /* map widget aracılığıyla sınıf olarak gönderdiğimiz verileri kaydediyoruz */
    var map = <String, dynamic>{
      DBProvider.COLUMN_TITLE: title,
      DBProvider.COLUMN_DESC: desc,
      DBProvider.COLUMN_TYPE: type,
      DBProvider.COLUMN_CHECKED: checked
    };
    // id varsa yani böyle bir veri varsa
    if (id != null) {
      map[DBProvider.COLUMN_ID] = id;
    }
    return map;
  }

  // map olarak çevirdiğimiz verileri görüntülerken tekrar data.id
  // sınıf şeklinde kullanmamızı sağlar
  Todo.fromMap(Map<String, dynamic> map) {
    id = map[DBProvider.COLUMN_ID];
    title = map[DBProvider.COLUMN_TITLE];
    desc = map[DBProvider.COLUMN_DESC];
    type = map[DBProvider.COLUMN_TYPE];
    checked = map[DBProvider.COLUMN_CHECKED];
  }
}
