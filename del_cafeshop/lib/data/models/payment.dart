class Payment {
  final String orderId;
  final int amount;
  final String customerName;
  final String snapToken; // Token dari backend/API
  final DateTime paymentDate;
  

  Payment({
    required this.orderId,
    required this.amount,
    required this.customerName,
    required this.snapToken,
    required this.paymentDate,
    
  });

  // Contoh enum untuk status pembayaran
  

  // Untuk mengonversi dari JSON (misalnya dari API response)
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      orderId: json['orderId'],
      amount: json['amount'],
      customerName: json['customerName'],
      snapToken: json['snapToken'],
      paymentDate: DateTime.parse(json['paymentDate']),
      
    );
  }

  // Untuk mengonversi ke JSON (misalnya untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'customerName': customerName,
      'snapToken': snapToken,
      'paymentDate': paymentDate.toIso8601String(),
      
    };
  }
}
