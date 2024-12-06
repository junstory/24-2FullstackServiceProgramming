import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config();

const SECRET_KEY = process.env.JWT_SECRET_KEY || 'my-strong-secret-key'; // JWT 비밀 키 설정
const EXPIRES_IN = process.env.JWT_EXPIRE || '24h'; // 토큰 만료 시간 설정

// JWT 토큰 생성
export const generateToken = (payload) => {
  return jwt.sign(payload, SECRET_KEY, { expiresIn: EXPIRES_IN });
};

// JWT 토큰 검증
export const verifyToken = (token) => {
  try {
    return jwt.verify(token, SECRET_KEY);
  } catch (err) {
    console.error('Invalid token:', err);
    throw new Error('유효하지 않은 토큰입니다.');
  }
};
