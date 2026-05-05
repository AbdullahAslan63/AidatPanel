/**
 * Backend Kod Analiz Modülü
 * Controller ve route dosyalarını tarar, tamamlanmış endpoint'leri tespit eder
 */

import { readdirSync, readFileSync, existsSync, statSync } from 'fs';
import { join, resolve } from 'path';

const BACKEND_PATH = resolve('/home/abdullah/Desktop/git branch/AidatPanel/backend/src');

/**
 * Controller dosyalarını analiz et
 */
export function analyzeControllers() {
  const controllersPath = join(BACKEND_PATH, 'controllers');
  if (!existsSync(controllersPath)) {
    return { error: 'Controllers dizini bulunamadı' };
  }

  const files = readdirSync(controllersPath).filter(f => f.endsWith('.js'));
  const analysis = {
    totalFiles: files.length,
    endpoints: {},
    commentedFeatures: [],
    completedFeatures: []
  };

  for (const file of files) {
    const filePath = join(controllersPath, file);
    const content = readFileSync(filePath, 'utf-8');
    const fileName = file.replace(/\.js$/, '').replace(/Controllers?$/, '');

    // Export edilen fonksiyonları bul (iki pattern: export { a, b } ve export const x = ...)
    let exports = [];
    
    // Pattern 1: export { func1, func2 }
    const exportBlockMatches = content.match(/export\s*\{([^}]+)\}/);
    if (exportBlockMatches) {
      exports = exportBlockMatches[1].split(',').map(e => e.trim()).filter(Boolean);
    }
    
    // Pattern 2: export const funcName = async ...
    const exportConstMatches = content.matchAll(/export\s+const\s+(\w+)\s*=\s*async/g);
    for (const match of exportConstMatches) {
      if (!exports.includes(match[1])) {
        exports.push(match[1]);
      }
    }

    // Yorumda olan fonksiyonları bul (/* const funcName = async ... */)
    const commentedFunctionRegex = /\/\*[\s\S]*?const\s+(\w+)\s*=\s*async/g;
    let match;
    while ((match = commentedFunctionRegex.exec(content)) !== null) {
      analysis.commentedFeatures.push({
        file: fileName,
        function: match[1],
        status: 'commented'
      });
    }

    // Aktif fonksiyonları ekle
    for (const exp of exports) {
      const isCommented = content.includes(`/* ${exp}`) || 
                         content.includes(`// ${exp}`) ||
                         (content.indexOf(`const ${exp}`) > content.indexOf(`/*`) && 
                          content.indexOf(`const ${exp}`) < content.indexOf(`*/`));
      
      if (!isCommented) {
        analysis.completedFeatures.push({
          file: fileName,
          function: exp,
          status: 'active'
        });
      }
    }

    analysis.endpoints[fileName] = {
      exports: exports,
      hasCommentedCode: content.includes('/*') && content.includes('*/'),
      lineCount: content.split('\n').length
    };
  }

  return analysis;
}

/**
 * Route dosyalarını analiz et
 */
export function analyzeRoutes() {
  const routesPath = join(BACKEND_PATH, 'routes');
  if (!existsSync(routesPath)) {
    return { error: 'Routes dizini bulunamadı' };
  }

  const files = readdirSync(routesPath).filter(f => f.endsWith('.js'));
  const analysis = {
    totalFiles: files.length,
    routes: {}
  };

  for (const file of files) {
    const filePath = join(routesPath, file);
    const content = readFileSync(filePath, 'utf-8');
    const fileName = file.replace(/\.js$/, '').replace(/Routes$/, '');

    // HTTP metodlarını ve path'leri bul
    const routeMatches = content.matchAll(/(router\.(get|post|put|patch|delete))\(['"]([^'"]+)['"]/g);
    const routes = [];
    
    for (const match of routeMatches) {
      routes.push({
        method: match[2].toUpperCase(),
        path: match[3]
      });
    }

    analysis.routes[fileName] = {
      routeCount: routes.length,
      endpoints: routes
    };
  }

  return analysis;
}

/**
 * Özellik tamamlanma durumunu kontrol et
 */
export function checkFeatureStatus() {
  const controllerAnalysis = analyzeControllers();
  const routeAnalysis = analyzeRoutes();
  
  // Debug: Controller ve route isimlerini göster
  // console.log('Controllers:', Object.keys(controllerAnalysis.endpoints));
  // console.log('Routes:', Object.keys(routeAnalysis.routes));

  // Özellik eşleştirme haritası (controllerName, routeName)
  const featureMap = {
    'auth': {
      files: ['auth', 'auth'],
      requiredEndpoints: ['register', 'login', 'refreshToken', 'logout'],
      description: 'Kimlik Doğrulama Sistemi'
    },
    'building': {
      files: ['building', 'building'],
      requiredEndpoints: ['createBuilding', 'getBuildings', 'getBuilding', 'updateBuilding', 'deleteBuilding'],
      description: 'Bina Yönetimi'
    },
    'apartment': {
      files: ['apartment', 'apartment'],
      requiredEndpoints: ['createApartment', 'getApartments', 'updateApartment', 'deleteApartment'],
      description: 'Daire Yönetimi'
    },
    'inviteCode': {
      files: ['inviteCode', 'inviteCode'],
      requiredEndpoints: ['generateInviteCode', 'validateInviteCode'],
      description: 'Davet Kodu Sistemi'
    },
    'due': {
      files: ['due', 'due'],
      requiredEndpoints: ['createDue', 'getDues', 'updateDueStatus'],
      description: 'Aidat Sistemi'
    },
    'expense': {
      files: ['expense', 'expense'],
      requiredEndpoints: ['createExpense', 'getExpenses'],
      description: 'Gider Sistemi'
    },
    'ticket': {
      files: ['ticket', 'ticket'],
      requiredEndpoints: ['createTicket', 'getTickets', 'updateTicket'],
      description: 'Arıza/Talep Sistemi'
    }
  };

  const featureStatus = {};

  for (const [key, config] of Object.entries(featureMap)) {
    const controllerFile = config.files[0];
    const controllerInfo = controllerAnalysis.endpoints[controllerFile] || { exports: [] };
    
    // Controller dosyası var mı?
    const hasController = Object.keys(controllerAnalysis.endpoints).includes(controllerFile);
    
    // Route dosyası var mı?
    const routeFile = config.files[1];
    const hasRoutes = Object.keys(routeAnalysis.routes).includes(routeFile.replace('Routes', ''));
    
    // Required endpoint'lerin kaçı var? (flexible matching)
    const availableEndpoints = controllerInfo.exports || [];
    const matchedEndpoints = config.requiredEndpoints.filter(req => {
      // Direkt eşleşme
      if (availableEndpoints.includes(req)) return true;
      
      // Kısmi eşleşme (örn: getBuildingById matches getBuilding)
      return availableEndpoints.some(avail => {
        const availLower = avail.toLowerCase();
        const reqLower = req.toLowerCase();
        // Remove common suffixes/prefixes for comparison
        const normalizedAvail = availLower.replace(/byid$/, '').replace(/all$/, '');
        const normalizedReq = reqLower.replace(/byid$/, '').replace(/all$/, '');
        return normalizedAvail.includes(normalizedReq) || normalizedReq.includes(normalizedAvail);
      });
    });

    // Yorumda olan fonksiyonlar var mı?
    const commentedInFeature = controllerAnalysis.commentedFeatures.filter(f => 
      f.file === controllerFile
    );

    let status = 'not-started';
    if (hasController && hasRoutes) {
      if (matchedEndpoints.length === config.requiredEndpoints.length && commentedInFeature.length === 0) {
        status = 'completed';
      } else if (matchedEndpoints.length > 0 || commentedInFeature.length > 0) {
        status = 'in-progress';
      }
    } else if (hasController || hasRoutes) {
      status = 'in-progress';
    }

    featureStatus[key] = {
      description: config.description,
      status: status,
      hasController,
      hasRoutes,
      matchedEndpoints: matchedEndpoints.length,
      totalRequired: config.requiredEndpoints.length,
      availableEndpoints,
      commentedFunctions: commentedInFeature.map(f => f.function)
    };
  }

  return {
    features: featureStatus,
    summary: {
      completed: Object.values(featureStatus).filter(f => f.status === 'completed').length,
      inProgress: Object.values(featureStatus).filter(f => f.status === 'in-progress').length,
      notStarted: Object.values(featureStatus).filter(f => f.status === 'not-started').length
    }
  };
}

/**
 * Faz tamamlanma yüzdesini hesapla
 */
export function calculatePhaseProgress() {
  const features = checkFeatureStatus();
  
  // Faz 1 özellikleri
  const faz1Features = ['auth', 'building', 'apartment'];
  const faz2Features = ['inviteCode', 'due'];
  const faz3Features = ['expense', 'ticket'];

  const calculatePercentage = (featureList) => {
    const relevant = Object.entries(features.features)
      .filter(([key]) => featureList.includes(key));
    
    if (relevant.length === 0) return 0;
    
    const completed = relevant.filter(([_, val]) => val.status === 'completed').length;
    const inProgress = relevant.filter(([_, val]) => val.status === 'in-progress').length;
    
    // Tamamlananlar %100, devam edenler %50
    return Math.round(((completed * 1 + inProgress * 0.5) / relevant.length) * 100);
  };

  return {
    faz1: calculatePercentage(faz1Features),
    faz2: calculatePercentage(faz2Features),
    faz3: calculatePercentage(faz3Features),
    overall: Math.round(
      (calculatePercentage(faz1Features) + 
       calculatePercentage(faz2Features) + 
       calculatePercentage(faz3Features)) / 3
    )
  };
}

export default {
  analyzeControllers,
  analyzeRoutes,
  checkFeatureStatus,
  calculatePhaseProgress
};
