#!/usr/bin/env python3

import http.server
import socketserver

HOST = '127.0.0.1'
PORT = 11000

Handler = http.server.SimpleHTTPRequestHandler

httpd = socketserver.TCPServer(("", PORT), Handler)

print(f"[+] Server running at http://{HOST}:{PORT}/")

httpd.serve_forever()