import api from './api';

export interface LoginResponse {
  user: {
    id: string;
    email: string;
    full_name: string;
    role: string;
  };
  token: string;
}

export interface RegisterData {
  email: string;
  password: string;
  full_name: string;
}

export const authService = {
  async login(email: string, password: string): Promise<LoginResponse> {
    const response = await api.post('/auth/login', { email, password });
    return response.data;
  },

  async register(data: RegisterData): Promise<LoginResponse> {
    const response = await api.post('/auth/register', data);
    return response.data;
  },

  logout() {
    localStorage.removeItem('authToken');
  },
};
