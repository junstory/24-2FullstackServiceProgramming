import request from 'supertest';
import express from 'express';
import userRouter from './src/routes/user.route.js';
import commuteRouter from './src/routes/commute.route.js';
import scheduleRouter from './src/routes/schedule.route.js';

const app = express();
app.use(express.json());
app.use('/api/v1/user', userRouter);
app.use('/api/v1/commute', commuteRouter);
app.use('/api/v1/schedule', scheduleRouter);

app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    message: 'Not Found',
  });
});

describe('Test the root path', () => {
  test('It should respond with 404 for unknown routes', async () => {
    const response = await request(app).get('/unknown');
    expect(response.statusCode).toBe(404);
    expect(response.body).toEqual({
      success: false,
      message: 'Not Found',
    });
  });
});

describe('Test the /api/v1/user path', () => {
  test('It should respond with 200 for user route', async () => {
    const response = await request(app).get('/api/v1/user');
    expect(response.statusCode).toBe(200);
  });
});

describe('Test the /api/v1/commute path', () => {
  test('It should respond with 200 for commute route', async () => {
    const response = await request(app).get('/api/v1/commute');
    expect(response.statusCode).toBe(200);
  });
});

describe('Test the /api/v1/schedule path', () => {
  test('It should respond with 200 for schedule route', async () => {
    const response = await request(app).get('/api/v1/schedule');
    expect(response.statusCode).toBe(200);
  });
});
