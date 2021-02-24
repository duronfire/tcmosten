from http.server import BaseHTTPRequestHandler,HTTPServer
#import check_olstatus
import time
_host="localhost"
_port=8000
 
class myHandler(BaseHTTPRequestHandler):
  def do_GET(self):
 
    if self.path == "/check":
 
      self.send_response(200)
      self.send_header("Content-type","text/plain")
      self.end_headers()
 
      print("check ol activities")
#       if check_olstatus.check_syncrun(10):
#        self.wfile.write("True".encode("utf-8"))
#      else:
#        self.wfile.write("False".encode("utf-8"))
 
    elif self.path == "/sync":
 
      self.send_response(200)
      self.send_header("Content-type","text/plain")
      self.end_headers()
 
      print("start sync")
      print("do sync")
      statexxx = run_sync
      self.wfile.write("statexxx".encode("utf-8"))
 
      
    else:
      self.send_response(404)
      self.send_header("Content-type","text/plain")
      self.end_headers()
      self.wfile.write("Error: 404".encode("utf-8"))
 
 
if __name__ == "__main__":
  print("Run")
  webServer = HTTPServer((_host,_port),myHandler)
  try:
    webServer.serve_forever()
  except KeyboardInterrupt:
    pass
  finally:
    print("Exit HTTPServer")
    webServer.server_close()

