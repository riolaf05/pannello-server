from flask import Flask, Response, request

app = Flask(__name__)

@app.route('/camera', methods = ['GET', 'POST', 'DELETE'])
def camera():
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

if __name__ == '__main__':
     app.run(host='0.0.0.0', port='5002')