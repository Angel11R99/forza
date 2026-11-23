import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_DO');
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const ForzaApp());
}
