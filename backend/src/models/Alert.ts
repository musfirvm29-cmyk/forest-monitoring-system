export type AlertType = 'forest_fire' | 'illegal_cutting' | 'unauthorized_entry' | 'wildlife_conflict' | 'sensor_failure' | 'heavy_rain' | 'flood' | 'landslide' | 'boundary_breach';
export type AlertSeverity = 'low' | 'medium' | 'high' | 'critical';
export type AlertStatus = 'pending' | 'acknowledged' | 'resolved' | 'false_alarm';

export interface Alert {
  id: string;
  forest_id?: string;
  alert_type: AlertType;
  severity: AlertSeverity;
  status: AlertStatus;
  location?: GeoJSON.Point;
  description?: string;
  image_url?: string;
  created_at: Date;
  acknowledged_at?: Date;
  acknowledged_by?: string;
  resolved_at?: Date;
  resolved_by?: string;
  resolution_notes?: string;
  updated_at: Date;
}

export interface AlertInput {
  forest_id?: string;
  alert_type: AlertType;
  severity: AlertSeverity;
  location?: GeoJSON.Point;
  description?: string;
  image_url?: string;
}
