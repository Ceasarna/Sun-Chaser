import 'package:mysql1/mysql1.dart';

class mysql{
  static String host = 'mysql.dsv.su.se', user = 'maen0574', password = 'iT0aeth8ofib', db = 'maen0574';

  static int port = 3306;

  mysql();

  Future<MySqlConnection> getConnection() async{
    var settings = ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db
    );
    return await MySqlConnection.connect(settings);
  }

}