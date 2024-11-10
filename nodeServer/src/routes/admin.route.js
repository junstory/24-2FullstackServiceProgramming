import express from 'express';
import {
  adminActivateUserController,
  adminDeactivateUserController,
  adminWorkStartController,
  adminWorkEndController,
  adminCheckUserCommuteController,
} from '../controllers/admin.controller.js';

export const adminRouter = express.Router({ mergeParams: true });

// adminRouter.get('/:userId', userGetInfoController);
// adminRouter.post('/:userId', userEditProfileController);
adminRouter.put('/activate/:targetId', adminActivateUserController);
adminRouter.put('/deactivate/:targetId', adminDeactivateUserController);
adminRouter.put('/commute/in/:targetId', adminWorkStartController);
adminRouter.put('/commute/out/:targetId', adminWorkEndController);
adminRouter.get('/commute/:targetId', adminCheckUserCommuteController);

export default adminRouter;
