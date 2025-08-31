import { useState } from "react";

function App() {
  const [count, setCount] = useState(0);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-12">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            🏪 StockFlow
          </h1>
          <p className="text-xl text-gray-600">Inventory Management System</p>
        </div>

        <div className="max-w-2xl mx-auto">
          <div className="card text-center">
            <h2 className="text-2xl font-semibold mb-6">Setup Complete!</h2>
            <p className="text-gray-600 mb-8">
              Frontend and Backend are now configured and running.
            </p>

            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-8">
              <div className="bg-green-100 text-green-800 px-4 py-2 rounded-lg">
                ✅ React + TypeScript
              </div>
              <div className="bg-green-100 text-green-800 px-4 py-2 rounded-lg">
                ✅ Tailwind CSS
              </div>
              <div className="bg-green-100 text-green-800 px-4 py-2 rounded-lg">
                ✅ Vite Build Tool
              </div>
            </div>

            <div className="space-y-4">
              <div>
                <button
                  className="btn-primary mr-4"
                  onClick={() => setCount(count + 1)}
                >
                  Click Count: {count}
                </button>
                <button className="btn-secondary" onClick={() => setCount(0)}>
                  Reset
                </button>
              </div>
            </div>

            <div className="mt-8 pt-8 border-t border-gray-200">
              <h3 className="font-semibold mb-4">Next Steps:</h3>
              <ul className="text-sm text-gray-600 space-y-2">
                <li>✨ Design database schema</li>
                <li>🔐 Implement authentication</li>
                <li>📦 Create product management</li>
                <li>📊 Build dashboard</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
