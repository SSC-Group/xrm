sed -i 's/CMC_PROXY_DOMAIN/cent25-1.ddns.net/g' config.json
sed -i '' 's|"url": ".*:5332",|"url": "test.com:5332",|' config.json
docker build -t myimage .


mkdir info
echo [EMAIL] > info/email.txt
echo [COMPUTER] > info/computer.txt
echo 0 > info/status.txt