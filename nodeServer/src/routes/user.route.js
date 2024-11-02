import express from 'express'
import { userGetInfoController, userCreateController, userDeleteController } from '../controllers/user.controller.js'
export const userRouter = express.Router({ mergeParams: true })

userRouter.get('/:userId', userGetInfoController)
userRouter.post('/', userCreateController)
userRouter.delete('/:userId', userDeleteController)

export default userRouter