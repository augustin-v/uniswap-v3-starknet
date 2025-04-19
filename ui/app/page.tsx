import Link from 'next/link'

export default function Home() {
  return (
      <main className="flex min-h-screen flex-col items-center justify-center p-4 sm:p-6 md:p-24">
      <Link href="/swap" className=" bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg mt-4 transition-colors">
          Swap
        </Link>
      </main>
    );
}
