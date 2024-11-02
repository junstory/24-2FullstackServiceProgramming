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
        companyName: result.company_name,
        roleId: result.role_id,
        roleName: result.role_name,
        commuteId: result.commute_id,
        goToWork: result.go_to_work,
        getOffWork: result.get_off_work
    };
  }

  export default userResponseDTO;
  