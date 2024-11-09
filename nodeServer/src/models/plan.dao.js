import sqlite3 from 'sqlite3';
import { db, executeTransaction } from '../../config/db.config.js';
import { planResponseDTO } from '../dtos/plan.dto.js';
import { BaseError } from '../../config/error.js';
import { status } from '../../config/response.status.js';
//Create
export const createPlanDAO = async (plan) => {
  try {
    // 사용자 존재 확인
    const existingUser = await new Promise((resolve, reject) => {
      db.get(`SELECT id FROM users WHERE id = ?`, [plan.userId], (err, row) => {
        if (err) {
          console.error('Error checking existing user:', err);
          reject('회원 확인 실패');
        } else {
          resolve(row); // row가 있으면 존재하는 사용자
        }
      });
    });

    if (!existingUser) {
      throw new BaseError(status.USER_NOT_EXISTS); // 존재하지 않는 사용자.
    }

    const newPlanId = await new Promise((resolve, reject) => {
      db.run(
        `INSERT INTO plans (user_id, description, start_date, end_date) VALUES (?, ?, ?, ?)`,
        [plan.userId, plan.description, plan.startDate, plan.endDate],
        function (err) {
          if (err) {
            console.error('createPlanDAO error:', err);
            reject('일정 등록 실패');
          } else {
            resolve(this.lastID); // 생성된 일정의 ID 반환
          }
        },
      );
    });

    return {
      message: 'Plan created successfully',
      planId: newPlanId,
    };
  } catch (error) {
    console.error('Error in createUserDAO:', error);
    throw error;
  }
};

//READ
export const getPlanInfoDAO = async (companyId) => {
  try {
    console.log('planGetInfoDAO:', companyId);
    let result = [];
    const companyInfo = await new Promise((resolve, reject) => {
      db.all(
        `SELECT
              u.id AS user_id,
              u.name AS user_name,
              c.name AS company_name,
              p.description,
              p.start_date,
              p.end_date
          FROM
              users u
                  JOIN
              user_company uc ON u.id = uc.user_id
                  JOIN
              company c ON uc.company_id = c.id
                  JOIN
              plans p ON u.id = p.user_id
          WHERE
              c.id = ? 
            AND uc.is_activated = 1
          ORDER BY
              u.id, p.start_date`,
        [companyId],
        (err, rows) => {
          if (err) {
            console.error('planGetInfoDAO error:', err);
            reject('일정조회 실패'); // 에러 시 reject
          } else {
            if (!rows || rows.length === 0) {
              console.log('No data found');
              resolve('No data found'); // 조회 결과 없을 시 reject
            }
            // if(!row.company_id){
            //     console.log('No company found');
            //     reject("No company found"); // 조회 결과 없을 시 reject
            // }
            console.log('Query result:', rows);
            result = rows;
            resolve(rows); // 성공 시 resolve
          }
        },
      );
    });
    console.log('result', result);
    // companyInfo 조회된 경우 반환 처리
    return planResponseDTO(result);
  } catch (error) {
    console.error('Error in planGetInfoDAO:', error);
    throw error; // 상위로 에러 전파
  }
};

// 일정 정보 업데이트 함수
export const updatePlanDAO = async (planId, updatedPlan) => {
  try {
    //사용자 확인
    const existingUser = await new Promise((resolve, reject) => {
      db.get(`SELECT user_id FROM plans WHERE id = ?`, [planId], (err, row) => {
        if (err) {
          console.error('Error checking existing user:', err);
          reject('회원 확인 실패');
        } else {
          resolve(row); // row가 있으면 일정이 존재.
        }
      });
    });

    if (!existingUser) {
      throw '일정을 조회할 수 없습니다.'; // 일정이 조회되지 않는 경우
    }

    if (existingUser.user_id !== updatedPlan.userId) {
      throw '사용자가 일치하지 않습니다.'; //new BaseError(status.USER_NOT_MATCHED); // 일정의 사용자와 업데이트 요청한 사용자가 일치하지 않는 경우
    }

    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE plans 
              SET description = ?, 
                  start_date = ?, 
                  end_date = ?, 
                  updated_at = CURRENT_TIMESTAMP 
              WHERE id = ?`,
        [
          updatedPlan.description,
          updatedPlan.startDate,
          updatedPlan.endDate,
          planId,
        ],
        function (err) {
          if (err) {
            console.error('updatePlanDAO error:', err);
            reject('일정 정보 수정 실패');
          } else if (this.changes === 0) {
            reject('해당 ID의 일정을 찾을 수 없습니다');
          } else {
            resolve({
              message: 'Plan updated successfully',
              changes: this.changes,
            });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in updatePlanDAO:', error);
    throw error;
  }
};

// 일정 정보 삭제 함수
export const deletePlanDAO = async (planId, req) => {
  try {
    const result = await new Promise((resolve, reject) => {
      db.run(
        `DELETE FROM plans WHERE id = ? and user_id = ?`,
        [planId, req.userId],
        function (err) {
          if (err) {
            console.error('deletePlanDAO error:', err);
            reject('일정 삭제 실패');
          } else if (this.changes === 0) {
            reject('해당 ID의 일정이 없거나 잘못된 사용자입니다.');
          } else {
            resolve({
              message: 'Plan deleted successfully',
              changes: this.changes,
            });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in deletePlanDAO:', error);
    throw error;
  }
};
