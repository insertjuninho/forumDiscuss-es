import { serve } from '@hono/node-server';
import { Hono } from 'hono';
import { config } from 'dotenv';
import { verifyAuthenticatedUser } from './middlewares/Auth';
import { AuthRouter } from './controllers/auth';
import { app as DiscussionsRouter } from './controllers/discussions';
import { app as UsersRouter } from './controllers/users';
import { app as GroupsRouter } from './controllers/groups';

config();

type HonoVariables = {
  userID: number;
  userEmail: string;
  username: string;
}

const app = new Hono<{ Variables: HonoVariables}>();

app.notFound((c) => {
  return c.text('Resource not found', 404);
});

app.get('/', verifyAuthenticatedUser, (c) => {
  return c.text(`Hello ${c.get('username')}!`);
});

app.route('/auth', AuthRouter);
app.route('/posts', DiscussionsRouter);
app.route('/users', UsersRouter);
app.route('/groups', GroupsRouter);

const port = Number(process.env.ENGINE_PORT) || 3000;

serve({
  fetch: app.fetch,
  port
});

console.log(`Server is running on port ${port}`);