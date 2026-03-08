FROM python:3.11-slim

# Vaqt zonasini o'rnatish
ENV TZ=Asia/Tashkent
RUN apt-get update && apt-get install -y \
    gcc g++ make curl wget \
    ntpdate tzdata \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2 \
    libpango-1.0-0 libcairo2 libatspi2.0-0 \
    fonts-liberation fonts-noto-color-emoji \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

RUN playwright install chromium

COPY . .

# Ishga tushishdan oldin vaqtni sinxronlashtirish
CMD ntpdate -u pool.ntp.org 2>/dev/null || true && python main.py
