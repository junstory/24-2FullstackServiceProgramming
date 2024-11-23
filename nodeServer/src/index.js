import express from 'express';
import dotenv from 'dotenv';
import userRouter from './routes/user.route.js';
import companyRouter from './routes/company.route.js';
import planRouter from './routes/plan.route.js';
import adminRouter from './routes/admin.route.js';
import oauthRouter from './controllers/oauth.controller.js';

const app = express();
const port = process.env.PORT || 3000;
app.use(express.json());
//app.use(cors());

app.use((req, res, next) => {
  console.log('====================================');
  console.log(`${req.method} ${req.url}`);
  next();
});

app.use('/api/v1/user', userRouter);
app.use('/api/v1/company', companyRouter);
app.use('/api/v1/plan', planRouter);
app.use('/api/v1/admin', adminRouter);
app.use('/oauth', oauthRouter);

app.get('/health', (req, res) => {
  res.json({
    success: true,
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
