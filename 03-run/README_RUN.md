## On init application (after verifying that all scripts work well !)
We want the script on_init.sh to be runned on system init. To do so, there are multiple choices but, as we wanted to keep it simple and lightweight, we are going to use the Systemd service to execute our file at the begining. 

## Using a Systemd Service

## 1. Create a service file:
````
sudo nano /etc/systemd/system/pi-platter.service
````
## 2. Add the following:
````
[Unit]
Description=Pi Platter Script
After=multi-user.target

[Service]
ExecStart=/home/admin/tralala_pi0_sp_ws/03-run/raspberry/on_init.sh
WorkingDirectory=/home/admin/tralala_pi0_sp_ws/03-run/raspberry/
StandardOutput=journal
StandardError=journal
Restart=always
User=admin
Group=admin

[Install]
WantedBy=multi-user.target
````
## 3. Enable and start the service:
````
sudo systemctl enable pi-platter.service
sudo systemctl start pi-platter.service
````
## 4. Check status:
````
sudo systemctl status pi-platter.service
````
## 5. Reboot to verify it starts automatically.