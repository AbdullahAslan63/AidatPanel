import { prisma } from "../config/db.js";

export const createBuildingService = async ({ name, address, city, managerId }) => {
  return await prisma.building.create({
    data: { name, address, city, managerId },
  });
};

export const getBuildingsService = async (managerId) => {
  return await prisma.building.findMany({
    where: { managerId },
    orderBy: { createdAt: "desc" },
  });
};

export const getBuildingByIdService = async (id, managerId) => {
  return await prisma.building.findFirst({
    where: { id, managerId },
  });
};

export const updateBuildingService = async (id, managerId, data) => {
  const building = await prisma.building.findFirst({
    where: { id, managerId },
  });

  if (!building) return null;

  return await prisma.building.update({
    where: { id },
    data,
  });
};

export const deleteBuildingService = async (id, managerId) => {
  const building = await prisma.building.findFirst({
    where: { id, managerId },
  });

  if (!building) return null;

  return await prisma.building.delete({
    where: { id },
  });
};