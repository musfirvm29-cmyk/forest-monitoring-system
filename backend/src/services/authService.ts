import bcrypt from 'bcryptjs';
import jwt from 'jwt-simple';
import { pool } from '../config/database';
import { jwtConfig } from '../config/jwt';
import { User, UserInput } from '../models/User';

export class AuthService {
  async registerUser(input: UserInput): Promise<User> {
    const hashedPassword = await bcrypt.hash(input.password, 10);
    
    const result = await pool.query(
      `INSERT INTO users (email, password_hash, full_name, role, division_id, phone_number)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING id, email, full_name, role, division_id, phone_number, is_active, mfa_enabled, created_at, updated_at`,
      [input.email, hashedPassword, input.full_name, input.role || 'field_staff', input.division_id, input.phone_number]
    );
    
    return result.rows[0];
  }

  async loginUser(email: string, password: string): Promise<{ user: User; token: string }> {
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    
    if (result.rows.length === 0) {
      throw new Error('User not found');
    }
    
    const user = result.rows[0];
    const validPassword = await bcrypt.compare(password, user.password_hash);
    
    if (!validPassword) {
      throw new Error('Invalid password');
    }
    
    const token = jwt.encode(
      {
        id: user.id,
        email: user.email,
        role: user.role,
        division_id: user.division_id,
      },
      jwtConfig.secret,
      jwtConfig.accessTokenExpiry
    );
    
    // Update last login
    await pool.query('UPDATE users SET last_login = NOW() WHERE id = $1', [user.id]);
    
    return { user, token };
  }

  async getUserById(id: string): Promise<User> {
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      throw new Error('User not found');
    }
    
    return result.rows[0];
  }
}
