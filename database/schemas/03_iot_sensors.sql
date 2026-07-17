-- IoT Sensors Schema

-- Sensor Type Enum
CREATE TYPE sensor_type AS ENUM ('temperature', 'humidity', 'rainfall', 'wind_speed', 'smoke_level', 'co_level', 'soil_moisture', 'water_level');
CREATE TYPE sensor_status AS ENUM ('active', 'inactive', 'maintenance', 'faulty');

-- Sensors Table
CREATE TABLE IF NOT EXISTS sensors (
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

-- Sensor Readings Table
CREATE TABLE IF NOT EXISTS sensor_readings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sensor_id UUID NOT NULL REFERENCES sensors(id) ON DELETE CASCADE,
    value DECIMAL(10, 3) NOT NULL,
    unit VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensor Alerts Table
CREATE TABLE IF NOT EXISTS sensor_alerts (
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

-- Indexes
CREATE INDEX idx_sensors_forest_id ON sensors(forest_id);
CREATE INDEX idx_sensors_location ON sensors USING GIST(location);
CREATE INDEX idx_sensor_readings_sensor_id ON sensor_readings(sensor_id);
CREATE INDEX idx_sensor_readings_timestamp ON sensor_readings(timestamp DESC);
CREATE INDEX idx_sensor_alerts_sensor_id ON sensor_alerts(sensor_id);
CREATE INDEX idx_sensor_alerts_created_at ON sensor_alerts(created_at DESC);
