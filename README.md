# truffleProject
TD 5 - Prog Blockchain

## Instalation

``npm install -g truffle``
``truffle init``

## Create an ERC20 token contract

Dans un premier temps nous avons créé le fichier [MyToken.sol], puis nous avons créé un constructeur dans lequel on écrit :
* ``string memory ticker`` : nom de notre token
* ``string memory symbol`` : symbole de notre token
* ``uint256 totalSupply`` : quantité maximale de notre token

## Implement all ERC20 functions

## Create a getToken() function

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

## Create a migration to deploy your contract(s)

## Implement customer allow listing

## Implement multi level distribution

## Implement air drop functions

## Deploy to a testnet

