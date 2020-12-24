import { Connection, QueryOptions } from "mysql";
const mysql = require('mysql');

export class Database {
    connection: Connection;

    constructor() {
        this.connection = mysql.createConnection({
            host: "localhost",
            user: "fssu-api",
            password: "Thoughtseize",
            database: "fssu"
        });
    }


    query(options: string | QueryOptions, values?: unknown): Promise<any[]>
    {
        return new Promise((resolve, reject) => {
            this.connection.query(options, values, (error, rows) => {
                if (error)
                    return reject(error);
                resolve(rows);
            });
        });
    }

    close()
    {
        return new Promise((resolve, reject) => {
            this.connection.end(error => {
                if (error)
                    return reject(error);
                resolve(null);
            });
        });
    }
}

const database = new Database();
export default database;