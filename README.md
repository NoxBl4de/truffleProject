# truffleProject
TD 5 - Prog Blockchain

## Instalation

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
 
## Create a migration to deploy your contract(s)

```solidity
    contract Migrations {
      address public owner = msg.sender;
      uint public last_completed_migration;

      modifier restricted() {
        require(
          msg.sender == owner,
          "This function is restricted to the contract's owner"
        );
        _;
      }

      function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
      }
    }
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

