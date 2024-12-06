import db from '../../config/db.config.js';

// 1. 사용자를 인증하여 입사 처리하는 함수 (회사 활성화)
export const adminActivateUserDAO = async (targetId, req) => {
  try {
    const userCompanyExists = await new Promise((resolve, reject) => {
      db.get(
        `SELECT 1 FROM user_company WHERE user_id = ? AND company_id = ?`,
        [targetId, req.companyId],
        (err, row) => {
          if (err) {
            console.error('Error checking user_company:', err);
            reject('사용자 회사 확인 실패');
          } else if (!row) {
            reject('해당 사용자가 회사에 속해 있지 않습니다');
          } else {
            resolve(true);
          }
        },
      );
    });

    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE user_company SET is_activated = 1 WHERE user_id = ?`,
        [targetId],
        function (err) {
          if (err) {
            console.error('adminActivateUserDAO error:', err);
            reject('사용자 등록 실패');
          } else if (this.changes === 0) {
            reject('해당 ID의 사용자를 찾을 수 없습니다');
          } else {
            resolve({ message: 'User activated successfully' });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in adminActivateUserDAO:', error);
    throw error;
  }
};

// 2. 회사에서 사용자를 제거하는 함수 (회사 비활성화)
export const adminDeactivateUserDAO = async (targetId, req) => {
  try {
    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE user_company SET is_activated = 0 WHERE user_id = ? AND company_id = ?`,
        [targetId, req.companyId],
        function (err) {
          if (err) {
            console.error('adminDeactivateUserDAO error:', err);
            reject('사용자 비활성화 실패');
          } else if (this.changes === 0) {
            reject('해당 ID의 사용자를 찾을 수 없습니다');
          } else {
            resolve({ message: 'User deactivated successfully' });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in adminDeactivateUserDAO:', error);
    throw error;
  }
};

// 3. 사용자 출근 시간 수정
export const adminStartWorkDAO = async (targetId, req) => {
  try {
    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE commutes SET go_to_work = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ? AND id = ?`,
        [req.goToWork, targetId, req.commuteId],
        function (err) {
          if (err) {
            console.error('adminStartWorkDAO error:', err);
            reject('출근 시간 수정 실패');
          } else if (this.changes === 0) {
            reject('값이 잘못되었습니다. 다시 시도해주세요');
          } else {
            resolve({ message: 'Work start time updated successfully' });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in adminStartWorkDAO:', error);
    throw error;
  }
};

// 4. 사용자 퇴근 시간 수정
export const adminEndWorkDAO = async (targetId, req) => {
  try {
    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE commutes SET get_off_work = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ? AND id = ?`,
        [req.getOffWork, targetId, req.commuteId],
        function (err) {
          if (err) {
            console.error('adminEndWorkDAO error:', err);
            reject('퇴근 시간 수정 실패');
          } else if (this.changes === 0) {
            reject('퇴근 기록이 존재하지 않거나 이미 설정되었습니다');
          } else {
            resolve({ message: 'Work end time updated successfully' });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in adminEndWorkDAO:', error);
    throw error;
  }
};

// 5. 사용자 출퇴근 기록 확인
export const adminCheckUserCommuteDAO = async (targetId, req) => {
  try {
    let month, year;
    if (req.date) {
      const date = new Date(req.date);
      month = date.getMonth() + 1;
      year = date.getFullYear();
    } else {
      month = new Date().getMonth() + 1;
      year = new Date().getFullYear();
    }
    console.log('month:', month, 'year:', year);

    const commuteData = await new Promise((resolve, reject) => {
      db.all(
        `SELECT * FROM commutes 
           WHERE user_id = ? 
           AND strftime('%Y', plan_in) = ? 
           AND strftime('%m', plan_in) = ?`,
        [targetId, String(year), month.toString().padStart(2, '0')],
        (err, rows) => {
          if (err) {
            console.error('adminCheckUserCommuteDAO error:', err);
            reject('출퇴근 기록 조회 실패');
          } else if (rows.length === 0) {
            reject('해당 사용자의 출퇴근 기록이 없습니다');
          } else {
            resolve(rows);
          }
        },
      );
    });

    return commuteData;
  } catch (error) {
    console.error('Error in adminCheckUserCommuteDAO:', error);
    throw error;
  }
};
