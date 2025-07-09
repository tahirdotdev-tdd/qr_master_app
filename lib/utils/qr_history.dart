import 'package:shared_preferences/shared_preferences.dart';

const _historyKey = 'qr_history';

Future<List<String>> getQrHistory() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(_historyKey) ?? [];
}

Future<void> addToQrHistory(String code) async {
  final prefs = await SharedPreferences.getInstance();
  final history = prefs.getStringList(_historyKey) ?? [];
  // Add latest at top, remove duplicates
  history.remove(code);
  history.insert(0, code);
  // Keep only the latest 50 scans for performance and UI clarity
  if (history.length > 50) {
    history.removeRange(50, history.length);
  }
  await prefs.setStringList(_historyKey, history);
}

Future<void> clearQrHistory() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_historyKey);
}