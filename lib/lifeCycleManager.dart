import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class LifecycleWatcher extends StatefulWidget {

  final Widget child;

  LifecycleWatcher({this.child});

  @override
  _LifecycleWatcherState createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;
  final LastSeenDBManager lastSeenDBManager = LastSeenDBManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });

    if(_lastLifecycleState != AppLifecycleState.resumed)
      {
        LastSeen lastSeen = LastSeen(
          timestamp: DateTime.now().millisecondsSinceEpoch,
          state: _lastLifecycleState.toString(),
        );

        lastSeenDBManager.insertLastSeen(lastSeen);
      }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


class LastSeen {
  final int timestamp;
  final String state;

  LastSeen({this.timestamp, this.state});

  Map<String, dynamic> toMap() {
    return {
      "timestamp": timestamp,
      "state": state,
    };
  }
}

class LastSeenDBManager {
  Database _database;

  Future openDB() async {
    if (_database == null)
    {
      _database = await openDatabase(
          join(await getDatabasesPath(), "lastSeen.db"),
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                "CREATE TABLE lastSeen (timestamp INTEGER PRIMARY KEY, state TEXT)"
            );
          }
      );
    }
  }

  Future<int> insertLastSeen(LastSeen lastSeen) async {
    await openDB();
    return await _database.insert('lastSeen', lastSeen.toMap());
  }

  Future<int> getLastSeen() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM lastSeen ORDER BY timestamp DESC LIMIT 1');

    return maps.length == 0? DateTime.now().millisecondsSinceEpoch : maps[0]['timestamp'];
  }
}