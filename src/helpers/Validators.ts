import { validator } from "hono/validator";
import { reactionTypes } from "../config";

export const jsonDiscussionValidator = validator('json', (value, c) => {
    const title = value['title'];
    const message = value['message'];
    const group_id = value['group_id'];
    
    if (!title || typeof title !== 'string') {
        return c.text('Missing field \'title\'', 400);
    }
    
    if (!message || typeof message !== 'string') {
        return c.text('Missing field \'message\'', 400);
    }
    
    if (!group_id || typeof group_id !== 'string') {
        return c.text('Missing field \'group_id\'', 400);
    }

    return {
        requestBody: value
    }
});

export const jsonDiscussionPostValidator = validator('json', (value, c) => {
    const message = value['message'];
    const postID = value['postID'];

    if (!message || typeof message !== 'string') {
        return c.text('Missing field \'message\'', 400)
    }
    
    if (!postID || typeof postID !== 'string') {
        return c.text('Missing field \'postID\'', 400)
    }

    return {
        requestBody: value
    }
});

// This validator assumes user is already logged in on route
export const jsonReactionValidator = validator('json',(value, c) => {
    const postID = value['post_id'];
    const reaction = value['reaction'];

    if (!postID || typeof postID !== 'string') {
        return c.text('Missing field \'post_id\'', 400);
    }
    if (!reaction || typeof reaction !== 'string') {
        return c.text('Missing field \'reaction\'', 400);
    }

    if (reactionTypes.indexOf(reaction) === -1) {
        return c.text('\'reaction\' not supported', 400);
    }

    return {
        requestBody: value
    }
});