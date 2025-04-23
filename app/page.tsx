import Link from "next/link";
import { getAllTodos } from "@/api/todos";

export const dynamic = "force-dynamic";

export default async function Home() {
  // API 함수 사용
  const todosData = await getAllTodos();

  return (
    <div>
      <div className="flex justify-between">
        <h1 className="text-2xl font-bold">테스트</h1>
        <Link href="/create">
          <button className="bg-blue-500 text-white px-4 py-2 rounded-md">
            생성
          </button>
        </Link>
      </div>
      <div>
        <ul>
          {todosData.map((todo) => (
            <li key={todo.id} className="text-2xl border border-gray-300">
              {todo.title}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
