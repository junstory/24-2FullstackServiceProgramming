// user response DTO
export const userResponseDTO = (result) => {
  if (!result) {
    return {
      message: 'No data found',
      data: null,
    };
  }

  return {
    id: result.id,
    email: result.email,
    name: result.name,
    gender: result.gender,
    phoneNumber: result.phone_num,
    birthday: result.birthday,
    createdAt: result.created_at,
    updatedAt: result.updated_at,
    companyId: result.company_id,
    companyIsActive: result.company_is_active,
    companyName: result.company_name,
    roleId: result.role_id,
    roleName: result.role_name,
    commuteId: result.commute_id,
    today: {
      planedToGo: result.today_plan_in,
      goToWork: result.today_go_to_work,
      planedToLeave: result.today_plan_out,
      getOffWork: result.today_get_off_work,
    },
    next: {
      planedToGo: result.next_plan_in,
      planedToLeave: result.next_plan_out,
    },
  };
};

export const loginResDto = (token) => {
  if (!token) {
    return {
      message: 'No data found',
      data: null,
    };
  }
  return {
    token: token,
  };
};
export default userResponseDTO;
