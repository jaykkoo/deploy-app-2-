sudo rm -f /etc/nginx/sites-enabled/default

sudo cp /home/ubuntu/django-aws_cicd/nginx/nginx.conf /etc/nginx/sites-available/django-aws_cicd
sudo ln -s /etc/nginx/sites-available/blog /etc/django-aws_cicd/sites-enabled/
#sudo ln -s /etc/nginx/sites-available/blog /etc/nginx/sites-enabled
#sudo nginx -t
sudo gpasswd -a www-data ubuntu
sudo systemctl restart nginx