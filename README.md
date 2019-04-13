# computate-zookeeper
sudo mkdir /usr/local/src/computate-zookeeper
sudo chown $USER: /usr/local/src/computate-zookeeper/
git clone git@github.com:computate/computate-zookeeper.git /usr/local/src/computate-zookeeper/
cd /usr/local/src/computate-zookeeper
docker build -t computate/computate-zookeeper:latest .
docker login
docker push computate/computate-zookeeper:latest
git add -i
git commit
git push
oc replace --force -f "https://raw.githubusercontent.com/computate/computate-zookeeper/master/openshift-computate-zookeeper.json"

