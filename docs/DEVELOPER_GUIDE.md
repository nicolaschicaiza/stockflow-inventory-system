# 👩‍💻 Developer Guide - StockFlow

*Guía completa para desarrolladores que trabajen en el proyecto StockFlow*

---

## 📑 Índice

1. [Quick Start](#quick-start)
2. [Desarrollo Local](#desarrollo-local)
3. [Estructura del Código](#estructura-del-código)
4. [Convenciones y Standards](#convenciones-y-standards)
5. [Testing Guide](#testing-guide)
6. [API Development](#api-development)
7. [Frontend Development](#frontend-development)
8. [Database Guide](#database-guide)
9. [Troubleshooting](#troubleshooting)
10. [Workflow de Desarrollo](#workflow-de-desarrollo)

---

## 🚀 Quick Start

### Prerequisites

Antes de empezar, asegúrate de tener instalado:

```bash
# Verificar versiones
node --version    # >= 18.0.0
npm --version     # >= 9.0.0
git --version     # >= 2.30.0
```

### Initial Setup

```bash
# 1. Clonar el repositorio con submódulos
git clone --recursive git@github.com:tu-usuario/developer-portfolio.git
cd developer-portfolio/web-development/stockflow

# 2. Install backend dependencies
cd backend
npm install
cp .env.example .env

# 3. Install frontend dependencies  
cd ../frontend
npm install

# 4. Start development servers
# Terminal 1 (Backend)
cd backend && npm run dev

# Terminal 2 (Frontend)
cd frontend && npm run dev
```

### Verificar Instalación

```bash
# Backend health check
curl http://localhost:5000/health

# Frontend
# Abrir http://localhost:5173 en el navegador
```

---

## 💻 Desarrollo Local

### Development Workflow

#### 1. **Backend Development**

```bash
cd backend

# Desarrollo con hot reload
npm run dev

# Ejecutar tests
npm test

# Ejecutar tests en watch mode
npm run test:watch

# Build para producción
npm run build

# Ver coverage
npm run test:coverage
```

#### 2. **Frontend Development**

```bash
cd frontend

# Desarrollo con hot reload
npm run dev

# Build para producción
npm run build

# Preview del build
npm run preview

# Ejecutar linting
npm run lint
```

### Environment Variables

#### Backend (.env)
```env
# Server Configuration
NODE_ENV=development
PORT=5000

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=stockflow_db
DB_USER=postgres
DB_PASSWORD=your_password

# Authentication
JWT_SECRET=your-super-secret-key-minimum-32-chars
JWT_EXPIRES_IN=7d

# External APIs (cuando se implementen)
STRIPE_SECRET_KEY=sk_test_...
SENDGRID_API_KEY=SG...

# Logging Level
LOG_LEVEL=debug
```

#### Frontend (.env)
```env
# API Configuration
VITE_API_BASE_URL=http://localhost:5000/api/v1
VITE_APP_NAME=StockFlow
VITE_APP_VERSION=1.0.0

# Feature Flags
VITE_ENABLE_ANALYTICS=false
VITE_ENABLE_PWA=false
```

### Puertos por Defecto

| Servicio | Puerto | URL |
|----------|---------|-----|
| Backend API | 5000 | http://localhost:5000 |
| Frontend | 5173 | http://localhost:5173 |
| PostgreSQL | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |

---

## 🏗️ Estructura del Código

### Backend Structure

```
backend/
├── src/
│   ├── controllers/           # Request handlers
│   │   ├── authController.ts
│   │   ├── productController.ts
│   │   └── inventoryController.ts
│   ├── middleware/            # Express middleware
│   │   ├── auth.ts           # Authentication middleware
│   │   ├── validation.ts     # Request validation
│   │   ├── errorHandler.ts   # Error handling
│   │   └── rateLimiter.ts    # Rate limiting
│   ├── models/               # Data models
│   │   ├── User.ts
│   │   ├── Product.ts
│   │   └── Inventory.ts
│   ├── routes/               # API routes
│   │   ├── auth.ts
│   │   ├── products.ts
│   │   └── inventory.ts
│   ├── services/             # Business logic
│   │   ├── authService.ts
│   │   ├── productService.ts
│   │   └── inventoryService.ts
│   ├── utils/                # Utilities
│   │   ├── logger.ts
│   │   ├── validation.ts
│   │   └── helpers.ts
│   ├── types/                # TypeScript types
│   │   ├── auth.ts
│   │   ├── product.ts
│   │   └── common.ts
│   └── index.ts              # Server entry point
├── tests/                    # Test files
│   ├── __fixtures__/         # Test data
│   ├── unit/                 # Unit tests
│   ├── integration/          # Integration tests
│   └── helpers/              # Test utilities
├── package.json
├── tsconfig.json
├── jest.config.js
└── .env.example
```

### Frontend Structure

```
frontend/
├── src/
│   ├── components/           # React components
│   │   ├── ui/              # Reusable UI components
│   │   │   ├── Button.tsx
│   │   │   ├── Input.tsx
│   │   │   ├── Modal.tsx
│   │   │   └── Card.tsx
│   │   ├── layout/          # Layout components
│   │   │   ├── Header.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   └── Footer.tsx
│   │   └── forms/           # Form components
│   │       ├── LoginForm.tsx
│   │       └── ProductForm.tsx
│   ├── pages/               # Page components
│   │   ├── Dashboard.tsx
│   │   ├── Products.tsx
│   │   ├── Inventory.tsx
│   │   └── Auth.tsx
│   ├── hooks/               # Custom React hooks
│   │   ├── useAuth.ts
│   │   ├── useApi.ts
│   │   └── useLocalStorage.ts
│   ├── services/            # API services
│   │   ├── api.ts           # Axios configuration
│   │   ├── authService.ts
│   │   └── productService.ts
│   ├── context/             # React Context
│   │   ├── AuthContext.tsx
│   │   └── ThemeContext.tsx
│   ├── types/               # TypeScript types
│   │   ├── auth.ts
│   │   ├── product.ts
│   │   └── api.ts
│   ├── utils/               # Utility functions
│   │   ├── formatters.ts
│   │   ├── validators.ts
│   │   └── constants.ts
│   └── main.tsx             # App entry point
├── public/                  # Static assets
├── package.json
├── tsconfig.json
├── tailwind.config.js
├── postcss.config.js
└── vite.config.ts
```

---

## 📝 Convenciones y Standards

### Code Style

#### TypeScript Conventions

```typescript
// ✅ Good
interface User {
  id: number;
  email: string;
  createdAt: Date;
}

const createUser = async (userData: CreateUserRequest): Promise<User> => {
  // Implementation
};

// ❌ Bad
interface user {
  ID: number;
  Email: string;
  created_at: Date;
}

const CreateUser = async (userData: any): Promise<any> => {
  // Implementation
};
```

#### Naming Conventions

| Tipo | Convención | Ejemplo |
|------|------------|---------|
| Variables | camelCase | `userName`, `productList` |
| Functions | camelCase | `getUserById`, `createProduct` |
| Classes | PascalCase | `UserService`, `ProductModel` |
| Interfaces | PascalCase | `User`, `CreateUserRequest` |
| Types | PascalCase | `UserRole`, `ProductStatus` |
| Enums | PascalCase | `UserRole`, `ProductStatus` |
| Constants | UPPER_SNAKE_CASE | `JWT_SECRET`, `MAX_ITEMS` |
| Files | camelCase | `userService.ts`, `productController.ts` |
| Components | PascalCase | `UserCard.tsx`, `ProductList.tsx` |

#### File Organization

```typescript
// File structure order
// 1. Imports (third-party first, then local)
import express from 'express';
import jwt from 'jsonwebtoken';

import { User } from '../models/User';
import { validateRequest } from '../utils/validation';

// 2. Types and interfaces
interface LoginRequest {
  email: string;
  password: string;
}

// 3. Constants
const JWT_EXPIRES_IN = '7d';

// 4. Main code
export const loginController = async (req: Request, res: Response) => {
  // Implementation
};

// 5. Default export (if applicable)
export default loginController;
```

### Git Conventions

#### Commit Messages

```bash
# Format: type(scope): description
# Examples:

feat(auth): add JWT authentication middleware
fix(products): resolve duplicate product creation bug
docs(api): update authentication endpoint documentation
refactor(database): optimize user query performance
test(auth): add unit tests for login validation
chore(deps): update dependencies to latest versions
```

#### Branch Naming

```bash
# Format: type/description-with-dashes
# Examples:

feature/user-authentication
fix/product-validation-bug
refactor/database-optimization
docs/api-documentation-update
test/auth-integration-tests
chore/dependency-updates
```

### API Conventions

#### REST API Design

```typescript
// ✅ Good - RESTful endpoints
GET    /api/v1/products           # List products
GET    /api/v1/products/123       # Get specific product
POST   /api/v1/products           # Create new product
PUT    /api/v1/products/123       # Update entire product
PATCH  /api/v1/products/123       # Partial product update
DELETE /api/v1/products/123       # Delete product

// ✅ Good - Nested resources
GET    /api/v1/products/123/variants
POST   /api/v1/products/123/variants

// ❌ Bad - Non-RESTful
GET    /api/v1/getProducts
POST   /api/v1/createProduct
POST   /api/v1/updateProduct
```

#### Response Format

```typescript
// ✅ Success Response
{
  "success": true,
  "data": {
    "id": 123,
    "name": "Product Name"
  },
  "meta": {
    "timestamp": "2025-08-31T10:00:00Z",
    "version": "1.0.0"
  }
}

// ✅ Error Response
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid email format",
    "details": {
      "field": "email",
      "value": "invalid-email"
    }
  },
  "meta": {
    "timestamp": "2025-08-31T10:00:00Z",
    "requestId": "req-123"
  }
}
```

---

## 🧪 Testing Guide

### Testing Strategy

```
E2E Tests (cypress)           ← Few, expensive, slow
├─ Integration Tests         ← Some, medium cost
│  ├─ API endpoint tests
│  └─ Database integration
└─ Unit Tests               ← Many, cheap, fast
   ├─ Service functions
   ├─ Utility functions
   └─ Component logic
```

### Backend Testing

#### Unit Tests Example

```typescript
// tests/unit/services/authService.test.ts
import { AuthService } from '../../../src/services/authService';
import { User } from '../../../src/models/User';

describe('AuthService', () => {
  describe('validatePassword', () => {
    it('should return true for valid password', async () => {
      const hashedPassword = await AuthService.hashPassword('password123');
      const isValid = await AuthService.validatePassword('password123', hashedPassword);
      
      expect(isValid).toBe(true);
    });

    it('should return false for invalid password', async () => {
      const hashedPassword = await AuthService.hashPassword('password123');
      const isValid = await AuthService.validatePassword('wrongpassword', hashedPassword);
      
      expect(isValid).toBe(false);
    });
  });
});
```

#### Integration Tests Example

```typescript
// tests/integration/auth.test.ts
import request from 'supertest';
import app from '../../src/index';

describe('Auth Endpoints', () => {
  describe('POST /api/v1/auth/login', () => {
    it('should authenticate valid user', async () => {
      const response = await request(app)
        .post('/api/v1/auth/login')
        .send({
          email: 'test@example.com',
          password: 'password123'
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.token).toBeDefined();
    });

    it('should reject invalid credentials', async () => {
      const response = await request(app)
        .post('/api/v1/auth/login')
        .send({
          email: 'test@example.com',
          password: 'wrongpassword'
        });

      expect(response.status).toBe(401);
      expect(response.body.success).toBe(false);
    });
  });
});
```

### Frontend Testing

#### Component Tests Example

```typescript
// src/components/__tests__/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from '../ui/Button';

describe('Button Component', () => {
  it('renders button text correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument();
  });

  it('calls onClick handler when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('applies correct CSS classes', () => {
    render(<Button variant="primary">Click me</Button>);
    const button = screen.getByRole('button');
    
    expect(button).toHaveClass('btn-primary');
  });
});
```

### Running Tests

```bash
# Backend tests
cd backend
npm test                    # Run all tests
npm run test:watch         # Watch mode
npm run test:coverage      # With coverage
npm test -- --verbose      # Verbose output

# Frontend tests
cd frontend
npm test                   # Run all tests
npm run test:watch        # Watch mode
npm run test:coverage     # With coverage
```

---

## 🔌 API Development

### Endpoint Development Pattern

#### 1. Define Types First

```typescript
// src/types/product.ts
export interface Product {
  id: number;
  name: string;
  description: string;
  price: number;
  categoryId: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateProductRequest {
  name: string;
  description: string;
  price: number;
  categoryId: number;
}

export interface UpdateProductRequest extends Partial<CreateProductRequest> {}
```

#### 2. Create Validation Schema

```typescript
// src/utils/validation/productValidation.ts
import Joi from 'joi';

export const createProductSchema = Joi.object({
  name: Joi.string().min(3).max(100).required(),
  description: Joi.string().max(500).optional(),
  price: Joi.number().positive().precision(2).required(),
  categoryId: Joi.number().integer().positive().required()
});

export const updateProductSchema = Joi.object({
  name: Joi.string().min(3).max(100).optional(),
  description: Joi.string().max(500).optional(),
  price: Joi.number().positive().precision(2).optional(),
  categoryId: Joi.number().integer().positive().optional()
});
```

#### 3. Implement Service

```typescript
// src/services/productService.ts
import { Product, CreateProductRequest, UpdateProductRequest } from '../types/product';

export class ProductService {
  static async getAllProducts(): Promise<Product[]> {
    // Database query implementation
  }

  static async getProductById(id: number): Promise<Product | null> {
    // Database query implementation
  }

  static async createProduct(productData: CreateProductRequest): Promise<Product> {
    // Database insert implementation
  }

  static async updateProduct(id: number, productData: UpdateProductRequest): Promise<Product | null> {
    // Database update implementation
  }

  static async deleteProduct(id: number): Promise<boolean> {
    // Database delete implementation
  }
}
```

#### 4. Create Controller

```typescript
// src/controllers/productController.ts
import { Request, Response, NextFunction } from 'express';
import { ProductService } from '../services/productService';
import { CreateProductRequest, UpdateProductRequest } from '../types/product';

export class ProductController {
  static async getAllProducts(req: Request, res: Response, next: NextFunction) {
    try {
      const products = await ProductService.getAllProducts();
      
      res.json({
        success: true,
        data: products,
        meta: {
          timestamp: new Date().toISOString(),
          count: products.length
        }
      });
    } catch (error) {
      next(error);
    }
  }

  static async createProduct(req: Request, res: Response, next: NextFunction) {
    try {
      const productData: CreateProductRequest = req.body;
      const product = await ProductService.createProduct(productData);
      
      res.status(201).json({
        success: true,
        data: product,
        meta: {
          timestamp: new Date().toISOString()
        }
      });
    } catch (error) {
      next(error);
    }
  }
}
```

#### 5. Setup Routes

```typescript
// src/routes/products.ts
import { Router } from 'express';
import { ProductController } from '../controllers/productController';
import { validateRequest } from '../middleware/validation';
import { createProductSchema, updateProductSchema } from '../utils/validation/productValidation';
import { authenticate } from '../middleware/auth';

const router = Router();

router.get('/', 
  authenticate,
  ProductController.getAllProducts
);

router.post('/', 
  authenticate,
  validateRequest(createProductSchema),
  ProductController.createProduct
);

router.put('/:id',
  authenticate,
  validateRequest(updateProductSchema),
  ProductController.updateProduct
);

export default router;
```

---

## 🎨 Frontend Development

### Component Development Pattern

#### 1. Create Type Definitions

```typescript
// src/types/components.ts
export interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  onClick?: () => void;
  type?: 'button' | 'submit' | 'reset';
}
```

#### 2. Create Base Components

```typescript
// src/components/ui/Button.tsx
import React from 'react';
import { ButtonProps } from '../../types/components';

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  disabled = false,
  loading = false,
  onClick,
  type = 'button',
  ...props
}) => {
  const baseClasses = 'font-medium rounded-lg transition duration-200 focus:outline-none focus:ring-2';
  const variantClasses = {
    primary: 'bg-blue-600 hover:bg-blue-700 text-white focus:ring-blue-500',
    secondary: 'bg-gray-200 hover:bg-gray-300 text-gray-800 focus:ring-gray-500',
    danger: 'bg-red-600 hover:bg-red-700 text-white focus:ring-red-500'
  };
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2',
    lg: 'px-6 py-3 text-lg'
  };

  const classes = `${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${
    disabled || loading ? 'opacity-50 cursor-not-allowed' : ''
  }`;

  return (
    <button
      type={type}
      className={classes}
      disabled={disabled || loading}
      onClick={onClick}
      {...props}
    >
      {loading ? (
        <div className="flex items-center">
          <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-current mr-2"></div>
          Loading...
        </div>
      ) : (
        children
      )}
    </button>
  );
};
```

#### 3. Create Custom Hooks

```typescript
// src/hooks/useApi.ts
import { useState, useEffect } from 'react';
import { apiService } from '../services/api';

interface UseApiResult<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
  refetch: () => void;
}

export function useApi<T>(url: string): UseApiResult<T> {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchData = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await apiService.get(url);
      setData(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [url]);

  return { data, loading, error, refetch: fetchData };
}
```

#### 4. Create Services

```typescript
// src/services/api.ts
import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:5000/api/v1';

export const apiService = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor para add auth token
apiService.interceptors.request.use((config) => {
  const token = localStorage.getItem('authToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor para error handling
apiService.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
      localStorage.removeItem('authToken');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);
```

---

## 🗄️ Database Guide

### Database Setup (PostgreSQL)

#### Installation con Docker

```bash
# docker-compose.yml
version: '3.8'
services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: stockflow_db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: your_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/database/init.sql:/docker-entrypoint-initdb.d/init.sql

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

```bash
# Iniciar bases de datos
docker-compose up -d postgres redis
```

#### Schema Design

```sql
-- backend/database/schema.sql

-- Users and Authentication
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'employee',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  parent_id INTEGER REFERENCES categories(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Suppliers
CREATE TABLE suppliers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  contact_email VARCHAR(255),
  contact_phone VARCHAR(20),
  address TEXT,
  tax_id VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  sku VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(200) NOT NULL,
  description TEXT,
  category_id INTEGER REFERENCES categories(id),
  supplier_id INTEGER REFERENCES suppliers(id),
  cost_price DECIMAL(10,2),
  selling_price DECIMAL(10,2) NOT NULL,
  barcode VARCHAR(100),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory
CREATE TABLE inventory (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id),
  current_stock INTEGER NOT NULL DEFAULT 0,
  min_stock INTEGER DEFAULT 0,
  max_stock INTEGER,
  location VARCHAR(100),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory Movements
CREATE TABLE inventory_movements (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id),
  movement_type VARCHAR(20) NOT NULL, -- 'IN', 'OUT', 'ADJUSTMENT'
  quantity INTEGER NOT NULL,
  reason VARCHAR(200),
  reference_id VARCHAR(100), -- Invoice ID, adjustment ID, etc.
  user_id INTEGER REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_movements_product ON inventory_movements(product_id);
CREATE INDEX idx_movements_created_at ON inventory_movements(created_at);
```

### Database Operations

#### Connection Setup

```typescript
// src/utils/database.ts
import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME || 'stockflow_db',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

export default pool;
```

#### Model Example

```typescript
// src/models/Product.ts
import pool from '../utils/database';
import { Product, CreateProductRequest, UpdateProductRequest } from '../types/product';

export class ProductModel {
  static async findAll(): Promise<Product[]> {
    const query = `
      SELECT p.*, c.name as category_name, s.name as supplier_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      LEFT JOIN suppliers s ON p.supplier_id = s.id
      WHERE p.is_active = true
      ORDER BY p.name
    `;
    
    const result = await pool.query(query);
    return result.rows;
  }

  static async findById(id: number): Promise<Product | null> {
    const query = `
      SELECT p.*, c.name as category_name, s.name as supplier_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      LEFT JOIN suppliers s ON p.supplier_id = s.id
      WHERE p.id = $1 AND p.is_active = true
    `;
    
    const result = await pool.query(query, [id]);
    return result.rows[0] || null;
  }

  static async create(productData: CreateProductRequest): Promise<Product> {
    const query = `
      INSERT INTO products (sku, name, description, category_id, supplier_id, cost_price, selling_price, barcode)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING *
    `;
    
    const values = [
      productData.sku,
      productData.name,
      productData.description,
      productData.categoryId,
      productData.supplierId,
      productData.costPrice,
      productData.sellingPrice,
      productData.barcode
    ];
    
    const result = await pool.query(query, values);
    return result.rows[0];
  }
}
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. **Port Already in Use**

```bash
# Find process using port
lsof -i :5000
lsof -i :5173

# Kill process
kill -9 <PID>

# Or use different ports
PORT=5001 npm run dev
```

#### 2. **Database Connection Issues**

```typescript
// Test database connection
import pool from './src/utils/database';

async function testConnection() {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT NOW()');
    console.log('Database connected:', result.rows[0]);
    client.release();
  } catch (error) {
    console.error('Database connection error:', error);
  }
}

testConnection();
```

#### 3. **TypeScript Compilation Errors**

```bash
# Clear TypeScript cache
rm -rf node_modules/.cache
rm -rf dist/

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Check TypeScript config
npx tsc --noEmit
```

#### 4. **Frontend Build Issues**

```bash
# Clear Vite cache
rm -rf node_modules/.vite
rm -rf dist/

# Update dependencies
npm update

# Check for peer dependency issues
npm ls
```

#### 5. **Environment Variables Not Loading**

```typescript
// Verify environment variables
console.log('Environment check:', {
  NODE_ENV: process.env.NODE_ENV,
  PORT: process.env.PORT,
  DB_HOST: process.env.DB_HOST,
  // Don't log sensitive values like passwords
});
```

### Debug Mode

#### Backend Debug

```bash
# Enable debug logging
DEBUG=* npm run dev

# VS Code debug configuration
# .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Backend",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/backend/src/index.ts",
      "outFiles": ["${workspaceFolder}/backend/dist/**/*.js"],
      "runtimeArgs": ["-r", "ts-node/register"],
      "env": {
        "NODE_ENV": "development"
      }
    }
  ]
}
```

#### Frontend Debug

```typescript
// Add debug logging
const DEBUG = import.meta.env.DEV;

if (DEBUG) {
  console.log('API Response:', response.data);
  console.log('User State:', user);
}
```

---

## 🔄 Workflow de Desarrollo

### Feature Development Process

#### 1. **Planning**
```bash
# Create feature branch
git checkout -b feature/user-authentication
```

#### 2. **Backend First (API Contract)**
```typescript
// 1. Define types
// 2. Create validation schemas
// 3. Write tests (TDD approach)
// 4. Implement service
// 5. Create controller
// 6. Setup routes
```

#### 3. **Frontend Implementation**
```typescript
// 1. Create API service methods
// 2. Create custom hooks
// 3. Build components
// 4. Add to pages
// 5. Write component tests
```

#### 4. **Integration Testing**
```bash
# Test full flow
npm test
npm run test:integration
```

#### 5. **Documentation**
```markdown
# Update API documentation
# Update README if needed
# Add inline code comments
```

#### 6. **Code Review**
```bash
# Self-review checklist
- [ ] All tests passing
- [ ] TypeScript compilation successful
- [ ] No console.log statements in production code
- [ ] Error handling implemented
- [ ] Responsive design (frontend)
- [ ] Security considerations addressed
```

#### 7. **Merge**
```bash
# Rebase and merge
git rebase main
git push origin feature/user-authentication
# Create pull request
```

### Daily Development Routine

#### Morning Setup (5 minutes)
```bash
# Pull latest changes
git pull origin main

# Check dependencies
npm outdated

# Start development environment
npm run dev
```

#### Development Session
```bash
# Make small, frequent commits
git add .
git commit -m "feat(auth): add password validation"

# Push regularly
git push origin feature/current-work
```

#### End of Day (10 minutes)
```bash
# Run full test suite
npm test

# Check code coverage
npm run test:coverage

# Clean up and document progress
git status
git log --oneline -5
```

### Production Deployment Checklist

#### Pre-deployment
- [ ] All tests passing
- [ ] TypeScript compilation successful
- [ ] Environment variables configured
- [ ] Database migrations ready
- [ ] Security audit completed
- [ ] Performance testing done

#### Deployment
- [ ] Build production assets
- [ ] Run database migrations
- [ ] Deploy backend first
- [ ] Deploy frontend
- [ ] Verify health checks

#### Post-deployment
- [ ] Monitor error logs
- [ ] Verify key functionality
- [ ] Update documentation
- [ ] Notify stakeholders

---

## 📚 Additional Resources

### Learning Resources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [React Documentation](https://react.dev/)
- [Express.js Guide](https://expressjs.com/en/guide/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

### Tools and Extensions

#### VS Code Extensions
- ES7+ React/Redux/React-Native snippets
- TypeScript Hero
- Auto Rename Tag
- Bracket Pair Colorizer
- GitLens
- Thunder Client (API testing)
- Tailwind CSS IntelliSense

#### Chrome Extensions
- React Developer Tools
- Redux DevTools
- JSON Viewer

### Community

- [TypeScript Discord](https://discord.gg/typescript)
- [Reactiflux Discord](https://discord.gg/reactiflux)
- [r/webdev](https://reddit.com/r/webdev)
- [Stack Overflow](https://stackoverflow.com/)

---

**¿Questions or Issues?**
Create an issue in the repository o contacta al team lead.

*Última actualización: 31 de Agosto, 2025*