# AGENT KURALLARI

## Zorunlu Kısıtlamalar
- **KULLANICI İZİ OLMADAN ASLA YENİ SÜRÜM OLUŞTURMA** - Sürüm değişiklikleri SADECE açık kullanıcı onayıyla
- **mobile/flutter-core branch'inde KAL** - Açık talimat olmadan ASLA branch değiştirme
- **Kullanıcı onayı olmadan backend entegrasyonu YOK** - İzin olmadan ASLA backend kodu ekleme
- **Güvensiz komutları ASLA otomatik çalıştırma** - Potansiyel olarak yıkıcı komutları çalıştırmadan önce kullanıcı onayı iste

## Bitirmeden Önce Doğrulama
- **Flutter clean + pub get** - Önemli build sorunlarından önce çalıştır
- **Git status kontrolü** - Önemli operasyonlardan önce commit edilmemiş değişiklik olmadığından emin ol
- **Branch doğrula** - Herhangi bir işten önce hala mobile/flutter-core'de olduğundan emin ol

## Repo'ya Özel Kurallar
- **Dummy data mevcut** - Backend hazır olana kadar tüm backend çağrıları dummy data kullanır
- **Sürüm formatı** - pubspec.yaml'da semantic versioning (0.0.7+1) kullan
- **Türkçe dili** - Tüm UI metinleri Türkçe olmalı, teknik jargon yok
- **50+ yaş kısıtı** - Minimum 16sp font, 48dp dokunma hedefleri, BottomNavigationBar zorunlu

## Önemli Konumlar (sadece belirgin olmayanlar)
- **mobile/lib/** - Ana Flutter uygulama kodu
- **planning/** - Dokümantasyon ve prompt'lar
- **mobile/pubspec.yaml** - Sürüm ve bağımlılıklar
- **mobile/android/app/build.gradle** - Android yapılandırması

## Değişiklik Güvenliği Kuralları
- **Dummy data koru** - Açıkça istenmeden dummy implementasyonları kaldırma
- **Sürüm tutarlılığını koru** - pubspec.yaml sürümünü app constants ile senkronize tut
- **emulator-5554'de test et** - Birincil test cihazı Android emülatörüdür
- **Debug modu tercih edilir** - Release açıkça istenmeden geliştirme için debug mod kullan

## Bilinen Sorunlar
- **Kotlin daemon çökmeleri** - Derleme başarısız olursa, `flutter clean` çalıştırın ve Android Studio'yu yeniden başlatın
- **Java süreç çakışmaları** - Build takılıyorsa java.exe süreçlerini sonlandırın
- **Windows'ta path sorunları** - Path'lerde forward slash kullanın, özel karakterlerden kaçının
- **Hot reload sınırlamaları** - Bazı değişiklikler sadece hot reload değil, tam yeniden başlatma gerektirir
