import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../utils/qr_history.dart';

class QrResultScreen extends StatelessWidget {
  final String result;

  const QrResultScreen({super.key, required this.result});

  bool get _isUrl {
    final uri = Uri.tryParse(
      result.startsWith('http') ? result : 'https://${result.trim()}',
    );
    return uri != null && uri.isAbsolute;
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      final fixedUrl = url.trim().startsWith('http')
          ? url.trim()
          : 'https://${url.trim()}';
      final uri = Uri.parse(fixedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open the link")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error opening link")));
    }
  }

  void _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard!"), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    addToQrHistory(result);

    final bool isLink = _isUrl;

    // Responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;
    final double maxCardWidth = (screenSize.width * 0.95).clamp(260.0, 420.0);
    final double cardPadding = (screenSize.width * 0.06).clamp(14.0, 32.0);
    final double iconSize = (screenSize.shortestSide * 0.13).clamp(36.0, 64.0);

    // Modern, minimal color palette
    const background = Color(0xFFF7F9FB);
    const primary = Color(0xFF1B263B);
    const accent = Color(0xFF62B6CB);
    const cardColor = Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "QR Result",
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            fontSize: (screenSize.width * 0.052).clamp(17.0, 22.0),
          ),
        ),
        iconTheme: const IconThemeData(color: primary),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: isPortrait ? 30 : 12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: cardPadding + 4,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_2_rounded, color: accent, size: iconSize),
                const SizedBox(height: 16),
                Text(
                  "Scanned Result",
                  style: TextStyle(
                    fontSize: (screenSize.width * 0.045).clamp(15.0, 20.0),
                    color: primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Scrollable Selectable Text for long values
                Container(
                  constraints: BoxConstraints(
                    maxHeight: screenSize.height * 0.28,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SelectableText(
                        result,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (screenSize.width * 0.042).clamp(13.0, 17.0),
                          color: primary.withOpacity(0.85),
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(context, result),
                        icon: const Icon(Icons.copy_rounded, size: 18, color: accent),
                        label: Text(
                          "Copy",
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w600,
                            fontSize: (screenSize.width * 0.040).clamp(12.0, 15.5),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: accent, width: 1.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: (screenSize.width * 0.035).clamp(8.0, 14.0),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    if (isLink) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              vertical: (screenSize.width * 0.038).clamp(11.0, 18.0),

                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: (screenSize.width * 0.041).clamp(13.0, 16.0),
                            ),
                          ),
                          icon: const Icon(Icons.open_in_browser_rounded),
                          label: const Text("Browse"),
                          onPressed: () => _launchURL(context, result),
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}