-- Drones and Imagery Schema

-- Drone Status Enum
CREATE TYPE drone_status AS ENUM ('available', 'in_flight', 'charging', 'maintenance', 'offline');

-- Drones Table
CREATE TABLE IF NOT EXISTS drones (
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

-- Drone Missions Table
CREATE TABLE IF NOT EXISTS drone_missions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    drone_id UUID NOT NULL REFERENCES drones(id) ON DELETE SET NULL,
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

-- Drone Imagery Table
CREATE TABLE IF NOT EXISTS drone_imagery (
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

-- Satellite Imagery Table
CREATE TABLE IF NOT EXISTS satellite_imagery (
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

-- Indexes
CREATE INDEX idx_drones_division_id ON drones(division_id);
CREATE INDEX idx_drone_missions_drone_id ON drone_missions(drone_id);
CREATE INDEX idx_drone_missions_forest_id ON drone_missions(forest_id);
CREATE INDEX idx_drone_imagery_drone_mission_id ON drone_imagery(drone_mission_id);
CREATE INDEX idx_satellite_imagery_forest_id ON satellite_imagery(forest_id);
