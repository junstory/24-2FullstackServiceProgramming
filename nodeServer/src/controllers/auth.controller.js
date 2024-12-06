// app.js
import dotenv from 'dotenv';
import express from 'express';
import axios from 'axios';
import { response } from '../../config/response.js';
import { status } from '../../config/response.status.js';
import { loginUserDAO } from '../models/user.dao.js';
const authRouter = express();
dotenv.config();

authRouter.post('/login', async (req, res) => {
  console.log('log in');
  const { email, password } = req.body;
  try {
    console.log('login user : ', req.body);
    return res.send(
      response(status.SUCCESS, await loginUserDAO(email, password)),
    );
  } catch (err) {
    console.log('LOGIN USER CTRL ERR: ', err);
    res.status(400).send(response(status.BAD_REQUEST, err.Error));
  }
});

// 카카오 로그인 초기화 경로 (로그인 페이지로 리디렉트)
authRouter.get('/kakao', (req, res) => {
  console.log('auth in');
  console.log(process.env.KAKAO_REST_API_KEY);
  console.log(process.env.KAKAO_REDIRECT_URI);
  const kakaoAuthUrl = `https://kauth.kakao.com/oauth/authorize?client_id=${process.env.KAKAO_REST_API_KEY}&redirect_uri=${process.env.KAKAO_REDIRECT_URI}&response_type=code`;
  res.redirect(kakaoAuthUrl);
});

// 카카오 로그인 리디렉트 URI
authRouter.get('/kakao/callback', async (req, res) => {
  console.log('redirected');
  const code = req.query.code;
  try {
    // 1. 인가 코드를 이용해 액세스 토큰 요청
    const tokenResponse = await axios.post(
      'https://kauth.kakao.com/oauth/token',
      new URLSearchParams({
        grant_type: 'authorization_code',
        client_id: process.env.KAKAO_REST_API_KEY,
        redirect_uri: process.env.KAKAO_REDIRECT_URI,
        code: code,
      }),
      {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      },
    );

    const accessToken = tokenResponse.data.access_token;

    // 2. 액세스 토큰을 이용해 사용자 정보 요청
    const userResponse = await axios.get('https://kapi.kakao.com/v2/user/me', {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });

    const userInfo = userResponse.data;
    console.log('User Info:', userInfo);

    // 3. 사용자 정보를 바탕으로 JWT 생성 또는 세션 설정
    // 예시로 세션에 사용자 정보를 저장합니다 (실제 구현에서는 JWT를 사용할 수도 있습니다).
    // req.session.user = {
    //   id: userInfo.id,
    //   nickname: userInfo.kakao_account.name,
    //   email: userInfo.kakao_account.email,
    // };

    // 4. 최종 리디렉트 (로그인 완료 페이지로 이동)
    res.redirect('http://localhost:3000/oauth/dashboard'); // 로그인 후 보여줄 페이지로 리디렉트합니다.
  } catch (error) {
    console.error('Error during Kakao login process:', error);
    res.status(500).send('카카오 로그인 중 오류가 발생했습니다.');
  }
});

// 대시보드 페이지 (로그인 후 사용자 정보 확인 가능)
authRouter.get('/dashboard', (req, res) => {
  res.send(`로그인 성공! <br>`);
});

// 로그아웃 경로
authRouter.get('/logout', (req, res) => {
  req.session.destroy();
  res.redirect('/');
});

export default authRouter;
