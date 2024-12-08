import request from 'supertest'; // supertest를 이용해 API 요청
import app from '../index.js'; // Express 앱 (경로는 실제 프로젝트에 맞춰 수정)
import { db } from '../../config/db.config.js'; // DB 모듈 Mock
import { userGetInfoDAO } from '../../src/models/user.dao.js'; // DAO 모듈 Mock
import { jest } from '@jest/globals';

//jest.mock('../../src/models/user.dao'); // DAO 모듈 Mocking

describe('User Controller Tests', () => {
  afterEach(() => {
    jest.clearAllMocks(); // 각 테스트 후 Mock 초기화
  });

  describe('GET /:userId - Get User Info', () => {
    it('should return user information successfully', async () => {
      // Mock DAO Response
      const mockUserInfo = {
        id: 1,
        email: 'test@example.com',
        name: 'Test User',
        gender: 'M',
        phoneNumber: '01012345678',
        birthday: '1990-01-01',
        companyId: 1,
        companyName: 'Test Company',
        roleId: 2,
        roleName: 'Employee',
        today_plan_in: '2024-12-08 09:00:00',
        today_plan_out: '2024-12-08 18:00:00',
        next_plan_in: '2024-12-09 09:00:00',
        next_plan_out: '2024-12-09 18:00:00',
      };

      // Send a request to the API
      const response = await request(app).get('/api/v1/user/1');

      // Check the response
      expect(response.status).toBe(200);
      expect(response.body.isSuccess).toBe(true);
      expect(response.body.result).toEqual({
        id: mockUserInfo.id,
        email: mockUserInfo.email,
        name: mockUserInfo.name,
        gender: mockUserInfo.gender,
        phoneNumber: mockUserInfo.phoneNumber,
        birthday: mockUserInfo.birthday,
        companyId: mockUserInfo.companyId,
        companyName: mockUserInfo.companyName,
        roleId: mockUserInfo.roleId,
        roleName: mockUserInfo.roleName,
        todayPlanIn: mockUserInfo.today_plan_in,
        todayPlanOut: mockUserInfo.today_plan_out,
        nextPlanIn: mockUserInfo.next_plan_in,
        nextPlanOut: mockUserInfo.next_plan_out,
      });
    });

    it('should return 404 if user is not found', async () => {
      // Mock DAO Response for no user
      userGetInfoDAO.mockRejectedValue(new Error('No data found'));

      // Send a request to the API
      const response = await request(app)
        .get('/api/v1/user/1')
        .set('Authorization', 'Bearer mockToken')
        .send(); // Authorization 헤더 추가;

      // Check the response
      expect(response.status).toBe(404);
      expect(response.body.isSuccess).toBe(false);
      expect(response.body.message).toBe('No data found');
    });
  });
});
