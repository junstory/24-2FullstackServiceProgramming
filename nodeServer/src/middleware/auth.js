import { verifyToken } from '../util/jwt.js';

export const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  console.log('authHeader:', authHeader, '\ntoken:', token);
  if (!token) {
    return res.status(401).json({ message: '토큰이 필요합니다.' });
  }

  try {
    const decoded = verifyToken(token);
    console.log('decoded:', decoded);
    req.user = decoded; // 토큰에서 추출한 사용자 정보를 요청 객체에 추가
    next();
  } catch (err) {
    return res.status(403).json({ message: '유효하지 않은 토큰입니다.' });
  }
};

export default authenticateToken;
