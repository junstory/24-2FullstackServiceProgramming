module.exports = {
  apps: [
    {
      name: 'my-app', // 애플리케이션 이름
      script: './src/index.js', // 실행할 파일 경로
      instances: 'max', // 클러스터 모드: CPU 코어 수만큼 실행
      exec_mode: 'cluster', // 클러스터 모드 사용
      watch: true, // 파일 변경 시 자동 재시작
      ignore_watch: ['node_modules', 'logs'], // 감시 제외 폴더
      env: {
        NODE_ENV: 'development', // 개발 환경 변수
        PORT: 3000,
      },
      env_production: {
        NODE_ENV: 'production', // 프로덕션 환경 변수
        PORT: 8080,
      },
      log_file: './logs/app.log', // 로그 파일 경로
      error_file: './logs/error.log', // 에러 로그 경로
      out_file: './logs/out.log', // 일반 로그 경로
      time: true, // 로그에 타임스탬프 추가
    },
  ],
};
