const express = require('express');
const mongoose = require('mongoose');
const redis = require('redis');

//connect to mongodb
const DB_USER = 'root';
const DB_PASSWORD = 'example';
const DB_PORT = '27017';
const DB_HOST = 'mongo'; //  mongo is the name of the service in the docker-compose file
URI = `mongodb://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}`;
mongoose.connect(URI).then(() => {
  console.log('Connected to MongoDB');
}).catch(err => {
  console.log('Failed to connect to MongoDB', err);
});

// connect to redis
const REDIS_PORT = 6379;
const REDIS_HOST = 'redis';
const redisclient = redis.createClient({
 
  url: `redis://${REDIS_HOST}:${REDIS_PORT}`

});
redisclient.on('error', err => console.log('Redis Client Error', err));
redisclient.on('connect', () => console.log('connected to redis'));
redisclient.connect();



//connect to postgresql
const pg = require('pg')
const { Pool, Client } = pg
const POSTGRES_DB_USER = 'root';
const POSTGRES_DB_PASSWORD = 'example'; 
const POSTGRES_DB_PORT = '5432';
const POSTGRES_DB_HOST = 'postgres'; 
const POSTGRES_URI = `postgresql://${POSTGRES_DB_USER}:${POSTGRES_DB_PASSWORD}@${POSTGRES_DB_HOST}:${POSTGRES_DB_PORT}`;
const client = new Client({
  connectionString:POSTGRES_URI,
})
client
.connect()
.then(() => console.log('connected to postgresql'))
.catch(err => console.error('connection error to postgres', err));




//init express 
const PORT = process.env.PORT|| 4000;
const app = express();



app.get('/', (req, res) => { 
  redisclient.set('name', 'Ahmed');
  res.send('Hello World! with watch tower ');


});


app.get('/data', async(req, res) => { 
  const name = await redisclient.get('name');
  res.send(`Hello ${name}!`);


});
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});