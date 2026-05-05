/**
 * Rapor Yazma Modülü
 * Markdown raporlarını parse eder ve günceller
 */

import { readFileSync, writeFileSync, existsSync } from 'fs';
import { resolve } from 'path';

const ANALIZ_PATH = resolve('/home/abdullah/Desktop/git branch/AidatPanel/analiz_raporlari');

/**
 * Mevcut tarihi formatla
 */
function getFormattedDate() {
  const now = new Date();
  return now.toISOString().split('T')[0]; // YYYY-MM-DD
}

/**
 * Checklist satırını güncelle
 * - [ ] → - [x] veya tersi
 */
function updateChecklistItem(content, itemText, completed) {
  const checkboxPattern = new RegExp(
    `(- \\[([ x])\\]) (.*?${escapeRegex(itemText)}.*?)(?=\\n|$)`,
    'gi'
  );
  
  return content.replace(checkboxPattern, (match, checkbox, currentStatus, itemContent) => {
    const newStatus = completed ? 'x' : ' ';
    return `- [${newStatus}] ${itemContent}`;
  });
}

/**
 * Regex için string escape
 */
function escapeRegex(string) {
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

/**
 * Rapor dosyasındaki yüzde değerini güncelle
 */
function updatePercentage(content, context, newPercentage) {
  // "%XX ..." patternini bul ve güncelle (esnek: %75'i tamamlanmış veya %75 Tamamlandı)
  // suffix: kelimeler, boşluklar ve tırnak işaretleri
  const percentPattern = new RegExp(
    `(${escapeRegex(context)}.*?)%(\\d+)([\\w\\s'\\.]*)`,
    'gi'
  );
  
  return content.replace(percentPattern, (match, prefix, oldNum, suffix) => {
    // Eğer suffix 'tamam' içeriyorsa güncelle (tamamlandı/tamamlanmış/tamamlanmıştır)
    if (suffix.toLowerCase().includes('tamam') || prefix.toLowerCase().includes('faz')) {
      return `${prefix}%${newPercentage}${suffix}`;
    }
    return match;
  });
}

/**
 * "Son Güncelleme" tarihini güncelle
 */
function updateTimestamp(content) {
  const date = getFormattedDate();
  
  // **Son Güncelleme:** YYYY-MM-DD pattern
  return content.replace(
    /(\*\*Son Güncelleme:\*\*)\s*\d{4}-\d{2}-\d{2}/g,
    `$1 ${date}`
  );
}

/**
 * Analiz tarihini güncelle
 */
function updateAnalysisDate(content) {
  const date = getFormattedDate();
  
  return content.replace(
    /(## Analiz Tarihi\s*)\d{4}-\d{2}-\d{2}/g,
    `$1${date}`
  );
}

/**
 * Master Prompt analiz raporunu güncelle
 */
export function updateMasterPromptReport(featureStatus, phaseProgress) {
  const reportPath = resolve(ANALIZ_PATH, '1-master_prompt_analizi/1-ANALIZ_RAPORU.md');
  
  if (!existsSync(reportPath)) {
    return { success: false, error: 'Rapor dosyası bulunamadı' };
  }

  let content = readFileSync(reportPath, 'utf-8');

  // Faz 1 durumunu güncelle
  // Auth: register/login/refresh/logout tamamlandı (join yorumda ama o Faz 2'ye ait)
  // Building ve Apartment tamamen tamamlandı
  const authCoreCompleted = featureStatus.features.auth.matchedEndpoints >= 4; // 4 temel endpoint
  const faz1Completed = authCoreCompleted &&
                       featureStatus.features.building.status === 'completed' &&
                       featureStatus.features.apartment.status === 'completed';
  
  content = updateChecklistItem(content, 'Auth sistemi', faz1Completed);
  content = updateChecklistItem(content, 'Bina/Daire CRUD', faz1Completed);
  
  // Davet kodu durumu
  const inviteStatus = featureStatus.features.inviteCode.status;
  const inviteCompleted = inviteStatus === 'completed';
  const inviteInProgress = inviteStatus === 'in-progress';
  
  content = content.replace(
    /- \[([ x])\] (Davet kodu sistemi.*$)/m,
    inviteCompleted ? `- [x] $2 (Tamamlandı)` : 
    inviteInProgress ? `- [-] $2 (Devam ediyor)` : 
    `- [ ] $2 (başlanacak)`
  );

  // Faz 1 yüzdesini güncelle
  content = updatePercentage(content, 'Faz 1', phaseProgress.faz1);
  
  // Analiz tarihini güncelle
  content = updateAnalysisDate(content);
  content = updateTimestamp(content);

  // Dry-run modu: önce değişiklikleri göster
  const originalContent = readFileSync(reportPath, 'utf-8');
  const hasChanges = content !== originalContent;

  return {
    success: true,
    hasChanges,
    path: reportPath,
    newContent: content,
    diff: hasChanges ? generateDiff(originalContent, content) : null
  };
}

/**
 * Görev dağılımı raporunu güncelle
 */
export function updateGorevDagilimiReport(featureStatus, phaseProgress) {
  const reportPath = resolve(ANALIZ_PATH, '3-gorevdagilimi_analizi/1-ANALIZ_RAPORU.md');
  
  if (!existsSync(reportPath)) {
    return { success: false, error: 'Rapor dosyası bulunamadı' };
  }

  let content = readFileSync(reportPath, 'utf-8');

  // Abdullah'nın ilerlemesini güncelle
  const faz1Progress = phaseProgress.faz1;
  
  // "Abdullah'nın İlerlemesi" bölümündeki Faz 1 yüzdesini güncelle
  // Başlık: "### Abdullah'nın İlerlemesi" sonraki satırda "**Faz 1 Status:** %XX..."
  content = content.replace(
    /(Abdullah.*İlerlemesi.*\n\*\*Faz 1 Status:\*\* )%(\d+)/,
    `$1%${faz1Progress}`
  );

  // Davet kodu durumunu güncelle
  const inviteStatus = featureStatus.features.inviteCode.status;
  const inviteStatusText = inviteStatus === 'completed' ? 'Tamamlandı' :
                          inviteStatus === 'in-progress' ? 'Devam ediyor' :
                          'başlanacak';
  
  // Pattern 1: Faz 2 bölümündeki "- Davet kodu (Invite Code) üretim ve doğrulama..."
  // Hemen ardından gelen "- başlanacak|Devam ediyor|Tamamlandı 🔄" satırını güncelle
  content = content.replace(
    /(-\s*Davet\s+kodu\s*\([^)]+\).*?\n-\s*)(başlanacak|Devam ediyor|Tamamlandı)(\s+[🔄✅⏳])/is,
    `$1${inviteStatusText}$3`
  );
  
  // Pattern 2: İlerleme bölümündeki "- 🔄 Davet kodu (başlanacak)" satırı
  // Emoji sonrası parantez içindeki durum bilgisini güncelle
  // Not: 🔄 = \u{1F504}, ✅ = \u{2705}, ⏳ = \u{23F3}
  content = content.replace(
    /(-\s*[\u{1F504}\u{2705}\u{23F3}]\s*Davet\s+kodu\s*\()(başlanacak|Devam ediyor|Tamamlandı)(\))/iu,
    `$1${inviteStatusText}$3`
  );

  // Analiz tarihini güncelle
  content = updateAnalysisDate(content);
  content = updateTimestamp(content);

  const originalContent = readFileSync(reportPath, 'utf-8');
  const hasChanges = content !== originalContent;

  return {
    success: true,
    hasChanges,
    path: reportPath,
    newContent: content,
    diff: hasChanges ? generateDiff(originalContent, content) : null
  };
}

/**
 * AidatPanel raporunu güncelle (API endpoint tablosu)
 */
export function updateAidatPanelReport(featureStatus, phaseProgress, routeAnalysis) {
  const reportPath = resolve(ANALIZ_PATH, '4-aidatpanel_analizi/1-ANALIZ_RAPORU.md');
  
  if (!existsSync(reportPath)) {
    return { success: false, error: 'Rapor dosyası bulunamadı' };
  }

  let content = readFileSync(reportPath, 'utf-8');

  // Endpoint durumlarını güncelle
  // Örnek: POST /api/auth/register # Yönetici kaydı → ✅/⏳
  
  const endpointUpdates = [
    { pattern: /POST\s+\/api\/auth\/register.*$/, feature: 'auth', completed: true },
    { pattern: /POST\s+\/api\/auth\/login.*$/, feature: 'auth', completed: true },
    { pattern: /POST\s+\/api\/auth\/refresh.*$/, feature: 'auth', completed: true },
    { pattern: /POST\s+\/api\/auth\/logout.*$/, feature: 'auth', completed: true },
    { pattern: /POST\s+\/api\/auth\/join.*$/, feature: 'inviteCode', completed: false },
    { pattern: /GET\s+\/api\/buildings.*$/, feature: 'building', completed: true },
    { pattern: /POST\s+\/api\/buildings.*$/, feature: 'building', completed: true },
    { pattern: /GET\s+\/api\/buildings\/:id\/apartments.*$/, feature: 'apartment', completed: true },
    { pattern: /POST\s+\/api\/buildings\/:id\/apartments.*$/, feature: 'apartment', completed: true },
    { pattern: /PUT\s+\/api\/buildings\/:buildingId\/apartments\/:id.*$/, feature: 'apartment', completed: true },
    { pattern: /POST\s+\/api\/apartments\/:id\/invite-code.*$/, feature: 'inviteCode', completed: false },
    { pattern: /GET\s+\/api\/buildings\/:id\/dues.*$/, feature: 'due', completed: false },
    { pattern: /POST\s+\/api\/buildings\/:id\/dues\/bulk.*$/, feature: 'due', completed: false },
  ];

  for (const update of endpointUpdates) {
    const feature = featureStatus.features[update.feature];
    const status = update.completed || feature?.status === 'completed' ? '✅' :
                  feature?.status === 'in-progress' ? '🔄' : '⏳';
    
    content = content.replace(update.pattern, (match) => {
      // Mevcut durum işaretini kaldır ve yenisini ekle
      return match.replace(/[✅🔄⏳]$/, '').trimEnd() + ` ${status}`;
    });
  }

  // Faz 1 checklist'ini güncelle
  content = updateChecklistItem(content, 'Auth', featureStatus.features.auth.status === 'completed');
  content = updateChecklistItem(content, 'Bina ve daire CRUD', 
    featureStatus.features.building.status === 'completed' && 
    featureStatus.features.apartment.status === 'completed');
  content = updateChecklistItem(content, 'Davet kodu sistemi', 
    featureStatus.features.inviteCode.status === 'completed');
  
  // Davet kodu durum metnini güncelle (başlanacak → Devam ediyor → Tamamlandı)
  const inviteStatusText2 = featureStatus.features.inviteCode.status === 'completed' ? 'Tamamlandı' :
                           featureStatus.features.inviteCode.status === 'in-progress' ? 'Devam ediyor' :
                           'başlanacak';
  content = content.replace(
    /(-\s*\[.?\]\s*Davet\s+kodu\s+sistemi\s*\()[^)]+(\))/i,
    `$1${inviteStatusText2}$2`
  );

  // MVP yüzdelerini güncelle
  content = updatePercentage(content, 'Faz 1', phaseProgress.faz1);

  // Analiz tarihini güncelle
  content = updateAnalysisDate(content);
  content = updateTimestamp(content);

  const originalContent = readFileSync(reportPath, 'utf-8');
  const hasChanges = content !== originalContent;

  return {
    success: true,
    hasChanges,
    path: reportPath,
    newContent: content,
    diff: hasChanges ? generateDiff(originalContent, content) : null
  };
}

/**
 * Basit diff oluştur
 */
function generateDiff(original, updated) {
  const origLines = original.split('\n');
  const newLines = updated.split('\n');
  const changes = [];

  const maxLen = Math.max(origLines.length, newLines.length);
  
  for (let i = 0; i < maxLen; i++) {
    if (origLines[i] !== newLines[i]) {
      if (origLines[i] && !newLines.includes(origLines[i])) {
        changes.push({ type: 'removed', line: i + 1, content: origLines[i] });
      }
      if (newLines[i] && !origLines.includes(newLines[i])) {
        changes.push({ type: 'added', line: i + 1, content: newLines[i] });
      }
    }
  }

  return changes.slice(0, 20); // İlk 20 değişiklik
}

/**
 * Raporu dosyaya yaz
 */
export function writeReport(result, dryRun = true) {
  if (!result.success) {
    return { success: false, error: result.error };
  }

  if (dryRun) {
    return {
      success: true,
      dryRun: true,
      path: result.path,
      message: 'Dry-run modu: Değişiklikler yazılmadı',
      diff: result.diff
    };
  }

  try {
    writeFileSync(result.path, result.newContent, 'utf-8');
    return {
      success: true,
      dryRun: false,
      path: result.path,
      message: 'Rapor başarıyla güncellendi'
    };
  } catch (error) {
    return {
      success: false,
      error: `Dosya yazma hatası: ${error.message}`
    };
  }
}

export default {
  updateMasterPromptReport,
  updateGorevDagilimiReport,
  updateAidatPanelReport,
  writeReport
};
