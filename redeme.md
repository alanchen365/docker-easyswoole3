
run
```
docker-compose up -d --build
```

stop
```
docker-compose stop
```

1. 项目检出是没有vendor文件目录的
[root@9960ef4ca465 php-easyswoole3]# php easyswoole  start
include composer Autoload.php fail

2. 安装依赖 (docker内部)
```
composer install
```

3. php版本
[root@9960ef4ca465 php-easyswoole3]# php -v
PHP 7.3.5 (cli) (built: Apr 30 2019 08:37:17) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.3.5, Copyright (c) 1998-2018 Zend Technologies


4. 配置文件
/App/Constant/EnvConst.php
    ENV 开发环境 大写 本机(LOCAL) 开发服务器(DEV) 生产服务器(PRODUCTION)
    SERVER_PORT 端口 
    SERVICE_NAME 服务名称 大写 
       示范 ES3_TEST.*
    路径
        日志
            /mnt/logs/php/{SERVICE_NAME}
        临时文件
            /mnt/temp/php/{SERVICE_NAME}