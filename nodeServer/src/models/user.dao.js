import sqlite3 from 'sqlite3'
import { db,executeTransaction } from '../../config/db.config.js'
import { userResponseDTO } from '../dtos/user.dto.js';

export const userGetInfoDAO = async (userId) => {
    try {
        const userInfo = await new Promise((resolve, reject) => {
            db.get(
                `SELECT
                    u.*,
                    c.id AS company_id,
                    c.name AS company_name,
                    r.id AS role_id,
                    r.name AS role_name,
                    co.id AS commute_id,
                    co.go_to_work,
                    co.get_off_work
                FROM
                    users u
                LEFT JOIN user_company uc ON u.id = uc.user_id
                LEFT JOIN company c ON uc.company_id = c.id
                LEFT JOIN user_role ur ON u.id = ur.user_id
                LEFT JOIN role r ON ur.role_id = r.id
                LEFT JOIN commutes co ON u.id = co.user_id
                WHERE u.id = ?;`, 
                [userId],
                (err, row) => {
                    if (err) {
                        console.error('userGetInfoDAO error:', err);
                        reject(err); // 에러 시 reject
                    } else {
                        console.log('Query result:', row);
                        resolve(row); // 성공 시 resolve
                    }
                }
            );
        });

        // userInfo가 조회된 경우 반환 처리
        return userResponseDTO(userInfo);
    } catch (error) {
        console.error('Error in userGetInfoDAO:', error);
        throw error; // 상위로 에러 전파
    }
    
}

export const userGetInfoTEST = async (userId) => {
    const user = db.get(
        `SELECT
    u.*,
    c.id AS company_id,
    c.name AS company_name,
    r.id AS role_id,
    r.name AS role_name,
    co.id AS commute_id,
    co.go_to_work,
    co.get_off_work
FROM
    users u
LEFT JOIN user_company uc ON ? = uc.user_id
LEFT JOIN company c ON uc.company_id = c.id
LEFT JOIN user_role ur ON ? = ur.user_id
LEFT JOIN role r ON ur.role_id = r.id
LEFT JOIN commutes co ON ? = co.user_id;`,[userId,userId,userId], (err, row) => {
        if (err) {
            console.error('userGetInfoDAO error:', err);
            return null;
        }
        return row;
    }
    );
    console.log('userGetInfoDAO : ', user);
}