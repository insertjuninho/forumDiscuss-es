import { bearerAuth } from "hono/bearer-auth";
import { config } from "dotenv";
import { fetchBearerTokenFromAuthServer } from "../helpers/Auth";

config();

export const verifyAuthenticatedUser = bearerAuth({ verifyToken: async (token, c) => {
    const foundKeyData = await fetchBearerTokenFromAuthServer(token);
    
    // If left value is undefined or null, it evaluates to the value on its right
    if (!!foundKeyData) {
        const parsedFoundKeyData = JSON.parse(foundKeyData);

        c.set('userID', parsedFoundKeyData.id);
        c.set('username', parsedFoundKeyData.username);
        c.set('userEmail', parsedFoundKeyData.email);
        c.set('privileges', parsedFoundKeyData.privileges);

        return true;
    } else {
        return false;
    }
}});

export const verifyAdminAuthenticated = bearerAuth({ verifyToken: async (token, c) => {
    const foundKeyData = await fetchBearerTokenFromAuthServer(token);
    
    // If left value is undefined or null, it evaluates to the value on its right
    if (!!foundKeyData) {
        const parsedFoundKeyData = JSON.parse(foundKeyData);

        if (parsedFoundKeyData.privileges === 'ADMIN') {
            return true;
        }
    }

    return false;
}});

export const verifyAdminOrModeratorAuthenticated = bearerAuth({ verifyToken: async (token, c) => {
    const foundKeyData = await fetchBearerTokenFromAuthServer(token);
    
    // If left value is undefined or null, it evaluates to the value on its right
    if (!!foundKeyData) {
        const parsedFoundKeyData = JSON.parse(foundKeyData);

        if (parsedFoundKeyData.privileges === 'ADMIN' || parsedFoundKeyData.privileges === 'MODERATOR') {
            return true;
        }
    }

    return false;
}});