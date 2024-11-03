import express from 'express'

export const commuteRouter = express.Router({ mergeParams: true })

// commuteRouter.get('/:userId', userGetInfoController)
// commuteRouter.post('/:userId', userEditProfileController)

export default commuteRouter;