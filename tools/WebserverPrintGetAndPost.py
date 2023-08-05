#!/usr/bin/env python3
"""
Very simple HTTP server in python for showing and logging requests
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
import logging
import argparse
import sys

class S(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        logging.info("GET request,\nPath: %s\nHeaders:\n%s\n", str(self.path), str(self.headers))
        self._set_response()
        self.wfile.write("GET request for {}".format(self.path).encode('utf-8'))

    def do_POST(self):
        content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
        post_data = self.rfile.read(content_length) # <--- Gets the data itself
        logging.info("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                str(self.path), str(self.headers), post_data.decode('utf-8'))

        self._set_response()
        self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))

def run(server_class=HTTPServer, handler_class=S):
    logging.basicConfig(level=logging.INFO, filename=args.filename, format='%(message)s')
    if args.filename != None:
        logging.getLogger().addHandler(logging.StreamHandler(sys.stdout))

    server_address = ('', args.port)
    httpd = server_class(server_address, handler_class)
    logging.info('Starting httpd...')
    logging.info('Listening on port: %s' % args.port)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    logging.info('Stopping httpd...')

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Very simple HTTP server in python for logging requests")
    parser.add_argument('-p', dest='port', type=int, default='8080',
                        help='Port to listen on (default: 8080)')
    parser.add_argument('-f', dest='filename', type=str, default=None,
                        help='File to store output in. (default: disabled)')

    args = parser.parse_args()
    run()
