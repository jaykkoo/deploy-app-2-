# #!/usr/bin/env bash

# # kill any servers that may be running in the background 
# sudo pkill -f runserver

# # kill frontend servers if you are deploying frontend
# # sudo pkill -f tailwind
# # sudo pkill -f node

# cd /home/ubuntu/django-aws_cicd/

# # activate virtual environment
# python3 -m venv venv
# source venv/bin/activate

# install requirements.txt
# pip install -r /home/ubuntu/django-aws_cicd/requirements.txt

# # run server
# screen -d -m python3 manage.py runserver 0:8000

#!/usr/bin/env bash

# Kill any running Django servers
sudo pkill -f runserver

# Kill frontend servers if deploying frontend (uncomment if needed)
# sudo pkill -f tailwind
# sudo pkill -f node

# Clean up CodeDeploy agent files for a fresh install
sudo rm -rf /home/ubuntu/install

# Install CodeDeploy agent
sudo apt update
sudo apt install -y ruby wget

cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
sudo chmod +x ./install 
sudo ./install auto

# Update OS and install Python3 and related packages
sudo apt install -y python3 python3-dev python3-pip python3-venv
pip install --user --upgrade virtualenv

# Clean up any previous app installations
sudo rm -rf /home/ubuntu/django-aws_cicd

# Install Nginx
sudo apt install -y nginx

# Configure Nginx (Replace with your domain and app location)
cat <<EOL | sudo tee /etc/nginx/sites-available/django-aws_cicd
server {
    listen 80;
    server_name www.appfree.work.gd;

    location / {
        proxy_pass http://127.0.0.1:8000;  # Your Django app
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

# Enable the new Nginx site configuration
sudo ln -s /etc/nginx/sites-available/django-aws_cicd /etc/nginx/sites-enabled/

# Test Nginx configuration
if sudo nginx -t; then
    echo "Nginx configuration is valid"
else
    echo "Nginx configuration is invalid"
    exit 1
fi

# Restart Nginx to apply changes
sudo systemctl restart nginx

# Navigate to the Django project directory
cd /home/ubuntu/django-aws_cicd/

# Activate the virtual environment
python3 -m venv venv
source venv/bin/activate

# Install requirements
pip install -r requirements.txt

# Run the Django server in the background
screen -d -m python3 manage.py runserver 0:8000
