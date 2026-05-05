import { Router } from "express";
import { generateInviteCode } from "../controllers/inviteCodeController.js";
import { authMiddleware } from "../middlewares/authMiddleware.js";

const router = Router();

// Davet kodu üret (sadece yönetici)
router.post("/", authMiddleware, generateInviteCode);

export default router;
