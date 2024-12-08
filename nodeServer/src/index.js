import express from 'express';
import dotenv from 'dotenv';
import authenticateToken from './middleware/auth.js';
import userRouter from './routes/user.route.js';
import companyRouter from './routes/company.route.js';
import planRouter from './routes/plan.route.js';
import adminRouter from './routes/admin.route.js';
import oauthRouter from './controllers/auth.controller.js';
import swaggerUi from 'swagger-ui-express';
//import swaggerFile from './swagger/swagger_output.json' assert { type: 'json' };
import data from './swagger/swagger-output.js';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;
app.use(express.json());
//app.use(cors());

app.use((req, res, next) => {
  console.log('====================================');
  console.log(`${req.method} ${req.url}`);
  next();
});

app.use('/api/v1/user', authenticateToken, userRouter);
app.use('/api/v1/company', companyRouter);
app.use('/api/v1/plan', planRouter);
app.use('/api/v1/admin', adminRouter);
app.use('/auth', oauthRouter);

//swagger 문서화를 위한 api
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(data));

app.get('/health', (req, res) => {
  res.json({
    isSuccess: true,
  });
});
app.get('/', (req, res) => {
  res.json({
    isSuccess: true,
  });
});
app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    message: 'Not found',
  });
});

app.listen(port, () => {
  console.log(`server is listening at ${port}`);
});

export default app;
