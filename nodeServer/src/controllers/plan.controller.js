import { response } from '../../config/response.js';
import { status } from '../../config/response.status.js';
import { createPlanDAO, getPlanInfoDAO } from '../models/plan.dao.js';

export const planCreateController = async (req, res) => {
  try {
    console.log('Create plan : ', req.body);
    return res.send(response(status.SUCCESS, await createPlanDAO(req.body)));
  } catch (err) {
    console.log('CREATE USER CTRL ERR: ', err);
    res.send(response(status.BAD_REQUEST, err));
  }
};

export const planGetInfoController = async (req, res) => {
  try {
    console.log('GET plan Info : ', req.params);
    return res.send(
      response(status.SUCCESS, await getPlanInfoDAO(req.params.companyId)),
    );
  } catch (err) {
    console.log('GET USER CTRL ERR: ', err);
    res.send(response(status.BAD_REQUEST, err));
  }
};

export const planEditProfileController = async (req, res) => {
  try {
    console.log('Edit user Info : ', req.params.userId);
    const result = await userEditProfileService(req);
    return res.send(response(status.SUCCESS, result));
  } catch (err) {
    console.log('GET USER CTRL ERR: ', err);
    res.send(response(status.BAD_REQUEST, err.data.message));
  }
};

export const planUpdateController = async (req, res) => {
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
    res.send(response(status.BAD_REQUEST, err));
  }
};

export const planDeleteController = async (req, res) => {
  try {
    console.log('Delete user Info : ', req.params.userId);
    return res.send(
      response(status.SUCCESS, await deleteUserDAO(req.params.userId)),
    );
  } catch (err) {
    console.log('DELETE USER CTRL ERR: ', err);
    res.send(response(status.BAD_REQUEST, err));
  }
};
