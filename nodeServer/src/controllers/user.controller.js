import { response } from '../../config/response.js';
import { status } from '../../config/response.status.js';
import {
  userGetInfoDAO,
  createUserDAO,
  deleteUserDAO,
  updateUserDAO,
  userWorkStartDAO,
  userWorkEndDAO,
  linkUserToCompanyDAO,
} from '../models/user.dao.js';

export const userCreateController = async (req, res) => {
  try {
    console.log('Create user : ', req.body);
    return res.send(response(status.SUCCESS, await createUserDAO(req.body)));
  } catch (err) {
    console.log('CREATE USER CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

export const userLinkCompanyController = async (req, res) => {
  try {
    console.log('Link user to company : ', req.body);
    return res.send(
      response(
        status.SUCCESS,
        await linkUserToCompanyDAO(req.body.userId, req.body.companyId),
      ),
    );
  } catch (err) {
    console.log('LINK USER CTRL ERR: ', err);
    res.send(response(status.BAD_REQUEST, err));
  }
};

export const userGetInfoController = async (req, res) => {
  try {
    console.log('GET user Info : ', req.params.userId);
    return res.send(
      response(status.SUCCESS, await userGetInfoDAO(req.params.userId)),
    );
  } catch (err) {
    console.log('GET USER CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

export const userGetInfoByTokenController = async (req, res) => {
  try {
    console.log('GET user Info : ', req.user.id);
    return res.send(
      response(status.SUCCESS, await userGetInfoDAO(req.user.id)),
    );
  } catch (err) {
    console.log('GET USER CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

// export const userEditProfileController = async (req, res) => {
//   try {
//     console.log('Edit user Info : ', req.params.userId);
//     const result = await userEditProfileService(req);
//     if (result == -2) {
//       return res.send(
//         response(
//           status.NAME_ALREADY_EXISTS,
//           await userGetInfoProvide(req.params.userId),
//         ),
//       );
//     }
//     return res.send(response(status.SUCCESS, result));
//   } catch (err) {
//     console.log('GET USER CTRL ERR: ', err);
//     res.send(response(status.BAD_REQUEST, err.data.message));
//   }
// };

export const userUpdateController = async (req, res) => {
  try {
    console.log('Update user Info : ', req.body);
    return res.send(
      response(
        status.SUCCESS,
        await updateUserDAO(req.params.userId, req.body),
      ),
    );
  } catch (err) {
    console.log('UPDATE USER CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

export const userDeleteController = async (req, res) => {
  try {
    console.log('Delete user Info : ', req.params.userId);
    return res.send(
      response(status.SUCCESS, await deleteUserDAO(req.params.userId)),
    );
  } catch (err) {
    console.log('DELETE USER CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

export const userWorkStartController = async (req, res) => {
  try {
    console.log('Start work user: ', req.body.userId);
    return res.send(response(status.SUCCESS, await userWorkStartDAO(req.body)));
  } catch (err) {
    console.log('WORK START CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

export const userWorkEndController = async (req, res) => {
  try {
    let userId = req.user.id || req.body.userId;
    console.log('End work user: ', userId);
    return res.send(response(status.SUCCESS, await userWorkEndDAO(userId)));
  } catch (err) {
    console.log('WORK END CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};
