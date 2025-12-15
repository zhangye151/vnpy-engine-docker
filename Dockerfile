FROM python:3.10-slim

ENV TZ=Asia/Shanghai
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    xfce4 xfce4-terminal \
    tightvncserver \
    python3-pyqt5 \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip \
    && pip install vnpy \
       vnpy_ctastrategy \
       vnpy_sqlite

WORKDIR /app

CMD sh -c "\
    vncserver :1 -geometry 1280x800 && \
    vnpy \
"
