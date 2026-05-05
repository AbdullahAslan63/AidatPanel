#!/usr/bin/env node

/**
 * AidatPanel Analiz Rapor Güncelleme Scripti
 * 
 * Kullanım:
 *   node scripts/update-reports.js           # Dry-run modu
 *   node scripts/update-reports.js --write   # Gerçek güncelleme
 *   node scripts/update-reports.js --status  # Sadece durum göster
 * 
 * Bu script:
 *   1. Backend kodunu analiz eder
 *   2. Tamamlanmış endpoint'leri tespit eder
 *   3. Analiz raporlarını günceller
 *   4. Faz ilerleme yüzdelerini hesaplar
 */

import { 
  checkFeatureStatus, 
  calculatePhaseProgress,
  analyzeControllers,
  analyzeRoutes 
} from './analyzers/backend-analyzer.js';
import { 
  updateMasterPromptReport,
  updateGorevDagilimiReport, 
  updateAidatPanelReport,
  writeReport 
} from './analyzers/report-writer.js';

// Renkli output için ANSI kodları
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  cyan: '\x1b[36m',
  gray: '\x1b[90m'
};

function colorize(text, color) {
  return `${colors[color]}${text}${colors.reset}`;
}

function printHeader(text) {
  console.log('\n' + colorize('═'.repeat(60), 'cyan'));
  console.log(colorize(`  ${text}`, 'bright'));
  console.log(colorize('═'.repeat(60), 'cyan') + '\n');
}

function printSection(text) {
  console.log('\n' + colorize(`▸ ${text}`, 'yellow'));
  console.log(colorize('-'.repeat(50), 'gray'));
}

// Komut satırı argümanlarını parse et
const args = process.argv.slice(2);
const shouldWrite = args.includes('--write') || args.includes('-w');
const showStatusOnly = args.includes('--status') || args.includes('-s');
const showHelp = args.includes('--help') || args.includes('-h');

if (showHelp) {
  console.log(`
${colorize('AidatPanel Rapor Güncelleme Scripti', 'bright')}

Kullanım:
  node scripts/update-reports.js [seçenekler]

Seçenekler:
  --write, -w     Raporları gerçekten güncelle (dry-run değil)
  --status, -s    Sadece mevcut durumu göster, raporları güncelleme
  --help, -h      Bu yardım mesajını göster

Örnekler:
  node scripts/update-reports.js           # Değişiklikleri önizle
  node scripts/update-reports.js --write   # Raporları güncelle
  node scripts/update-reports.js --status  # Durum özetini göster
`);
  process.exit(0);
}

async function main() {
  printHeader('AidatPanel - Analiz Rapor Güncelleme');

  // 1. Backend analizi yap
  printSection('Backend Kod Analizi');
  
  const controllerAnalysis = analyzeControllers();
  const routeAnalysis = analyzeRoutes();
  const featureStatus = checkFeatureStatus();
  const phaseProgress = calculatePhaseProgress();

  console.log(colorize(`Controller Dosyaları:`, 'bright'), controllerAnalysis.totalFiles);
  console.log(colorize(`Route Dosyaları:`, 'bright'), routeAnalysis.totalFiles);
  
  console.log('\n' + colorize('Tamamlanan Özellikler:', 'green'));
  const completedFeatures = Object.entries(featureStatus.features)
    .filter(([_, f]) => f.status === 'completed');
  completedFeatures.forEach(([key, f]) => {
    console.log(`  ✅ ${f.description}`);
  });

  if (featureStatus.summary.inProgress > 0) {
    console.log('\n' + colorize('Devam Eden Özellikler:', 'yellow'));
    Object.entries(featureStatus.features)
      .filter(([_, f]) => f.status === 'in-progress')
      .forEach(([key, f]) => {
        console.log(`  🔄 ${f.description} (${f.matchedEndpoints}/${f.totalRequired})`);
        if (f.commentedFunctions.length > 0) {
          console.log(`     └─ Yorumda: ${f.commentedFunctions.join(', ')}`);
        }
      });
  }

  if (featureStatus.summary.notStarted > 0) {
    console.log('\n' + colorize('Başlanmamış Özellikler:', 'red'));
    Object.entries(featureStatus.features)
      .filter(([_, f]) => f.status === 'not-started')
      .forEach(([key, f]) => {
        console.log(`  ⏳ ${f.description}`);
      });
  }

  // 2. Faz ilerlemesini göster
  printSection('Faz İlerleme Durumu');
  
  const faz1Bar = renderProgressBar(phaseProgress.faz1, 20);
  const faz2Bar = renderProgressBar(phaseProgress.faz2, 20);
  const faz3Bar = renderProgressBar(phaseProgress.faz3, 20);

  const faz1Color = phaseProgress.faz1 >= 80 ? 'green' : phaseProgress.faz1 >= 50 ? 'yellow' : 'red';
  const faz2Color = phaseProgress.faz2 >= 50 ? 'green' : phaseProgress.faz2 >= 25 ? 'yellow' : 'red';
  const faz3Color = phaseProgress.faz3 >= 30 ? 'green' : phaseProgress.faz3 >= 10 ? 'yellow' : 'red';

  console.log(`Faz 1 (Temel Altyapı)  ${faz1Bar} ${colorize(phaseProgress.faz1 + '%', faz1Color)}`);
  console.log(`Faz 2 (Aidat/Onboard)  ${faz2Bar} ${colorize(phaseProgress.faz2 + '%', faz2Color)}`);
  console.log(`Faz 3 (Gider/Rapor)    ${faz3Bar} ${colorize(phaseProgress.faz3 + '%', faz3Color)}`);

  // Sadece durum göster modu
  if (showStatusOnly) {
    console.log('\n' + colorize('Durum gösterimi tamamlandı. Raporlar güncellenmedi.', 'gray'));
    process.exit(0);
  }

  // 3. Raporları güncelle
  printSection('Rapor Güncellemeleri');

  const reports = [
    { name: 'Master Prompt Analizi', updater: updateMasterPromptReport },
    { name: 'Görev Dağılımı', updater: updateGorevDagilimiReport },
    { name: 'AidatPanel Master', updater: updateAidatPanelReport }
  ];

  const results = [];

  for (const report of reports) {
    process.stdout.write(`${colorize('Güncelleniyor:', 'gray')} ${report.name}... `);
    
    const result = report.updater(featureStatus, phaseProgress, routeAnalysis);
    const writeResult = writeReport(result, !shouldWrite);
    
    results.push({ name: report.name, ...writeResult });
    
    if (writeResult.success) {
      if (writeResult.dryRun) {
        if (result.hasChanges) {
          console.log(colorize('Değişiklikler hazır', 'yellow'));
        } else {
          console.log(colorize('Güncel', 'green'));
        }
      } else {
        console.log(colorize('Güncellendi ✓', 'green'));
      }
    } else {
      console.log(colorize(`Hata: ${writeResult.error}`, 'red'));
    }
  }

  // 4. Özet
  printSection('Özet');

  const changedReports = results.filter(r => r.hasChanges);
  
  if (changedReports.length === 0) {
    console.log(colorize('Tüm raporlar güncel. Değişiklik yok.', 'green'));
  } else if (shouldWrite) {
    console.log(colorize(`${changedReports.length} rapor güncellendi:`, 'green'));
    changedReports.forEach(r => {
      console.log(`  ✓ ${r.name}`);
    });
  } else {
    console.log(colorize(`${changedReports.length} raporda değişiklik hazır:`, 'yellow'));
    changedReports.forEach(r => {
      console.log(`  • ${r.name}`);
    });
    console.log('\n' + colorize('Değişiklikleri uygulamak için:', 'bright'));
    console.log(colorize('  node scripts/update-reports.js --write', 'cyan'));
  }

  // 5. Detaylı değişiklikler (varsa)
  if (!shouldWrite && changedReports.length > 0 && args.includes('--verbose')) {
    printSection('Detaylı Değişiklikler');
    
    for (const report of changedReports) {
      if (report.diff && report.diff.length > 0) {
        console.log(`\n${colorize(report.name, 'bright')}:`);
        report.diff.forEach(change => {
          const prefix = change.type === 'added' ? colorize('+', 'green') : colorize('-', 'red');
          console.log(`  ${prefix} ${change.content.substring(0, 80)}`);
        });
      }
    }
  }

  console.log('\n' + colorize('═'.repeat(60), 'cyan'));
  console.log(colorize('Tamamlandı!', 'bright'));
  console.log(colorize('═'.repeat(60), 'cyan') + '\n');
}

/**
 * İlerleme çubuğu render et
 */
function renderProgressBar(percentage, width = 20) {
  const filled = Math.round((percentage / 100) * width);
  const empty = width - filled;
  
  const bar = '█'.repeat(filled) + '░'.repeat(empty);
  return `[${bar}]`;
}

// Hata yakalama
main().catch(error => {
  console.error(colorize('\nHATA:', 'red'), error.message);
  console.error(error.stack);
  process.exit(1);
});
