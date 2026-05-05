import { prisma } from "../config/db.js";
import crypto from "crypto";

// Davet kodu üret
export const generateInviteCode = async (req, res) => {
  try {
    const { apartmentId } = req.body;
    const managerId = req.user.id;

    // Apartmanın bu yöneticiye ait olduğunu kontrol et
    const apartment = await prisma.apartment.findFirst({
      where: { 
        id: apartmentId,
        building: { managerId }
      }
    });

    if (!apartment) {
      return res.status(403).json({
        success: false,
        message: "Bu daire için davet kodu üretme yetkiniz yok."
      });
    }

    // 12 karakterlik rastgele kod üret
    const code = crypto.randomBytes(6).toString('hex').toUpperCase();
    const formattedCode = `AP${code.slice(0, 3)}-${code.slice(3, 6)}-${code.slice(6, 9)}`;

    // 7 gün geçerlilik süresi
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    const inviteCode = await prisma.inviteCode.create({
      data: {
        code: formattedCode,
        apartmentId,
        expiresAt,
        createdBy: managerId
      }
    });

    res.status(201).json({
      success: true,
      data: {
        code: inviteCode.code,
        expiresAt: inviteCode.expiresAt
      }
    });
  } catch (error) {
    next(error);
  }
};

/* const validateInviteCode = async (req, res) => {
  try {
    const { code } = req.body;

    const inviteCode = await prisma.inviteCode.findUnique({
      where: { code },
      include: { apartment: { include: { building: true } } }
    });

    if (!inviteCode) {
      return res.status(400).json({
        success: false,
        message: "Geçersiz davet kodu."
      });
    }

    if (inviteCode.usedAt) {
      return res.status(400).json({
        success: false,
        message: "Bu davet kodu zaten kullanılmış."
      });
    }

    if (inviteCode.expiresAt < new Date()) {
      return res.status(400).json({
        success: false,
        message: "Davet kodunun süresi dolmuş."
      });
    }

    res.status(200).json({
      success: true,
      data: {
        apartment: inviteCode.apartment,
        building: inviteCode.apartment.building
      }
    });
  } catch (error) {
    next(error);
  }
}; */
