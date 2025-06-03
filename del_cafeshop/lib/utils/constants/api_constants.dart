class APIConstants {
  

  // API Endpoint untuk backend (misalnya Node.js atau Laravel API)
  static const String baseUrl = 'http://192.168.79.183:8000';

  // Secret API Key (pastikan hanya digunakan di backend, bukan frontend)
  static const String tSecretAPIKey = "cwt_live_b2da6ds3df3e785v8ddc59198f7615ba";

  // Contoh endpoint spesifik (biar gampang panggil di banyak tempat)
  static const String resendVerificationEmail = '$baseUrl/resend-verification-email';
}
