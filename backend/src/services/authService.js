import { prisma } from "../config/db.js";
import bcrypt from "bcryptjs";

/**
 * Kullanıcı oluşturma servisi
 */
export const createUserService = async (userData) => {
  const { name, email, password, role = "MANAGER", apartmentId = null } = userData;
  
  const hashedPassword = await bcrypt.hash(password, 10);
  
  return await prisma.user.create({
    data: {
      name,
      email,
      passwordHash: hashedPassword,
      role,
      apartmentId,
    },
  });
};

/**
 * Email kontrolü servisi
 */
export const findUserByEmail = async (email) => {
  return await prisma.user.findUnique({
    where: { email },
  });
};

/**
 * Şifre doğrulama servisi
 */
export const validatePassword = async (plainPassword, hashedPassword) => {
  return await bcrypt.compare(plainPassword, hashedPassword);
};

/**
 * Davet kodu kontrolü servisi
 */
export const validateInviteCode = async (inviteCode) => {
  const code = await prisma.inviteCode.findUnique({
    where: { code: inviteCode },
    include: { apartment: true }
  });

  if (!code) {
    return { valid: false, error: "Geçersiz davet kodu." };
  }

  if (code.usedAt) {
    return { valid: false, error: "Bu davet kodu zaten kullanılmış." };
  }

  if (code.expiresAt < new Date()) {
    return { valid: false, error: "Davet kodunun süresi dolmuş." };
  }

  return { valid: true, code, apartment: code.apartment };
};

/**
 * Davet kodu kullanıldı olarak işaretleme servisi
 */
export const markInviteCodeAsUsed = async (codeId, userId) => {
  return await prisma.inviteCode.update({
    where: { id: codeId },
    data: {
      usedAt: new Date(),
      usedBy: userId,
    },
  });
};
