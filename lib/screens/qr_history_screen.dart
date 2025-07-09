import 'package:flutter/material.dart';
import 'package:qr_scanner/utils/qr_history.dart';
import 'package:qr_scanner/screens/qr_result_screen.dart';

class QrHistoryScreen extends StatefulWidget {
  const QrHistoryScreen({super.key});
  @override
  State<QrHistoryScreen> createState() => _QrHistoryScreenState();
}

class _QrHistoryScreenState extends State<QrHistoryScreen> {
  late Future<List<String>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = getQrHistory();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureHistory = getQrHistory();
    });
    await _futureHistory;
  }

  void _clearHistory() async {
    await clearQrHistory();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;
    final double horizontalPadding = (screenSize.width * 0.06).clamp(12.0, 32.0);

    const background = Color(0xFFF7F9FB);
    const primary = Color(0xFF1B263B);
    const accent = Color(0xFF62B6CB);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Scan History",
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
            fontSize: (screenSize.width * 0.048).clamp(18.0, 23.0),
          ),
        ),
        iconTheme: const IconThemeData(color: primary),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: "Clear History",
            onPressed: () async {
              final confirmed = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    "Clear all history?",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w700,
                      fontSize: (screenSize.width * 0.048).clamp(17.0, 20.0),
                    ),
                  ),
                  content: Text(
                    "This will remove all scan records.",
                    style: TextStyle(
                      color: primary,
                      fontSize: (screenSize.width * 0.042).clamp(14.0, 16.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        foregroundColor: primary,
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      child: const Text("Clear"),
                    ),
                  ],
                ),
              );
              if (confirmed == true) _clearHistory();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _futureHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accent));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No scan history yet.",
                style: TextStyle(
                  color: primary.withOpacity(0.7),
                  fontSize: (screenSize.width * 0.045).clamp(14.0, 19.0),
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          final history = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isPortrait ? 14 : 8,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0x11000000)),
              itemBuilder: (context, idx) {
                final code = history[idx];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => QrResultScreen(result: code)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: accent.withOpacity(0.14),
                          child: Icon(Icons.qr_code_2_rounded, color: accent, size: 22),
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          code.length > 64 ? "${code.substring(0, 64)}..." : code,
                          style: TextStyle(
                            color: primary,
                            fontSize: (screenSize.width * 0.042).clamp(14.0, 17.0),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded, color: primary),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}