import express from 'express';
var cors = require('cors');

const app = express();
const port = 3200;

app.use(cors());
app.use(express.json());

app.get('/', (request, result) => {
    result.send('The sedulous hyena ate the antelope!');
});

app.get('/problems/', (request, result) => {
    //result.setHeader('Access-Control-Allow-Origin', '*');
    result.json({ problem: "Problem"});
});

var userRouter = require('./routers/userRouter');
userRouter(app);

app.listen(port, function() {
    console.log(`server is listening on ${port}`);
});