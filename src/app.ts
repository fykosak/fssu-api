import express from 'express';
import cookieParser from 'cookie-parser';
import { CLIENT_ORIGIN, COOKIE_SECRET } from './config';

var cors = require('cors');

const app = express();
const port = 3200;

// Necessity for the cookies. Includes 'Access-Control-Allow-Origin' and 'Access-Control-Allow-Credentials' in the request headers.
app.use(cors({
    origin: CLIENT_ORIGIN,
    credentials: true
}));
app.use(express.json());

app.use(cookieParser(COOKIE_SECRET));

var userRouter = require('./routers/userRouter');
userRouter(app);

app.listen(port, function() {
    console.log(`server is listening on ${port}`);
});