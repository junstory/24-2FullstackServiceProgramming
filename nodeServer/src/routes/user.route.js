import express from 'express'
import { userGetInfoController, userCreateController, userDeleteController, userUpdateController } from '../controllers/user.controller.js'
export const userRouter = express.Router({ mergeParams: true })

userRouter.get('/:userId', userGetInfoController)
userRouter.post('/', userCreateController)
userRouter.delete('/:userId', userDeleteController)
userRouter.put('/:userId', userUpdateController)
export default userRouter