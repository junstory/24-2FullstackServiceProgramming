import sqlite3 from 'sqlite3';
import { db, executeTransaction } from '../../config/db.config.js';
import { planResponseDTO } from '../dtos/plan.dto.js';

//Create
export const createPlanDAO = async (plan) => {
  try {
    // 사용자 중복 확인
    const existingUser = await new Promise((resolve, reject) => {
      db.get(`SELECT id FROM users WHERE id = ?`, [plan.userId], (err, row) => {
        if (err) {
          console.error('Error checking existing user:', err);
          reject('회원 확인 실패');
        } else {
          resolve(row); // row가 있으면 중복된 사용자
        }
      });
    });

    if (!existingUser) {
      throw new Error('존재하지 않는 회원입니다.'); // 중복된 사용자 예외 발생
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
export const updatePlanDAO = async (updatedPlan) => {
  try {
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
          updatedPlan.planId,
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

// // 사용자 삭제 함수
// export const deleteUserDAO = async (userId) => {
//   try {
//     // 사용자 삭제 전에 외래 키가 걸린 테이블에서 데이터를 먼저 삭제해야 할 수도 있음
//     await new Promise((resolve, reject) => {
//       db.run(
//         `DELETE FROM user_company WHERE user_id = ?`,
//         [userId],
//         function (err) {
//           if (err) {
//             console.error('Error deleting from user_company:', err);
//             reject('user_company 테이블에서 관계 삭제 실패');
//           } else {
//             resolve();
//           }
//         },
//       );
//     });

//     await new Promise((resolve, reject) => {
//       db.run(
//         `DELETE FROM user_role WHERE user_id = ?`,
//         [userId],
//         function (err) {
//           if (err) {
//             console.error('Error deleting from user_role:', err);
//             reject('user_role 테이블에서 관계 삭제 실패');
//           } else {
//             resolve();
//           }
//         },
//       );
//     });

//     // 사용자 삭제
//     const result = await new Promise((resolve, reject) => {
//       db.run(`DELETE FROM users WHERE id = ?`, [userId], function (err) {
//         if (err) {
//           console.error('Error deleting user:', err);
//           reject('회원 삭제 실패');
//         } else if (this.changes === 0) {
//           reject('해당 ID의 사용자를 찾을 수 없습니다');
//         } else {
//           resolve({
//             message: 'User deleted successfully',
//             changes: this.changes,
//           });
//         }
//       });
//     });

//     return result;
//   } catch (error) {
//     console.error('Error in deleteUserDAO:', error);
//     throw error;
//   }
// };

// //사용자와 회사 관계 등록
// export const linkUserToCompanyDAO = async (userId, companyId) => {
//   try {
//     await new Promise((resolve, reject) => {
//       db.run(
//         `INSERT INTO user_company (user_id, company_id) VALUES (?, ?)`,
//         [userId, companyId],
//         (err) => {
//           if (err) {
//             console.error('linkUserToCompanyDAO error:', err);
//             reject('사용자와 회사 관계 등록 실패');
//           } else {
//             resolve();
//           }
//         },
//       );
//     });
//   } catch (error) {
//     console.error('Error in linkUserToCompanyDAO:', error);
//     throw error;
//   }
// };
