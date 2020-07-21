#!/usr/bin/env node

const http = require('http');

const HOST = '127.0.0.1';
const PORT = 10000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World from NodeJS App');
});

server.listen(PORT, HOST, () => {
  console.log(`[+] Server running at http://${HOST}:${PORT}/`);
});