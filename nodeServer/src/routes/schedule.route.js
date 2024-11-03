import express from 'express'

export const scheduleRouter = express.Router({ mergeParams: true })

// scheduleRouter.get('/:userId', userGetInfoController)
// scheduleRouter.post('/:userId', userEditProfileController)

export default scheduleRouter