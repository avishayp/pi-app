# pi-app
rpi IoT app skeleton:
 * AP setup
 * `nginx` + `flask` in `wsgi` mode
 * `supervisor` + `rsyslog` + `logrotate` for more production oriented setup 

### Usage

```bash
wget https://raw.githubusercontent.com/avishayp/pi-app/master/setup.sh
chmod +x ap_setup.sh
./setup.sh [ssid-name] [ssid-pass]
```

### Feedback
Only tested on rpi3. Open an issue if something does not work as expected.
