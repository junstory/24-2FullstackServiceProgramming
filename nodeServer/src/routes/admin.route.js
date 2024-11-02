import express from 'express'

export const adminRouter = express.Router({ mergeParams: true });

// adminRouter.get('/:userId', userGetInfoController);
// adminRouter.post('/:userId', userEditProfileController);

export default adminRouter;