import { Database } from './database';

export { Login };

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
            return new Login(logins[0]);
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
            return new Login(logins[0]);
        })
        .catch(error => {
            console.log(error);
            return null;
        });
    }

    getLoginGroups(login: Login): Promise<Group[]>
    {
        return this.database.query('SELECT group.name, group.id FROM `group` INNER JOIN login_group ON group.id = group_id WHERE login_id = ?', login.id)
        .then(groups => {
            var output = new Array<Group>();
            groups.forEach(group => output.push(new Group(group)));
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
}

class Login
{
    id: number;
    email: string;
    password: string;
    groups: Group[];

    constructor(object: any)
    {
        this.id = object.id;
        this.email = object.email;
        this.password = object.password;
        this.groups = [];
    }

    isInGroup(groupId: number): boolean
    {
        return this.groups.find(group => group.id === groupId) !== undefined;
    }
}

class Group
{
    id: number;
    name: string;

    constructor(object: any)
    {
        this.id = object.id;
        this.name = object.name;
    }
}