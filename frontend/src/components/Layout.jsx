function Layout({ children }) {
  return (
    <div className="min-h-screen bg-dark-950">
      <header className="bg-dark-900 border-b border-dark-800 text-gray-100 py-4">
        <div className="container mx-auto px-4">
          <h1 className="text-2xl font-bold">JTAC Reference</h1>
        </div>
      </header>
      <main className="container mx-auto px-4 py-8">
        {children}
      </main>
    </div>
  )
}

export default Layout