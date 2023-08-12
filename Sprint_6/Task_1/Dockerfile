FROM python:3

ENV FLASK_APP=home.py
ENV FLASK_RUN_HOST=0.0.0.0

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 8081

CMD ["flask", "run"]