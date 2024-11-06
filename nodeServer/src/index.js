import express from 'express';
import dotenv from 'dotenv';
import userRouter from './routes/user.route.js';
import commuteRouter from './routes/commute.route.js';
import planRouter from './routes/plan.route.js';
import adminRouter from './routes/admin.route.js';
import planRouter from './routes/plan.route.js';

const app = express();
const port = process.env.PORT || 3000;
app.use(express.json());
//app.use(cors());

app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

app.use('/api/v1/user', userRouter);
app.use('/api/v1/commute', commuteRouter);
app.use('/api/v1/plan', planRouter);
//app.use('/api/v1/admin', adminRouter);

app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    message: 'Not Found',
  });
});

// app.get('/', (req, res) => {
//   res.json({
//     success: true,
//   });
// });

app.listen(port, () => {
  console.log(`server is listening at ${port}`);
});
