# System Architecture

## Overview

The Forest Resources Monitoring System follows a microservices architecture with three main components:

1. **Frontend** - React/Next.js web application
2. **Backend** - Node.js/Express REST API
3. **AI Services** - Python FastAPI microservice

## Architecture Components

### Frontend (React/Next.js)
- **Dashboard**: Real-time monitoring cards and charts
- **Maps**: GIS visualization with Leaflet/Google Maps
- **Alerts**: Alert management and notifications
- **Reports**: Report generation and viewing
- **Settings**: User preferences and system configuration

### Backend (Express.js)
- **Authentication**: JWT-based authentication
- **Authorization**: Role-based access control (RBAC)
- **API Routes**: RESTful endpoints for all features
- **Business Logic**: Core application logic
- **Database Abstraction**: ORM for data access
- **External Integrations**: SMS, Email, Firebase

### AI Services (FastAPI)
- **Model Management**: Loading and managing ML models
- **Image Processing**: Processing drone and satellite imagery
- **Detection Services**: Tree health, fire, wildlife detection
- **Analytics**: Data analysis and predictions
- **Result Storage**: Storing detection results

## Data Flow

### Real-time Monitoring
1. IoT sensors send data to backend
2. Backend stores data and notifies AI services
3. AI services process data and generate alerts
4. Alerts sent to frontend via WebSocket
5. Frontend updates dashboard in real-time

### Drone Image Analysis
1. Officer uploads drone image via frontend
2. Backend stores image in AWS S3
3. Backend sends image to AI services
4. AI services process image and detect objects
5. Results stored in database
6. Frontend displays results and alerts

### Alert System
1. AI/IoT generates alert
2. Backend creates alert record
3. Backend sends notifications (SMS/Email/Push)
4. Frontend displays alert in real-time
5. Officer can acknowledge/act on alert

## Security Architecture

- **HTTPS/TLS Encryption**: All communications encrypted
- **JWT Authentication**: Stateless authentication
- **RBAC**: Role-based access control
- **Audit Logging**: Track all user actions
- **Secure Storage**: Encrypted sensitive data

## Deployment Architecture

- **Kubernetes Orchestration**: Container management
- **Load Balancer**: Distribute traffic
- **Auto-scaling**: Scale based on demand
- **Database Cluster**: Managed database services
- **Cloud Storage**: S3/Blob storage for media
