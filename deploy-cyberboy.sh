#!/bin/bash
# ------------------------------------------------------------------
# [Author] Eric Abraham Kalloor
#          Automated Cyberboy deployment
# ------------------------------------------------------------------
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

cd /var/www/cyberboy/

#git stash and pull
echo 'pulling code'
git stash
git pull

#activate venv
echo 'Activating virtual environment'
source venv/bin/activate

#install requirments
echo 'Installing Requirements'
pip install -r requirements.txt

#collect static
echo 'Collecting Static Files'
python manage.py collectstatic

#make migrations and migrate
echo 'Running Migraions'
python manage.py makemigrations
python manage.py migrate

#deactivate vent
echo 'Deactivating Virtual Environment'
deactivate

#remove existing staticfile folder and rename static folder
echo 'Renaming Static Directory'
rm -rf staticfiles/
mv static/ staticfiles/

#change ownership and permission of directory
echo 'Changing Permission and Ownership'
chown -R www-data:www-data .
chmod -R 777 .

#exit
echo 'Deploy Completed'
