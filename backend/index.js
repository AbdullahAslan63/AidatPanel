import { config } from "dotenv";
config();

import express from "express";
import cors from "cors";
import helmet from "helmet";
import { connectDB, disconnectDB } from "./src/config/db.js";
import authRouter from "./src/routes/authRoutes.js";
import buildingRoutes from "./src/routes/buildingRoutes.js";
import apartmentRoutes from "./src/routes/apartmentRoutes.js";
import { apiLimiter } from "./src/middlewares/rateLimitMiddleware.js";
import { errorHandler, notFoundHandler } from "./src/middlewares/errorHandler.js";

const app = express();

const port = process.env.PORT || 4200;

const allowedOrigins = process.env.ALLOWED_ORIGINS
  ? process.env.ALLOWED_ORIGINS.split(',')
  : ['http://localhost:3000', 'http://localhost:4200'];

// GÜVENLİK MIDDLEWARE'LERİ
// Helmet - HTTP başlıklarını güvenli hale getirir
app.use(helmet());

// CORS - Flutter'dan gelen isteklere izin ver
app.use(cors({
  origin: allowedOrigins,
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));

// Rate Limiting - Tüm API'ler için 15 dakikada 100 istek
app.use("/api/v1", apiLimiter);

// BODY PARSING MIDDLEWARE'I
app.use(express.json());

// ROTALAR
app.use("/api/v1/auth", authRouter);
app.use("/api/v1/buildings", buildingRoutes);
app.use("/api/v1/buildings/:buildingId/apartments", apartmentRoutes);

// 404 Handler - Tanımlanmamış route'lar
app.use(notFoundHandler);

// Global Error Handler - Tüm hataları merkezi olarak yönetir
app.use(errorHandler);

connectDB();
const server = app.listen(port, () => {
  console.log("Server is running on port: ", port);
});

// Handle unhandled promise rejections (e.g., database connection errors)
process.on("unhandledRejection", (err) => {
  console.error("Unhandled Rejection:", err);
  server.close(async () => {
    await disconnectDB();
    process.exit(1);
  });
});

// Handle uncaught exceptions
process.on("uncaughtException", async (err) => {
  console.error("Uncaught Exception:", err);
  await disconnectDB();
  process.exit(1);
});

// Graceful shutdown
process.on("SIGTERM", async () => {
  console.log("SIGTERM received, shutting down gracefully");
  server.close(async () => {
    await disconnectDB();
    process.exit(0);
  });
});
