FROM python:3.14-alpine

RUN addgroup -S app && adduser -S app -G app

WORKDIR /home/app/web

COPY requirements.txt /
RUN pip install -r /requirements.txt

COPY --chown=app:app pyproject.toml ./
COPY --chown=app:app uv.lock ./

RUN uv sync

RUN chown -R app:app /home/app

COPY --chown=app:app . .

RUN mkdir -p /certs

USER app

RUN mkdir -p db

RUN uv run manage.py collectstatic --noinput --clear

EXPOSE 5001

ENTRYPOINT ["uv run granian"]
CMD ["--interface", "wsgi", "algebra_api.wsgi"]
