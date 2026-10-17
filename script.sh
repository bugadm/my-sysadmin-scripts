#!/usr/bin/env bash

set -euo pipefail


INTERVAL=5
LOG_FILE="monitor.log"
MAX_ITERATIONS="${MAX_ITERATIONS:-0}"

for cmd in free df uptime date; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "ERROR: команда '$cmd' не найдена в PATH" >&2
        exit 1
    fi
done

if ! touch "$LOG_FILE" 2>/dev/null; then
    echo "ERROR: нет прав на запись в '$LOG_FILE'" >&2
    exit 1
fi

trap 'echo; echo "Мониторинг остановлен пользователем."; exit 0' INT TERM

echo "Мониторинг запущен (интервал: ${INTERVAL}s, лог: ${LOG_FILE})"
echo "Для остановки нажмите Ctrl+C"

i=0
while true; do
    if ! {
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---"
        free -h
        df -h
        uptime
        echo ""
    } >> "$LOG_FILE"; then
        echo "ERROR: не удалось записать в '$LOG_FILE'" >&2
        exit 1
    fi

    i=$((i + 1))
    if [[ "$MAX_ITERATIONS" -gt 0 && "$i" -ge "$MAX_ITERATIONS" ]]; then
        echo "Достигнуто ${MAX_ITERATIONS} итераций, выход."
        break
    fi

    sleep "$INTERVAL"
done