# Bina Kat ve Daire Yapılandırma Planı

Bina modeline `totalFloors` (toplam kat sayısı) ve `apartmentsPerFloor` (kat başına daire sayısı) alanlarını ekleyerek Flutter uygulamasının bina ekleme akışına uyum sağla.

## Değişiklikler

### 1. Prisma Schema (backend/prisma/schema.prisma)

`Building` modeline iki yeni alan ekle:

```prisma
model Building {
  id                String      @id @default(uuid())
  name              String
  address           String
  city              String
  totalFloors       Int?        // Toplam kat sayısı
  apartmentsPerFloor Int?       // Her kattaki daire sayısı
  managerId         String
  manager           User        @relation("BuildingManager", fields: [managerId], references: [id])
  apartments        Apartment[]
  expenses          Expense[]
  createdAt         DateTime    @default(now())
  updatedAt         DateTime    @updatedAt

  @@index([managerId])
}
```

### 2. Validation Schema (backend/src/middlewares/validate.js)

`buildingSchemas.create`'e yeni alanları ekle:

```javascript
export const buildingSchemas = {
  create: {
    body: z.object({
      name: z.string().min(2).max(100),
      address: z.string().min(5).max(200),
      city: z.string().min(2).max(50),
      totalFloors: z.number().int().min(1).max(200).optional(),
      apartmentsPerFloor: z.number().int().min(1).max(50).optional(),
    }),
  },
  // ...
}
```

### 3. Building Controller (backend/src/controllers/buildingController.js)

`createBuilding` fonksiyonuna yeni alanları dahil et:

```javascript
export const createBuilding = async (req, res) => {
  const { name, address, city, totalFloors, apartmentsPerFloor } = req.body;
  const managerId = req.user.id;

  const building = await createBuildingService({
    name,
    address,
    city,
    totalFloors,
    apartmentsPerFloor,
    managerId,
  });
  // ...
};
```

### 4. Building Service (backend/src/services/buildingService.js)

`createBuildingService`'i güncelle:

```javascript
export const createBuildingService = async ({ 
  name, address, city, totalFloors, apartmentsPerFloor, managerId 
}) => {
  return await prisma.building.create({
    data: { 
      name, address, city, totalFloors, apartmentsPerFloor, managerId 
    },
  });
};
```

## API Request Formatı (Flutter'dan Gelen)

```json
{
  "name": "Yıldız Apartmanı",
  "address": "Atatürk Cad. No:15",
  "city": "İstanbul",
  "totalFloors": 5,
  "apartmentsPerFloor": 4
}
```

## API Response Formatı

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Yıldız Apartmanı",
    "address": "Atatürk Cad. No:15",
    "city": "İstanbul",
    "totalFloors": 5,
    "apartmentsPerFloor": 4,
    "managerId": "uuid",
    "createdAt": "2026-05-07T00:00:00Z",
    "updatedAt": "2026-05-07T00:00:00Z"
  }
}
```

## Notlar

- `totalFloors` ve `apartmentsPerFloor` **opsiyonel** alanlardır (zorunlu değil)
- Bu alanlar sadece metadata olarak saklanır, otomatik daire oluşturma yapılmaz
- Mevcut binalar için bu alanlar `null` kalabilir
