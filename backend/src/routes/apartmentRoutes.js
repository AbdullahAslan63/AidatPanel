import express from "express";
import {
  getApartments,
  createApartment,
  deleteApartment,
} from "../controllers/apartmentController.js";

import { authMiddleware } from "../middlewares/authMiddleware.js";
import { validate, apartmentSchemas } from "../middlewares/validate.js";

const router = express.Router({ mergeParams: true });

router.use(authMiddleware);

router.get("/", validate(apartmentSchemas.getByBuilding), getApartments);
router.post("/", validate(apartmentSchemas.create), createApartment);
router.delete("/:id", validate(apartmentSchemas.delete), deleteApartment);

export default router;