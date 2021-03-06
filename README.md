# Truffle Project - Malcolm ETOUNDI - Guillaume RICHER
TD 5 - Prog Blockchain

## Installation

``npm install -g truffle``

``truffle init``
```javascript
    compilers: {
        solc: {
          version: "0.7.5",    // Fetch exact version from solc-bin (default: truffle's version)
          // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
          // settings: {          // See the solidity docs for advice about optimization and evmVersion
          //  optimizer: {
          //    enabled: false,
          //    runs: 200
          //  },
          //  evmVersion: "byzantium"
          // }
        }
      },
```
On choisit également la version du compiler qui nous convient en décommentant la partie du code dédiée dans le fichier [truffle-configs.js]


## Create an ERC20 token contract

```solidity
constructor(
        string memory ticker,
        string memory symbol,
        uint256 totalSupply
    ) public ERC20(ticker, symbol) {
    }
```

Dans un premier temps nous avons créé le fichier [MyToken.sol], puis nous avons créé un constructeur dans lequel on écrit :
* ``string memory ticker`` : nom de notre token
* ``string memory symbol`` : symbole de notre token
* ``uint256 totalSupply`` : quantité maximale de notre token

## Implement all ERC20 functions

Pour implémenter les fonctions ERC20, on utilise la librairie OpenZeppelin que l'on importe via Node.js grâce à la commande : ``npm install @openzeppelin/contract``

## Create a getToken() function
```solidity
    function getToken() payable public onlyAllowed {
          //we set the tier before starting the exchange procedure
          setTier(msg.sender);

          // If you are in the first tier you get 100 tokens
          if (tiers[msg.sender] == 1) {
              _mint(msg.sender, 100);
          }

          // If you are in the second tier you get 50 tokens
          else if (tiers[msg.sender] == 2) {
              _mint(msg.sender, 50);
          }

          // If you are in the third tier you get 10 tokens
          else if (tiers[msg.sender] == 3) {
              _mint(msg.sender, 10);
          }

          // If an information is not entered right, we throw the function
          else {}
      }
 ``` 
La fonction ``getToken()`` attribue les Tokens aux utilisateurs en fonction de leur rang d'arrivée. Les 100 premiers utilisateurs reçoivent 100 Tokens puis les 900 suivants reçoivent 50 et les derniers reçoivent quant à eux 10 Tokens. La fonction ``getToken()`` attribue les tokens grâce à la fonction ``setTier`` suivante :

```solidity
     function setTier(address _user) private {
            // the first tier is a 100 users
            if (tierCount <= 100) {
                tiers[_user] = 1;
            }

            // the second tier is till we reach 1000 users
            else if (tierCount > 100 && tierCount <= 1000) {
                tiers[_user] = 2;
            }

            // the third tier is over 1000 users
            else if (tierCount > 1000) {
                tiers[_user] = 3;
            }

            tierCount += 1;
        }
```      

Le but de cette fonction est de ne pas laisser une petite partie des utilisateurs avoir tous la plus grande partie des token.
 
## Create a migration to deploy your contract(s) (Migrate to Ganache)

``npm install -g ganache-cli``

``ganache-cli``

``truffle migrate``

```
Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.



Starting migrations...
======================
> Network name:    'development'
> Network id:      1615747796017
> Block gas limit: 6721975 (0x6691b7)


1_initial_migration.js
======================

   Deploying 'MyToken'
   ----------------------
   > transaction hash:    0x6c4139cff74ff0b735662d1e7f5f226aab01c179c5e178c7e9035ff6a16aa1f2
   > Blocks: 0            Seconds: 0
   > contract address:    0x05Bf0fA9a532B6E8B40A9DF10f31Ca333E98D23E
   > block number:        1
   > block timestamp:     1615747824
   > account:             0xB4A033F84d660A3052C66597008A91a4fb0b75fC
   > balance:             99.99626074
   > gas used:            186963 (0x2da53)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00373926 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00373926 ETH


Summary
=======
> Total deployments:   1
> Final cost:          0.00373926 ETH
```

```
Transaction: 0x6c4139cff74ff0b735662d1e7f5f226aab01c179c5e178c7e9035ff6a16aa1f2
  Contract created: 0x05bf0fa9a532b6e8b40a9df10f31ca333e98d23e
  Gas usage: 186963
  Block Number: 1
  Block Time: Sun Mar 14 2021 19:50:24 GMT+0100 (heure normale d’Europe centrale)

eth_getTransactionReceipt
eth_getCode
eth_getTransactionByHash
eth_getBlockByNumber
eth_getBalance
eth_getBlockByNumber
eth_getBlockByNumber
eth_sendTransaction

  Transaction: 0xbd1e71e3c334cb2d7339a9e3ed0168b0659c235b6c6dc5a1ab2b6143acc5b795
  Gas usage: 42335
  Block Number: 2
  Block Time: Sun Mar 14 2021 19:50:25 GMT+0100 (heure normale d’Europe centrale)

eth_getTransactionReceipt
eth_blockNumber
net_version
eth_accounts
eth_getBlockByNumber
eth_getCode
eth_getBlockByNumber
eth_call
```
## Implement customer allow listing

```solidity
    /**
     * @dev Add an allowed user to the mapping.
     */
    function addAllowedUser(address _user) public virtual onlyOwner {
        allowedUsers[_user] = true;
    }

    /**
     * @dev Throws if called by any account other than the allowed ones.
     */
    modifier onlyAllowed() {
        require(allowedUsers[msg.sender], "Allowed: user is not allowed to call this function");
        _;
    }
```

La fonction ``addAllowedUser`` ajoute tous les utilisateurs sans distinction dans la liste des utilisateurs autorisés. La seule personne à pouvoir voir cette liste est l'admistrateur.

## Implement multi level distribution

```solidity
     function setTier(address _user) private {
            // the first tier is a 100 users
            if (tierCount <= 100) {
                tiers[_user] = 1;
            }

            // the second tier is till we reach 1000 users
            else if (tierCount > 100 && tierCount <= 1000) {
                tiers[_user] = 2;
            }

            // the third tier is over 1000 users
            else if (tierCount > 1000) {
                tiers[_user] = 3;
            }

            tierCount += 1;
        }
```      

Le but de cette fonction est de ne pas laisser une petite partie des utilisateurs avoir tous la plus grande partie des token.

## Implement air drop functions

```solidity
    function airdrop(address _arbitrary, uint256 amount) public virtual onlyOwner {
             _mint(_arbitrary, amount);
         }
```  

Cette fonction permet de créditer un montant de token arbitraire à une adresse choisie. Cette action est uniquement réalisable par l'administrateur.

## Deploy to a testnet

``truffle migrate --network ropsten``

```
Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.



Starting migrations...
======================
> Network name:    'ropsten'
> Network id:      3
> Block gas limit: 8000000 (0x7a1200)


1_initial_migration.js
======================

   Deploying 'MyToken'
   -------------------
   > transaction hash:    0x22103e0ac815b8506047b81a8ac9980a2ef3431e28373eb2040bf6a5704a2803
   > Blocks: 2            Seconds: 16
   > contract address:    0x7e0D7Bf00A6693c8Ba3a52D462E7E4081Db6d0Be
   > block number:        9835285
   > block timestamp:     1615752610
   > account:             0x13996883A32288a28f9560D28d27B131758354c5
   > balance:             2.96432498
   > gas used:            1783751 (0x1b37c7)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.03567502 ETH

   Pausing for 2 confirmations...
   ------------------------------
   > confirmation number: 1 (block: 9835286)
   > confirmation number: 2 (block: 9835287)
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.03567502 ETH


Summary
=======
> Total deployments:   1
> Final cost:          0.03567502 ETH
```
