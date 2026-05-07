import {
  createBuildingService,
  getBuildingsService,
  getBuildingByIdService,
  updateBuildingService,
  deleteBuildingService,
} from "../services/buildingService.js";

// CREATE
export const createBuilding = async (req, res) => {
  try {
    const { name, address, city } = req.body;

    const managerId = req.user.id; // JWT'den geliyor

    const building = await createBuildingService({
      name,
      address,
      city,
      managerId,
    });

    res.status(201).json({
      success: true,
      data: building,
    });
  } catch (error) {
    if (process.env.NODE_ENV === "development") {
      console.error(error);
    }
    res.status(500).json({
      success: false,
      message: "Bina oluşturulamadı",
    });
  }
};

// GET ALL
export const getBuildings = async (req, res) => {
  try {
    const managerId = req.user.id;

    const buildings = await getBuildingsService(managerId);

    res.json({
      success: true,
      data: buildings,
    });
  } catch (error) {
    if (process.env.NODE_ENV === "development") {
      console.error(error);
    }
    res.status(500).json({
      success: false,
      message: "Binalar alınamadı",
    });
  }
};

// GET BY ID
export const getBuildingById = async (req, res) => {
  try {
    const { id } = req.params;
    const managerId = req.user.id;

    const building = await getBuildingByIdService(id, managerId);

    if (!building) {
      return res.status(404).json({
        success: false,
        message: "Bina bulunamadı",
      });
    }

    res.json({
      success: true,
      data: building,
    });
  } catch (error) {
    if (process.env.NODE_ENV === "development") {
      console.error(error);
    }
    res.status(500).json({
      success: false,
      message: "Bina getirilemedi",
    });
  }
};

// UPDATE
export const updateBuilding = async (req, res) => {
  try {
    const { id } = req.params;
    const managerId = req.user.id;

    const updated = await updateBuildingService(id, managerId, req.body);

    if (!updated) {
      return res.status(404).json({
        success: false,
        message: "Bina bulunamadı",
      });
    }

    res.json({
      success: true,
      data: updated,
    });
  } catch (error) {
    if (process.env.NODE_ENV === "development") {
      console.error(error);
    }
    res.status(500).json({
      success: false,
      message: "Bina güncellenemedi",
    });
  }
};

// DELETE
export const deleteBuilding = async (req, res) => {
  try {
    const { id } = req.params;
    const managerId = req.user.id;

    const deleted = await deleteBuildingService(id, managerId);

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: "Bina bulunamadı",
      });
    }

    res.json({
      success: true,
      message: "Bina silindi",
    });
  } catch (error) {
    if (process.env.NODE_ENV === "development") {
      console.error(error);
    }
    res.status(500).json({
      success: false,
      message: "Bina silinemedi",
    });
  }
};