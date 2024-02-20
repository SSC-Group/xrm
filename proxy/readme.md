
# Create file
yum install -y nano
cd / && mkdir nginx && cd /nginx
nano Dockerfile
nano nginx.conf
# Install Docker & Run image
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
service docker start
chkconfig docker on
docker build -t my-nginx-proxy . && docker run -d --restart always -p 5332:5332 my-nginx-proxy