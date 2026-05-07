#!/usr/bin/env python3
"""
Otomatik L10n Script
Yeni eklenen Dart dosyalarındaki hardcoded Türkçe string'leri extract eder,
İngilizce'ye çevirir ve JSON dosyalarına ekler.
"""

import re
import json
import subprocess
from pathlib import Path
from typing import List, Dict, Tuple

# Google Translate API yerine manuel çeviri için placeholder
# Ücretsiz API limiti nedeniyle manuel yaklaşım

class L10nExtractor:
    def __init__(self, mobile_path: Path):
        self.mobile_path = mobile_path
        self.tr_json_path = mobile_path / "lib" / "l10n" / "strings_tr.i18n.json"
        self.en_json_path = mobile_path / "lib" / "l10n" / "strings_en.i18n.json"
        
    def load_json(self, path: Path) -> Dict:
        """JSON dosyasını yükle"""
        with open(path, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    def save_json(self, path: Path, data: Dict):
        """JSON dosyasını kaydet"""
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
    
    def extract_hardcoded_strings(self, dart_file: Path) -> List[str]:
        """Dart dosyasından hardcoded string'leri extract et"""
        with open(dart_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Text() içindeki string'leri bul
        text_pattern = r'Text\s*\(\s*[\'"](.*?)[\'"]'
        matches = re.findall(text_pattern, content)
        
        # String literal'leri bul (tek ve çift tırnaklı)
        string_pattern = r'(?<!context\.t\.)[\'"]([^\'"]{3,})[\'"]'
        string_matches = re.findall(string_pattern, content)
        
        # Tekrarları kaldır
        unique_strings = list(set(matches + string_matches))
        
        # context.t kullanmayan ve uzunluk > 2 olan string'leri filtrele
        filtered = [s for s in unique_strings if len(s) > 2 and not s.startswith('context.t')]
        
        return filtered
    
    def generate_key(self, text: str) -> str:
        """String'den camelCase key oluştur"""
        # Türkçe karakterleri İngilizce'ye çevir
        tr_to_en = {
            'ş': 's', 'Ş': 'S',
            'ı': 'i', 'İ': 'I',
            'ğ': 'g', 'Ğ': 'G',
            'ü': 'u', 'Ü': 'U',
            'ö': 'o', 'Ö': 'O',
            'ç': 'c', 'Ç': 'C'
        }
        
        cleaned = text
        for tr, en in tr_to_en.items():
            cleaned = cleaned.replace(tr, en)
        
        # Boşlukları kaldır ve camelCase yap
        words = cleaned.split()
        if not words:
            return 'unknown'
        
        # İlk kelime küçük harf, diğerleri büyük harfle başlasın
        key = words[0].lower()
        for word in words[1:]:
            key += word.capitalize()
        
        # Özel karakterleri kaldır
        key = re.sub(r'[^a-zA-Z0-9]', '', key)
        
        return key
    
    def translate_to_english(self, text: str) -> str:
        """
        Türkçe string'i İngilizce'ye çevir
        Şu an için placeholder - manuel çeviri gerekli
        """
        # Google Translate API yerine manuel çeviri
        # İleride API entegrasyonu yapılabilir
        return f"[TRANSLATE: {text}]"
    
    def add_to_json(self, data: Dict, key: str, tr_value: str, en_value: str) -> Dict:
        """JSON verisine yeni key ekle"""
        # common namespace altına ekle
        if 'common' not in data:
            data['common'] = {}
        
        data['common'][key] = tr_value
        return data
    
    def replace_in_dart(self, dart_file: Path, old_text: str, new_text: str):
        """Dart dosyasında string'i değiştir"""
        with open(dart_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # String'i değiştir
        content = content.replace(f"'{old_text}'", f"context.t.common.{new_text}")
        content = content.replace(f'"{old_text}"', f"context.t.common.{new_text}")
        
        # Import ekle (yoksa)
        if 'import \'../../../../l10n/strings.g.dart\';' not in content:
            # İlk import satırından önce ekle
            lines = content.split('\n')
            import_line = "import '../../../../l10n/strings.g.dart';"
            
            # İlk import'u bul
            for i, line in enumerate(lines):
                if line.strip().startswith('import '):
                    lines.insert(i, import_line)
                    break
            
            content = '\n'.join(lines)
        
        with open(dart_file, 'w', encoding='utf-8') as f:
            f.write(content)
    
    def run_slang(self):
        """Slang çalıştır"""
        try:
            result = subprocess.run(
                ['dart', 'run', 'slang'],
                cwd=self.mobile_path,
                capture_output=True,
                text=True
            )
            print(f"Slang output: {result.stdout}")
            if result.stderr:
                print(f"Slang error: {result.stderr}")
        except Exception as e:
            print(f"Slang çalıştırma hatası: {e}")
    
    def process_file(self, dart_file: Path):
        """Tek bir Dart dosyasını işle"""
        print(f"\nİşleniyor: {dart_file}")
        
        # Hardcoded string'leri extract et
        strings = self.extract_hardcoded_strings(dart_file)
        print(f"Bulunan string'ler: {len(strings)}")
        
        if not strings:
            print("Hardcoded string bulunamadı.")
            return
        
        # JSON dosyalarını yükle
        tr_data = self.load_json(self.tr_json_path)
        en_data = self.load_json(self.en_json_path)
        
        # Her string için işlem yap
        for text in strings:
            key = self.generate_key(text)
            en_text = self.translate_to_english(text)
            
            print(f"Key: {key}, TR: {text}, EN: {en_text}")
            
            # JSON'a ekle
            tr_data = self.add_to_json(tr_data, key, text, en_text)
            en_data = self.add_to_json(en_data, key, en_text, en_text)
            
            # Dart dosyasında değiştir
            self.replace_in_dart(dart_file, text, key)
        
        # JSON dosyalarını kaydet
        self.save_json(self.tr_json_path, tr_data)
        self.save_json(self.en_json_path, en_data)
        
        print("JSON dosyaları güncellendi.")
        
        # Slang çalıştır
        self.run_slang()


def main():
    """Ana fonksiyon"""
    mobile_path = Path(__file__).parent.parent
    extractor = L10nExtractor(mobile_path)
    
    # Test için tek bir dosya
    test_file = mobile_path / "lib" / "features" / "buildings" / "presentation" / "screens" / "manager_dashboard_screen.dart"
    
    if test_file.exists():
        extractor.process_file(test_file)
    else:
        print(f"Dosya bulunamadı: {test_file}")


if __name__ == "__main__":
    main()
