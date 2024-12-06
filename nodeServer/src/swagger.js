import swaggerAutogen from 'swagger-autogen';
//const swagger = swaggerAutogen({ openapi: '3.0.0' });

// import { createRequire } from 'module';
// const require = createRequire(import.meta.url);

// const swaggerAutogen = require('swagger-autogen')();

const PORT = 3000; // 사용하는 포트 번호에 맞게 변경

const options = {
  info: {
    title: 'Fullstack service programming Server API 명세',
    description: '사용되는 다양한 API를 테스트합니다.',
  },
  servers: [
    {
      url: `http://localhost:${PORT}`, // base URL
    },
  ],
  schemes: ['http'], // 사용할 프로토콜
  securityDefinitions: {
    // JWT 인증을 위한 설정
    bearerAuth: {
      type: 'http',
      scheme: 'bearer',
      in: 'header',
      bearerFormat: 'JWT',
    },
  },
};

const outputFile = './swagger/swagger-output.json'; // 생성될 Swagger 설정 파일의 경로 및 파일명
const endpointsFiles = ['./index.js']; // 기본 라우터 즉, app.use("/", router)가 정의된 파일의 경로
//swaggerAutogen(outputFile, endpointsFiles, options); // Swagger 문서를 outputFile 경로에 생성
swaggerAutogen({ openapi: '3.0.0' })(outputFile, endpointsFiles, options);
