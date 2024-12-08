import request from 'supertest';
import app from '../routes/user.route.js'; // 실제 Express 앱이 정의된 파일
import { test_db } from '../../config/db_test.config.js'; // SQLite 또는 다른 데이터베이스 연결

beforeAll(async () => {
  // 데이터베이스 초기화 또는 모킹
  await test_db.run('DELETE FROM users'); // 테스트 전 데이터 삭제
});

describe('입력 A: 예외 처리 테스트', () => {
  test('공백만 입력되면 오류가 발생합니다', () => {});
  test('문자를 입력하면 오류가 발생합니다', () => {});
  test('3자리가 아닌 숫자를 입력하면 오류가 발생합니다', () => {});
});
// 사용자 생성 테스트
// describe('User Controller Tests', () => {
//   test('Create User - Success', async () => {
//     const newUser = {
//       email: 'testuser@example.com',
//       pssword: 'testpassword',
//       name: 'Test User',
//       gender: 'M',
//       phoneNumber: '01012345678',
//       birthday: '1990-01-01',
//     };

//     const response = await request(app)
//       .post('/') // 실제 API 경로
//       .send({
//         email: 'testuser@example.com',
//         pssword: 'testpassword',
//         name: 'Test User',
//         gender: 'M',
//         phoneNumber: '01012345678',
//         birthday: '1990-01-01',
//       });

//     expect(response.status).toBe(200);
//     expect(response.body.isSuccess).toBe(true);
//     expect(response.body.result.userId).toBeDefined(); // 생성된 userId가 있는지 확인
//   });

//   test('Get User Info - Success', async () => {
//     const userId = 1; // 생성된 사용자 ID
//     const response = await request(app).get(`/api/v1/user/${userId}`);

//     expect(response.status).toBe(200);
//     expect(response.body.isSuccess).toBe(true);
//     expect(response.body.result.email).toBe('testuser@example.com'); // 이메일 확인
//   });

//   test('Start Work - Success', async () => {
//     const workStartData = {
//       userId: 1,
//     };

//     const response = await request(app)
//       .post('/api/v1/user/work/start') // 출근 API 경로
//       .send(workStartData);

//     expect(response.status).toBe(200);
//     expect(response.body.isSuccess).toBe(true);
//     expect(response.body.result.message).toBe('출근 등록 성공');
//   });

//   test('End Work - Success', async () => {
//     const workEndData = {
//       userId: 1,
//     };

//     const response = await request(app)
//       .post('/api/v1/user/work/end') // 퇴근 API 경로
//       .send(workEndData);

//     expect(response.status).toBe(200);
//     expect(response.body.isSuccess).toBe(true);
//     expect(response.body.result.message).toBe('퇴근 등록 성공');
//   });
//});

afterAll(async () => {
  // 테스트 후 데이터 정리
  await test_db.run('DELETE FROM users');
  test_db.close(); // 연결 해제
});
