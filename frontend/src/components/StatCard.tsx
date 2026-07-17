'use client';

import React from 'react';

interface StatCardProps {
  title: string;
  value: string | number;
  icon?: string;
  color?: string;
  unit?: string;
}

export default function StatCard({ title, value, icon = '📊', color = 'blue', unit = '' }: StatCardProps) {
  const colorClasses = {
    blue: 'bg-blue-50 border-blue-200',
    green: 'bg-green-50 border-green-200',
    red: 'bg-red-50 border-red-200',
    yellow: 'bg-yellow-50 border-yellow-200',
  };

  return (
    <div className={`${colorClasses[color as keyof typeof colorClasses] || colorClasses.blue} border rounded-lg p-6 shadow-sm`}>
      <div className="flex items-center justify-between">
        <div>
          <p className="text-gray-600 text-sm font-medium">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {value} {unit && <span className="text-lg">{unit}</span>}
          </p>
        </div>
        <div className="text-4xl">{icon}</div>
      </div>
    </div>
  );
}
