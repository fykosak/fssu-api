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

    dateToDateTime(date: Date): string
    {
        return date.toISOString().slice(0, 19).replace('T', ' ');
    }

    dateTimeToDate(dateTime: string): Date
    {
        var dateTimeStrings = dateTime.split(/[- :]/);
        var DTN = dateTimeStrings.map(item => parseInt(item));
        DTN[1]--;
        return new Date(DTN[0], DTN[1], DTN[2], DTN[3], DTN[4], DTN[5]);
    }
}

const database = new Database();
export default database;