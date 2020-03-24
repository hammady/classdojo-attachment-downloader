FROM python:3.8.2

WORKDIR /home

ENV PYTHONPATH /home

RUN curl -o jq -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod u+x jq && \
    mv jq /usr/local/bin/

RUN pip3 install --upgrade pip

COPY requirements.txt /home

RUN pip3 install -r requirements.txt

COPY . /home

VOLUME [ "/feeds", "/downloads" ]
