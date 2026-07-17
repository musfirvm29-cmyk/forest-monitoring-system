import express, { Request, Response } from 'express';
import { AuthService } from '../services/authService';

const router = express.Router();
const authService = new AuthService();

// Register
router.post('/register', async (req: Request, res: Response) => {
  try {
    const user = await authService.registerUser(req.body);
    res.status(201).json({ success: true, user });
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});

// Login
router.post('/login', async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    const result = await authService.loginUser(email, password);
    res.json({ success: true, ...result });
  } catch (error: any) {
    res.status(401).json({ error: error.message });
  }
});

export default router;
