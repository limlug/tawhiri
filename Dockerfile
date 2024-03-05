# -------------------------
# The application container
# -------------------------
FROM python:3.11.3-slim-buster

EXPOSE 8000/tcp
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    python3-cffi \
    libffi-dev \
    unzip && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /build
RUN mkdir /app

COPY ./tawhiri /build/tawhiri
COPY README.md /build/README.md
COPY setup.cfg /build/setup.cfg
COPY MANIFEST.in /build/MANIFEST.in
COPY LICENCE /build/LICENCE
COPY AUTHORS /build/AUTHORS
COPY docs /build/docs
COPY requirements.txt /build/requirements.txt
COPY setup.py /build/setup.py
COPY tawhiri_api.py /app/tawhiri_api.py

WORKDIR /build/
RUN  pip install --no-warn-script-location --ignore-installed -r requirements.txt
RUN pip install magicmemoryview
RUN python3 setup.py build_ext --inplace
RUN pip install .
#
#RUN rm /etc/ImageMagick-6/policy.xml && \
WORKDIR /app
RUN rm -rf /build

#ENV PATH=/root/.local/bin:$PATH

CMD gunicorn -b 0.0.0.0:8000 --worker-class gevent -w 12 tawhiri_api:app
