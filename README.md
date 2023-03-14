# CloneCraft contracts



### SPEC

- openzeppelin: v4.5
- solidity: v0.8.10



### 시작하기

##### 1. 설치

```sh
git clone https://github.com/clonecraft/clonecraft-contracts.git
cd clonecraft-contracts
npm i
```

##### 2. dotenv 설정

```sh
# .env 파일 생성 후 아래 내용 작성

# ex) PK=42d503496e7aff5cf0a8c70a3939797fcedadaa6bbc0069ce7e3f816368c04f7
PK=개인키
TEST_PK=개인키
```

##### 3. 하드햇 배포

```sh
npx hardhat run --network klaytn ./scripts/asset.js
```



### klaytn CA

- V3 CA:
- Asset CA:
- Nectar CA: 0x39076d7a914017e04f6c0f67d88f4162625e8d1d



### baobab CA

- V3 CA: 0x7CED8C1340befc3ab605285b7b5FA665ce65Ccd7
- V3 Sale CA: 0xd09aFC46575D0d30Bd7fB30b31e2744DB8b902E2
- Asset CA: 0x9122eD280814713585E160303C48bb244C77661a
