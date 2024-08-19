```
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.1.0.4477-linux-x64.zip
```

```
sudo mv sonar-scanner-6.1.0.4477-linux-x64 /opt/sonar-scanner
```

```
vi ~/.bashrc
```

```
export SONAR_SCANNER_HOME=/opt/sonar-scanner
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
```

```
source ~/.bashrc
```

```
sonar-scanner --version
```



