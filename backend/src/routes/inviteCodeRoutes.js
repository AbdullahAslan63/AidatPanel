import { Router } from "express";
import { generateInviteCode } from "../controllers/inviteCodeController.js";
import { authMiddleware } from "../middlewares/authMiddleware.js";
import { validate, apartmentSchemas } from "../middlewares/validate.js";

const router = Router();

// Davet kodu üret (sadece yönetici)
// UUID validasyonu eklendi - apartmentId parametresi kontrol edilir
router.post("/", authMiddleware, validate(apartmentSchemas.generateInviteCode), generateInviteCode);

export default router;
