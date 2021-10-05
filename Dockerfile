FROM python:3.8-alpine

#set work directory
WORKDIR /app

#set environment variables
#Prevents Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE 1
#Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0


#install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

#copy entrypoint.sh and make it executable
#COPY ./entrypoint.sh .
#RUN chmod +x entrypoint.sh

# copy project
COPY . .

#run entrypoint.sh
#ENTRYPOINT [ "/app/entrypoint.prod.sh" ]

#comment out since we are now using docker compose to with postgres service to build the image
#collect static files
RUN python manage.py collectstatic --noinput

RUN adduser -D myuser
USER myuser

# run gunicorn  Gunicorn 'Green Unicorn' is a Python WSGI HTTP Server for UNIX. It's a pre-fork worker model. 
CMD gunicorn Comrades-housing.wsgi --bind 0.0.0.0:$PORT
