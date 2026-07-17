-- Fire Detection and Management Schema

-- Fire Status Enum
CREATE TYPE fire_status AS ENUM ('detected', 'confirmed', 'contained', 'extinguished', 'false_alarm');

-- Fire Events Table
CREATE TABLE IF NOT EXISTS fire_events (
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

-- Fire Spread Prediction Table
CREATE TABLE IF NOT EXISTS fire_spread_predictions (
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

-- Fire Resources Table
CREATE TABLE IF NOT EXISTS fire_resources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fire_event_id UUID NOT NULL REFERENCES fire_events(id) ON DELETE CASCADE,
    resource_type VARCHAR(100),
    resource_count INTEGER,
    arrival_time TIMESTAMP,
    deployed_at TIMESTAMP,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Water Sources Table
CREATE TABLE IF NOT EXISTS water_sources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    source_type VARCHAR(100),
    water_capacity_liters INTEGER,
    accessibility VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_fire_events_forest_id ON fire_events(forest_id);
CREATE INDEX idx_fire_events_status ON fire_events(status);
CREATE INDEX idx_fire_events_detection_time ON fire_events(detection_time DESC);
CREATE INDEX idx_fire_spread_predictions_fire_event_id ON fire_spread_predictions(fire_event_id);
CREATE INDEX idx_water_sources_forest_id ON water_sources(forest_id);
