import { Database } from './database';

export default class UserModel
{
    database: Database;

    constructor(database: Database)
    {
        this.database = database;
    }

    getLoginWithoutGroupById(id: number): Promise<Login | null>
    {
        return this.database.query('SELECT * FROM login WHERE id = ?', id)
        .then(logins => {
            return Login.createFromObject(logins[0]);
        })
        .catch(error => {
            console.log(error);
            return null;
        });
    }

    getLoginWithoutGroupByEmail(email: string): Promise<Login | null>
    {
        return this.database.query('SELECT * FROM login WHERE email = ?', email)
        .then(logins => {
            return Login.createFromObject(logins[0]);
        })
        .catch(error => {
            console.log(error);
            return null;
        });
    }

    getLoginGroups(login: Login): Promise<Group[]>
    {
        return this.database.query('SELECT group.name, group.id FROM "group" INNER JOIN login_group ON group.id = group_id WHERE login_id = ?', login.id)
        .then(groups => {
            var output = new Array<Group>();
            groups.forEach(group => output.push(Group.createFromObject(group)));
            return output;
        })
        .catch(error => {
            console.log(error);
            return new Array<Group>();
        });
    }

    async getLoginByEmail(email: string): Promise<Login | null>
    {
        var login = await this.getLoginWithoutGroupByEmail(email);
        if (login == null)
            return null;
        login.groups = await this.getLoginGroups(login);
        return login;
    }

    async getLoginById(id: number): Promise<Login | null>
    {
        var login = await this.getLoginWithoutGroupById(id);
        if (login == null)
            return null;
        login.groups = await this.getLoginGroups(login);
        return login;
    }

    async getRefreshTokenById(id: number): Promise<RefreshToken | null>
    {
        return this.database.query('SELECT * FROM refresh_token WHERE "login_id" = ?', id)
        .then(tokens => {
            let token = tokens[0];
            token.loginId = token.login_id;
            token.expires = this.database.dateTimeToDate(token.expires);
            return RefreshToken.createFromObject(token);
        })
        .catch(error => {
            console.log(error);
            return null;
        });
    }

    async setRefreshToken(token: RefreshToken): Promise<number | null>
    {
        return this.database.query('CALL set_refresh_token (?, ?, ?)', [ token.loginId, token.value, this.database.dateToDateTime(token.expires) ])
        .then(output => { 
            return output[0][0].login_id;
        })
        .catch(error => {
            console.log(error);
            return null;
        });
    }

    async resetRefreshToken(oldValue: string, newValue: string, expires: Date): Promise<number | null>
    {
        return this.database.query('CALL reset_refresh_token (?, ?, ?)', [ oldValue, newValue, this.database.dateToDateTime(expires) ])
        .then(output => {
            return output[0][0].login_id;
        })
        .catch(error => {
            console.log(error);
            return null;
        });
    }

    async deleteRefreshToken(loginId: number): Promise<boolean>
    {
        return this.database.query('DELETE FROM refresh_token WHERE login_id = ?', [ loginId ])
        .then(output => {
            return true;
        })
        .catch(error => {
            console.log(error);
            return false;
        });
    }
}

export class RefreshToken
{
    loginId: number;
    value: string;
    expires: Date;

    constructor(loginId: number, value: string, expires: Date)
    {
        this.loginId = loginId;
        this.value = value;
        this.expires = expires;
    }

    static createFromObject(object: any)
    {
        return new RefreshToken(object.loginId, object.value, object.expires);
    }
}

export class Login
{
    id: number;
    email: string;
    password: string;
    groups: Group[];

    constructor(id: number, email: string, password: string, groups: Group[] | null = [])
    {
        this.id = id;
        this.email = email;
        this.password = password;
        this.groups = groups != null ? groups : [];
    }

    static createFromObject(object: any)
    {
        return new Login(object.id, object.email, object.password, object.groups);
    }

    isInGroup(groupId: number): boolean
    {
        return this.groups.find(group => group.id === groupId) !== undefined;
    }
}

export class Group
{
    id: number;
    name: string;

    constructor(id: number, name: string)
    {
        this.id = id;
        this.name = name;
    }

    static createFromObject(object: any)
    {
        return new Group(object.id, object.name);
    }
}