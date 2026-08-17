#!/usr/bin/env python3
"""Reme 调试日志接收服务。

在电脑（HWS）上运行，接收 App POST 到 /upload 的日志，保存到 ~/reme-logs/。

用法:
    python tools/log_receiver.py            # 监听 0.0.0.0:8765
    python tools/log_receiver.py --port 9000
"""
import argparse
import json
import sys
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path

LOG_DIR = Path.home() / "reme-logs"


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path.rstrip("/") != "/upload":
            self.send_response(404)
            self.end_headers()
            return
        try:
            length = int(self.headers.get("Content-Length", 0) or 0)
            raw = (self.rfile.read(length) if length > 0 else self.rfile.read()).decode("utf-8", "replace")
            data = json.loads(raw) if raw else {}
            device = (data.get("device") or "unknown").replace("/", "_")
            logs = data.get("logs") or ""
            ts = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
            fname = LOG_DIR / f"{ts}_{device}.log"
            LOG_DIR.mkdir(parents=True, exist_ok=True)
            fname.write_text(logs, encoding="utf-8")
            print(f"[+] {datetime.now():%H:%M:%S} saved {fname.name} ({len(logs)} bytes)")
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"ok")
        except Exception as exc:  # noqa: BLE001
            self.send_response(500)
            self.end_headers()
            self.wfile.write(str(exc).encode())

    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"reme log receiver running")

    def log_message(self, *args):
        pass  # 静默默认请求日志


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="0.0.0.0")
    parser.add_argument("--port", type=int, default=8765)
    args = parser.parse_args()

    print(f"Reme log receiver -> http://{args.host}:{args.port}  (save to {LOG_DIR})")
    try:
        HTTPServer((args.host, args.port), Handler).serve_forever()
    except KeyboardInterrupt:
        print("\nbye")
        sys.exit(0)


if __name__ == "__main__":
    main()
