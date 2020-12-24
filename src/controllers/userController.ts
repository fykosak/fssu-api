import express from 'express';
import UserModel from '../models/userModel';
import database from '../models/database';

var jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
dotenv.config();

function generateAccessToken(id: number)
{
    return jwt.sign({ id }, process.env.TOKEN_SECRET, { expiresIn: 21600 });
}

export default class UserController
{
    getLogin(request: express.Request, response: express.Response)
    {
        var userModel = new UserModel(database);
        var loginId = request.body['loginId'];

        userModel.getLoginById(loginId)
        .then(login => {
            if (login == null)
                response.send({
                    ok: false,
                    error: 'Id not found.'
                });
            else
                response.send({
                    ok: true,
                    login: login
                });
        });
    }

    async loginUser(request: express.Request, response: express.Response)
    {
        const userModel = new UserModel(database);

        if (request.body == null)
            return response.sendStatus(400);
        if (!('email' in request.body))
            return response.sendStatus(400);
        if (!('password' in request.body))
            return response.sendStatus(400);

        var login = await userModel.getLoginByEmail(<string>request.body['email']);
        if (login == null) {
            response.json({
                ok: false,
                error: 'Invalid email or password'
            });
            return;
        }

        if (login.password !== request.body['password']) {
            response.json({
                ok: false,
                error: 'Invalid email or password'
            });
            return;
        }
        
        response.json({
            ok: true,
            token: generateAccessToken(login.id)
        });
    }

    authenticateToken(request: express.Request, response: express.Response, next: express.NextFunction)
    {
        const authorizationHeader = request.headers['authorization'];
        const token = authorizationHeader && authorizationHeader.split(' ')[1];
        if (token == null)
            return response.sendStatus(401);

        jwt.verify(token, process.env.TOKEN_SECRET as string, (error: Error, tokenData: any) => {
            if (error) {
                console.log(error);
                return response.sendStatus(403);
            }

            request.body['loginId'] = tokenData.id;
            next();
        })
    }
}