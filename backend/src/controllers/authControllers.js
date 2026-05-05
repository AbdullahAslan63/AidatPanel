import { prisma } from "../config/db.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { generateAccessToken, generateRefreshToken } from "../utils/generateTokens.js";

const register = async (req, res, next) => {
  try {
    const { name, email, password } = req.body;

    const mevcutKullanici = await prisma.user.findUnique({
      where: { email: email },
    });
    if (mevcutKullanici) {
      return res.status(409).json({ success: false, message: "Bu email adresi zaten kullanılıyor." });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: {
        name,
        email,
        passwordHash: hashedPassword,
        role: "MANAGER", // Normal kayıt olanlar otomatik MANAGER
      },
    });
    res.status(201).json({
      success: true,
      message: "Hesabınız başarıyla oluşturuldu.",
      data: { user: user.id, name: user.name, email: user.email, phone: user.phone, role: user.role, createdAt: user.createdAt, updatedAt: user.updatedAt }
    });
  } catch (error) {
    next(error);
  }
};

const login = async (req, res, next) => {
  try {
    const { identifier, password } = req.body;

    // identifier '@' içeriyorsa email, yoksa telefon numarası
    const isEmail = identifier.includes('@');

    const user = isEmail
      ? await prisma.user.findUnique({ where: { email: identifier } })
      : await prisma.user.findUnique({ where: { phone: identifier } });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Email/telefon veya şifre hatalı."
      });
    }
    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: "Email/telefon veya şifre hatalı."
      });
    }
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    res.status(200).json({
      success: true,
      message: "Giriş başarılı.",
      data: {
        accessToken,
        refreshToken,
        user: { id: user.id, email: user.email, name: user.name, role: user.role, phone: user.phone, createdAt: user.createdAt, updatedAt: user.updatedAt }
      }
    });
  } catch (error) {
    next(error);
  }
};

const refreshToken = async (req, res, next) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) {
      return res.status(401).json({
        success: false,
        message: "Refresh token gerekli."
      });
    }
    const decoded = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
    const user = await prisma.user.findUnique({ where: { id: decoded.id } });
    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Kullanıcı bulunamadı."
      });
    }
    const newAccessToken = generateAccessToken(user);
    res.status(200).json({
      success: true,
      data: { accessToken: newAccessToken }
    });
  } catch (error) {
    next(error);
  }
};

/* const join = async (req, res) => {
  const { name, email, password, inviteCode } = req.body;

  // Davet kodunu kontrol et
  const code = await prisma.inviteCode.findUnique({
    where: { code: inviteCode },
    include: { apartment: true }
  });

  if (!code) {
    return res.status(400).json({ error: "Geçersiz davet kodu." });
  }

  if (code.usedAt) {
    return res.status(400).json({ error: "Bu davet kodu zaten kullanılmış." });
  }

  if (code.expiresAt < new Date()) {
    return res.status(400).json({ error: "Davet kodunun süresi dolmuş." });
  }

  // Email zaten kullanılıyor mu kontrol et
  const mevcutKullanici = await prisma.user.findUnique({
    where: { email: email },
  });
  if (mevcutKullanici) {
    return res.status(400).json({ error: "Bu email adresi zaten kullanılıyor." });
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  // RESIDENT olarak kullanıcı oluştur
  const user = await prisma.user.create({
    data: {
      name,
      email,
      passwordHash: hashedPassword,
      role: "RESIDENT",
      apartmentId: code.apartmentId, // Davet kodunun bağlı olduğu daire
    },
  });

  // Davet kodunu kullanıldı olarak işaretle
  await prisma.inviteCode.update({
    where: { id: code.id },
    data: {
      usedAt: new Date(),
      usedBy: user.id,
    },
  });

  // Token'lar oluştur
  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  res.status(201).json({
    message: "Apartmana başarıyla katıldınız.",
    accessToken,
    refreshToken,
    user: { 
      id: user.id, 
      email: user.email, 
      name: user.name, 
      role: user.role,
      apartmentId: user.apartmentId
    },
  });
}; */

const logout = async (req, res) => {
  // Client-side token silme islemi
  // Not: Stateless JWT'da server tarafinda token invalidation icin
  // blacklist/whitelist sistemi gerekir (Redis vb.)
  res.status(200).json({
    success: true,
    message: "Çıkış başarılı."
  });
};

export { register, login, refreshToken, logout };