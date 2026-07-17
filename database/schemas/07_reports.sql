-- Reports Schema

-- Report Type Enum
CREATE TYPE report_type AS ENUM ('tree_health', 'fire', 'illegal_activity', 'wildlife', 'monthly_status', 'annual_resource', 'custom');

-- Reports Table
CREATE TABLE IF NOT EXISTS reports (
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

-- Report Parameters Table
CREATE TABLE IF NOT EXISTS report_parameters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    param_key VARCHAR(100),
    param_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Analytics Data Table
CREATE TABLE IF NOT EXISTS analytics_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    forest_id UUID REFERENCES forests(id) ON DELETE CASCADE,
    metric_name VARCHAR(255) NOT NULL,
    metric_value DECIMAL(15, 2),
    metric_date TIMESTAMP,
    trend_direction VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_reports_forest_id ON reports(forest_id);
CREATE INDEX idx_reports_division_id ON reports(division_id);
CREATE INDEX idx_reports_generated_by ON reports(generated_by);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);
CREATE INDEX idx_report_parameters_report_id ON report_parameters(report_id);
CREATE INDEX idx_analytics_data_forest_id ON analytics_data(forest_id);
CREATE INDEX idx_analytics_data_metric_date ON analytics_data(metric_date DESC);
