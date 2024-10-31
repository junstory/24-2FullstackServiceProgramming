import express from 'express'

export const userRouter = express.Router({ mergeParams: true })

userRouter.get('/:userId', userGetInfoController)
userRouter.post('/:userId', userEditProfileController)
