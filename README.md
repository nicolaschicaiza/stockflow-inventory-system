# 🏪 StockFlow - Inventory Management System

> **Full-stack inventory management system designed for SMBs with real-time stock tracking, comprehensive billing integration, and powerful analytics dashboard.**

[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)](https://reactjs.org/)
[![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)

## 🎯 Project Overview

**StockFlow** is a modern, production-ready inventory management system built to demonstrate advanced full-stack development skills. This project showcases professional-grade architecture, modern technologies, and industry best practices.

### 🚀 Live Demo
- **Frontend**: [https://stockflow-demo.vercel.app](coming-soon)
- **API Documentation**: [https://stockflow-api.railway.app/docs](coming-soon)

### 📊 Project Status
- 🟡 **In Development** - Week 1 of 6 (Setup Complete)
- 📅 **Started**: August 31, 2025
- 🎯 **Target Completion**: October 15, 2025

---

## ✨ Key Features

### 🔐 Authentication & Authorization
- JWT-based authentication system
- Role-based access control (Admin, Manager, Employee)
- Secure password hashing with bcryptjs
- Session management with Redis

### 📦 Product Management
- Complete CRUD operations for products
- Barcode scanning and generation
- Category management with hierarchical structure
- Supplier relationship management
- Bulk product import/export

### 📊 Inventory Control
- Real-time stock tracking
- Automated low-stock alerts
- Inventory movement history
- Stock adjustments and auditing
- Location-based inventory management

### 💰 Sales & Billing
- Point-of-sale (POS) interface
- Invoice generation with PDF export
- Tax calculations (IVA/GST support)
- Payment method tracking
- Sales reporting and analytics

### 📈 Analytics Dashboard
- Real-time business metrics
- Sales performance charts
- Inventory turnover analysis
- Top-selling products insights
- Custom date range reporting

### 🔧 Advanced Features
- Dark/Light theme support
- Responsive design (mobile-first)
- Progressive Web App (PWA) capabilities
- Offline functionality for critical operations
- Export capabilities (PDF, Excel, CSV)

---

## 🛠️ Technology Stack

### Backend
| Technology | Version | Purpose |
|------------|---------|---------|
| **Node.js** | 18+ | JavaScript runtime |
| **TypeScript** | ^5.9.2 | Type-safe development |
| **Express.js** | ^4.18.0 | Web framework |
| **PostgreSQL** | 15+ | Primary database |
| **Redis** | 7+ | Cache & session store |
| **Jest** | ^30.1.1 | Testing framework |

### Frontend
| Technology | Version | Purpose |
|------------|---------|---------|
| **React** | ^18.2.0 | UI library |
| **TypeScript** | ^5.9.2 | Type safety |
| **Vite** | ^7.1.3 | Build tool & dev server |
| **Tailwind CSS** | ^4.0 | Utility-first CSS |
| **Axios** | ^latest | HTTP client |
| **React Router** | ^latest | Client-side routing |

### DevOps & Tools
- **Docker** - Containerization
- **GitHub Actions** - CI/CD pipeline
- **ESLint & Prettier** - Code quality
- **Husky** - Git hooks
- **Swagger/OpenAPI** - API documentation

---

## 🚀 Quick Start

### Prerequisites
```bash
node >= 18.0.0
npm >= 9.0.0
git >= 2.30.0
```

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/nicolaschicaiza/stockflow-inventory-system.git
   cd stockflow-inventory-system
   ```

2. **Setup Backend**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Setup Frontend**
   ```bash
   cd ../frontend
   npm install
   ```

4. **Start Development Servers**
   ```bash
   # Terminal 1 - Backend
   cd backend && npm run dev
   
   # Terminal 2 - Frontend  
   cd frontend && npm run dev
   ```

5. **Access the Application**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:5000
   - API Health Check: http://localhost:5000/health

---

## 📖 Documentation

### 📚 Complete Documentation
- **[Setup Documentation](docs/SETUP_DOCUMENTATION.md)** - Complete technical setup guide
- **[Architecture Decisions](docs/architecture/ARCHITECTURE_DECISIONS.md)** - ADRs and design choices
- **[Developer Guide](docs/DEVELOPER_GUIDE.md)** - Development workflows and conventions
- **[API Documentation](docs/api/)** - Complete API reference

### 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React SPA     │    │   Express API   │    │  PostgreSQL DB  │
│  (Frontend)     │◄──►│   (Backend)     │◄──►│   (Database)    │
│  Port 5173      │    │   Port 5000     │    │   Port 5432     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌─────────────────┐
                       │   Redis Cache   │
                       │   (Sessions)    │
                       │   Port 6379     │
                       └─────────────────┘
```

### 📁 Project Structure
```
stockflow/
├── backend/                 # Node.js + TypeScript API
│   ├── src/
│   │   ├── controllers/    # Request handlers
│   │   ├── middleware/     # Express middleware
│   │   ├── models/         # Data models
│   │   ├── routes/         # API routes
│   │   ├── services/       # Business logic
│   │   ├── utils/          # Utility functions
│   │   └── types/          # TypeScript types
│   └── tests/              # Test files
├── frontend/               # React + TypeScript SPA
│   ├── src/
│   │   ├── components/     # React components
│   │   ├── pages/          # Page components
│   │   ├── hooks/          # Custom hooks
│   │   ├── services/       # API services
│   │   └── types/          # TypeScript types
│   └── public/             # Static assets
├── docs/                   # Documentation
└── .github/                # CI/CD workflows
```

---

## 🧪 Testing

### Running Tests
```bash
# Backend tests
cd backend
npm test                    # Run all tests
npm run test:watch         # Watch mode
npm run test:coverage      # Coverage report

# Frontend tests
cd frontend
npm test                   # Run component tests
```

### Test Coverage Goals
- **Unit Tests**: > 80% coverage
- **Integration Tests**: All API endpoints
- **E2E Tests**: Critical user journeys

---

## 🚀 Development Roadmap

### ✅ Phase 1: Foundation (Week 1) - COMPLETED
- [x] Project setup and architecture
- [x] Development environment configuration
- [x] Basic backend server with TypeScript
- [x] React frontend with Tailwind CSS
- [x] Documentation structure

### 🔄 Phase 2: Core Backend (Week 2) - IN PROGRESS
- [ ] Database schema design
- [ ] Authentication system (JWT)
- [ ] User management APIs
- [ ] Product management APIs
- [ ] API documentation with Swagger

### 📋 Phase 3: Frontend Core (Week 3-4)
- [ ] Authentication UI
- [ ] Dashboard layout
- [ ] Product management interface
- [ ] Inventory tracking UI
- [ ] Responsive design implementation

### 📈 Phase 4: Advanced Features (Week 5)
- [ ] Sales and billing system
- [ ] Analytics and reporting
- [ ] Advanced inventory features
- [ ] PWA implementation
- [ ] Performance optimization

### 🚀 Phase 5: Production Ready (Week 6)
- [ ] Docker containerization
- [ ] CI/CD pipeline setup
- [ ] Production deployment
- [ ] Performance testing
- [ ] Security audit

---

## 📊 Technical Highlights

### Architecture Decisions
- **API-First Development**: OpenAPI contracts drive implementation
- **Type-Safe Development**: 100% TypeScript adoption
- **Modern CSS**: Tailwind CSS with utility-first approach
- **Testing Strategy**: Comprehensive unit, integration, and E2E testing
- **Security**: JWT authentication, input validation, SQL injection prevention

### Performance Features
- **Frontend**: Vite for ultra-fast HMR, lazy loading, code splitting
- **Backend**: Connection pooling, Redis caching, optimized queries
- **Database**: Indexed columns, efficient joins, query optimization

### Code Quality
- **ESLint + Prettier**: Consistent code formatting
- **Husky**: Pre-commit hooks for quality gates
- **TypeScript Strict Mode**: Maximum type safety
- **Jest Testing**: High test coverage standards

---

## 🤝 Contributing

This is a portfolio project, but feedback and suggestions are welcome!

### Development Process
1. Check the [Developer Guide](docs/DEVELOPER_GUIDE.md)
2. Follow TypeScript and React best practices
3. Maintain test coverage above 80%
4. Update documentation for new features

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 📞 Contact & Links

**Developer**: [Nicolas Chicaiza]  
**Portfolio**: [Link to your main portfolio]  
**LinkedIn**: [jnicolashc](https://www.linkedin.com/in/nicolas-chicaiza/)  
**Email**: [jefryn@unicauca.edu.co](jefryn@unicauca.edu.co)

### Project Links
- **Repository**: [GitHub - StockFlow](https://github.com/nicolaschicaiza/stockflow-inventory-system)
- **Issues**: [Bug reports and feature requests](https://github.com/nicolaschicaiza/stockflow-inventory-system/issues)
- **Portfolio**: [Main developer portfolio](https://github.com/nicolaschicaiza/developer-portfolio)

### 🔗 Related Documentation
- **[📊 Portfolio Overview](../../docs/PORTFOLIO_OVERVIEW.md)** - Complete portfolio progress and all projects
- **[📋 Master Plan](../../docs/PLAN_MAESTRO.md)** - 16-week development roadmap
- **[📈 Weekly Reports](../../docs/weekly-reports/)** - Development progress tracking

---

## 🌟 Acknowledgments

- Built as part of a 16-week portfolio development plan
- Demonstrates modern full-stack development practices
- Showcases professional-grade software architecture
- Designed to solve real-world business problems

---

*Last updated: August 31, 2025*  
*Project status: Active Development 🚧*
