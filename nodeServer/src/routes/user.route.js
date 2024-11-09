import express from 'express';
import {
  userGetInfoController,
  userCreateController,
  userDeleteController,
  userUpdateController,
  userWorkStartController,
  userWorkEndController,
  userLinkCompanyController,
} from '../controllers/user.controller.js';
export const userRouter = express.Router({ mergeParams: true });

userRouter.get('/:userId', userGetInfoController);
userRouter.post('/', userCreateController);
userRouter.post('/company', userLinkCompanyController);
userRouter.delete('/:userId', userDeleteController);
userRouter.put('/:userId', userUpdateController);
userRouter.post('/commute/in', userWorkStartController);
userRouter.post('/commute/out', userWorkEndController);
export default userRouter;
