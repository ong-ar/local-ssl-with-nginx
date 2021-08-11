## 사용법

**설정된 모든 도메인은 `3000`번 포트로 향해있습니다.**

### 0. clone

```bash
git clone https://github.com/ong-ar/local-ssl-with-nginx.git

cd local-ssl-with-nginx
```

### 1. mkcert 설치 및 인증서 생성

mkcert is a simple tool for making locally-trusted development certificates.

```bash
$ brew install mkcert

$ mkcert -install

$ mkcert -cert-file=./ssl/all.crt -key-file ./ssl/all.key "*.local.kcd.co.kr" "*.local.cashnote.kr"
```

### 2. 실행

```bash
$ docker-compose up -d
```

### 3. `/etc/hosts` 수정

```bash
$ echo '127.0.0.1   merlin.local.cashnote.kr kestrel.local.cashnote.kr space.local.kcd.co.kr' | sudo tee -a /etc/hosts
```

### 4. chrome 에서 확인

- `merlin.local.cashnote.kr`
- `kestrel.local.cashnote.kr`
- `space.local.kcd.co.kr`

# 설정 방법

## 도메인 추가하는 방법

- 위 설정에서는 `*.local.kcd.co.kr` `*.local.cashnote.kr` 서브도메인에 대해서는 인증서가 있다라는 뜻

### 만약 `merlin.local.cashnote.kr` 도메인을 localhost:4000 포트로 설정하고 싶다면 아래와 같이 설정

에디터로 `nginx/conf.d/local.cashnote.kr.conf` 열고 아래 코드 추가

```
server {
    listen 443 ssl;
    server_name merlin.local.cashnote.kr;

    location / {
        proxy_pass http://host.docker.internal:4000;
    }
}
```

```bash
$ docker-compose restart
```

### 만약 `a.local.kcd.co.kr` 또는 `a.local.cashnote.kr` 을 추가하고 싶다면 아래와 같이 설정

```bash
$ sudo vi /etc/hosts
```

```
127.0.0.1 a.local.kcd.co.kr a.local.cashnote.kr
```

### 만약 `a.example.com` 을 추가하고 싶다면 아래와 같이 설정

```bash
$ mkcert -cert-file=./ssl/all.crt -key-file ./ssl/all.key "*.local.kcd.co.kr" "*.local.cashnote.kr" "*.example.com"
```

```bash
$ sudo vi /etc/hosts
```

```
127.0.0.1 a.example.com
```

`nginx/conf.d/example.com.conf` 생성 후

```
server {
    listen 443 ssl;
    server_name *.example.com;

    location / {
        proxy_pass http://host.docker.internal:3000;
    }
}
```

```bash
$ docker-compose restart
```

## 삭제 방법

```
$ mkcert -uninstall
$ brew uninstall mkcert
$ docker-compose down
```

- `/etc/hosts` 정리
