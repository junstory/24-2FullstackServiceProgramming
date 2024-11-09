import express from 'express';

export const companyRouter = express.Router({ mergeParams: true });

// commuteRouter.get('/:userId', userGetInfoController)
// commuteRouter.post('/:userId', userEditProfileController)

export default companyRouter;
