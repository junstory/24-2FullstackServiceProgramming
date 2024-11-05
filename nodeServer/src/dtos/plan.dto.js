// plan response DTO
export const planResponseDTO = (results) => {
  if (!results || results.length === 0) {
    return {
      message: 'No data found',
      data: null,
    };
  }

  // results가 배열이므로 각 항목을 DTO 형태로 변환
  const formattedResults = results.map((result) => ({
    userId: result.user_id,
    userName: result.user_name,
    companyName: result.company_name,
    description: result.description,
    startDate: result.start_date,
    endDate: result.end_date,
    createdAt: result.created_at,
    updatedAt: result.updated_at,
  }));

  return {
    message: 'Data retrieved successfully',
    data: formattedResults,
  };
};

export default planResponseDTO;
