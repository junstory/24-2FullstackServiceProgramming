import express from 'express';
import {
  planGetInfoController,
  planCreateController,
  planDeleteController,
  planUpdateController,
} from '../controllers/plan.controller.js';
export const planRouter = express.Router({ mergeParams: true });

planRouter.get('/:companyId', planGetInfoController);
planRouter.post('/', planCreateController);
planRouter.delete('/:planId', planDeleteController);
planRouter.put('/:planId', planUpdateController);

export default planRouter;
