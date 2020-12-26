import express from 'express';
import UserModel from '../models/userModel';
import { RefreshToken } from '../models/userModel';
import database from '../models/database';
import { TOKEN_SECRET, REFRESH_TOKEN_EXPIRES_DAYS } from '../config';

var jwt = require('jsonwebtoken');

function generateAccessToken(id: number): string
{
    return jwt.sign({ id }, TOKEN_SECRET, { expiresIn: 1024 });
}

function generateRefreshToken(): string
{
    var crypto = require("crypto");
    return crypto.randomBytes(32).toString('hex');
}

async function resetRefreshToken(request: express.Request, expires: Date): Promise<[ number, string ]>
{
    var oldRefreshToken = request.signedCookies.refreshToken;
    if (oldRefreshToken == null)
        throw Error('Refresh token is not set.');

    var newRefreshToken = generateRefreshToken();
    
    var userModel = new UserModel(database);
    var loginId = await userModel.resetRefreshToken(oldRefreshToken, newRefreshToken, expires);
    if (loginId == null)
        throw Error('Refresh token is not valid.');

    return [ loginId, newRefreshToken ];
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
            return response.json({
                ok: false,
                error: 'Invalid email or password.'
            });
        }

        if (login.password !== request.body['password']) {
            return response.json({
                ok: false,
                error: 'Invalid email or password.'
            });
        }
        
        let expires = new Date();
        expires.setDate(expires.getDate() + REFRESH_TOKEN_EXPIRES_DAYS)
        let refreshToken = new RefreshToken(login.id, generateRefreshToken(), expires)

        let loginId = await userModel.setRefreshToken(refreshToken);
        if (loginId == null)
            return response.json({
                ok: false,
                error: 'Refresh token could not been set.'
            });

        response.cookie('refreshToken', refreshToken.value, {
            signed: true,
            httpOnly: true,
            expires
        });
        response.json({ok: true});
    }

    async logoutUser(request: express.Request, response: express.Response)
    {
        const userModel = new UserModel(database);
        const loginId = request.body['loginId'];

        const result = await userModel.deleteRefreshToken(loginId);
        if (!result)
            return response.json({
                ok: false,
                error: 'Refresh token could not been deleted.'
            })
        
        
        response.clearCookie('refreshToken');
        response.json({ok: true});
    }

    authenticateToken(request: express.Request, response: express.Response, next: express.NextFunction)
    {
        const authorizationHeader = request.headers['authorization'];
        const token = authorizationHeader && authorizationHeader.split(' ')[1];
        if (token == null)
            return response.sendStatus(401);

        jwt.verify(token, TOKEN_SECRET as string, (error: Error, tokenData: any) => {
            if (error) {
                console.log(error);
                return response.sendStatus(403);
            }

            request.body['loginId'] = tokenData.id;
            next();
        })
    }

    async refreshToken(request: express.Request, response: express.Response)
    {
        var expires = new Date();
        expires.setDate(expires.getDate() + REFRESH_TOKEN_EXPIRES_DAYS)

        try {
            var [loginId, newRefreshToken] = await resetRefreshToken(request, expires);
        }
        catch (error) {
            response.json({
                ok: false,
                error: error.message
            });
            return;
        }

        var newJWT = generateAccessToken(loginId);

        response.cookie('refreshToken', newRefreshToken, {
            signed: true,
            httpOnly: true,
            expires
        });

        response.json({
            ok: true,
            token: newJWT
        });
    }
}