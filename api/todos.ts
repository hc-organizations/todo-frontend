// API 엔드포인트 기본 주소

// Todo 타입 정의
export type Todo = {
  id: string;
  title: string;
  content: string;
  status: string;
  startDate: string;
  endDate: string;
  createdAt: string;
  updatedAt: string;
};

// Todo 생성 인터페이스
export interface CreateTodoInput {
  title: string;
  content: string;
  status: string;
  startDate: string;
  endDate: string;
}

// 모든 Todo 가져오기
export async function getAllTodos(): Promise<Todo[]> {
  const response = await fetch(`${process.env.API_URL}/api/v1/todos`);

  if (!response.ok) {
    throw new Error("할 일 목록을 가져오는데 실패했습니다");
  }

  return response.json();
}

// 새 Todo 생성하기
export async function createTodo(todoData: CreateTodoInput): Promise<Todo> {
  console.log(process.env.NEXT_PUBLIC_API_ENDPOINT);
  const response = await fetch(
    `${process.env.NEXT_PUBLIC_API_ENDPOINT}/api/v1/todos`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(todoData),
    }
  );

  if (!response.ok) {
    throw new Error("할 일을 추가하는데 실패했습니다");
  }

  return response.json();
}
