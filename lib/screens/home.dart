import 'package:flutter/material.dart';
import 'package:piton_todo/fragments/all.dart';
import 'package:piton_todo/fragments/daily.dart';
import 'package:piton_todo/fragments/monthly.dart';
import 'package:piton_todo/fragments/weekly.dart';
import 'package:piton_todo/screens/add_task.dart';

class HomePage extends StatelessWidget {
  // Tab bar menülerinin içerikleri. Her indis sekmeyi belirtir.
  List<Widget> fragments = [
    AllFrag(), // Tüm verileri gösteren ilk sekme
    DailyFrag(), // Günlük verileri gösteren ikinci sekme
    WeeklyFrag(), // Haftalık verileri gösteren üçüncü sekme
    MonthlyFrag() // Aylık verileri gösteren dördüncü sekme
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tasks PITON'),
          bottom: TabBar(
            tabs: [
              /* Sekme isimleri */
              Tab(text: 'Hepsi'),
              Tab(text: 'Günlük'),
              Tab(text: 'Haftalık'),
              Tab(text: 'Aylık'),
            ],
          ),
        ),
        /* sekme içerik görüntüleyicisi list olan fragments'ten almakta */
        body: TabBarView(
          children: fragments,
        ),
        // Yüzen buton
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask())),
          // Yüzen butona tıklandığında ekleme yapılacak ilgili sayfa yönlendirir.
          tooltip: 'Add Task', // Yüzen buton ipucu
          child: Icon(Icons.add), // Yüzen buton ikonu
        ),
      ),
    );
  }
}
