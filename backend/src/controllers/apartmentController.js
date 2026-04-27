import {
  getApartmentsService,
  createApartmentService,
  deleteApartmentService,
} from "../services/apartmentService.js";

// GET /api/v1/buildings/:buildingId/apartments
export const getApartments = async (req, res) => {
  try {
    const { buildingId } = req.params;
    const managerId = req.user.id;

    const apartments = await getApartmentsService(buildingId, managerId);

    if (!apartments) {
      return res.status(403).json({
        success: false,
        message: "Bu binanın dairelerini görüntüleme yetkiniz yok.",
      });
    }

    res.status(200).json({
      success: true,
      data: apartments,
    });
  } catch (error) {
    if (process.env.NODE_ENV === "development") {
      console.error("Daire listeleme hatası:", error);
    }
    res.status(500).json({
      success: false,
      message: "Daireler listelenemedi.",
    });
  }
};

// POST /api/v1/buildings/:buildingId/apartments
export const createApartment = async (req, res) => {
  try {
    const { buildingId } = req.params;
    const { number, floor } = req.body;
    const managerId = req.user.id;

    if (!number) {
      return res.status(400).json({
        success: false,
        message: "Daire numarası zorunludur.",
      });
    }

    const apartment = await createApartmentService({
      buildingId,
      number: number.trim(),
      floor: floor ? Number(floor) : null,
      managerId,
    });

    if (!apartment) {
      return res.status(403).json({
        success: false,
        message: "Bu binaya daire ekleme yetkiniz yok.",
      });
    }

    res.status(201).json({
      success: true,
      message: "Daire başarıyla oluşturuldu.",
      data: apartment,
    });
  } catch (error) {
    if (process.env.NODE_ENV === "development") {
      console.error("Daire oluşturma hatası:", error);
    }
    res.status(500).json({
      success: false,
      message: "Daire oluşturulamadı.",
    });
  }
};

// DELETE /api/v1/buildings/:buildingId/apartments/:id
export const deleteApartment = async (req, res) => {
  try {
    const { buildingId, id } = req.params;
    const managerId = req.user.id;

    const deleted = await deleteApartmentService(id, buildingId, managerId);

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: "Daire bulunamadı veya silme yetkiniz yok.",
      });
    }

    res.status(200).json({
      success: true,
      message: "Daire silindi.",
    });
  } catch (error) {
    if (process.env.NODE_ENV === "development") {
      console.error("Daire silme hatası:", error);
    }
    res.status(500).json({
      success: false,
      message: "Daire silinemedi.",
    });
  }
};