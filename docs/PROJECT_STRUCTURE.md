# Project Structure

## Root Directory

```
forest-monitoring-system/
├── frontend/                    # React/Next.js Frontend Application
├── backend/                     # Node.js/Express Backend API
├── ai-services/                 # Python FastAPI AI Services
├── database/                    # Database Schemas & Migrations
├── docker/                      # Docker & Container Configuration
├── config/                      # Configuration Files
├── docs/                        # Documentation
├── .env.example                 # Environment Variables Template
├── .gitignore                   # Git Ignore Rules
├── README.md                    # Project README
├── CONTRIBUTING.md              # Contributing Guidelines
├── LICENSE                      # MIT License
└── package.json                 # Root Package Configuration
```

## Frontend Directory (`/frontend`)

```
frontend/
├── src/
│   ├── components/              # Reusable React Components
│   │   ├── Dashboard/
│   │   ├── Map/
│   │   ├── Charts/
│   │   ├── Alerts/
│   │   ├── Navigation/
│   │   └── Common/
│   ├── pages/                   # Next.js Pages
│   │   ├── index.tsx
│   │   ├── dashboard.tsx
│   │   ├── map.tsx
│   │   ├── alerts.tsx
│   │   ├── reports.tsx
│   │   ├── settings.tsx
│   │   └── login.tsx
│   ├── hooks/                   # Custom React Hooks
│   ├── services/                # API Services
│   ├── styles/                  # Global Styles & Tailwind Config
│   ├── utils/                   # Utility Functions
│   ├── types/                   # TypeScript Type Definitions
│   ├── context/                 # React Context
│   └── App.tsx
├── public/                      # Static Assets
├── .env.local                   # Local Environment Variables
├── tsconfig.json                # TypeScript Configuration
├── tailwind.config.js           # Tailwind CSS Configuration
├── next.config.js               # Next.js Configuration
└── package.json
```

## Backend Directory (`/backend`)

```
backend/
├── src/
│   ├── controllers/             # Route Controllers
│   ├── models/                  # Database Models
│   ├── routes/                  # API Routes
│   ├── middleware/              # Express Middleware
│   ├── services/                # Business Logic Services
│   ├── utils/                   # Utility Functions
│   ├── config/                  # Configuration
│   ├── validators/              # Input Validators
│   ├── auth/                    # Authentication Logic
│   └── app.ts                   # Express App Setup
├── tests/                       # Test Files
├── migrations/                  # Database Migrations
├── seeders/                     # Database Seeders
├── .env.local
├── tsconfig.json
├── jest.config.js
└── package.json
```

## AI Services Directory (`/ai-services`)

```
ai-services/
├── app/
│   ├── main.py                  # FastAPI Main Application
│   ├── config.py               # Configuration
│   ├── models/                 # AI/ML Models
│   │   ├── tree_health.py
│   │   ├── illegal_cutting.py
│   │   ├── fire_detection.py
│   │   ├── wildlife_detection.py
│   │   ├── human_detection.py
│   │   └── boundary_monitoring.py
│   ├── routers/                # API Routers
│   │   ├── tree_health.py
│   │   ├── fire.py
│   │   ├── wildlife.py
│   │   └── ...
│   ├── services/               # Business Logic
│   ├── utils/                  # Utility Functions
│   └── schemas/                # Pydantic Schemas
├── models/                     # Pre-trained Model Files
├── tests/                      # Test Files
├── requirements.txt            # Python Dependencies
├── .env.local
└── Dockerfile
```

## Database Directory (`/database`)

```
database/
├── schemas/
│   ├── users.sql
│   ├── forests.sql
│   ├── trees.sql
│   ├── alerts.sql
│   ├── sensors.sql
│   ├── drones.sql
│   ├── wildlife.sql
│   ├── incidents.sql
│   └── reports.sql
├── migrations/
│   ├── V1__initial_schema.sql
│   ├── V2__add_postGIS.sql
│   └── ...
├── seeders/
│   ├── initial_data.sql
│   └── test_data.sql
└── README.md
```

## Docker Directory (`/docker`)

```
docker/
├── Dockerfile.frontend
├── Dockerfile.backend
├── Dockerfile.ai
├── docker-compose.yml
└── docker-compose.prod.yml
```

## Documentation Directory (`/docs`)

```
docs/
├── ARCHITECTURE.md              # System Architecture
├── API.md                       # API Documentation
├── AI_MODULES.md                # AI Modules Documentation
├── DATABASE_SCHEMA.md           # Database Schema
├── DEPLOYMENT.md                # Deployment Guide
├── SETUP.md                     # Setup Instructions
├── USER_ROLES.md                # User Roles & Permissions
├── SECURITY.md                  # Security Guidelines
└── TROUBLESHOOTING.md           # Troubleshooting Guide
```

## Configuration Directory (`/config`)

```
config/
├── dev.js                       # Development Config
├── prod.js                      # Production Config
├── test.js                      # Test Config
├── database.js                  # Database Config
├── auth.js                      # Authentication Config
└── services.js                  # External Services Config
```
