FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

# ===== 默认环境变量（可 docker run 覆盖）=====
ENV USER=vnpy
ENV HOME=/home/vnpy
ENV VNC_PASSWORD=vnpy123
ENV VNC_RESOLUTION=1280x800
ENV DISPLAY=:0

# ===== 系统依赖 =====
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    fluxbox \
    dbus-x11 \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ===== 用户 =====
RUN useradd -m ${USER}
WORKDIR ${HOME}

# ===== Python =====
RUN pip install -U pip setuptools wheel \
    && pip install numpy pandas \
    && pip install vnpy \
    && pip install vnpy_ctastrategy --no-deps

# ===== VNC 目录 =====
RUN mkdir -p ${HOME}/.vnc \
    && chown -R ${USER}:${USER} ${HOME}

# ===== 启动脚本 =====
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${USER}
ENTRYPOINT ["/entrypoint.sh"]
