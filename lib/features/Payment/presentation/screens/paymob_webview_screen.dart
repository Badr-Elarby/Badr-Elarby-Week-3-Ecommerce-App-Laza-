import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymobWebViewScreen extends StatefulWidget {
  final String iframeUrl;

  const PaymobWebViewScreen({super.key, required this.iframeUrl});

  @override
  State<PaymobWebViewScreen> createState() => _PaymobWebViewScreenState();
}

class _PaymobWebViewScreenState extends State<PaymobWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            _checkUrlForResult(url);
          },
          onPageFinished: (url) => setState(() => _isLoading = false),
          onNavigationRequest: (req) {
            _checkUrlForResult(req.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.iframeUrl));
  }

  void _checkUrlForResult(String? url) {
    if (url == null || !mounted) return;

    final normalized = url.toLowerCase();
    // Paymob iframe usually redirects to your merchant redirect URL with params.
    // Detect common success indicators. Adjust if your redirect uses different params.
    if (normalized.contains('success=true') ||
        normalized.contains('status=success')) {
      if (mounted) {
        context.pop<bool>(true);
      }
    } else if (normalized.contains('failure') ||
        normalized.contains('cancel')) {
      if (mounted) {
        context.pop<bool>(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (mounted) {
              context.pop<bool>(false);
            }
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
