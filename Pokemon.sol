// SPDX-License-Identifier: MIT
// Define a licença como MIT, um padrão de código aberto amplamente aceito.

pragma solidity ^0.8.2;
// Define a versão do Solidity que o código usa. Aqui está especificado que o compilador deve ser versão 0.8.2 ou superior.

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// Importa o contrato ERC721 da biblioteca OpenZeppelin, que fornece uma implementação padrão para NFTs.

contract PokeNFT is ERC721 {
    // Declara o contrato PokeNFT, que herda a funcionalidade do contrato ERC721.

    uint constant LEVEL_1 = 1;
    // Define uma constante de nível inicial para os Pokémon, que é 1.

    struct Pokemon {
        string name;    // Nome do Pokémon.
        uint level;     // Nível atual do Pokémon.
        string img;     // URL ou caminho para a imagem do Pokémon.
    }

    Pokemon[] public pokemons;
    // Declara um array público que armazena todos os Pokémon criados.

    address public gameOwner;
    // Declara o endereço do proprietário do jogo, que terá permissões especiais.

    constructor () ERC721 ("PokeNFT", "PKD") {
        gameOwner = msg.sender;
        // Inicializa o contrato e define o deployer (quem fez o deploy) como o proprietário do jogo.
    }

    modifier onlyOwnerOf(uint _monsterId) {
        // Modificador que garante que apenas o dono do Pokémon especificado pode executar certas funções.
        require(ownerOf(_monsterId) == msg.sender, "Apenas o dono pode batalhar com esse Pokemon.");
        // Verifica se o chamador da função é o dono do Pokémon com ID `_monsterId`.
        _;
    }

    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon) {
        // Função para batalhar entre dois Pokémon. O chamador precisa ser o dono do Pokémon atacante.

        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];
        // Recupera os Pokémon atacante e defensor do array `pokemons` usando `storage` para modificar os dados.

        if (attacker.level > defender.level) {
            attacker.level += 2;   // Se o nível do atacante é maior, ele ganha 2 níveis.
            defender.level += 1;   // O defensor ganha 1 nível como consolação.
        } else {
            attacker.level += 1;   // Se o nível do atacante é menor ou igual, ele ganha 1 nível.
            defender.level += 2;   // O defensor ganha 2 níveis.
        }
    }

    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        // Função para criar um novo Pokémon. Só o `gameOwner` pode chamar esta função.

        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons.");
        // Verifica se o chamador é o `gameOwner`.

        uint id = pokemons.length;
        // Define o ID do novo Pokémon como o índice atual do array `pokemons`.

        pokemons.push(Pokemon(_name, LEVEL_1, _img));
        // Cria um novo Pokémon com o nome, nível inicial e imagem fornecidos e o adiciona ao array.

        _safeMint(_to, id);
        // Faz o mint do NFT para o endereço `_to` com o ID `id`. `_safeMint` é seguro para enviar NFTs a contratos.
    }
}
