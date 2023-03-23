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

- Nectar CA: 0x39076d7a914017e04f6c0f67d88f4162625e8d1d
- Amber CA: 0x3bd0911e1c71f817f402b904b2fccc4e33b6db44
- V3 CA: 0x59e6A2aE6Dda3aF3F370301c7a054f49E446da59
- V3Sale CA: 0xB8C9be8453b0EB4A97659D0209ECFdBD59Ac9623
- Asset CA: 0x99E5FcfbE6981D994b778e4C3532E709A1A3b5F8
- V3LevelStorage CA: 0x95a0F321684a44850048f603033Bc50C78dbDEa8
- LevelToken CA: 0xb65c4D631Cb7c57Cc567B9ec2C544eDB6b201738
- V3LevelUP CA: 0x4b71223bf7Cf2ee2CfBE6BbE0CEe42350a448776
- EquipStorage CA: 0x96af25ea7065636C3dE1379b235EC7EF07F1A7e0
- ClonecraftEquip CA: 0x3acbc08c9AD397AaB86852CF24Eb86417dD91B48
- Price Calculator CA: 0xe07d5CF13Dd2376230e68bFE7A352e4AA2Ac7389
- AssetAirdrop CA: 0x151Fe667D66f9e3d35654EC5b0ac1C24183cD9E9
- AssetBurn CA: 0xDd0d4dA6264354104b50e5b830E7Deb594EA54d1

### baobab CA

- V3 CA: 0x7CED8C1340befc3ab605285b7b5FA665ce65Ccd7
- V3Sale CA: 0xd09aFC46575D0d30Bd7fB30b31e2744DB8b902E2
- Asset CA: 0x9122eD280814713585E160303C48bb244C77661a
- V3LevelStorage CA: 0xD5D571820b37FE6a3c9d3D07666303384EC19554
- LevelToken CA: 0x75802711e54DE1cbCd6cc7d819E2878Ca6E803a0
- V3LevelUP CA: 0x312c957192CFaE8531e8d95ad52424C818e37f61
- EquipStorage CA: 0xd26108aEA0e0FC61b4443C31106bbe0E9484c7ea
- ClonecraftEquip CA: 0xBa01F76496ce0771257D1B1Ac429733E61BE3dAc
- TestAmber CA: 0x3caf1c85b1823455b9564aBcaFfE956966a46E8E