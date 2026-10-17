Скрипт `script.sh` раз в N секунд (по умолчанию 5) снимает `free -h`, `df -h`, `uptime` и дописывает блок с временной меткой в `monitor.log`.

## Запуск

```bash
chmod +x script.sh
./script.sh