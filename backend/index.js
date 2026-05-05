import { config } from "dotenv";
config();

import express from "express";
import cors from "cors";
import helmet from "helmet";
import { connectDB, disconnectDB } from "./src/config/db.js";
import authRouter from "./src/routes/authRoutes.js";
import buildingRoutes from "./src/routes/buildingRoutes.js";
import apartmentRoutes from "./src/routes/apartmentRoutes.js";
import inviteCodeRoutes from "./src/routes/inviteCodeRoutes.js";
import { apiLimiter } from "./src/middlewares/rateLimitMiddleware.js";
import { errorHandler, notFoundHandler } from "./src/middlewares/errorHandler.js";

const app = express();

const port = process.env.PORT;

// GÜVENLİK MIDDLEWARE'LERİ
// Helmet - HTTP başlıklarını güvenli hale getirir
app.use(helmet());

// CORS - Flutter web + mobil + landing page
const allowedOrigins = [
  "http://localhost:3000",
  "http://localhost:4200",
  "http://localhost:2773",
  "http://api.aidatpanel.com:2773",
  "https://api.aidatpanel.com:2773",
  "http://aidatpanel.com",
  "https://aidatpanel.com",
];

app.use(cors({
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("CORS policy violation"));
    }
  },
  credentials: true,
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
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
app.use("/api/v1/apartments/:apartmentId/invite-code", inviteCodeRoutes);

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
