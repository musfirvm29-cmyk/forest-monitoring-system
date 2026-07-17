-- Alerts and Incidents Schema

-- Alert Type Enum
CREATE TYPE alert_type AS ENUM ('forest_fire', 'illegal_cutting', 'unauthorized_entry', 'wildlife_conflict', 'sensor_failure', 'heavy_rain', 'flood', 'landslide', 'boundary_breach');
CREATE TYPE alert_severity AS ENUM ('low', 'medium', 'high', 'critical');
CREATE TYPE alert_status AS ENUM ('pending', 'acknowledged', 'resolved', 'false_alarm');

-- Alerts Table
CREATE TABLE IF NOT EXISTS alerts (
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

-- Incidents Table
CREATE TABLE IF NOT EXISTS incidents (
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

-- Incident Updates Table
CREATE TABLE IF NOT EXISTS incident_updates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    status VARCHAR(50),
    update_text TEXT,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Alert Notifications Table
CREATE TABLE IF NOT EXISTS alert_notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    alert_id UUID NOT NULL REFERENCES alerts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notification_type VARCHAR(50),
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    channel VARCHAR(50)
);

-- Indexes
CREATE INDEX idx_alerts_forest_id ON alerts(forest_id);
CREATE INDEX idx_alerts_severity ON alerts(severity);
CREATE INDEX idx_alerts_status ON alerts(status);
CREATE INDEX idx_alerts_created_at ON alerts(created_at DESC);
CREATE INDEX idx_incidents_forest_id ON incidents(forest_id);
CREATE INDEX idx_incidents_status ON incidents(status);
CREATE INDEX idx_incident_updates_incident_id ON incident_updates(incident_id);
CREATE INDEX idx_alert_notifications_user_id ON alert_notifications(user_id);
