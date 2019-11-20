from flask import Flask, render_template, redirect
import requests
import json
from flask_restful import Resource, Api
import subprocess

app = Flask(__name__)
api = Api(app)

class Camera(Resource):
    def get(self, command):
        if command == 'on':
            rc = subprocess.call("/home/pi/Scripts/motion-start.sh")
            return redirect("http://riohomecloud.ddns.net/pannello_controllo/server_status.php", code=302)
        else:
            rc = subprocess.call("/home/pi/Scripts/motion-stop.sh")
            return redirect("http://riohomecloud.ddns.net/pannello_controllo/server_status.php", code=302)

class Docker(Resource):
    def get(self):
        rc = subprocess.call("/home/pi/Scripts/minidlna-restart.sh")
        return redirect("http://riohomecloud.ddns.net/pannello_controllo/server_status.php", code=302)

api.add_resource(Camera, '/camera/<command>') # Route_1
api.add_resource(Docker, '/minidlna') # Route_2

if __name__ == '__main__':
     app.run(host='0.0.0.0', port='5002')