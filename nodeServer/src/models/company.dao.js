import db from '../../config/db.config.js';

// 회사 생성 함수
export const createCompanyDAO = async (company) => {
  try {
    const existingCompany = await new Promise((resolve, reject) => {
      db.get(
        `SELECT * FROM company WHERE name = ? AND address = ?`,
        [company.name, company.address],
        (err, row) => {
          if (err) {
            console.error('createCompanyDAO error:', err);
            reject('회사 조회 실패');
          } else {
            resolve(row);
          }
        },
      );
    });

    if (existingCompany) {
      throw '동일한 회사가 이미 존재합니다';
    }
    const companyId = await new Promise((resolve, reject) => {
      db.run(
        `INSERT INTO company (name, address) VALUES (?, ?)`,
        [company.name, company.address],
        function (err) {
          if (err) {
            console.error('createCompanyDAO error:', err);
            reject('회사 생성 실패');
          } else {
            resolve(this.lastID); // 생성된 회사의 ID 반환
          }
        },
      );
    });

    return { message: 'Company created successfully', companyId };
  } catch (error) {
    console.error('Error in createCompanyDAO:', error);
    throw error;
  }
};

// 회사 정보 조회 함수
export const companyGetInfoDAO = async (companyId) => {
  try {
    const companyInfo = await new Promise((resolve, reject) => {
      db.get(`SELECT * FROM company WHERE id = ?`, [companyId], (err, row) => {
        if (err) {
          console.error('companyGetInfoDAO error:', err);
          reject('회사 조회 실패');
        } else if (!row) {
          reject('해당 ID의 회사를 찾을 수 없습니다');
        } else {
          resolve(row);
        }
      });
    });

    return companyInfo;
  } catch (error) {
    console.error('Error in companyGetInfoDAO:', error);
    throw error;
  }
};

// 회사 정보 업데이트 함수
export const updateCompanyDAO = async (companyId, updatedCompany) => {
  try {
    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE company 
                SET name = ?, address = ?, updated_at = CURRENT_TIMESTAMP 
                WHERE id = ?`,
        [updatedCompany.name, updatedCompany.address, companyId],
        function (err) {
          if (err) {
            console.error('updateCompanyDAO error:', err);
            reject('회사 정보 수정 실패');
          } else if (this.changes === 0) {
            reject('해당 ID의 회사를 찾을 수 없습니다');
          } else {
            resolve({
              message: 'Company updated successfully',
              changes: this.changes,
            });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in updateCompanyDAO:', error);
    throw error;
  }
};

// 회사 삭제 함수
export const deleteCompanyDAO = async (companyId) => {
  try {
    const result = await new Promise((resolve, reject) => {
      db.run(`DELETE FROM company WHERE id = ?`, [companyId], function (err) {
        if (err) {
          console.error('deleteCompanyDAO error:', err);
          reject('회사 삭제 실패');
        } else if (this.changes === 0) {
          reject('해당 ID의 회사를 찾을 수 없습니다');
        } else {
          resolve({
            message: 'Company deleted successfully',
            changes: this.changes,
          });
        }
      });
    });

    return result;
  } catch (error) {
    console.error('Error in deleteCompanyDAO:', error);
    throw error;
  }
};
