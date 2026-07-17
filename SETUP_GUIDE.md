# Project Setup & Getting Started Guide

## 🎯 Project Overview

The **AI Forest Resources Monitoring System** is a comprehensive full-stack application for monitoring forest resources in real-time using AI, satellite imagery, drones, IoT sensors, and computer vision.

### Current Status: ✅ **All Core Modules Completed**

---

## 📂 Repository Structure

```
forest-monitoring-system/
├── frontend/                    # React/Next.js Web Application
├── backend/                     # Express.js REST API
├── ai-services/                 # FastAPI AI Detection Services
├── database/                    # PostgreSQL Schemas & Migrations
├── docker/                      # Docker Configurations
├── config/                      # Configuration Files
├── docs/                        # Documentation
│   ├── ARCHITECTURE.md
│   ├── PROJECT_STRUCTURE.md
│   └── ...
├── README.md                    # Main README
├── CONTRIBUTING.md              # Contributing Guidelines
├── LICENSE                      # MIT License
├── package.json                 # Root Package Configuration
└── .env.example                 # Environment Variables Template
```

---

## 🌿 Feature Branches

### 1. **feature/database-schemas** ✅
Complete PostgreSQL database schema with PostGIS support.

**Files:**
- `database/schemas/01_users_and_roles.sql` - User management
- `database/schemas/02_forests_and_trees.sql` - Tree health tracking
- `database/schemas/03_iot_sensors.sql` - Sensor data
- `database/schemas/04_drones_and_imagery.sql` - Drone missions
- `database/schemas/05_alerts_and_incidents.sql` - Alert management
- `database/schemas/06_wildlife.sql` - Wildlife monitoring
- `database/schemas/07_reports.sql` - Report generation
- `database/schemas/08_fire_detection.sql` - Fire management
- `database/migrations/V1__initial_schema.sql` - Combined migration

**Key Features:**
- 25+ tables with relationships
- PostGIS for spatial queries
- Type-safe enums for status values
- Comprehensive indexing for performance
- Audit logging built-in

### 2. **feature/backend-setup** ✅
Express.js REST API with authentication and business logic.

**Files:**
- `backend/src/config/database.ts` - Database connections
- `backend/src/config/jwt.ts` - JWT configuration
- `backend/src/middleware/auth.ts` - Authentication & RBAC
- `backend/src/models/User.ts` - User type definitions
- `backend/src/models/Forest.ts` - Forest type definitions
- `backend/src/models/Alert.ts` - Alert type definitions
- `backend/src/services/authService.ts` - Authentication logic
- `backend/src/routes/auth.ts` - Auth endpoints
- `backend/src/app.ts` - Express app setup
- `backend/tsconfig.json` - TypeScript config
- `backend/.env.example` - Environment template
- `backend/package.json` - Dependencies

**Key Features:**
- JWT authentication with refresh tokens
- Role-based access control (RBAC)
- PostgreSQL + MongoDB support
- Input validation
- Error handling
- Security middleware (Helmet, CORS, Rate Limiting)

### 3. **feature/frontend-setup** ✅
React/Next.js frontend with authentication and dashboard.

**Files:**
- `frontend/src/services/api.ts` - API client with interceptors
- `frontend/src/services/authService.ts` - Authentication service
- `frontend/src/services/alertService.ts` - Alert management service
- `frontend/src/context/AuthContext.tsx` - Auth state management
- `frontend/src/components/Navbar.tsx` - Navigation component
- `frontend/src/components/StatCard.tsx` - Dashboard metric cards
- `frontend/src/app/dashboard/page.tsx` - Dashboard page
- `frontend/src/app/login/page.tsx` - Login page
- `frontend/src/app/layout.tsx` - Root layout with providers
- `frontend/src/app/globals.css` - Global styles
- `frontend/tsconfig.json` - TypeScript config
- `frontend/tailwind.config.ts` - Tailwind CSS config
- `frontend/next.config.js` - Next.js config
- `frontend/.env.example` - Environment template
- `frontend/package.json` - Dependencies

**Key Features:**
- Server-side rendering with Next.js
- Tailwind CSS with forest green theme
- React Context for state management
- Axios with request/response interceptors
- Responsive design (mobile, tablet, desktop)
- Real-time data display
- Toast notifications

### 4. **feature/ai-services-setup** ✅
FastAPI Python microservice for AI detection models.

**Files:**
- `ai-services/app/main.py` - FastAPI app setup
- `ai-services/app/config.py` - Configuration management
- `ai-services/app/utils/image_processor.py` - Image preprocessing
- `ai-services/app/utils/detection_utils.py` - Detection utilities
- `ai-services/app/routers/tree_health.py` - Tree health detection
- `ai-services/app/routers/fire_detection.py` - Fire detection
- `ai-services/app/routers/wildlife.py` - Wildlife detection
- `ai-services/app/routers/boundary.py` - Boundary monitoring
- `ai-services/.env.example` - Environment template
- `ai-services/Dockerfile` - Container setup
- `ai-services/requirements.txt` - Python dependencies

**Key Features:**
- YOLOv8 model integration ready
- Image processing pipeline
- Multiple detection modules
- Fire spread prediction
- Wildlife species detection
- Boundary breach detection
- FastAPI with async support

---

## 🚀 Quick Start Guide

### Prerequisites
- Node.js v16+
- Python 3.8+
- PostgreSQL 12+
- MongoDB 4.0+
- Docker & Docker Compose (optional)

### 1. Clone Repository
```bash
git clone https://github.com/musfirvm29-cmyk/forest-monitoring-system.git
cd forest-monitoring-system
```

### 2. Setup Database

**Option A: Using Docker**
```bash
cd docker
docker-compose up -d postgres mongo redis
```

**Option B: Manual Setup**
```bash
# PostgreSQL
psql -U postgres -c "CREATE USER forest_user WITH PASSWORD 'forest_password';"
psql -U postgres -c "CREATE DATABASE forest_monitoring OWNER forest_user;"
psql -U forest_user -d forest_monitoring -f database/migrations/V1__initial_schema.sql

# MongoDB (if using)
mongod --dbpath /var/lib/mongodb
```

### 3. Backend Setup
```bash
cd backend

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env with your configuration

# Run development server
npm run dev

# Server runs on http://localhost:5000
```

### 4. Frontend Setup
```bash
cd frontend

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env with your API URL

# Run development server
npm run dev

# Open http://localhost:3000
```

### 5. AI Services Setup
```bash
cd ai-services

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Setup environment
cp .env.example .env

# Run FastAPI server
python -m uvicorn app.main:app --reload

# API docs: http://localhost:8000/docs
```

### 6. Docker Compose (All Services)
```bash
cd docker
docker-compose up

# Services:
# Frontend: http://localhost:3000
# Backend: http://localhost:5000
# AI Services: http://localhost:8000
# PostgreSQL: localhost:5432
# MongoDB: localhost:27017
# Redis: localhost:6379
```

---

## 📊 API Endpoints

### Authentication
```
POST /api/auth/register     - User registration
POST /api/auth/login        - User login
```

### Alerts
```
GET  /api/alerts            - Get all alerts
GET  /api/alerts/:id        - Get alert by ID
PUT  /api/alerts/:id/acknowledge - Acknowledge alert
PUT  /api/alerts/:id/resolve - Resolve alert
```

### AI Services
```
POST /tree-health/detect           - Detect tree health
GET  /tree-health/stats            - Get tree statistics
POST /fire-detection/detect        - Detect fire
POST /fire-detection/predict-spread - Predict fire spread
POST /wildlife/detect              - Detect wildlife
GET  /wildlife/species             - Get wildlife species
POST /boundary/detect-breach       - Detect boundary breach
POST /boundary/detect-encroachment - Detect encroachment
```

---

## 🔐 Default Test Credentials

**For Development Only!**

```
Email: officer@forest.gov
Password: Test123!@#
Role: forest_officer
```

⚠️ Change credentials in production!

---

## 📝 Environment Variables

### Frontend (.env)
```
REACT_APP_API_URL=http://localhost:5000/api
REACT_APP_GOOGLE_MAPS_KEY=your_key
REACT_APP_FIREBASE_API_KEY=your_key
```

### Backend (.env)
```
PORT=5000
NODE_ENV=development
DATABASE_URL=postgresql://forest_user:forest_password@localhost:5432/forest_monitoring
MONGO_URL=mongodb://localhost:27017/forest_monitoring
JWT_SECRET=your_super_secret_key
JWT_EXPIRY=15m
```

### AI Services (.env)
```
PYTHONUNBUFFERED=1
AI_SERVICE_PORT=8000
DATABASE_URL=postgresql://forest_user:forest_password@localhost:5432/forest_monitoring
MODEL_PATH=/models
```

---

## 📦 Project Dependencies

### Frontend
- React 18
- Next.js 14
- TypeScript
- Tailwind CSS
- Axios
- React Hot Toast
- Zustand (state management)

### Backend
- Express.js
- TypeScript
- PostgreSQL (pg)
- MongoDB (mongoose)
- JWT (jwt-simple)
- Bcryptjs
- Helmet (security)
- CORS

### AI Services
- FastAPI
- Uvicorn
- TensorFlow 2.14
- PyTorch 2.1
- OpenCV
- NumPy
- Pandas
- Scikit-learn

---

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test
```

### Frontend Tests
```bash
cd frontend
npm test
```

### API Testing with Postman
Import the included Postman collection:
`docs/postman_collection.json`

---

## 📚 Documentation

- [Architecture Documentation](docs/ARCHITECTURE.md)
- [Project Structure](docs/PROJECT_STRUCTURE.md)
- [API Documentation](docs/API.md)
- [Database Schema](docs/DATABASE_SCHEMA.md)
- [Deployment Guide](docs/DEPLOYMENT.md)

---

## 🐛 Troubleshooting

### Database Connection Failed
```bash
# Check PostgreSQL is running
psql -U postgres

# Verify connection string in .env
DATABASE_URL=postgresql://user:password@host:port/database
```

### Port Already in Use
```bash
# Find process using port
lsof -i :3000      # Frontend
lsof -i :5000      # Backend
lsof -i :8000      # AI Services

# Kill process
kill -9 <PID>
```

### Module Not Found
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

---

## 🤝 Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Branching strategy
- Commit conventions
- Pull request process
- Code style

---

## 📋 Development Roadmap

### Phase 1: ✅ Complete
- [x] Database schema design
- [x] Backend API setup
- [x] Frontend scaffold
- [x] AI services framework
- [x] Authentication system

### Phase 2: In Progress
- [ ] Additional API routes (forests, reports, drones)
- [ ] Frontend pages (maps, reports, settings)
- [ ] Real-time WebSocket integration
- [ ] Advanced AI model integration

### Phase 3: Planned
- [ ] Mobile app (React Native)
- [ ] Analytics dashboard
- [ ] Advanced search and filtering
- [ ] Integration with external services
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Kubernetes deployment

---

## 📞 Support

- **Issues**: GitHub Issues
- **Discussions**: GitHub Discussions
- **Email**: support@forestmonitoring.gov

---

## 📄 License

MIT License - See [LICENSE](LICENSE) for details

---

## 👥 Team

- **Project Lead**: musfirvm29-cmyk
- **Contributors**: Open for contributions!

---

**Last Updated**: 2026-07-17
**Version**: 0.1.0
**Status**: Active Development
