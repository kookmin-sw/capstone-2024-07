FROM python:3.9-bookworm

ADD . /app
WORKDIR /app

RUN python -m venv venv
RUN venv/bin/pip install --upgrade pip
RUN venv/bin/pip install -r requirements.txt

CMD . venv/bin/activate && uvicorn check_api:app --reload --host 0.0.0.0 --port 8000