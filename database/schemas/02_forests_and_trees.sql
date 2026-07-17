-- Forests and Trees Schema

-- Trees Status Enum
CREATE TYPE tree_status AS ENUM ('healthy', 'diseased', 'dead', 'dry', 'burned');

-- Forests Table
CREATE TABLE IF NOT EXISTS forests (
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

-- Trees Table
CREATE TABLE IF NOT EXISTS trees (
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

-- Tree Health History Table
CREATE TABLE IF NOT EXISTS tree_health_history (
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

-- Forest Statistics Table
CREATE TABLE IF NOT EXISTS forest_statistics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID NOT NULL REFERENCES forests(id) ON DELETE CASCADE,
    total_trees INTEGER DEFAULT 0,
    healthy_trees INTEGER DEFAULT 0,
    diseased_trees INTEGER DEFAULT 0,
    dead_trees INTEGER DEFAULT 0,
    dry_trees INTEGER DEFAULT 0,
    burned_trees INTEGER DEFAULT 0,
    average_health_score DECIMAL(3, 2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_forests_division_id ON forests(division_id);
CREATE INDEX idx_trees_forest_id ON trees(forest_id);
CREATE INDEX idx_trees_status ON trees(status);
CREATE INDEX idx_trees_location ON trees USING GIST(location);
CREATE INDEX idx_tree_health_history_tree_id ON tree_health_history(tree_id);
CREATE INDEX idx_forest_statistics_forest_id ON forest_statistics(forest_id);
