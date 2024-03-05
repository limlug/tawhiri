# -------------------------
# The build container
# -------------------------
FROM python:3.11-alpine as build
RUN apk update && \
  apk add build-base \
    py3-cffi \
    libffi-dev \
    unzip

RUN mkdir /build

COPY ./tawhiri /build/tawhiri
COPY README.md /build/README.md
COPY setup.cfg /build/setup.cfg
COPY MANIFEST.in /build/MANIFEST.in
COPY LICENCE /build/LICENCE
COPY AUTHORS /build/AUTHORS
COPY docs /build/docs
COPY requirements.txt /build/requirements.txt
COPY setup.py /build/setup.py

WORKDIR /build/
RUN  pip install --no-warn-script-location --ignore-installed -r requirements.txt
RUN mkdir /build/wheels
RUN pip wheel . -w /build/wheels
RUN pip wheel magicmemoryview -w /build/wheels


# -------------------------
# The build container
# -------------------------
FROM python:3.11-alpine
RUN mkdir /wheels
COPY --from=build /build/wheels /wheels
RUN pip install /wheels/*.whl
RUN pip install gunicorn gevent eventlet requests loguru python-dateutil
RUN mkdir /app
WORKDIR /app    
COPY tawhiri_api.py /app/tawhiri_api.py

CMD python3 -m gunicorn -b 0.0.0.0:8000 --worker-class gevent -w 12 tawhiri_api:app
