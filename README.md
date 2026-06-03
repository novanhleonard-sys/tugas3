# Crypto Market App

Aplikasi mobile Flutter untuk menampilkan data cryptocurrency realtime.

## API
- **Endpoint:** https://api.coinlore.net/api/tickers/
- **Method:** GET

## Fitur
- Daftar cryptocurrency (rank, nama, simbol, harga USD)
- Search berdasarkan nama / simbol
- Pull to refresh
- Skeleton loading state
- Error state + tombol retry

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

## Struktur Project

```
lib/
├── main.dart
├── models/crypto.dart
├── services/api_service.dart
├── screens/home_screen.dart
└── widgets/crypto_tile.dart
```

## Tugas Praktikum
MSIM4401 - Tugas 03
Novan Hani Leonard - 045110332
