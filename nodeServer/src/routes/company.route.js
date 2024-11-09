import express from 'express';
import {
  companyCreateController,
  companyGetInfoController,
  companyUpdateController,
  companyDeleteController,
} from '../controllers/company.controller.js';

export const companyRouter = express.Router({ mergeParams: true });

companyRouter.post('/', companyCreateController);
companyRouter.get('/:companyId', companyGetInfoController);
companyRouter.put('/:companyId', companyUpdateController);
companyRouter.delete('/:companyId', companyDeleteController);
export default companyRouter;
