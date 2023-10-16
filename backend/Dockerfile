# BUILDER

FROM python:3.11-alpine as builder

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk add --update --no-cache gcc

RUN pip install --upgrade pip
COPY . ./api

RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r ./api/requirements.txt


# FINAL
FROM python:3.11-alpine

RUN mkdir -p /home/app
RUN addgroup -S app && adduser -S app -G app

ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
RUN mkdir -p $APP_HOME/user_files/learn_images
WORKDIR $APP_HOME

# install dependencies
COPY --from=builder /usr/src/app/wheels /wheels
COPY --from=builder /usr/src/app/api/requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache /wheels/*

# copy project
COPY . $APP_HOME

# chown all the files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app
