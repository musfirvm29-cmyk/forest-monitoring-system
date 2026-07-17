'use client';

import React from 'react';
import Link from 'next/link';
import { useAuth } from '@/context/AuthContext';

export default function Navbar() {
  const { user, logout, isAuthenticated } = useAuth();

  return (
    <nav className="bg-green-800 text-white shadow-lg">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <div className="flex items-center space-x-2">
            <span className="text-2xl font-bold">🌲</span>
            <Link href="/" className="font-bold text-xl">
              Forest Monitoring
            </Link>
          </div>

          <div className="hidden md:flex space-x-4">
            {isAuthenticated && (
              <>
                <Link href="/dashboard" className="hover:text-green-200">
                  Dashboard
                </Link>
                <Link href="/map" className="hover:text-green-200">
                  Map
                </Link>
                <Link href="/alerts" className="hover:text-green-200">
                  Alerts
                </Link>
                <Link href="/reports" className="hover:text-green-200">
                  Reports
                </Link>
              </>
            )}
          </div>

          <div className="flex items-center space-x-4">
            {isAuthenticated ? (
              <>
                <span className="text-sm">{user?.full_name}</span>
                <button
                  onClick={logout}
                  className="bg-red-600 hover:bg-red-700 px-4 py-2 rounded"
                >
                  Logout
                </button>
              </>
            ) : (
              <>
                <Link href="/login" className="hover:text-green-200">
                  Login
                </Link>
                <Link href="/register" className="bg-green-600 px-4 py-2 rounded hover:bg-green-700">
                  Register
                </Link>
              </>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
}
