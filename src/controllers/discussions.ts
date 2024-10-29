import { deletePostLogically, deletePostResponseLogically, DiscussionData, DiscussionPostData, fetchPostResponse, getPost, getPostResponses, getReactionData, GroupData, modifyPostResponse, ReactionData, removeReaction, uploadDiscussion, uploadDiscussionPost, uploadNewGroup, uploadReaction } from "../helpers/DBHelpers";
import { Hono } from "hono";
import { jsonDiscussionPostValidator, jsonDiscussionValidator, jsonReactionValidator } from "../helpers/Validators";
import { verifyAdminAuthenticated, verifyAuthenticatedUser } from "../middlewares/Auth";

type HonoVariables = {
    userID: number;
    userEmail: string;
    username: string;
    privileges: string;
  }

export const app = new Hono<{ Variables: HonoVariables }>();

app.get('/getPost/:id', async (c) => {
    const postID = Number(c.req.param('id'));

    try {
        const fetchResponse = await getPost(postID);

        if (!!fetchResponse && fetchResponse.length > 0) {
            const postResponses = await getPostResponses(postID);
            const responseWithMessages = {...fetchResponse[0], responses: postResponses.length > 0 ? postResponses : []}
            return c.json(responseWithMessages);
        } else {
            return c.text('Post not found', 404);
        }
    } catch (e) {
        return c.text('Fetch could not be completed', 500);
    }
});

app.post('/createPost', verifyAuthenticatedUser,jsonDiscussionValidator, async (c) => {
    const { requestBody } = c.req.valid('json');

    const discussionData: DiscussionData = {
        groupID: requestBody.group_id,
        title: requestBody.title,
        message: requestBody.message,
        ownerID: Number(c.get('userID'))
    }

    const uploadResult = await uploadDiscussion(discussionData);
    
    return c.json(uploadResult, 200);
});

app.get('/postResponses/:postID', async (c) => {
    const postID = Number(c.req.param('postID'));

    const postResponses = await getPostResponses(postID);

    return c.json(postResponses || []);
});

app.patch('/modifyPostResponse', verifyAuthenticatedUser, jsonDiscussionPostValidator, async (c) => {
    const { requestBody } = c.req.valid('json');

    const postResponseData = await fetchPostResponse(requestBody.postID);

    let result;
    if (
        (!!postResponseData && postResponseData.length > 0 && postResponseData[0].user_id === Number(c.get('userID'))) ||
        (c.get('privileges') === 'MODERATOR' || c.get('privileges') === 'ADMIN')
    ) {
        result = modifyPostResponse(Number(requestBody.postID), requestBody.message);

        return c.json(result);
    } else {
        return c.text('Post not found', 404);
    }

});

app.post('/createPostResponse', verifyAuthenticatedUser, jsonDiscussionPostValidator, async(c) => {
    const { requestBody } = c.req.valid('json');

    const discussionData: DiscussionPostData = {
        postID: requestBody.postID,
        ownerID: 9,
        message: requestBody.message
    }

    const uploadResult = await uploadDiscussionPost(discussionData);

    return c.json(uploadResult, 200);
});

app.delete('/deletePostResponse/:postID', verifyAuthenticatedUser, async (c) => {
    const postID = Number(c.req.param('postID'));
    const postResponseData = await fetchPostResponse(postID);

    let result;
    if (
        (!!postResponseData && postResponseData.length > 0 && postResponseData[0].user_id === Number(c.get('userID'))) ||
        (c.get('privileges') === 'MODERATOR' || c.get('privileges') === 'ADMIN')
    ) {
        result = deletePostResponseLogically(postID);

        return c.json(result);
    } else {
        return c.text('Post not found', 404);
    }
});

app.delete('/deletePost/:postID', verifyAuthenticatedUser, async (c) => {
    const postID = Number(c.req.param('postID'));
    const postResponseData = await fetchPostResponse(postID);

    let result;
    if (
        (!!postResponseData && postResponseData.length > 0 && postResponseData[0].user_id === Number(c.get('userID'))) ||
        (c.get('privileges') === 'MODERATOR' || c.get('privileges') === 'ADMIN')
    ) {
        result = deletePostLogically(postID);

        return c.json(result);
    } else {
        return c.text('Post not found', 404);
    }
});

app.post('/uploadReaction', verifyAuthenticatedUser, jsonReactionValidator, async (c) => {
    const { requestBody } = c.req.valid('json');
    const userID = c.get('userID');

    const reactionData: ReactionData = {
        postID: Number(requestBody['post_id']),
        userID: userID,
        reaction: requestBody.reaction
    }

    let uploadResult;
    try {
        uploadResult = await uploadReaction(reactionData);
    } catch (e) {
        console.debug(e);
        c.text('Error uploading reaction.', 500);
    }

    return c.json(uploadResult);
});

app.delete('/removeReaction/:reactionID', verifyAuthenticatedUser, async (c) => {
    const reactionID = Number(c.req.param('reactionID'));
    const reactData = await getReactionData(reactionID)

    if (
        (!!reactData && reactData.length > 0 && reactData[0].user_id === Number(c.get('userID'))) ||
        (c.get('privileges') === 'MODERATOR' || c.get('privileges') === 'ADMIN')) {
        try {
            const removeResult = await removeReaction(reactionID);

            if (!!removeResult) {
                return c.json(removeResult)
            } else {
                return c.text('Reaction not found', 404);
            }
        } catch (e) {
            console.debug(e);
            return c.text('Error trying to delete reaction', 500);
        }
    } else {
        return c.text('Reaction does not exist', 404);
    }
});