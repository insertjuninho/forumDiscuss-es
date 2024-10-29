import { Hono } from "hono";
import { authenticateUser, registerUser, UserData } from "../helpers/Auth";

type Variables = {
    isUserAuthenticated: Boolean,
    userBearerToken: string
}

export const AuthRouter = new Hono<{ Variables: Variables}>();

AuthRouter.post('/', authenticateUser, (c, next) => {
    const isUserAuthenticated = c.get('isUserAuthenticated') === true;
    const bearerToken = c.get('userBearerToken');

    if (isUserAuthenticated) {
        return c.text('Bearer ' + bearerToken);
    } else {
        return c.text('Auth failed', 401);
    }
});

AuthRouter.post('/register', async (c) => {
    let userData;
    try {
        userData = await c.req.json();
    } catch (e) {
        console.debug(e);
        return c.text('Request processing failed', 400);
    }

    if (typeof userData.username === 'undefined' || userData.password === 'undefined' ) {
        return c.text('User credentials not provided', 400);
    }

    const userCredentials: UserData = {
        email: userData.email,
        username: userData.username,
        password: userData.password
    }

    let registrationResult;
    try {
        registrationResult = await registerUser(userCredentials);
    } catch (e: any) {
        if (typeof e.detiail !== 'undefined') {
            return c.text('Error registering user. ' + e.detail, 400);
        }
    }

    if (typeof registrationResult.severity !== 'undefined' && registrationResult.severity === 'ERROR') {
        return c.text('Error registering user. ' + registrationResult.detail, 400);
    }

    return c.text('Registration successful');
});