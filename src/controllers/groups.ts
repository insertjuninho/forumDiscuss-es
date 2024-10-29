import { Hono } from "hono";
import { verifyAdminAuthenticated, verifyAuthenticatedUser } from "../middlewares/Auth";
import { GroupData, listGroupPostings, listGroups, uploadNewGroup } from "../helpers/DBHelpers";

type HonoVariables = {
    userID: number;
    userEmail: string;
    username: string;
    privileges: string;
  }

export const app = new Hono<{ Variables: HonoVariables}>();

// Only admins can create new discussion groups
app.post('/createGroup/:groupName', verifyAdminAuthenticated, verifyAuthenticatedUser, async (c) => {
    const groupName = c.req.param('groupName');
    console.log(Number(c.get('userID')));

    const groupData: GroupData = {
        name: groupName,
        creatorID: Number(c.get('userID'))
    }

    try {
        const uploadResult = await uploadNewGroup(groupData);
        console.debug(uploadResult);
        
        return c.json(uploadResult);
    } catch (e) {
        return c.text('Failed creating group', 500);
    }
});

app.get('/listGroups', async (c) => {
    try {
        const groupsSearchResult = await listGroups();

        return c.json(groupsSearchResult);
    } catch (e) {
        console.debug(e);
        return c.text('Search on groups failed', 500);
    }
});

app.get('/listGroupPostings/:groupID', async (c) => {
    const groupID: number = Number(c.req.param('groupID'));
    try {
        const searchResult = await listGroupPostings(groupID);

        return c.json(searchResult);
    } catch (e) {
        console.debug(e);
        return c.text('Search on list group messages failed', 500);
    }
});