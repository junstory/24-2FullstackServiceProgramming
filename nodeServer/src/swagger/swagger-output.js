export const data = {
  openapi: '3.0.0',
  info: {
    title: 'Fullstack service programming Server API 명세',
    description: '사용되는 다양한 API를 테스트합니다.',
    version: '1.0.0',
  },
  servers: [
    {
      url: 'http://localhost:3000',
    },
  ],
  paths: {
    '/health': {
      get: {
        description: '서버 상태 확인',
        responses: {
          200: {
            description: 'OK',
          },
        },
      },
    },
    '/': {
      get: {
        description: '서버 상태 확인',
        responses: {
          200: {
            description: 'OK',
          },
        },
      },
    },
    '/api/v1/user/{userId}': {
      get: {
        description: '유저 정보 확인',
        parameters: [
          {
            name: 'userId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
      delete: {
        description: '유저 삭제',
        parameters: [
          {
            name: 'userId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
      put: {
        description: '유저 정보 수정',
        parameters: [
          {
            name: 'userId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/user/': {
      post: {
        description: '유저 생성',
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/user/company': {
      post: {
        description: '회사 지원',
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
        requestBody: {
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  userId: {
                    example: 'any',
                  },
                  companyId: {
                    example: 'any',
                  },
                },
              },
            },
          },
        },
      },
    },
    '/api/v1/user/commute/in': {
      post: {
        description: '출근 처리',
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
        requestBody: {
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  userId: {
                    example: 'any',
                  },
                },
              },
            },
          },
        },
      },
    },
    '/api/v1/user/commute/out': {
      post: {
        description: '퇴근 처리',
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
        requestBody: {
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  userId: {
                    example: 'any',
                  },
                },
              },
            },
          },
        },
      },
    },
    '/api/v1/company/': {
      post: {
        description: '회사 생성',
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/company/{companyId}': {
      get: {
        description: '회사 정보 확인',
        parameters: [
          {
            name: 'companyId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
      put: {
        description: '회사 정보 수정',
        parameters: [
          {
            name: 'companyId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
      delete: {
        description: '회사 삭제',
        parameters: [
          {
            name: 'companyId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/plan/{companyId}': {
      get: {
        description: '회사 직원 일정 조회',
        parameters: [
          {
            name: 'companyId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/plan/': {
      post: {
        description: '유저의 일정 등록',
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/plan/{planId}': {
      delete: {
        description: '일정 삭제',
        parameters: [
          {
            name: 'planId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
      put: {
        description: '일정 수정',
        parameters: [
          {
            name: 'planId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/admin/activate/{targetId}': {
      put: {
        description: '유저 회사 승인',
        parameters: [
          {
            name: 'targetId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/admin/deactivate/{targetId}': {
      put: {
        description: '유저 회사 승인 철회',
        parameters: [
          {
            name: 'targetId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/admin/commute/in/{targetId}': {
      put: {
        description: '유저 출근 정보 수정',
        parameters: [
          {
            name: 'targetId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/admin/commute/out/{targetId}': {
      put: {
        description: '유저 퇴근 정보 수정',
        parameters: [
          {
            name: 'targetId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/api/v1/admin/commute/{targetId}': {
      get: {
        description: '유저 출퇴근 정보 확인',
        parameters: [
          {
            name: 'targetId',
            in: 'path',
            required: true,
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
      },
    },
    '/auth/login': {
      post: {
        description: '로그인',
        responses: {
          200: {
            description: 'OK',
          },
          400: {
            description: 'Bad Request',
          },
        },
        requestBody: {
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  email: {
                    example: 'test04@example.com',
                  },
                  password: {
                    example: 'test',
                  },
                },
              },
            },
          },
        },
      },
    },
    '/auth/kakao': {
      get: {
        description: '카카오 소셜 로그인',
        responses: {
          default: {
            description: '',
          },
        },
      },
    },
    '/auth/kakao/callback': {
      get: {
        description: '유저 로그인시 액세스 토큰이 넘어오는 콜백 api',
        parameters: [
          {
            name: 'code',
            in: 'query',
            schema: {
              type: 'string',
            },
          },
        ],
        responses: {
          500: {
            description: 'Internal Server Error',
          },
        },
      },
    },
    '/auth/logout': {
      get: {
        description: '로그아웃',
        responses: {
          default: {
            description: '',
          },
        },
      },
    },
  },
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        in: 'header',
        bearerFormat: 'JWT',
      },
    },
  },
};

export default data;
