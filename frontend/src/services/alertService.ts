import api from './api';

export interface Alert {
  id: string;
  forest_id?: string;
  alert_type: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  status: 'pending' | 'acknowledged' | 'resolved';
  location?: { type: string; coordinates: number[] };
  description?: string;
  image_url?: string;
  created_at: Date;
}

export const alertService = {
  async getAlerts(params?: any) {
    const response = await api.get('/alerts', { params });
    return response.data;
  },

  async getAlertById(id: string) {
    const response = await api.get(`/alerts/${id}`);
    return response.data;
  },

  async acknowledgeAlert(id: string) {
    const response = await api.put(`/alerts/${id}/acknowledge`);
    return response.data;
  },

  async resolveAlert(id: string, notes: string) {
    const response = await api.put(`/alerts/${id}/resolve`, { resolution_notes: notes });
    return response.data;
  },
};
