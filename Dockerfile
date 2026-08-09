FROM python:3.11-slim
RUN useradd -m -u 1001 appuser
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir "pip>=24.3" "setuptools>=78.1.1" "wheel>=0.46.2" && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir --upgrade "msgpack>=1.2.1"
COPY --chown=appuser:appuser . .
RUN chmod 750 /app
EXPOSE 5000
USER appuser
HEALTHCHECK --interval=30s --timeout=3s CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1
CMD ["python3", "app.py"]
