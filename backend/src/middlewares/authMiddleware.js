import jwt from "jsonwebtoken";
import { prisma } from "../config/db.js";

export const authMiddleware = async (req, res, next) => {
  // Development'da sadece debug et - production performansı için kaldırıldı
  if (process.env.NODE_ENV === "development") {
    console.log("Auth middleware");
  }
  let token;
  if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
    token = req.headers.authorization.split(" ")[1];
  } else if (req.cookies?.jwt) {
    token = req.cookies.jwt;
  }

  if (!token) {
    return res.status(401).json({ success: false, message: "Token gerekli." });
  }
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await prisma.user.findUnique({ where: { id: decoded.id } });
    if (!user) {
      return res.status(401).json({ success: false, message: "Kullanıcı bulunamadı." });
    }
    req.user = user;
    next();
  } catch (error) {
    next(error);
  }
};
