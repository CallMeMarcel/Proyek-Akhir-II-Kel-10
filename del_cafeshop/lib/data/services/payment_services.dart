Future<String?> createTransaction({
  required String orderId,
  required int amount,
  required String customerName,
}) async {
  try {
    // Simulasi ambil token pembayaran dari backend
    final snapToken = 'generatedSnapToken'; // Ganti dengan real API response
    return snapToken;
  } catch (e) {
    print('Error creating transaction: $e');
    return null;
  }
}
