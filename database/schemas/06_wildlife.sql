-- Wildlife Monitoring Schema

-- Wildlife Status Enum
CREATE TYPE wildlife_species AS ENUM ('elephant', 'tiger', 'leopard', 'deer', 'monkey', 'bear', 'bird', 'other');
CREATE TYPE wildlife_threat_level AS ENUM ('low', 'medium', 'high', 'critical');

-- Wildlife Sightings Table
CREATE TABLE IF NOT EXISTS wildlife_sightings (
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

-- Wildlife Corridors Table
CREATE TABLE IF NOT EXISTS wildlife_corridors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    species wildlife_species,
    corridor_path GEOGRAPHY(LINESTRING, 4326),
    frequency_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wildlife Conflicts Table
CREATE TABLE IF NOT EXISTS wildlife_conflicts (
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

-- Indexes
CREATE INDEX idx_wildlife_sightings_forest_id ON wildlife_sightings(forest_id);
CREATE INDEX idx_wildlife_sightings_species ON wildlife_sightings(species);
CREATE INDEX idx_wildlife_sightings_location ON wildlife_sightings USING GIST(location);
CREATE INDEX idx_wildlife_corridors_forest_id ON wildlife_corridors(forest_id);
CREATE INDEX idx_wildlife_conflicts_forest_id ON wildlife_conflicts(forest_id);
