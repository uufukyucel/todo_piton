import 'package:flutter/material.dart';
import 'package:piton_todo/database/DBProvider.dart';
import 'package:piton_todo/models/todo_model.dart';
import 'package:piton_todo/screens/edit_task.dart';

class WeeklyFrag extends StatefulWidget {
  @override
  _WeeklyFragState createState() => _WeeklyFragState();
}

class _WeeklyFragState extends State<WeeklyFrag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DBProvider.db.getTodosWeekly(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print(snapshot.data);
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (snapshot.data[index] != null) {
                Todo todo = snapshot.data[index];
                return Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(todo.title ?? ""), // Başlık
                        subtitle: Text(todo.desc ?? ""), // Açıklama
                        leading: Icon(
                          Icons.check,
                          color:
                              // Görev tamamlandıysa yeşil tik değilse gri tik gösterir
                              (todo.checked == 1) ? Colors.green : Colors.grey,
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.edit),
                            // Görevi düzenlemek için eklenen kalem ikonu
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditTask(
                                          editTodo: todo,
                                        )))),
                      ),
                    )
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}
