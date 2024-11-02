import { response } from '../../config/response.js'
import { status } from '../../config/response.status.js'
import { userGetInfoDAO } from '../models/user.dao.js'

export const userGetInfoController = async (req, res) => {
  try {
    console.log('GET user Info : ', req.params.userId)
    return res.send(
      response(status.SUCCESS, await userGetInfoDAO(req.params.userId)),
    )
  } catch (err) {
    console.log('GET USER CTRL ERR: ', err)
    res.send(response(status.BAD_REQUEST, err.data.message))
  }
}

export const userEditProfileController = async (req, res) => {
  try {
    console.log('Edit user Info : ', req.params.userId)
    const result = await userEditProfileService(req)
    if (result == -2) {
      return res.send(
        response(
          status.NAME_ALREADY_EXISTS,
          await userGetInfoProvide(req.params.userId),
        ),
      )
    }
    return res.send(response(status.SUCCESS, result))
  } catch (err) {
    console.log('GET USER CTRL ERR: ', err)
    res.send(response(status.BAD_REQUEST, err.data.message))
  }
}
