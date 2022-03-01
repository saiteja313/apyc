FROM python:3.7.12-alpine3.14

WORKDIR /opt/apyc

RUN mkdir -p /opt/apyc

ADD . /opt/apyc/

RUN pip install -r requirements.txt

ENTRYPOINT [ "python", "/opt/apyc/src/app.py" ]