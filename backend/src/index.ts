import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

// Crate Express app
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan("combined"));
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true }));

// Helth check route
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "OK",
    message: "StockFlow API is running",
    timestamp: new Date().toISOString(),
    version: "1.0.0",
  });
});

// API routes
app.get("/api/v1", (req, res) => {
  res.json({
    message: "Welcome to StockFlow Inventory API",
    version: "1.0.0",
    endpoints: [
      "GET /health - Health check",
      "POST /api/v1/auth/login - User authentication",
      "GET /api/v1/products - List products",
      "POST /api/v1/products - Create product",
      "GET /api/v1/inventory - Check inventory",
    ],
  });
});

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({
    error: "Route not found",
    message: `Cannot ${req.method} ${req.originalUrl}`,
  });
});

// Error handler
app.use(
  (
    error: any,
    req: express.Request,
    res: express.Response,
    next: express.NextFunction,
  ) => {
    console.error("Error", error);
    res.status(error.status || 500).json({
      error: "Internal Server Error",
      message:
        process.env.NODE_ENV === "development"
          ? error.message
          : "Something went wrong",
    });
  },
);

// Start server
app.listen(PORT, () => {
  console.log(`🚀 StockFlow API Server running on port ${PORT}`);
  console.log(`📍 Health check: http://localhost:${PORT}/health`);
  console.log(`📍 API Info: http://localhost:${PORT}/api/v1`);
});

export default app;
