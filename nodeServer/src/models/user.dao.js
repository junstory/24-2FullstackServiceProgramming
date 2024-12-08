import { db } from '../../config/db.config.js';
import bcrypt from 'bcrypt';
import { userResponseDTO, loginResDto } from '../dtos/user.dto.js';
import { BaseError } from '../../config/error.js';
import { generateToken } from '../util/jwt.js';

//Create
export const createUserDAO = async (user) => {
  console.log('user:', user);
  try {
    // 사용자 중복 확인
    const existingUser = await new Promise((resolve, reject) => {
      db.get(
        `SELECT id FROM users WHERE email = ?`,
        [user.email],
        (err, row) => {
          if (err) {
            console.error('Error checking existing user:', err);
            reject('회원 중복 확인 실패');
          } else {
            resolve(row); // row가 있으면 중복된 사용자
          }
        },
      );
    });

    if (existingUser) {
      throw new BaseError('이미 존재하는 이메일입니다.'); // 중복된 사용자 예외 발생
    }

    // 비밀번호 해시 생성
    const hashedPassword = await bcrypt.hash(user.password, 10);

    const newUserId = await new Promise((resolve, reject) => {
      db.run(
        `INSERT INTO users (email, name, gender, phone_num, birthday, password) VALUES (?, ?, ?, ?, ?, ?)`,
        [
          user.email,
          user.name,
          user.gender,
          user.phoneNumber,
          user.birthday,
          hashedPassword,
        ],
        function (err) {
          if (err) {
            console.error('createUserDAO error:', err);
            reject('회원 생성 실패');
          } else {
            resolve(this.lastID); // 생성된 사용자의 ID 반환
          }
        },
      );
    });

    // 역할 등록 (role은 미리 정의된 값이 필요하므로 이름을 기준으로 조회)
    //기본 employee로 설정하기 위해  req로 isAdmin 입력 안함.
    const roleId = user.isAdmin ? 1 : 2; // 예: 1은 'admin', 2는 'employee'

    // user_role 테이블에 사용자와 역할 관계 등록
    await new Promise((resolve, reject) => {
      db.run(
        `INSERT INTO user_role (user_id, role_id) VALUES (?, ?)`,
        [newUserId, roleId],
        (err) => {
          if (err) {
            console.error('User-Role relation insert error:', err);
            reject('사용자와 역할 관계 등록 실패');
          } else {
            resolve();
          }
        },
      );
    });

    return {
      message: 'User and role created successfully',
      userId: newUserId,
      roleId,
    };
  } catch (error) {
    console.error('Error in createUserDAO:', error);
    throw error;
  }
};

//READ
export const userGetInfoDAO = async (userId) => {
  try {
    const userInfo = await new Promise((resolve, reject) => {
      db.get(
        `SELECT
          u.*,
          c.id AS company_id,
          uc.is_activated AS company_is_active,
          c.name AS company_name,
          r.id AS role_id,
          r.name AS role_name,
          co.id AS commute_id,
          co.plan_in AS today_plan_in,
          co.go_to_work AS today_go_to_work,
          co.plan_out AS today_plan_out,
          co.get_off_work AS today_get_off_work,
          co_next.plan_in AS next_plan_in,
          co_next.plan_out AS next_plan_out
        FROM
          users u
        LEFT JOIN user_company uc ON u.id = uc.user_id
        LEFT JOIN company c ON uc.company_id = c.id
        LEFT JOIN user_role ur ON u.id = ur.user_id
        LEFT JOIN role r ON ur.role_id = r.id
        LEFT JOIN commutes co ON u.id = co.user_id AND DATE(co.plan_in) = DATE('now')
        LEFT JOIN commutes co_next ON u.id = co_next.user_id AND DATE(co_next.plan_in) = DATE('now', '+1 day')
        WHERE u.id = ?;`,
        [userId],
        (err, row) => {
          if (err) {
            console.error('userGetInfoDAO error:', err);
            reject('회원조회 실패'); // 에러 시 reject
          } else {
            if (!row) {
              console.log('No data found');
              reject('No data found'); // 조회 결과 없을 시 reject
            }
            console.log('Query result:', row);
            resolve(row); // 성공 시 resolve
          }
        },
      );
    });

    // userInfo가 조회된 경우 반환 처리
    return userResponseDTO(userInfo);
  } catch (error) {
    console.error('Error in userGetInfoDAO:', error);
    throw error; // 상위로 에러 전파
  }
};

// 사용자 정보 업데이트 함수
export const updateUserDAO = async (userId, updatedUser) => {
  try {
    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE users 
                SET email = ?, 
                    name = ?, 
                    gender = ?, 
                    phone_num = ?, 
                    birthday = ?, 
                    updated_at = (datetime('now', 'localtime')) 
                WHERE id = ?`,
        [
          updatedUser.email,
          updatedUser.name,
          updatedUser.gender,
          updatedUser.phoneNumber,
          updatedUser.birthday,
          userId,
        ],
        function (err) {
          if (err) {
            console.error('updateUserDAO error:', err);
            reject('회원 정보 수정 실패');
          } else if (this.changes === 0) {
            reject('해당 ID의 사용자를 찾을 수 없습니다');
          } else {
            resolve({
              message: 'User updated successfully',
              changes: this.changes,
            });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in updateUserDAO:', error);
    throw error;
  }
};

// 사용자 삭제 함수
export const deleteUserDAO = async (userId) => {
  try {
    // 사용자 삭제 전에 외래 키가 걸린 테이블에서 데이터를 먼저 삭제해야 할 수도 있음
    await new Promise((resolve, reject) => {
      db.run(
        `DELETE FROM user_company WHERE user_id = ?`,
        [userId],
        function (err) {
          if (err) {
            console.error('Error deleting from user_company:', err);
            reject('user_company 테이블에서 관계 삭제 실패');
          } else {
            resolve();
          }
        },
      );
    });

    await new Promise((resolve, reject) => {
      db.run(
        `DELETE FROM user_role WHERE user_id = ?`,
        [userId],
        function (err) {
          if (err) {
            console.error('Error deleting from user_role:', err);
            reject('user_role 테이블에서 관계 삭제 실패');
          } else {
            resolve();
          }
        },
      );
    });

    // 사용자 삭제
    const result = await new Promise((resolve, reject) => {
      db.run(`DELETE FROM users WHERE id = ?`, [userId], function (err) {
        if (err) {
          console.error('Error deleting user:', err);
          reject('회원 삭제 실패');
        } else if (this.changes === 0) {
          reject('해당 ID의 사용자를 찾을 수 없습니다');
        } else {
          resolve({
            message: 'User deleted successfully',
            changes: this.changes,
          });
        }
      });
    });

    return result;
  } catch (error) {
    console.error('Error in deleteUserDAO:', error);
    throw error;
  }
};

//사용자 출근
export const userWorkStartDAO = async (req) => {
  try {
    // 사용자 존재 여부 확인
    const userExists = await new Promise((resolve, reject) => {
      db.get(`SELECT id FROM users WHERE id = ?`, [req.userId], (err, row) => {
        if (err) {
          console.error('Error checking user existence:', err);
          reject('사용자 존재 확인 실패');
        } else {
          resolve(row); // row가 있으면 사용자 존재
        }
      });
    });

    if (!userExists) {
      throw '존재하지 않는 사용자입니다.'; // 사용자 존재하지 않음 예외 발생
    }
    // 오늘 날짜에 이미 출근 기록이 있는지 확인
    const existingCommute = await new Promise((resolve, reject) => {
      db.get(
        `SELECT id FROM commutes WHERE user_id = ? AND DATE(go_to_work) = DATE('now')`,
        [req.userId],
        (err, row) => {
          if (err) {
            console.error('Error checking existing commute:', err);
            reject('출근 기록 확인 실패');
          } else {
            resolve(row); // row가 있으면 이미 출근 기록이 있음
          }
        },
      );
    });

    if (existingCommute) {
      throw new BaseError('이미 오늘 출근 기록이 있습니다.'); // 중복된 출근 기록 예외 발생
    }
    // 출근 시간 기록
    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE commutes SET go_to_work = (datetime('now', 'localtime')) WHERE user_id = ? AND DATE(plan_in) = DATE('now')`,
        [req.userId],
        function (err) {
          if (err) {
            console.error('userWorkStartDAO error:', err);
            reject('출근 등록 실패');
          } else if (this.changes === 0) {
            reject('출근 시간을 기록할 수 없습니다.');
          } else {
            resolve({
              message: '출근 등록 성공',
              changes: this.changes,
            });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in userWorkStartDAO:', error);
    throw error;
  }
};

//사용자 퇴근
export const userWorkEndDAO = async (userId) => {
  try {
    // 오늘 날짜의 퇴근 예정(plan_out)이 존재하는지 확인
    const existingPlan = await new Promise((resolve, reject) => {
      db.get(
        `SELECT id FROM commutes WHERE user_id = ? AND DATE(plan_out) = DATE('now')`,
        [userId],
        (err, row) => {
          if (err) {
            console.error('Error checking existing plan:', err);
            reject('오늘 퇴근 예정 확인 실패');
          } else {
            resolve(row); // row가 있으면 퇴근 예정 존재
          }
        },
      );
    });

    if (!existingPlan) {
      throw new BaseError('오늘 퇴근 예정이 없습니다.'); // 퇴근 예정이 없으면 예외 발생
    }

    // 이미 퇴근 기록이 있는지 확인
    const existingCommute = await new Promise((resolve, reject) => {
      db.get(
        `SELECT id FROM commutes WHERE user_id = ? AND DATE(plan_out) = DATE('now') AND get_off_work IS NOT NULL`,
        [userId],
        (err, row) => {
          if (err) {
            console.error('Error checking existing commute:', err);
            reject('퇴근 기록 확인 실패');
          } else {
            resolve(row); // row가 있으면 이미 퇴근 기록이 있음
          }
        },
      );
    });

    if (existingCommute) {
      throw new BaseError('이미 오늘 퇴근 기록이 있습니다.'); // 중복된 퇴근 기록 예외 발생
    }

    // 퇴근 시간 기록
    const result = await new Promise((resolve, reject) => {
      db.run(
        `UPDATE commutes SET get_off_work = (datetime('now', 'localtime')) WHERE user_id = ? AND DATE(plan_out) = DATE('now')`,
        [userId],
        function (err) {
          if (err) {
            console.error('userWorkEndDAO error:', err);
            reject('퇴근 등록 실패');
          } else if (this.changes === 0) {
            reject('퇴근 시간을 기록할 수 없습니다.');
          } else {
            resolve({
              message: '퇴근 등록 성공',
              changes: this.changes,
            });
          }
        },
      );
    });

    return result;
  } catch (error) {
    console.error('Error in userWorkEndDAO:', error);
    throw new BaseError(error);
  }
};

//사용자와 회사 관계 등록
export const linkUserToCompanyDAO = async (userId, companyId) => {
  try {
    // 회사 존재 여부 확인
    const companyExists = await new Promise((resolve, reject) => {
      db.get(`SELECT id FROM company WHERE id = ?`, [companyId], (err, row) => {
        if (err) {
          console.error('Error checking company existence:', err);
          reject('회사 존재 확인 실패');
        } else {
          resolve(row); // row가 있으면 회사 존재
        }
      });
    });

    if (!companyExists) {
      throw '존재하지 않는 회사입니다.'; // 회사 존재하지 않음 예외 발생
    }

    //이미 등록된 회사가 있는지 확인
    const existingLink = await new Promise((resolve, reject) => {
      db.get(
        `SELECT is_activated FROM user_company WHERE user_id = ?`,
        [userId],
        (err, row) => {
          if (err) {
            console.error('Error checking existing link:', err);
            reject('기존 관계 확인 실패');
          } else {
            resolve(row); // row가 있으면 기존 관계 존재
          }
        },
      );
    });

    if (existingLink) {
      if (existingLink.is_activated === 1) {
        throw '이미 활성화된 사용자와 회사 관계가 있습니다.'; // 활성화된 관계 예외 발생
      } else {
        await new Promise((resolve, reject) => {
          db.run(
            `DELETE FROM user_company WHERE user_id = ?`,
            [userId],
            (err) => {
              if (err) {
                console.error('Error deleting existing link:', err);
                reject('기존 관계 삭제 실패');
              } else {
                resolve();
              }
            },
          );
        });
      }
    }

    await new Promise((resolve, reject) => {
      db.run(
        `INSERT INTO user_company (user_id, company_id) VALUES (?, ?)`,
        [userId, companyId],
        (err) => {
          if (err) {
            console.error('linkUserToCompanyDAO error:', err);
            reject('사용자와 회사 관계 등록 실패');
          } else {
            resolve();
          }
        },
      );
    });
  } catch (error) {
    console.error('Error in linkUserToCompanyDAO:', error);
    throw error;
  }
};

//login
export const loginUserDAO = async (email, password) => {
  try {
    const user = await new Promise((resolve, reject) => {
      db.get(
        `SELECT id, email, password, name FROM users WHERE email = ?`,
        [email],
        (err, row) => {
          if (err) {
            console.error('Error querying user:', err);
            reject('사용자 조회 실패');
          } else {
            resolve(row);
          }
        },
      );
    });

    if (!user) {
      throw new Error('사용자가 존재하지 않습니다.');
    }

    // 비밀번호 해시 검증
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      throw new Error('비밀번호가 올바르지 않습니다.');
    }

    // JWT 생성
    const token = generateToken({
      id: user.id,
      email: user.email,
      name: user.name,
    });

    return loginResDto(token);
  } catch (error) {
    console.error('Error in loginUserDAO:', error);
    throw error;
  }
};
