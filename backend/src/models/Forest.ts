export interface Forest {
  id: string;
  division_id: string;
  name: string;
  description?: string;
  boundary: GeoJSON.Polygon;
  area_sqkm: number;
  forest_type?: string;
  created_at: Date;
  updated_at: Date;
}

export interface ForestInput {
  division_id: string;
  name: string;
  description?: string;
  boundary: GeoJSON.Polygon;
  area_sqkm: number;
  forest_type?: string;
}
