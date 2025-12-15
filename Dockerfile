FROM python:3.10-bullseye

# ===== 禁止 apt 交互（非常关键）=====
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# ===== 基础环境 =====
ENV TZ=Asia/Shanghai
ENV USER=root
ENV DISPLAY=:1

# ===== VNC / GUI =====
ENV VNC_RESOLUTION=1280x800
ENV VNC_COL_DEPTH=24
ENV VNC_PASSWORD=123456

# ===== vn.py 数据目录 =====
ENV VNPY_HOME=/root/.vntrader

# ===== 系统依赖 =====
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-terminal \
    tightvncserver \
    dbus-x11 \
    python3-pyqt5 \
    python3-pyqt5.qtsvg \
    git \
    build-essential \
    libgl1 \
    libglib2.0-0 \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# ===== Python 依赖 =====
RUN pip install -U pip setuptools wheel
RUN pip install numpy pandas
RUN pip install \
    vnpy \
    vnpy_ctastrategy \
    vnpy_sqlite \
    vnpy_csvloader

# ===== VNC 初始化 =====
RUN mkdir -p /root/.vnc && \
    echo "${VNC_PASSWORD}" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    printf '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4 &\n' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

EXPOSE 5901
WORKDIR /root

CMD sh -c "\
    rm -rf /tmp/.X1-lock /root/.vnc/*.pid || true && \
    vncserver :1 -geometry ${VNC_RESOLUTION} -depth ${VNC_COL_DEPTH} && \
    vnpy \
"
