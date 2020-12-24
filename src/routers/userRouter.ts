import express from 'express';
import UserController from '../controllers/userController';

module.exports = function(app: express.Application) {
    var userController = new UserController();

    app.route('/user/')
    .post(userController.authenticateToken, userController.getLogin);

    app.route('/login/')
    .post(userController.loginUser);
}