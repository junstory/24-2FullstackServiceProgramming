import { response } from '../../config/response.js';
import { status } from '../../config/response.status.js';
import {
  companyGetInfoDAO,
  createCompanyDAO,
  deleteCompanyDAO,
  updateCompanyDAO,
} from '../models/company.dao.js';

export const companyCreateController = async (req, res) => {
  try {
    console.log('Create company : ', req.body);
    return res.send(response(status.SUCCESS, await createCompanyDAO(req.body)));
  } catch (err) {
    console.log('CREATE COMPANY CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

export const companyGetInfoController = async (req, res) => {
  try {
    console.log('GET company Info : ', req.params.companyId);
    return res.send(
      response(status.SUCCESS, await companyGetInfoDAO(req.params.companyId)),
    );
  } catch (err) {
    console.log('GET COMPANY CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

export const companyUpdateController = async (req, res) => {
  try {
    console.log('Update company Info : ', req.body);
    return res.send(
      response(
        status.SUCCESS,
        await updateCompanyDAO(req.params.companyId, req.body),
      ),
    );
  } catch (err) {
    console.log('UPDATE COMPANY CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};

export const companyDeleteController = async (req, res) => {
  try {
    console.log('Delete company Info : ', req.params.companyId);
    return res.send(
      response(status.SUCCESS, await deleteCompanyDAO(req.params.companyId)),
    );
  } catch (err) {
    console.log('DELETE COMPANY CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err));
  }
};
