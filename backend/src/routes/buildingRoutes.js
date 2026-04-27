import express from "express";
import {
  createBuilding,
  getBuildings,
  getBuildingById,
  updateBuilding,
  deleteBuilding,
} from "../controllers/buildingController.js";

import { authMiddleware } from "../middlewares/authMiddleware.js";
import { validate, buildingSchemas } from "../middlewares/validate.js";

const router = express.Router();

router.use(authMiddleware);

router.post("/", validate(buildingSchemas.create), createBuilding);
router.get("/", getBuildings);
router.get("/:id", validate(buildingSchemas.getById), getBuildingById);
router.put("/:id", validate(buildingSchemas.update), updateBuilding);
router.delete("/:id", validate(buildingSchemas.delete), deleteBuilding);

export default router;