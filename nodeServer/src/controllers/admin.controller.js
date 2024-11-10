import { response } from '../../config/response.js';
import { status } from '../../config/response.status.js';
import {
  adminActivateUserDAO,
  adminDeactivateUserDAO,
  adminStartWorkDAO,
  adminEndWorkDAO,
  adminCheckUserCommuteDAO,
} from '../models/admin.dao.js';

export const adminActivateUserController = async (req, res) => {
  try {
    const targetId = req.params.targetId;
    console.log('Activate user : ', targetId);
    await adminActivateUserDAO(targetId, req.body);
    return res.send(
      response(status.SUCCESS, { message: 'User activated successfully' }),
    );
  } catch (error) {
    console.log('ACTIVATE USER CTRL ERR: ', error);
    res.status(400).send(response(status.BAD_REQUEST, error));
  }
};

export const adminDeactivateUserController = async (req, res) => {
  try {
    const targetId = req.params.targetId;
    console.log('Deactivate user : ', targetId);
    await adminDeactivateUserDAO(targetId, req.body);
    return res.send(
      response(status.SUCCESS, { message: 'User deactivated successfully' }),
    );
  } catch (error) {
    console.log('DEACTIVATE USER CTRL ERR: ', error);
    res.status(400).send(response(status.BAD_REQUEST, error));
  }
};

export const adminWorkStartController = async (req, res) => {
  try {
    const targetId = req.params.targetId;
    console.log('Start work : ', targetId);
    await adminStartWorkDAO(targetId, req.body);
    return res.send(
      response(status.SUCCESS, { message: 'Work started successfully' }),
    );
  } catch (error) {
    console.log('START WORK CTRL ERR: ', error);
    res.status(400).send(response(status.BAD_REQUEST, error));
  }
};

export const adminWorkEndController = async (req, res) => {
  try {
    const targetId = req.params.targetId;
    console.log('End work : ', targetId);
    await adminEndWorkDAO(targetId, req.body);
    return res.send(
      response(status.SUCCESS, { message: 'Work ended successfully' }),
    );
  } catch (error) {
    console.log('END WORK CTRL ERR: ', error);
    res.status(400).send(response(status.BAD_REQUEST, error));
  }
};

export const adminCheckUserCommuteController = async (req, res) => {
  try {
    const targetId = req.params.targetId;
    console.log('Check user commute : ', targetId);
    const commuteData = await adminCheckUserCommuteDAO(targetId, req);
    return res.send(
      response(status.SUCCESS, {
        message: 'Commute data retrieved successfully',
        data: commuteData,
      }),
    );
  } catch (error) {
    console.log('CHECK USER COMMUTE CTRL ERR: ', error);
    res.status(400).send(response(status.BAD_REQUEST, error));
  }
};

export default {
  adminActivateUserController,
  adminDeactivateUserController,
  adminWorkStartController,
  adminWorkEndController,
  adminCheckUserCommuteController,
};
