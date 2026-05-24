import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/pss_circuit.dart';
import '../theme.dart';

class PssWebViewScreen extends StatefulWidget {
  final PssCircuit circuit;

  const PssWebViewScreen({super.key, required this.circuit});

  @override
  State<PssWebViewScreen> createState() => _PssWebViewScreenState();
}

class _PssWebViewScreenState extends State<PssWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _loadingProgress = 0;
          }),
          onProgress: (progress) => setState(() {
            _loadingProgress = progress;
          }),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (error) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.circuit.contentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TPColors.background,
      appBar: AppBar(
        backgroundColor: TPColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: TPColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.circuit.title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: TPColors.primary,
                letterSpacing: 1.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.circuit.busSection.isNotEmpty)
              Text(
                widget.circuit.busSection,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: TPColors.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                size: 20, color: TPColors.primary),
            onPressed: () => _controller.reload(),
            tooltip: 'Reload',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: _isLoading
              ? LinearProgressIndicator(
                  value: _loadingProgress / 100,
                  backgroundColor: TPColors.outlineVariant.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(TPColors.secondary),
                  minHeight: 3,
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
