FROM python:3.12-alpine as builder

LABEL description="tm3402-exporter" maintainer="github@compuix.com" version="2023.11.30"

COPY ./  /src/
WORKDIR /src

RUN python3 -mpip install -U pip setuptools wheel tox \
    && python3 -mpip wheel -w /wheel . \
    && tox

FROM python:3.12-alpine

COPY --from=builder /wheel/*.whl /wheel/

ENV PYTHONUNBUFFERED "x"

RUN python3 -mpip install -f /wheel --no-index tm3402_exporter \
    && rm -r /wheel

EXPOSE 9116

CMD [ "/usr/local/bin/tm3402_exporter" ]
