export interface User {
  id: string;
  email: string;
  password_hash: string;
  full_name: string;
  role: 'super_admin' | 'forest_officer' | 'field_staff';
  division_id?: string;
  phone_number?: string;
  is_active: boolean;
  last_login?: Date;
  mfa_enabled: boolean;
  mfa_secret?: string;
  created_at: Date;
  updated_at: Date;
}

export interface UserInput {
  email: string;
  password: string;
  full_name: string;
  role?: 'super_admin' | 'forest_officer' | 'field_staff';
  division_id?: string;
  phone_number?: string;
}

export interface UserResponse {
  id: string;
  email: string;
  full_name: string;
  role: string;
  division_id?: string;
  phone_number?: string;
  is_active: boolean;
  created_at: Date;
}
