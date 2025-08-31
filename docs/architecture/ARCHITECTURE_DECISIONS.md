# 🏗️ Architecture Decision Records (ADRs)

*StockFlow Inventory Management System*

---

## ADR Index

1. [ADR-001: Monorepo con Submódulos](#adr-001-monorepo-con-submódulos)
2. [ADR-002: Stack Tecnológico Backend](#adr-002-stack-tecnológico-backend)  
3. [ADR-003: Stack Tecnológico Frontend](#adr-003-stack-tecnológico-frontend)
4. [ADR-004: Separación Frontend/Backend](#adr-004-separación-frontendbackend)
5. [ADR-005: API-First Development](#adr-005-api-first-development)
6. [ADR-006: TypeScript Adoption](#adr-006-typescript-adoption)
7. [ADR-007: Testing Strategy](#adr-007-testing-strategy)
8. [ADR-008: CSS Framework Selection](#adr-008-css-framework-selection)

---

## ADR-001: Monorepo con Submódulos

**Date**: 2025-08-31
**Status**: ✅ Accepted  
**Deciders**: Equipo de desarrollo  
**Technical Story**: Setup inicial de arquitectura de repositorios

### Context

Necesitamos organizar múltiples proyectos de portafolio (StockFlow, FoodHub, SocialInsight) de manera que:
- Cada proyecto mantenga su identidad independiente
- Se pueda hacer deploy independiente de cada proyecto
- El portafolio principal tenga una estructura clara
- Los proyectos se puedan versionar independientemente

### Decision

Utilizaremos una arquitectura de **repositorio principal con submódulos** donde:
- `developer-portfolio` es el repositorio principal
- Cada proyecto (StockFlow, FoodHub, etc.) es un repositorio independiente
- Los proyectos se incluyen como submódulos de Git en el repositorio principal

### Consequences

**Positive**:
- ✅ Cada proyecto mantiene su propia historia de commits
- ✅ Deploy independiente por proyecto
- ✅ Versionado granular por proyecto  
- ✅ Posibilidad de colaboración específica por proyecto
- ✅ Estructura clara y profesional del portafolio

**Negative**:
- ❌ Complejidad adicional en manejo de submódulos
- ❌ Curva de aprendizaje para Git submodules
- ❌ Sincronización manual entre repos

**Neutral**:
- 🔄 Cada desarrollador debe entender Git submodules
- 🔄 CI/CD debe manejar submódulos correctamente

### Implementation

```bash
# Estructura final
developer-portfolio/
├── .gitmodules
├── web-development/
│   └── stockflow/           # Submódulo
├── mobile-apps/
├── apis-backend/ 
└── docs/
```

---

## ADR-002: Stack Tecnológico Backend

**Date**: 2025-08-31
**Status**: ✅ Accepted  
**Deciders**: Equipo de desarrollo  
**Technical Story**: Selección de tecnologías para el backend

### Context

Necesitamos un stack backend que:
- Sea moderno y demandado en la industria
- Permita desarrollo rápido y escalable
- Tenga excelente ecosistema y community support
- Demuestre competencias técnicas avanzadas

### Decision

**Core Stack**:
- **Runtime**: Node.js (v18+)
- **Language**: TypeScript  
- **Framework**: Express.js 4.18.x
- **Database**: PostgreSQL + Redis
- **Authentication**: JWT + bcryptjs

**Supporting Tools**:
- **Testing**: Jest + Supertest
- **Validation**: Joi
- **Security**: Helmet + CORS
- **Logging**: Morgan
- **Development**: Nodemon + ts-node

### Rationale

**Node.js + TypeScript**:
- ✅ JavaScript ecosystem unificado frontend/backend
- ✅ Type safety para mejor DX y menos bugs
- ✅ Excellent performance para I/O intensive apps
- ✅ Gran demanda en el mercado

**Express.js**:
- ✅ Framework maduro y estable
- ✅ Ecosistema masivo de middleware
- ✅ Flexible y no-opinionated
- ✅ Excelente para APIs REST

**PostgreSQL**:
- ✅ ACID compliance para data consistency
- ✅ JSON support para flexibilidad
- ✅ Excellent performance y escalabilidad
- ✅ Open source con gran community

### Consequences

**Positive**:
- ✅ Developer experience excelente
- ✅ Type safety reduce bugs significativamente  
- ✅ Ecosystem unificado JS/TS
- ✅ Fácil encontrar developers con estas skills

**Negative**:
- ❌ Single-threaded limitations de Node.js
- ❌ Dependency hell potencial con npm

**Mitigation**:
- 🔄 Redis para cache y tasks async
- 🔄 Package lock files para reproducibilidad

---

## ADR-003: Stack Tecnológico Frontend

**Date**: 2025-08-31  
**Status**: ✅ Accepted  
**Deciders**: Equipo de desarrollo  
**Technical Story**: Selección de tecnologías frontend

### Context

Necesitamos un stack frontend que:
- Sea moderno y performante
- Permita desarrollo component-based
- Tenga excelente Developer Experience
- Demuestre conocimiento de herramientas cutting-edge

### Decision

**Core Stack**:
- **Framework**: React 18 + TypeScript
- **Build Tool**: Vite 7.x  
- **CSS Framework**: Tailwind CSS v4
- **HTTP Client**: Axios
- **Routing**: React Router v6

**Supporting Tools**:
- **UI Components**: Headless UI
- **Icons**: Heroicons
- **Testing**: Jest + React Testing Library
- **Development**: Vite HMR

### Rationale

**React 18**:
- ✅ Industry standard, massive ecosystem
- ✅ Concurrent features para better performance
- ✅ Hooks API for modern development patterns
- ✅ Excellent job market demand

**Vite**:
- ✅ Extremely fast HMR (Hot Module Replacement)
- ✅ Modern ES modules approach
- ✅ Better than CRA (Create React App)
- ✅ Excellent TypeScript support

**Tailwind CSS v4**:
- ✅ Utility-first approach para desarrollo rápido
- ✅ Consistent design system
- ✅ Excellent performance (purge unused CSS)
- ✅ Modern CSS-in-JS alternative

**TypeScript**:
- ✅ Consistency con backend
- ✅ Better refactoring capabilities
- ✅ Compile-time error detection
- ✅ Excellent IDE support

### Consequences

**Positive**:
- ✅ Extremely fast development experience
- ✅ Type safety across entire codebase
- ✅ Modern tooling y best practices
- ✅ Excellent performance out of the box

**Negative**:
- ❌ Learning curve para Tailwind
- ❌ Bundle size considerations

**Mitigation**:
- 🔄 Tailwind purge para optimal bundle size
- 🔄 Code splitting con React.lazy

---

## ADR-004: Separación Frontend/Backend

**Date**: 2025-08-31
**Status**: ✅ Accepted  
**Deciders**: Equipo de desarrollo  
**Technical Story**: Arquitectura de aplicación

### Context

Debemos decidir entre:
1. **Monolith**: Frontend y backend en una sola aplicación
2. **Separated**: Frontend y backend como aplicaciones independientes
3. **Microfrontends**: Frontend también distribuido

### Decision

Implementaremos **aplicaciones completamente separadas**:
- Backend: API REST pura sin server-side rendering
- Frontend: Single Page Application (SPA) independiente
- Comunicación vía HTTP/HTTPS APIs

### Rationale

**Scalability**:
- ✅ Cada parte puede escalar independientemente
- ✅ Different deployment strategies
- ✅ Team scaling (frontend/backend specialists)

**Technology Flexibility**:
- ✅ Mejores herramientas para cada dominio
- ✅ Frontend puede ser replaced sin tocar backend
- ✅ Multiple frontends pueden usar same API

**Development**:
- ✅ Parallel development posible
- ✅ Clear contracts via API
- ✅ Easier testing de cada parte

**Deployment**:
- ✅ Independent deployment cycles
- ✅ Better fault isolation
- ✅ Different hosting strategies optimizadas

### Consequences

**Positive**:
- ✅ Maximum flexibility y scalability
- ✅ Clear separation of concerns
- ✅ Better performance optimization opportunities
- ✅ Future-proof architecture

**Negative**:
- ❌ Network latency considerations
- ❌ CORS complexity
- ❌ Authentication complexity

**Mitigation**:
- 🔄 Proper API design para minimize round trips
- 🔄 JWT tokens para stateless auth
- 🔄 Proper CORS configuration

---

## ADR-005: API-First Development

**Date**: 2025-08-31
**Status**: ✅ Accepted  
**Deciders**: Equipo de desarrollo  
**Technical Story**: Development approach

### Context

Debemos decidir el approach de desarrollo:
1. **Frontend-first**: UI mockups → Frontend → Backend
2. **Backend-first**: Database → Backend → Frontend  
3. **API-first**: API contracts → Parallel development

### Decision

Implementaremos **API-First Development**:
- Diseñar API contracts antes que implementation
- Usar OpenAPI/Swagger para documentation
- Desarrollar backend y frontend en paralelo
- Mock API para frontend development temprano

### Rationale

**Clear Contracts**:
- ✅ Unambiguous communication entre frontend/backend
- ✅ Parallel development sin dependencies
- ✅ Easy testing de cada parte independently

**Documentation**:
- ✅ Living documentation via OpenAPI
- ✅ Automatic API client generation
- ✅ Better onboarding para new developers

**Quality**:
- ✅ Forced thinking about data models temprano
- ✅ Better error handling design
- ✅ Consistent API patterns

**Future-proofing**:
- ✅ Easy para add mobile apps later
- ✅ Third-party integrations más fáciles
- ✅ Microservices migration path clara

### Implementation

```
Development Order:
1. Database schema design
2. API endpoint contracts (OpenAPI)
3. Backend implementation
4. Frontend implementation  
5. Integration testing
```

### Consequences

**Positive**:
- ✅ Better architecture y planning
- ✅ Faster parallel development
- ✅ Higher quality APIs
- ✅ Excellent documentation

**Negative**:
- ❌ More upfront planning required
- ❌ Potential over-engineering

**Mitigation**:
- 🔄 Start con MVP API contracts
- 🔄 Iterate based on real usage

---

## ADR-006: TypeScript Adoption

**Date**: 2025-08-31  
**Status**: ✅ Accepted  
**Deciders**: Equipo de desarrollo  
**Technical Story**: Language selection

### Context

Decidir entre JavaScript puro vs TypeScript para todo el proyecto:
- **JavaScript**: Faster initial development, more flexible
- **TypeScript**: Type safety, better tooling, compile-time checks

### Decision

**100% TypeScript adoption** en todo el codebase:
- Backend: Node.js con TypeScript
- Frontend: React con TypeScript  
- Shared types entre frontend y backend
- Strict TypeScript configuration

### Rationale

**Developer Experience**:
- ✅ Excellent IDE support (autocomplete, refactoring)
- ✅ Compile-time error detection
- ✅ Better code documentation via types
- ✅ Easier onboarding para new developers

**Code Quality**:
- ✅ Reduces runtime errors significantly
- ✅ Self-documenting code via type definitions
- ✅ Better refactoring safety
- ✅ Easier maintenance a largo plazo

**Professional Standards**:
- ✅ Industry best practice para large codebases
- ✅ Better collaboration en teams
- ✅ Demonstrates advanced technical skills

**Ecosystem**:
- ✅ Excellent library support
- ✅ Great tooling ecosystem
- ✅ Active development y community

### Implementation

```json
// Strict TypeScript configuration
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true
  }
}
```

### Consequences

**Positive**:
- ✅ Significantly fewer runtime errors
- ✅ Better code maintainability
- ✅ Excellent developer experience
- ✅ Professional-grade code quality

**Negative**:
- ❌ Steeper learning curve initially
- ❌ More verbose code
- ❌ Compilation step required

**Mitigation**:
- 🔄 ts-node para development sin compilation step
- 🔄 Good TypeScript patterns y utilities
- 🔄 Incremental adoption approach

---

## ADR-007: Testing Strategy

**Date**: 2025-08-31
**Status**: ✅ Accepted  
**Deciders**: Equipo de desarrollo  
**Technical Story**: Testing framework selection

### Context

Necesitamos una testing strategy comprehensiva que cubra:
- Unit testing
- Integration testing  
- API testing
- Frontend component testing
- End-to-end testing

### Decision

**Testing Stack**:
- **Backend**: Jest + Supertest + ts-jest
- **Frontend**: Jest + React Testing Library  
- **E2E**: Cypress (planeado para más adelante)
- **Coverage**: Built-in Jest coverage reporting

**Testing Pyramid**:
```
    E2E Tests (Few)
   ├─ Integration Tests (Some)  
   └─ Unit Tests (Many)
```

### Rationale

**Jest Selection**:
- ✅ Industry standard, excellent TypeScript support
- ✅ Built-in mocking, coverage, y assertions
- ✅ Consistent experience frontend y backend
- ✅ Excellent watch mode para development

**React Testing Library**:
- ✅ Testing best practices encouraged
- ✅ User-centric testing approach
- ✅ Better maintainability que Enzyme

**Supertest**:
- ✅ Excellent para API testing
- ✅ Express integration out of the box
- ✅ Chainable assertions

### Implementation

```javascript
// Backend API test example
describe('Authentication', () => {
  test('should authenticate valid user', async () => {
    const response = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'test@example.com', password: 'password' })
      .expect(200);
    
    expect(response.body.token).toBeDefined();
  });
});
```

### Consequences

**Positive**:
- ✅ High confidence en code changes
- ✅ Better refactoring safety
- ✅ Documentation via tests
- ✅ Professional development practices

**Negative**:
- ❌ Additional development time inicialmente
- ❌ Test maintenance overhead

**Mitigation**:
- 🔄 Focus on testing critical paths first
- 🔄 TDD approach where beneficial

---

## ADR-008: CSS Framework Selection

**Date**: 2025-08-31
**Status**: ✅ Accepted  
**Deciders**: Equipo de desarrollo  
**Technical Story**: Styling solution

### Context

Opciones de styling consideradas:
1. **Plain CSS**: Maximum control, more work
2. **CSS-in-JS**: Component co-location, runtime overhead
3. **Bootstrap**: Quick start, generic look
4. **Tailwind CSS**: Utility-first, customizable

### Decision

**Tailwind CSS v4** como primary CSS framework:
- Utility-first approach
- Custom design system
- JIT compilation para optimal performance
- Modern CSS features

### Rationale

**Development Speed**:
- ✅ Rapid prototyping con utility classes
- ✅ Consistent spacing y sizing system
- ✅ No need para CSS file switching

**Customization**:
- ✅ Complete design system control
- ✅ No generic "Bootstrap look"
- ✅ Easy tema customization

**Performance**:
- ✅ Purge unused CSS automatically
- ✅ Smaller bundle sizes que traditional CSS
- ✅ JIT compilation

**Developer Experience**:
- ✅ Excellent VS Code integration
- ✅ Great documentation
- ✅ Active community

**Modern Approach**:
- ✅ Utility-first está becoming standard
- ✅ Component-based thinking
- ✅ Design system approach

### Implementation

```css
/* Custom components con @layer */
@layer components {
  .btn-primary {
    @apply bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-200;
  }
}
```

### Consequences

**Positive**:
- ✅ Extremely fast UI development
- ✅ Consistent design system
- ✅ Great performance characteristics
- ✅ Modern development approach

**Negative**:
- ❌ Learning curve para utility-first approach
- ❌ HTML can become verbose

**Mitigation**:
- 🔄 Custom component classes para common patterns
- 🔄 Good naming conventions

---

## Decision Process

### How We Make Decisions

1. **Problem Identification**: Clear problem statement
2. **Options Research**: Research minimum 3 alternatives
3. **Criteria Definition**: Technical y business criteria
4. **Evaluation**: Pros/cons analysis
5. **Decision**: Clear choice con rationale
6. **Documentation**: ADR creation
7. **Review**: Periodic review para relevance

### Decision Criteria Framework

**Technical Criteria**:
- Performance characteristics
- Scalability potential
- Maintainability
- Security implications
- Integration complexity

**Business Criteria**:
- Development speed
- Team expertise
- Community support
- Long-term viability
- Hiring considerations

**Risk Assessment**:
- Technical risks
- Business risks  
- Mitigation strategies
- Fallback options

---

## ADR Template

```markdown
# ADR-XXX: [Decision Title]

**Date**: YYYY-MM-DD
**Status**: [Proposed | Accepted | Deprecated | Superseded]
**Deciders**: [List of decision makers]
**Technical Story**: [Link or brief description]

## Context
[Problem statement and context]

## Decision
[What we decided to do]

## Rationale  
[Why we made this decision]

## Consequences

**Positive**:
- ✅ [Good consequence]

**Negative**:
- ❌ [Bad consequence]

**Mitigation**:
- 🔄 [How we address negatives]

## Implementation
[Code examples or steps]
```

---

*Last Updated: August 31, 2025*  
*Next Review: September 15, 2025*