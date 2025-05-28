@echo off
CALL C:\Users\kim\Desktop\clone\shrimplake-core\team5env\Scripts\activate
cd /d C:\Users\kim\Desktop\clone\shrimplake-core\flask-dashboard-tabler
SET FLASK_APP=run.py
SET FLASK_DEBUG=true
flask run

