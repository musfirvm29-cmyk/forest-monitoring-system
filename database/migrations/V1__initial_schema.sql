-- Combined Migration Script
-- This file contains all schemas in one comprehensive migration

-- Create Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================
-- TYPE DEFINITIONS
-- ============================================

CREATE TYPE user_role AS ENUM ('super_admin', 'forest_officer', 'field_staff');
CREATE TYPE tree_status AS ENUM ('healthy', 'diseased', 'dead', 'dry', 'burned');
CREATE TYPE sensor_type AS ENUM ('temperature', 'humidity', 'rainfall', 'wind_speed', 'smoke_level', 'co_level', 'soil_moisture', 'water_level');
CREATE TYPE sensor_status AS ENUM ('active', 'inactive', 'maintenance', 'faulty');
CREATE TYPE drone_status AS ENUM ('available', 'in_flight', 'charging', 'maintenance', 'offline');
CREATE TYPE alert_type AS ENUM ('forest_fire', 'illegal_cutting', 'unauthorized_entry', 'wildlife_conflict', 'sensor_failure', 'heavy_rain', 'flood', 'landslide', 'boundary_breach');
CREATE TYPE alert_severity AS ENUM ('low', 'medium', 'high', 'critical');
CREATE TYPE alert_status AS ENUM ('pending', 'acknowledged', 'resolved', 'false_alarm');
CREATE TYPE wildlife_species AS ENUM ('elephant', 'tiger', 'leopard', 'deer', 'monkey', 'bear', 'bird', 'other');
CREATE TYPE wildlife_threat_level AS ENUM ('low', 'medium', 'high', 'critical');
CREATE TYPE report_type AS ENUM ('tree_health', 'fire', 'illegal_activity', 'wildlife', 'monthly_status', 'annual_resource', 'custom');
CREATE TYPE fire_status AS ENUM ('detected', 'confirmed', 'contained', 'extinguished', 'false_alarm');

-- ============================================
-- TABLES
-- ============================================

-- Divisions
CREATE TABLE divisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    location GEOGRAPHY(POLYGON, 4326),
    area_sqkm DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'field_staff',
    division_id UUID REFERENCES divisions(id) ON DELETE SET NULL,
    phone_number VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    mfa_enabled BOOLEAN DEFAULT false,
    mfa_secret VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sessions
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(1024) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Logs
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(255) NOT NULL,
    resource_type VARCHAR(100),
    resource_id VARCHAR(255),
    description TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Forests
CREATE TABLE forests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    division_id UUID NOT NULL REFERENCES divisions(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    boundary GEOGRAPHY(POLYGON, 4326) NOT NULL,
    area_sqkm DECIMAL(10, 2),
    forest_type VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trees
CREATE TABLE trees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    species VARCHAR(255),
    status tree_status DEFAULT 'healthy',
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    age_years INTEGER,
    height_meters DECIMAL(5, 2),
    diameter_cm DECIMAL(5, 2),
    health_score DECIMAL(3, 2),
    last_assessed TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tree Health History
CREATE TABLE tree_health_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tree_id UUID NOT NULL REFERENCES trees(id) ON DELETE CASCADE,
    status tree_status,
    health_score DECIMAL(3, 2),
    notes TEXT,
    assessed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    assessment_date TIMESTAMP,
    image_url VARCHAR(1024),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Forest Statistics
CREATE TABLE forest_statistics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL UNIQUE REFERENCES forests(id) ON DELETE CASCADE,
    total_trees INTEGER DEFAULT 0,
    healthy_trees INTEGER DEFAULT 0,
    diseased_trees INTEGER DEFAULT 0,
    dead_trees INTEGER DEFAULT 0,
    dry_trees INTEGER DEFAULT 0,
    burned_trees INTEGER DEFAULT 0,
    average_health_score DECIMAL(3, 2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensors
CREATE TABLE sensors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    sensor_type sensor_type NOT NULL,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    name VARCHAR(255),
    description TEXT,
    status sensor_status DEFAULT 'active',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    battery_level INTEGER,
    last_reading TIMESTAMP,
    last_maintenance TIMESTAMP,
    installed_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensor Readings
CREATE TABLE sensor_readings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sensor_id UUID NOT NULL REFERENCES sensors(id) ON DELETE CASCADE,
    value DECIMAL(10, 3) NOT NULL,
    unit VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensor Alerts
CREATE TABLE sensor_alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sensor_id UUID NOT NULL REFERENCES sensors(id) ON DELETE CASCADE,
    alert_type VARCHAR(100),
    severity VARCHAR(50),
    threshold_value DECIMAL(10, 3),
    current_value DECIMAL(10, 3),
    is_resolved BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

-- Drones
CREATE TABLE drones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    division_id UUID NOT NULL REFERENCES divisions(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    model VARCHAR(255),
    status drone_status DEFAULT 'available',
    battery_level INTEGER,
    current_location GEOGRAPHY(POINT, 4326),
    last_maintenance TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Drone Missions
CREATE TABLE drone_missions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    drone_id UUID REFERENCES drones(id) ON DELETE SET NULL,
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    mission_type VARCHAR(100),
    planned_area GEOGRAPHY(POLYGON, 4326),
    status VARCHAR(50) DEFAULT 'pending',
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    duration_minutes INTEGER,
    distance_km DECIMAL(8, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Drone Imagery
CREATE TABLE drone_imagery (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    drone_mission_id UUID NOT NULL REFERENCES drone_missions(id) ON DELETE CASCADE,
    image_url VARCHAR(1024) NOT NULL,
    image_key VARCHAR(500),
    captured_at TIMESTAMP NOT NULL,
    location GEOGRAPHY(POINT, 4326),
    altitude_m DECIMAL(8, 2),
    camera_angle DECIMAL(5, 2),
    file_size_mb INTEGER,
    processed BOOLEAN DEFAULT false,
    ai_analysis_done BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Satellite Imagery
CREATE TABLE satellite_imagery (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    source VARCHAR(100),
    image_url VARCHAR(1024),
    image_date TIMESTAMP,
    resolution_m DECIMAL(5, 2),
    coverage GEOGRAPHY(POLYGON, 4326),
    cloud_cover_percent DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Alerts
CREATE TABLE alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID REFERENCES forests(id) ON DELETE CASCADE,
    alert_type alert_type NOT NULL,
    severity alert_severity NOT NULL DEFAULT 'medium',
    status alert_status DEFAULT 'pending',
    location GEOGRAPHY(POINT, 4326),
    description TEXT,
    image_url VARCHAR(1024),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acknowledged_at TIMESTAMP,
    acknowledged_by UUID REFERENCES users(id) ON DELETE SET NULL,
    resolved_at TIMESTAMP,
    resolved_by UUID REFERENCES users(id) ON DELETE SET NULL,
    resolution_notes TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Incidents
CREATE TABLE incidents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    alert_id UUID REFERENCES alerts(id) ON DELETE CASCADE,
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    incident_type VARCHAR(100) NOT NULL,
    severity alert_severity NOT NULL,
    location GEOGRAPHY(POINT, 4326),
    description TEXT,
    reported_by UUID REFERENCES users(id) ON DELETE SET NULL,
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'reported',
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Incident Updates
CREATE TABLE incident_updates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    status VARCHAR(50),
    update_text TEXT,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Alert Notifications
CREATE TABLE alert_notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    alert_id UUID NOT NULL REFERENCES alerts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notification_type VARCHAR(50),
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    channel VARCHAR(50)
);

-- Wildlife Sightings
CREATE TABLE wildlife_sightings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    species wildlife_species NOT NULL,
    count INTEGER,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    sighting_time TIMESTAMP,
    threat_level wildlife_threat_level DEFAULT 'low',
    description TEXT,
    image_url VARCHAR(1024),
    reported_by UUID REFERENCES users(id) ON DELETE SET NULL,
    verified BOOLEAN DEFAULT false,
    verified_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wildlife Corridors
CREATE TABLE wildlife_corridors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    species wildlife_species,
    corridor_path GEOGRAPHY(LINESTRING, 4326),
    frequency_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wildlife Conflicts
CREATE TABLE wildlife_conflicts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    incident_id UUID REFERENCES incidents(id) ON DELETE CASCADE,
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    species wildlife_species,
    conflict_type VARCHAR(100),
    location GEOGRAPHY(POINT, 4326),
    human_injuries INTEGER DEFAULT 0,
    animal_injured BOOLEAN DEFAULT false,
    description TEXT,
    resolution TEXT,
    reported_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fire Events
CREATE TABLE fire_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    fire_location GEOGRAPHY(POINT, 4326) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    fire_intensity DECIMAL(5, 2),
    affected_area_sqkm DECIMAL(10, 2),
    status fire_status DEFAULT 'detected',
    detection_time TIMESTAMP,
    confirmed_time TIMESTAMP,
    contained_time TIMESTAMP,
    extinguished_time TIMESTAMP,
    wind_direction VARCHAR(20),
    wind_speed_kmh DECIMAL(5, 2),
    temperature_celsius DECIMAL(5, 2),
    humidity_percent DECIMAL(5, 2),
    description TEXT,
    image_url VARCHAR(1024),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fire Spread Predictions
CREATE TABLE fire_spread_predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fire_event_id UUID NOT NULL REFERENCES fire_events(id) ON DELETE CASCADE,
    predicted_area GEOGRAPHY(POLYGON, 4326),
    predicted_spread_rate_kmh DECIMAL(5, 2),
    time_to_spread INTEGER,
    affected_trees_estimate INTEGER,
    nearby_villages_affected INTEGER,
    confidence_percent DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fire Resources
CREATE TABLE fire_resources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fire_event_id UUID NOT NULL REFERENCES fire_events(id) ON DELETE CASCADE,
    resource_type VARCHAR(100),
    resource_count INTEGER,
    arrival_time TIMESTAMP,
    deployed_at TIMESTAMP,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Water Sources
CREATE TABLE water_sources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    source_type VARCHAR(100),
    water_capacity_liters INTEGER,
    accessibility VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reports
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    report_type report_type NOT NULL,
    forest_id UUID REFERENCES forests(id) ON DELETE CASCADE,
    division_id UUID REFERENCES divisions(id) ON DELETE CASCADE,
    generated_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    file_url VARCHAR(1024),
    file_format VARCHAR(50),
    file_size_mb INTEGER,
    data_summary JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Report Parameters
CREATE TABLE report_parameters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    param_key VARCHAR(100),
    param_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Analytics Data
CREATE TABLE analytics_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID REFERENCES forests(id) ON DELETE CASCADE,
    metric_name VARCHAR(255) NOT NULL,
    metric_value DECIMAL(15, 2),
    metric_date TIMESTAMP,
    trend_direction VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_division_id ON users(division_id);
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_forests_division_id ON forests(division_id);
CREATE INDEX idx_trees_forest_id ON trees(forest_id);
CREATE INDEX idx_trees_status ON trees(status);
CREATE INDEX idx_trees_location ON trees USING GIST(location);
CREATE INDEX idx_tree_health_history_tree_id ON tree_health_history(tree_id);
CREATE INDEX idx_forest_statistics_forest_id ON forest_statistics(forest_id);
CREATE INDEX idx_sensors_forest_id ON sensors(forest_id);
CREATE INDEX idx_sensors_location ON sensors USING GIST(location);
CREATE INDEX idx_sensor_readings_sensor_id ON sensor_readings(sensor_id);
CREATE INDEX idx_sensor_readings_timestamp ON sensor_readings(timestamp DESC);
CREATE INDEX idx_sensor_alerts_sensor_id ON sensor_alerts(sensor_id);
CREATE INDEX idx_sensor_alerts_created_at ON sensor_alerts(created_at DESC);
CREATE INDEX idx_drones_division_id ON drones(division_id);
CREATE INDEX idx_drone_missions_drone_id ON drone_missions(drone_id);
CREATE INDEX idx_drone_missions_forest_id ON drone_missions(forest_id);
CREATE INDEX idx_drone_imagery_drone_mission_id ON drone_imagery(drone_mission_id);
CREATE INDEX idx_satellite_imagery_forest_id ON satellite_imagery(forest_id);
CREATE INDEX idx_alerts_forest_id ON alerts(forest_id);
CREATE INDEX idx_alerts_severity ON alerts(severity);
CREATE INDEX idx_alerts_status ON alerts(status);
CREATE INDEX idx_alerts_created_at ON alerts(created_at DESC);
CREATE INDEX idx_incidents_forest_id ON incidents(forest_id);
CREATE INDEX idx_incidents_status ON incidents(status);
CREATE INDEX idx_incident_updates_incident_id ON incident_updates(incident_id);
CREATE INDEX idx_alert_notifications_user_id ON alert_notifications(user_id);
CREATE INDEX idx_wildlife_sightings_forest_id ON wildlife_sightings(forest_id);
CREATE INDEX idx_wildlife_sightings_species ON wildlife_sightings(species);
CREATE INDEX idx_wildlife_sightings_location ON wildlife_sightings USING GIST(location);
CREATE INDEX idx_wildlife_corridors_forest_id ON wildlife_corridors(forest_id);
CREATE INDEX idx_wildlife_conflicts_forest_id ON wildlife_conflicts(forest_id);
CREATE INDEX idx_fire_events_forest_id ON fire_events(forest_id);
CREATE INDEX idx_fire_events_status ON fire_events(status);
CREATE INDEX idx_fire_events_detection_time ON fire_events(detection_time DESC);
CREATE INDEX idx_fire_spread_predictions_fire_event_id ON fire_spread_predictions(fire_event_id);
CREATE INDEX idx_water_sources_forest_id ON water_sources(forest_id);
CREATE INDEX idx_reports_forest_id ON reports(forest_id);
CREATE INDEX idx_reports_division_id ON reports(division_id);
CREATE INDEX idx_reports_generated_by ON reports(generated_by);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);
CREATE INDEX idx_report_parameters_report_id ON report_parameters(report_id);
CREATE INDEX idx_analytics_data_forest_id ON analytics_data(forest_id);
CREATE INDEX idx_analytics_data_metric_date ON analytics_data(metric_date DESC);
