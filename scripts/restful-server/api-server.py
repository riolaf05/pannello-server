from flask import Flask, Response, request
import subprocess
import os

app = Flask(__name__)

@app.route('/camera', methods = ['GET', 'POST', 'DELETE'])
def camera():
    if request.method == 'GET':
        """return the information for <user_id>"""

    if request.method == 'POST':
        #process = subprocess.run(['/bin/sh', '-c', './command.sh'], stdout=subprocess.PIPE, stderr=subprocess.PIPE) #See: https://janakiev.com/blog/python-shell-commands/
        """modify/update the information for <user_id>"""
        # you can use <user_id>, which is a str but could
        # changed to be int or whatever you want, along
        # with your lxml knowledge to make the required
        # changes
        data = request.data
        if data == b'true':
            print("exec command..")
        return Response(response="command complete!", status=200)

@app.route('/motion_sensor', methods = ['GET', 'POST', 'DELETE'])
def motion_sensor():
    if request.method == 'GET':
        """return the information for <user_id>"""

    if request.method == 'POST':
        """modify/update the information for <user_id>"""
        # you can use <user_id>, which is a str but could
        # changed to be int or whatever you want, along
        # with your lxml knowledge to make the required
        # changes
        data = request.data
        if data == b'true':
            print("exec command..")
        return Response(response="command complete!", status=200)

@app.route('/light', methods = ['GET', 'POST', 'DELETE'])
def light():
    if request.method == 'GET':
        """return the information for <user_id>"""

    if request.method == 'POST':
        """modify/update the information for <user_id>"""
        # you can use <user_id>, which is a str but could
        # changed to be int or whatever you want, along
        # with your lxml knowledge to make the required
        # changes
        data = request.data
        if data == b'true':
            print("exec command..")
        return Response(response="command complete!", status=200)

@app.route('/restart_minidlna', methods = ['GET', 'POST', 'DELETE'])
def restart_minidlna():
    if request.method == 'GET':
        """return the information for <user_id>"""

    if request.method == 'POST':
        """modify/update the information for <user_id>"""
        # you can use <user_id>, which is a str but could
        # changed to be int or whatever you want, along
        # with your lxml knowledge to make the required
        # changes
        data = request.data
        if data == b'true':
            print("exec command..")
        return Response(response="command complete!", status=200)


@app.route('/temperature', methods = ['GET'])
def temperature():
    if request.method == 'GET':
        stream = os.popen("/opt/vc/bin/vcgencmd measure_temp | sed 's/[^0-9|\.]*//g'")
        output = stream.read()
    return Response(response=output[:-1], status=200)



@app.route('/memory', methods = ['GET'])
def memory():
    if request.method == 'GET':
        stream = os.popen("df -h / | awk '{ print $2 }' | tail -n 1 | sed 's/[^0-9|\,]*//g'")
        output = stream.read()
    return Response(response=output[:-1], status=200)



@app.route('/harddisk', methods = ['GET'])
def harddisk():
    if request.method == 'GET':
        stream = os.popen("df -h /dev/sda1 | awk '{ print $2 }' | tail -n 1 | sed 's/[^0-9|\,]*//g'")
        output = stream.read()
    return Response(response=output[:-1], status=200)


if __name__ == '__main__':
     app.run(host='0.0.0.0', port='5002')