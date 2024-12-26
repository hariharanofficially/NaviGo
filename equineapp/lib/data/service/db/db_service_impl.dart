
import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/transaction.dart' as appModel;
import 'db_service.dart';

final String t_transactions = 'transactions';
final String c_trackerdeviceid = 'trackerDeviceId';
final String c_eventid = 'eventId';
final String c_participantid = 'participantId';
final String c_time = 'dateTime';
final String c_speed = 'speed';
final String c_hr = 'heartRate';
final String c_distance = 'distance';
final String c_latitude = 'latitude';
final String c_longitude = 'longitude';

class DbServiceImpl extends DbService {
  late Database db;
  Logger logger = Logger();

  @override
  Future<void> open() async {
    db = await initialize();
  }

  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  //WidgetsFlutterBinding.ensureInitialized();
  @override
  Future<Database> initialize() async {
    //String dbpath = await getDatabasesPath();
    Directory dbPath = await getApplicationDocumentsDirectory();
   // logger.d(" ====== db path ${dbPath.path}");
    return openDatabase(
      join(dbPath.path, 'equineapp_trans_db_v1.db'),
      // When the database is first created, create a table to store transactions.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db
            .execute('''CREATE TABLE $t_transactions(id INTEGER PRIMARY KEY, 
            $c_trackerdeviceid TEXT, $c_eventid TEXT, $c_participantid TEXT, $c_time TEXT,
            $c_speed TEXT, $c_hr TEXT, $c_distance TEXT, $c_latitude TEXT, $c_longitude TEXT)''');
      },
      version: 1,
    );
  }

  @override
  Future<appModel.Transaction> insert(appModel.Transaction tran) async {
    await open();
    logger.d("=== inserting row to db");
    tran.id = await db.insert(t_transactions, tran.toMap());
    logger.d("=== inserted row id $tran.id");
    close();
    return tran;
  }

  @override
  Future<List<appModel.Transaction>> get(int limit) async {
    await open();

    var count = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $t_transactions')) ??
        0;
    if (count > 0) {
      logger.d("=== table row count $count");
    }
    List<appModel.Transaction> transactions = [];
    List<Map> list =
        await db.rawQuery('SELECT * FROM $t_transactions limit $limit');
    for (Map l in list) {
      transactions.add(appModel.Transaction.fromMap(l));
    }
    close();
    return transactions;
  }

  @override
  Future<int> delete(int id) async {
    await open();
    logger.d("=== deleting row id $id");
    int rowid =
        await db.delete(t_transactions, where: 'id = ?', whereArgs: [id]);
    await close();
    return rowid;
  }

  @override
  Future<void> close() async {
    db.close();
  }
}
