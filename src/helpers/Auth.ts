import { basicAuth } from "hono/basic-auth";
import { fetchUserAuthData, uploadNewUser } from "./DBHelpers";
import { compare } from "bcrypt";
import { hashSync } from "bcrypt";
import { config } from "dotenv";
import { createClient } from "redis";
import { v4 as uuidv4 } from "uuid";

config();

export interface UserData {
    email: string,
    username: string,
    password: string
}

export async function fetchBearerTokenFromAuthServer (bearerToken: string) {
    const redisUser = process.env.REDIS_USERNAME;
    const redisPassword = process.env.REDIS_PASSWORD;
    const redisHostname = process.env.REDIS_HOSTNAME;
    const redisPort = process.env.REDIS_PORT;
    
    const client = await createClient({
        url: 'redis://' + (redisUser ? redisUser + ':' + redisPassword + '@' : '') + redisHostname + ':' + redisPort
    })
    .on('error', err => console.debug(err))
    .connect();
    
    const foundKey = await client.get(bearerToken);
    
    return foundKey;
}

export async function uploadBearerTokenToAuthServer (key: string, value: string) {
    const redisUser = process.env.REDIS_USERNAME;
    const redisPassword = process.env.REDIS_PASSWORD;
    const redisHostname = process.env.REDIS_HOSTNAME;
    const redisPort = process.env.REDIS_PORT;
    const redisBearerLifetime = process.env.REDIS_BEARER_TOKEN_LIFETIME;

    const redisURL = 'redis://' + (redisUser ? redisUser + ':' + redisPassword + '@' : '') + redisHostname + ':' + redisPort;

    const client = await createClient({
        url: 'redis://' + (redisUser ? redisUser + ':' + redisPassword + '@' : '') + redisHostname + ':' + redisPort
    })
        .on('error', err => console.debug(err))
        .connect();
    
    client.set(key, value);
    client.expire(key, Number(redisBearerLifetime));
}

/**
 * Authenticates an user generating its bearer token
 */
export const authenticateUser = basicAuth({verifyUser: async (username, password, c) => {
    let userAuthenticated = false;
    const userFetchedData = await fetchUserAuthData(username);

    try {
        let comparisonResult;
        if (userFetchedData.length > 0) {
            comparisonResult = await compare(password, userFetchedData[0].password);
            userAuthenticated = comparisonResult;

            
            const bearerData = {
                id: userFetchedData[0].id,
                email: userFetchedData[0].email,
                username: userFetchedData[0].username,
                privileges: userFetchedData[0].privileges
            }
            
            const bearerToken = uuidv4();
            
            c.set('isUserAuthenticated', true);
            c.set('userBearerToken', bearerToken);

            uploadBearerTokenToAuthServer(bearerToken, JSON.stringify(bearerData));
        }
    } catch (e) {
        console.debug(e);
        return false;
    }

    return userAuthenticated;
}});

export async function registerUser(credentials: UserData) {
    const hashedUserPassword = hashSync(credentials.password, Number(process.env.ENGINE_SALT_ROUNDS) || 12);

    const dataToUpload = {
        username: credentials.username,
        email: credentials.email,
        password: hashedUserPassword
    };

    const uploadResult = await uploadNewUser(dataToUpload);

    return uploadResult;
}