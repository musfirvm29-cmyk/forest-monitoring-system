'use client';

import React, { useEffect, useState } from 'react';
import StatCard from '@/components/StatCard';
import { alertService, Alert } from '@/services/alertService';

export default function Dashboard() {
  const [alerts, setAlerts] = useState<Alert[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchAlerts = async () => {
      try {
        const data = await alertService.getAlerts({ limit: 10 });
        setAlerts(data);
      } catch (error) {
        console.error('Failed to fetch alerts:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchAlerts();
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">Forest Dashboard</h1>

        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <StatCard title="Total Forest Area" value="45,230" unit="sq km" icon="🌲" color="green" />
          <StatCard title="Healthy Trees" value="1,245,000" icon="✅" color="green" />
          <StatCard title="Trees at Risk" value="12,450" icon="⚠️" color="yellow" />
          <StatCard title="Active Alerts" value={alerts.filter(a => a.status === 'pending').length} icon="🚨" color="red" />
        </div>

        {/* Recent Alerts */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Recent Alerts</h2>
          {loading ? (
            <p className="text-gray-600">Loading...</p>
          ) : alerts.length > 0 ? (
            <div className="space-y-4">
              {alerts.slice(0, 5).map((alert) => (
                <div key={alert.id} className="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50">
                  <div>
                    <p className="font-semibold text-gray-900">{alert.alert_type}</p>
                    <p className="text-sm text-gray-600">{alert.description}</p>
                  </div>
                  <div className="text-right">
                    <span
                      className={`inline-block px-3 py-1 rounded-full text-sm font-semibold ${
                        alert.severity === 'critical'
                          ? 'bg-red-100 text-red-800'
                          : alert.severity === 'high'
                          ? 'bg-orange-100 text-orange-800'
                          : 'bg-yellow-100 text-yellow-800'
                      }`}
                    >
                      {alert.severity}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-gray-600">No alerts</p>
          )}
        </div>
      </div>
    </div>
  );
}
