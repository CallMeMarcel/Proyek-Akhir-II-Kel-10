import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String snapToken;

  const PaymentPage({super.key, required this.snapToken});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    print('Snap Token: ${widget.snapToken}');
    if (widget.snapToken.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token pembayaran tidak valid'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, {'status': 'error'});
      });
      return;
    }

    final snapUrl = 'https://app.midtrans.com/snap/v2/vtweb/${widget.snapToken}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started: $url');

            // Cek apakah Midtrans sudah mengembalikan ke redirect URL
            if (url.contains('transaction_status=')) {
              Uri uri = Uri.parse(url);
              String? status = uri.queryParameters['transaction_status'];

              // Sesuaikan response berdasarkan status transaksi
              if (status == 'settlement') {
                Navigator.pop(context, {'status': 'success'});
              } else if (status == 'pending') {
                Navigator.pop(context, {'status': 'pending'});
              } else if (status == 'deny' || status == 'cancel' || status == 'expire') {
                Navigator.pop(context, {'status': 'failed'});
              }
            }
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Webview error: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal memuat halaman pembayaran: ${error.description}'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(snapUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bayar Sekarang')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
