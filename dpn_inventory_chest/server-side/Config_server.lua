
function formaDeTirarDinheiro(user_id,amount)
    if vRP.tryFullPayment(user_id,amount) then
        return true
    elseif vRP.tryPayment(user_id,amount) then
        return true
    else
        return false
    end
end -- sua função de tirar o dinheiro

function formDeDarDinheiro(user_id,amount)
    vRP.giveMoney(user_id,amount)
end -- sua função de tirar o dinheiro

function getMoney(user_id)
    return vRP.getMoney(user_id)
end -- sua função de pegar o dinheiro

function hasPermission(user_id,perm)
    return vRP.hasPermission(user_id,perm)
end -- sua função de pegar a permissao


ConfigRevistar = {
    revistar = true,
    command = "revistar"
}


ConfigServer = {
    slots = 35, -- Maximo de slots que as pessoas poderão ter comprando slots, esse valor menos 15 slot, caso queria que não seja possivel comprar slots bote 0 
    priceSlot = 20000, -- Preço dos slots
    bahamas = false, -- Coloque true caso sua base seja a do bahamas
    typeJob = "job", -- Nome do type dos grupos padrões
    typeVip = "vip", -- Nome do type dos grupos dos vips
    multasType = "vRP:multas", -- Nome do banco de dados das multa
    currency = "R$", -- Tipo da sua moeda
    adminPermissao = "admin.permissao", -- Permissão que todos adm tem
    policiaPermissao = "policia.permissao", -- Permissão que todos policiais tem
    garageName = "nation_garages", -- Nome da sua resource de garagem
    skilBar = "", -- Nome da sua resource de skilbar se tiver claro
    groups = "cfg/groups", -- Caso use a base zirix deixe assim: zirix/groups, caso use a evolution deixe assim: evolution/groups
    itemVrp = "modules/inventory", -- Caso use a base zirix deixe assim: zirix, caso use a base evolution deixe assim: evolution
    typeItens = {
        usar = "usar", -- Type dos itens normais
        recarregar = "recarregar", -- Type das munições
        equipar = "equipar", -- Type das armas
    },
    carSlots = {
        exclusive = 20,
        carros = 10,
        motos = 4,
        work = 50,
        trunk = 10,
        vip = 20
    }, -- Cada carro tem um  tipo isso você pode ver em vrp<modules<inventory.lua, la vai ter uma lista com muitos carros e em cada carro tera tipo, os slots são
    -- separados pelo tipo do carro, ou seja se o tipo do carro for moto então ele pegará os slots da tabela a cima por ex:

    -- Vai estar mais ou menos assim:
    --	["urus"] = { ['name'] = "Lamborghini Urus", ['price'] = 1000000, ['tipo'] = "exclusive" },
    -- O tipo é exclusive então ele pegará 50 slots para esse carro.
    webhook = {
        send = "",
        dropar = "",
        equip = "",
        casa = "",
        carro = "",
        antidupe = "",
        craft = "",
        compras = "",
        arsenal = "",
    }, -- Webhook de enviar, dropar e equipar, bau de casa, bau de carro, anti-dump respectivamente

    listaDeItens = {
        --------------------------------------------------------
        ---- type:: arma, food, soda, box

        ["dinheiro"] = { index = "dinheiro", nome = "Dinheiro", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["dinheirosujo"] = { index = "dinheiro-sujo", nome = "Dinheiro Sujo", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
-----------HOSPITAL
        ["bandagem"] = { index = "bandagem", nome = "Bandagem", filtro = "box", type = "usar", funcao = false, descricao = "Bandagem para pequenos ferimentos!" },
         --;;;;;; REMEDIOS
         ["xerelto"] = { index = "xerelto", nome = "Xerelto", filtro = "box", type = "usar", descricao = "Remédio Utilizado para curar algo em você!" },
         ["r-xerelto"] = { index = "r-xerelto", nome = "Receita Xerelto", filtro = "box", type = "usar", descricao = "Receita médica para o rémedio xerelto." },
         ["comuadin"] = { index = "comuadin", nome = "Comuadin", filtro = "box", type = "usar", descricao = "Remédio Utilizado para curar algo em você!" },
         ["r-comuadin"] = { index = "r-comuadin", nome = "Receita Comuadin", filtro = "box", type = "usar", descricao = "Receita médica para o rémedio comuadin." },
         ["dorflex"] = { index = "dorflex", nome = "Dorflex", filtro = "box", type = "usar", descricao = "Remédio Utilizado para curar algo em você!" },
         ["r-dorflex"] = { index = "r-dorflex", nome = "Receita Dorflex", filtro = "box", type = "usar", descricao = "Receita médica para o rémedio dorflex." },
         ["cicatricure"] = { index = "cicatricure", nome = "Cicatricure", filtro = "box", type = "usar", descricao = "Remédio Utilizado para curar algo em você!" },
         ["r-cicatricure"] = { index = "r-cicatricure", nome = "Receita Cicatricure", filtro = "box", type = "usar", descricao = "Receita médica para o rémedio cicatricure." },
         ["paracetanal"] = { index = "paracetanal", nome = "Paracetanal", filtro = "box", type = "usar", descricao = "Remédio Utilizado para curar algo em você!" },
         ["r-paracetanal"] = { index = "r-paracetanal", nome = "Receita Paracetanal", filtro = "box", type = "usar", descricao = "Receita médica para o rémedio paracetanal." },
         ["atestado"] = { index = "atestado", nome = "Atestado Médico", filtro = "box", type = "usar", descricao = "Atestado assinado por um médico." },
         ["Rebite"] = { index = "Rebite", nome = "Rebite", filtro = "box", type = "usar", descricao = "Remédio Utilizado para curar algo em você!" },
         ["r-rebite"] = { index = "r-rebite", nome = "Receita Rebite", filtro = "box", type = "usar", descricao = "Receita médica para o rémedio rebite." },
------------- BEBIDAS
        ["cerveja"] = { index = "cerveja", nome = "Cerveja",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida alcoólica, somenta para +18 anos!" },
		["tequila"] = { index = "tequila", nome = "Tequila",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida alcoólica, somenta para +18 anos!" },
        ["vodka"] = { index = "vodka", nome = "Vodka",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida alcoólica, somenta para +18 anos!" },
		["whisky"] = { index = "whisky", nome = "Whisky",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida alcoólica, somenta para +18 anos!" },
		["absinto"] = { index = "absinto", nome = "Absinto",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida alcoólica, somenta para +18 anos!" },
        ["conhaque"] = { index = "conhaque", nome = "Conhaque",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida alcoólica, somenta para +18 anos!" },
      
        ["agua"] = { index = "agua", nome = "Agua",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
        ["garrafaaguavazia"] = { index = "garrafaaguavazia", nome = "Garrafa de água vazia",filtro = "soda", type = "usar", funcao = false, descricao = "Garrafa vazia, pode tentar enche-la" },
        ["limonada"] = { index = "limonada", nome = "Limonada",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
        ["refrigerante"] = { index = "refrigerante", nome = "Refrigerante",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida gaseificada refrescante" },
        ["cafe"] = { index = "cafe", nome = "Café",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida quente e energética!" },
        ["energetico"] = { index = "energetico", nome = "Energetico", filtro = "soda", type = "usar", funcao = false, descricao = "Bebida fria e energética!" },
        ["coquetelvanilla"] = { index = "coquetelvanilla", nome = "Coquetel Laranja", filtro = "soda", type = "usar", funcao = false, descricao = "Bebida fria de laranja, energética!" },		
        ["coquetelvanilla2"] = { index = "coquetelvanilla2", nome = "Coquetel Morango", filtro = "soda", type = "usar", funcao = false, descricao = "Bebida fria de morango, mais energética, porém com alguns efeitos." },		

        ------------- COMIDAS
        ["pao"] = { index = "pao", nome = "Pão",filtro = "food", type = "usar", funcao = false, descricao = "Fatia de pão, utilizada para fazer lanches!" },
        ["tomate"] = { index = "tomate", nome = "Tomate",filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente utilizado na receita dos lanches" },
        ["hamburguer"] = { index = "hamburguer", nome = "Hamburguer",filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente principal para a receita dos lanches!" },
        ["salsicha"] = { index = "salsicha", nome = "Salsicha",filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente principal para a receita do hot-dog!" },

        ["batata"] = { index = "batata", nome = "Batata", filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente utilizado na receita das batatas fritas!" },
        ["embalagem"] = { index = "embalagem", nome = "Embalagem", filtro = "food", type = "usar", funcao = false, descricao = "Embalagem utilizada para colocar as batatas" },
        ["queijo"] = { index = "queijo", nome = "Queijo",filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente utilizado na receita dos lanches e pizzas!" },
        ["alface"] = { index = "alface", nome = "Alface",filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente utilizado na receita dos lanches!" },
        ["calabresa"] = { index = "calabresa", nome = "Calabresa",filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente utilizado na receita da pizza!" },
        ["farinha"] = { index = "farinha", nome = "Farinha",filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente principal para a receita da pizza" },
        ["chocolate"] = { index = "chocolate", nome = "Chocolate",filtro = "food", type = "usar", funcao = false, descricao = "Sobremesa com alta caloria" },
        ["laranja"] = { index = "laranja", nome = "Laranja",filtro = "food", type = "usar", funcao = false, descricao = "Fruta novinha, geralmente utilizada para sucos ou drinks!" },
        ["morango"] = { index = "morango", nome = "Morango",filtro = "food", type = "usar", funcao = false, descricao = "Fruta novinha, geralmente utilizada para sucos ou drinks!" },

        ["salgadinho"] = { index = "salgadinho", nome = "Salgadinho",filtro = "food", type = "usar", funcao = false, descricao = "Alimento com alta caloria, mas com pouca sacies" },
        ["rosquinha"] = { index = "rosquinha", nome = "Rosquinha",filtro = "food", type = "usar", funcao = false, descricao = "Alimento com alta caloria, mas com pouca sacies" },
        ["xburguer"] = { index = "xburguer", nome = "X-Burguer",filtro = "food", type = "usar", funcao = false, descricao = "X-Burguer delicioso com ingredientes de qualidade" },
        ["xtudo"] = { index = "xtudo", nome = "X-Tudo",filtro = "food", type = "usar", funcao = false, descricao = "X-Tudo delicioso com ingredientes de qualidade" },

        ["pizza"] = { index = "pizza", nome = "Pizza",filtro = "food", type = "usar", funcao = false, descricao = "Pizza gostosa boa para matar a fome mama mia" },
        ["hotdog"] = { index = "hotdog", nome = "HotDog",filtro = "food", type = "usar", funcao = false, descricao = "Alimento gostoso, muito bom para matar a fome!" },
	    ["taco"] = { index = "taco", nome = "Taco",filtro = "food", type = "usar", funcao = false, descricao = "Comida mexicana, muito deliciosa!" },
        ["batatinha"] = { index = "batatinha", nome = "Batatinha Frita", filtro = "food", type = "usar", funcao = false, descricao = "Deliciosa laranja, colhida em um pé maduro" },

        ["sorvete"] = { index = "sorvete", nome = "Sorvete",filtro = "food", type = "usar", funcao = false, descricao = "Sorvete delicioso e geladinho." },
        ["coxinha"] = { index = "coxinha", nome = "Coxinha",filtro = "food", type = "usar", funcao = false, descricao = "Coxinha crocante de frango" },
        ["paodequeijo"] = { index = "paodequeijo", nome = "Pão de Queijo",filtro = "food", type = "usar", funcao = false, descricao = "Pão de queijo quentinho." },
        ["pastel"] = { index = "pastel", nome = "Pastel",filtro = "food", type = "usar", funcao = false, descricao = "Pastel de queijo com uma massa exclusiva" },
        ["frango"] = { index = "frango", nome = "Frango",filtro = "food", type = "usar", funcao = false, descricao = "Ingrediente utilizado na receita dos lanches!" },



        ---------------------------
        ["roupas"] = { index = "roupas", nome = "Roupas", filtro = "box", type = "usar", funcao = false, descricao = "Lindas roupas, com ele é possivel alterar suas roupas" },
        ["oculos"] = { index = "oculos", nome = "Óculos", filtro = "box", type = "usar", funcao = false, descricao = "Lindos óculos, com ele é possivel alterar seus óculos" },
        ["mascara"] = { index = "mascara", nome = "Mascara", filtro = "box", type = "usar", funcao = false, descricao = "Lindas máscaras, com ele é possivel alterar sua máscara" },
        ["chapeu"] = { index = "chapeu", nome = "Chapéu", filtro = "box", type = "usar", funcao = false, descricao = "Lindos Chapéus, com ele é possivel alterar seus chapéus" },


        ["couro"] = { index = "couro", nome = "Couro de Animal", filtro = "box", type = "usar", funcao = false, descricao = "Couro retirado de algum animal com uma faca!" },
        ["carnecrua"] = { index = "carnecrua", nome = "Carne Crua", filtro = "box", type = "usar", funcao = false, descricao = "Carne crua, cheia de sangue de algum animal silvestre" },

        ["serra"] = { index = "serra", nome = "Serra", filtro = "box", type = "usar", funcao = false, descricao = "Serra nova, geralmente utilizada para serrar grandes ferros/aços" },		
		["furadeira"] = { index = "furadeira", nome = "Furadeira", filtro = "box", type = "usar", funcao = false, descricao = "Furadeira nova, geralmente utilizada para furar pequenos ferros/aços" },	
        ["bombaadesiva"] = { index = "bombaadesiva", nome = "Bomba Adesiva", filtro = "box", type = "usar", funcao = false, descricao = "Bomba com cola, com grande quantidade de polvora!" },	
        ["notebook"] = { index = "notebook", nome = "Notebook", filtro = "box", type = "usar", funcao = false, descricao = "Notebook novo ainda na garantia." },
        ["notebookroubado"] = { index = "notebookroubado", nome = "Notebook Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Notebook Desbloqueado" },
        ["cartao"] = { index = "cartao", nome = "Cartão Limpo", filtro = "box", type = "usar", funcao = false, descricao = "Cartão Liso, sem identificação!" },
        ["cartao1"] = { index = "cartao1", nome = "Cartão Classic Clonado", filtro = "box", type = "usar", funcao = false, descricao = "Cartão Classic do Banco do Brasil, identificação desconhecida" },
        ["cartao2"] = { index = "cartao2", nome = "Cartão Gold Clonado", filtro = "box", type = "usar", funcao = false, descricao = "Cartão Gold do Banco do Brasil, identificação desconhecida" },
        ["cartao3"] = { index = "cartao3", nome = "Cartão Platinium Clonado", filtro = "box", type = "usar", funcao = false, descricao = "Cartão Platinium do Banco do Brasil, identificação desconhecida" },
        ["cartao4"] = { index = "cartao4", nome = "Cartão Black Clonado", filtro = "box", type = "usar", funcao = false, descricao = "Cartão Black do Banco do Brasil, identificação desconhecida" },


        ["suspensaoar"] = { index = "suspensaoar", nome = "Suspensão a Ar",filtro = "box", type = "usar", funcao = false, descricao = "Peça de suspensão a ar, aplicável em qualquer veículo!" },
        ["moduloxenon"] = { index = "moduloxenon", nome = "Módulo de Xenon",filtro = "box", type = "usar", funcao = false, descricao = "Módulo de Xenon, aplicável em qualquer veículo!" },
        ["moduloneon"] = { index = "moduloneon", nome = "Módulo de Neon",filtro = "box", type = "usar", funcao = false, descricao = "Módulo RGB de Neon, aplicável em qualquer veículo!" },


        ["plantademaconha"] = { index = "plantademaconha", nome = "Planta de maconha", filtro = "box", type = "usar", funcao = false, descricao = "Planta de maconha, verdinha!" },	
        ["cigarrodemaconha"] = { index = "cigarrodemaconha", nome = "Cigarro de maconha", filtro = "box", type = "usar", funcao = false, descricao = "Cigarro bem bolado de maconha, da boa!" },	
        ["cigarro"] = { index = "cigarro", nome = "Cigarro", filtro = "box", type = "usar", funcao = false, descricao = "Unidade de uma carteira de cigarro" },
        ["isqueiro"] = { index = "isqueiro", nome = "Isqueiro", filtro = "box", type = "usar", funcao = false, descricao = "Isqueiro para acender seu cigarro" },
        ["seda"] = { index = "seda", nome = "Seda", filtro = "box", type = "usar", funcao = false, descricao = "Seda de boa qualidade, para bolar seu baseado" },

        ["rosa"] = { index = "rosa", nome = "Rosa", filtro = "box", type = "usar", funcao = false, descricao = "Uma rosa bela e cheirosa" },
        ["identidade"] = { index = "identidade", nome = "Identidade", filtro = "box", type = "usar", funcao = false, descricao = "Documento de identificação, comprovante de quem é você!" },

        ["pecas"] = { index = "pecas", nome = "Peças", filtro = "box", type = "usar", funcao = false, descricao = "Peças de veiculo, com a numeração raspada." },
        ["pistao"] = { index = "pistao", nome = "Pistão", filtro = "box", type = "usar", funcao = false, descricao = "Pistão de veiculo, com a numeração raspada." },
        ["lataria"] = { index = "lataria", nome = "Lataria", filtro = "box", type = "usar", funcao = false, descricao = "Lataria de veiculo, com a numeração raspada." },
        ["banco"] = { index = "banco", nome = "Banco", filtro = "box", type = "usar", funcao = false, descricao = "Banco de veiculo, com a numeração raspada." },
------------------ COLETE/FUNção
        ["colete1"] = { index = "colete1", nome = "Colete Balistico Leve", filtro = "box", type = "usar", funcao = "Dar colete", descricao = "Utilize colete para maior segurança na troca de tiro" },
        ["colete2"] = { index = "colete2", nome = "Colete Balistico Médio", filtro = "box", type = "usar", funcao = "Dar colete", descricao = "Utilize colete para maior segurança na troca de tiro" },
        ["colete3"] = { index = "colete3", nome = "Colete Balistico Pesado", filtro = "box", type = "usar", funcao = "Dar colete", descricao = "Utilize colete para maior segurança na troca de tiro" },
    
        --------------------
        ["radio"] = { index = "radio", nome = "Radio", filtro = "box", type = "usar", funcao = false, descricao = "Rádio com diversas estações para conexão." },
        ["smartwatch"] = { index = "smartwatch", nome = "SmartWatch", filtro = "box", type = "usar", funcao = false,  descricao = "Celular tecnológico, funções importantes como chamar os paramédicos automático." },
        ["celular"] = { index = "celular", nome = "iPhone X5", filtro = "box", type = "usar", funcao = false, descricao = "Celular de última geração." },
        ["celularqueimado"] = { index = "celularqueimado", nome = "iPhone X5 Queimado", filtro = "box", type = "usar", funcao = false, descricao = "Celular inutilizável, está quiemado!" },
        ["mochila"] = { index = "mochila", nome = "Mochila Pequena", filtro = "box", type = "usar", funcao = false, descricao = "Uma linda mochila pequena, ótima para carregar mais coisas." },
        ["mochila2"] = { index = "mochila2", nome = "Mochila Média", filtro = "box", type = "usar", funcao = false, descricao = "Uma linda mochila média, ótima para carregar mais coisas." },
        ["mochila3"] = { index = "mochila3", nome = "Mochila Grande", filtro = "box", type = "usar", funcao = false, descricao = "Uma linda mochila grande, ótima para carregar mais coisas." },

        ["chipvip"] = { index = "chipvip", nome = "Chip VIP", filtro = "box", type = "usar", funcao = false,  descricao = "Chip VIP, utilizado para alterar seu número de telefone" },
        ["identidadevip"] = { index = "identidadevip", nome = "Identidade VIP", filtro = "box", type = "usar", funcao = false,  descricao = "Identidade VIP, utilizado para alterar suas informações como Nome/Sobrenome e Idade" },

        ["cartaodebito"] = { index = "cartaodebito", nome = "Cartão de Débito", filtro = "box", type = "usar", funcao = false,  descricao = "Cartão de débito, utilizado para quando está sem dinheiro na carteira." },

        ["alianca"] = { index = "alianca", nome = "Aliança", filtro = "box", type = "usar", funcao = false, descricao = "Linda aliança de casamento!"},
		["repairkit"] = { index = "repairkit", nome = "Kit de reparo", filtro = "box", type = "usar", funcao = false, descricao = "Kit de ferramentas para reparar um veículo danificado." },
        ["nitro"] = { index = "nitro", nome = "Nitro", filtro = "box", type = "usar", funcao = false, descricao = "Cilindro de nitro, utilizado em veiculos para topspeed" },
		["pneu"] = { index = "pneu", nome = "Pneu", filtro = "box", type = "usar", funcao = false, descricao = "Pneu novo, direto da fábrica e com garantia." },
		["skate"] = { index = "skate", nome = "Skate", filtro = "box", type = "usar", funcao = false, descricao = "Skate novo, assinado pelo Tony Hawk" },
        ["algemas"] = { index = "algemas", nome = "Algemas", filtro = "box", type = "usar", funcao = false, descricao = "Algemas de metal, muito utilizada pelos tiras." },	
        ["calculadora"] = { index = "calculadora", nome = "Calculadora", filtro = "box", type = "usar", funcao = false, descricao = "Calculadora simples, boa para calculos" },
        ["militec"] = { index = "militec", nome = "Militec-1", filtro = "box", type = "usar", funcao = false, descricao = "Militec" },	
        ["rastreador"] = { index = "rastreador", nome = "Rastreador Veicular", filtro = "box", type = "usar", funcao = false, descricao = "Rastreador para veiculos" },		

        ["alvejante"] = { index = "alvejante", nome = "Alvejante", filtro = "box", type = "usar", funcao = false, descricao = "Alvejante, ótimo para limpezadas" },
        ["borrifador"] = { index = "borrifador", nome = "Borrifador", filtro = "box", type = "usar", funcao = false, descricao = "Frasco para borrifar liquidos." },

        ["discofreio"] = { index = "discofreio", nome = "Disco de Freio", filtro = "box", type = "usar", funcao = false, descricao = "Disco de freio de veiculo, com a numeração raspada." },
        ["motorcarro"] = { index = "motorcarro", nome = "Motor de carro", filtro = "box", type = "usar", funcao = false, descricao = "Motor de veiculo, com a numeração raspada." },
        ["portacarro"] = { index = "portacarro", nome = "Porta de carro", filtro = "box", type = "usar", funcao = false, descricao = "Porta de veiculo, com a numeração raspada." },
        ["volante"] = { index = "volante", nome = "Volante", filtro = "box", type = "usar", funcao = false, descricao = "Volante de veiculo, com a numeração raspada." },
        ["parachoque"] = { index = "parachoque", nome = "Parachoque", filtro = "box", type = "usar", funcao = false, descricao = "Parachoque de veiculo, com a numeração raspada." },

        ["ficha"] = { index = "ficha", nome = "Fichas do Casino", filtro = "box", type = "usar", funcao = false, descricao = "Fichas para apostar e tentar a sorte no Casino Diamond!" },
        ["ticketroleta"] = { index = "ticketroleta", nome = "Ticket Roleta", filtro = "box", type = "usar", funcao = false, descricao = "Ticket para as roletas luxuosas para apostar e tentar a sorte de conseguir ótimos premios no Casino Diamond!" },

        ["tora"] = { index = "tora", nome = "Tora de madeira", filtro = "box", type = "usar", funcao = false, descricao = "Tora de madeira, isso vale dinheiro!" },
		["capuz"] = { index = "capuz", nome = "Capuz", filtro = "box", type = "usar", funcao = false, descricao = "Capuz preto, quem vestir isso não vai ver nada!" },	
        ["lockpick"] = { index = "lockpick", nome = "LockPick", filtro = "box", type = "usar", funcao = false, descricao = "Chave mestra para abrir veiculos, cuidado com a policia!" },	
        ["masterpick"] = { index = "masterpick", nome = "Masterpick", filtro = "box", type = "usar", funcao = false, descricao = "Chave mestra para abrir veiculos, cuidado com a policia!" },	
        ["placa"] = { index = "placa", nome = "Placa", filtro = "box", type = "usar", funcao = false, descricao = "Placa veicular, geralmente utilizam para clonagem ou detran." },	

        ------------------DROGAS------------
        ["cannabis"] = { index = "cannabis", nome = "Cannabis", filtro = "box", type = "usar", funcao = false, descricao = "Cannabis" },		
        ["adubo"] = { index = "adubo", nome = "Adubo", filtro = "box", type = "usar", funcao = false, descricao = "Utilizado para adubar terras de plantações" },		
		["maconha"] = { index = "maconha", nome = "Maconha", filtro = "box", type = "usar", funcao = false, descricao = "Folha de maconhas, bem verde." },	

        ["acidobateria"] = { index = "acidobateria", nome = "Acido Bateria", filtro = "box", type = "usar", funcao = false, descricao = "Material utilizado para criação da metanfetamina!" },		
		["metanfetamina"] = { index = "metanfetamina", nome = "Metanfetamina", filtro = "box", type = "usar", funcao = false, descricao = "Metanfetamina pura, cristal de qualidade." },	
        ["anfetamina"] = { index = "anfetamina", nome = "Anfetamina", filtro = "box", type = "usar", funcao = false, descricao = "Material utilizado para criação da metanfetamina!" },	

        ["folhadecoca"] = { index = "folhadecoca", nome = "Folha Coca", filtro = "box", type = "usar", funcao = false, descricao = "Folha da planta de coca, utilizada para produção da cocaina." },		
		["pastadecoca"] = { index = "pastadecoca", nome = "Pasta Coca", filtro = "box", type = "usar", funcao = false, descricao = "Pasta da folha da coca, utilizada para produção da cocaina." },		
		["cocaina"] = { index = "cocaina", nome = "Cocaina", filtro = "box", type = "usar", funcao = false, descricao = "Cocaina pura, pó de qualidade." },	

        ["ziplock"] = { index = "ziplock", nome = "Ziplock", filtro = "box", type = "usar", funcao = false, descricao = "Embalagem plástica vazia, geralmente utilizada para transporte de drogas!" },
        ["ziplockmaconha"] = { index = "ziplockmaconha", nome = "Ziplock com Maconha", filtro = "box", type = "usar", funcao = false, descricao = "Embalagem plastica com 1g de maconha dentro!" },	
        ["ziplockcocaina"] = { index = "ziplockcocaina", nome = "Ziplock com Cocaina", filtro = "box", type = "usar", funcao = false, descricao = "Embalagem plastica com 1g de cocaina dentro!" },	
        ["ziplockmeta"] = { index = "ziplockmeta", nome = "Ziplock com Metanfetamina", filtro = "box", type = "usar", funcao = false, descricao = "Embalagem plastica com 1g de metanfetamina dentro!" },		


        ["acidosulfurico"] = { index = "acidosulfurico", nome = "Acido Sulfurico", filtro = "box", type = "usar", funcao = false, descricao = "Material utilizado para criação da ecstasy!" },		
		["dietilamina"] = { index = "dietilamina", nome = "Dietilamina", filtro = "box", type = "usar", funcao = false, descricao = "Material utilizado para criação da ecstasy!" },		
		["ecstasy"] = { index = "ecstasy", nome = "Ecstasy", filtro = "box", type = "usar", funcao = false, descricao = "Ecstasy de qualidade." },	
        ------------------------------------

        ["TanqueDeOxigenio"] = { index = "TanqueDeOxigenio", nome = "Tanque de Oxigenio", filtro = "box", type = "usar", funcao = false, descricao = "Tanque cheio de oxigenio, utilizado para mergulhar na agua." },	
        ["trajemergulho"] = { index = "trajemergulho", nome = "Traje de Mergulho", filtro = "box", type = "usar", funcao = false, descricao = "Traje especial e focado para mergulhos" },	

        ["ouro"] = { index = "ouro", nome = "Ouro", filtro = "box", type = "usar", funcao = false, descricao = "Pedra muito valiosa, isso vale dinheiro!" },	
        ["ferro2"] = { index = "ferro2", nome = "Ferro", filtro = "box", type = "usar", funcao = false, descricao = "Material pesado e valioso, isso vale dinheiro!" },	
        ["diamante2"] = { index = "diamante2", nome = "Diamante", filtro = "box", type = "usar", funcao = false, descricao = "Pedra muito valiosa, isso vale dinheiro!" },	

        ["graosimpuros"] = { index = "graosimpuros", nome = "Grãos Impuros", filtro = "box", type = "usar", funcao = false, descricao = "Grãos impuros, isso deve ser limpo para a venda!" },
        ["graos"] = { index = "graos", nome = "Grãos", filtro = "box", type = "usar", funcao = false, descricao = "Grãos limpos, isso vale dinheiro!" },

        ["ferramenta"] = { index = "ferramenta", nome = "Ferramenta", filtro = "box", type = "usar", funcao = false, descricao = "Itens utilizados pelos mecânicos" },
        ["encomenda"] = { index = "encomenda", nome = "Encomenda", filtro = "box", type = "usar", funcao = false, descricao = "Encomendas de outras pessoas" },
        ["garrafavazia"] = { index = "garrafavazia", nome = "Garrafa Vazia", filtro = "box", type = "usar", funcao = false, descricao = "Garrafa vazia, geralmente usada para encher com leite!" },
        ["garrafadeleite"] = { index = "garrafadeleite", nome = "Garrafa com Leite", filtro = "box", type = "usar", funcao = false, descricao = "Garrafa cheia de leitinho da vaca!"},

		["vara"] = { index = "vara", nome = "Vara Pesca", filtro = "box", type = "usar", funcao = false, descricao = "Vara para pescas de grandes peixes!" },
		["isca"] = { index = "isca", nome = "Isca Pesca", filtro = "box", type = "usar", funcao = false, descricao = "Iscas utilizadas para as pescas!" },
        ["dourado"] = { index = "dourado", nome = "Dourado", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },
        ["corvina"] = { index = "corvina", nome = "Corvina", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },
        ["salmao"] = { index = "salmao", nome = "Salmão", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },
        ["pacu"] = { index = "pacu", nome = "Pacú", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },
        ["pintado"] = { index = "pintado", nome = "Pintado", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },
        ["pirarucu"] = { index = "pirarucu", nome = "Pirarucu", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },
        ["tilapia"] = { index = "tilapia", nome = "Tilapia", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },
        ["tucunare"] = { index = "tucunare", nome = "Tucunare", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },
        ["lambari"] = { index = "lambari", nome = "Lambari", filtro = "box", type = "usar", funcao = false, descricao = "Um lindo peixe, isso vale dinheiro ou uma boa refeição!" },

        ["orgao"] = { index = "orgao", nome = "Órgão", filtro = "box", type = "usar", funcao = false, descricao = "Orgão de pessoas, cuidado!" },
        ["orgaoamassado"] = { index = "orgaoamassado", nome = "Órgão Amassado", filtro = "box", type = "usar", funcao = false, descricao = "Orgão de alguma pessoa amassada, oque é isso?" },
        ["tartaruga"] = { index = "tartaruga", nome = "Tartaruga", filtro = "box", type = "usar", funcao = false, descricao = "Tartura pequena, oque vai fazer com isso?" },
        ["carnedetartaruga"] = { index = "carnedetartaruga", nome = "Carne de Tartaruga", filtro = "box", type = "usar", funcao = false, descricao = "Carne de tartaruga pequena, isso vale dinheiro!" },
        ["pecaeletronica"] = { index = "pecaeletronica", nome = "Peças eletronicas", filtro = "box", type = "usar", funcao = false, descricao = "Peças de computador, oque vai fazer com isso?" },
        ["computadormontado"] = { index = "computadormontado", nome = "Computador Montado", filtro = "box", type = "usar", funcao = false, descricao = "Computador gaming montado, isso vale dinheiro!" },
        ["identidadedigital"] = { index = "identidadedigital", nome = "Identidade digital", filtro = "box", type = "usar", funcao = false, descricao = "Identidade com nome desconhecido, oque vai fazer com isso?" },
        ["identidadefisica"] = { index = "identidadefisica", nome = "Identidade física", filtro = "box", type = "usar", funcao = false, descricao = "Identidade fisica com nome desconhecido, isso deve valer dinheiro!" },
        ["tecido"] = { index = "tecido", nome = "Tecido", filtro = "box", type = "usar", funcao = false, descricao = "Tecido leve para fabricação de alguma peça de roupa" },
        ["lingerie"] = { index = "lingerie", nome = "Lingerie", filtro = "box", type = "usar", funcao = false, descricao = "Lingerie sexy e vulgar." },

        ["corda"] = { index = "corda", nome = "Corda", filtro = "box", type = "usar", funcao = false, descricao = "Corda utilizada para amarrar e carregar algo" },


        ["pano"] = { index = "pano", nome = "Pano", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["linha"] = { index = "linha", nome = "Linha", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["fibra"] = { index = "fibra", nome = "Fibra", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["etiqueta"] = { index = "panetiquetao", nome = "Etiqueta", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["pendrive"] = { index = "pendrive", nome = "Pendrive", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },

        ["raceticket"] = { index = "raceticket", nome = "Ticket de Corrida", filtro = "box", type = "usar", funcao = false, descricao = "Ticket utilizado para participar de corridas ilegais pela cidade!" },

        ["relogioroubado"] = { index = "relogioroubado", nome = "Relogio Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["pulseiraroubada"] = { index = "pulseiraroubada", nome = "Pulseira Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["colarroubado"] = { index = "colarroubado", nome = "Colar Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["brincoroubado"] = { index = "brincoroubado", nome = "Brinco Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["carteiraroubada"] = { index = "carteiraroubada", nome = "Carteira Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["carregadorroubado"] = { index = "carregadorroubado", nome = "Carregador Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["tabletroubado"] = { index = "tabletroubado", nome = "Tablet Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["sapatosroubado"] = { index = "sapatosroubado", nome = "Sapatos Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["vibradorroubado"] = { index = "vibradorroubado", nome = "Vibrador Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["perfumeroubado"] = { index = "perfumeroubado", nome = "Perfume Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["maquiagemroubada"] = { index = "maquiagemroubada", nome = "Maquiagem Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },
        ["anelroubado"] = { index = "anelroubado", nome = "Anel Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Item roubado e com grande valor, isso deve valer dinheiro!" },

        ["laudoteoricocnh"] = { index = "laudoteoricocnh", nome = "Laudo Teórico", filtro = "box", type = "usar", funcao = false, descricao = "Laudo teórico para fazer as aulas práticas da auto escola!" },

        --------- [ MAPAS ] ----------- TESTAR
        ["mapacorridas"] = { index = "mapa", nome = "mapacorridas", filtro = "box", type = "usar", funcao = false, descricao = "Mapa com a localização das corridas" },
        --------- [ VIPS ] -------- TESTAR
        ["vipgold"] = { index = "vipgold", nome = "Pusseira Gold", filtro = "box", type = "usar", funcao = false, descricao = "Um beneficio Premium de Porte GOLD" },
		--------------------------------------------------------	
        ------------ARMAS
		["corpo-assaultsmg"] = { index = "corpo-assaultsmg", nome = "Corpo MTAR 21", filtro = "arma", type = "usar", funcao = false, descricao = "Corpo de uma arma de fogo, isso pode fazer um armamento letal!" },
        ["corpo-microsmg"] = { index = "corpo-microsmg", nome = "Corpo Micro SMG", filtro = "arma", type = "usar", funcao = false, descricao = "Corpo de uma arma de fogo, isso pode fazer um armamento letal!" },
        ["corpo-ak47"] = { index = "corpo-ak47", nome = "Corpo AK-47", filtro = "arma", type = "usar", funcao = false, descricao = "Corpo de uma arma de fogo, isso pode fazer um armamento letal!" },
        ["corpo-mp5"] = { index = "corpo-mp5", nome = "Corpo MP5", filtro = "arma", type = "usar", funcao = false, descricao = "Corpo de uma arma de fogo, isso pode fazer um armamento letal!" },
        ["corpo-pistolmk2"] = { index = "corpo-pistolmk2", nome = "Corpo FiveSeven", filtro = "arma", type = "usar", funcao = false, descricao = "Corpo de uma arma de fogo, isso pode fazer um armamento letal!" },
        ["corpo-revolver"] = { index = "corpo-revolver", nome = "Corpo Revolver", filtro = "arma", type = "usar", funcao = false, descricao = "Corpo de uma arma de fogo, isso pode fazer um armamento letal!" },
        ["corpo-thompson"] = { index = "corpo-thompson", nome = "Corpo Thompson", filtro = "arma", type = "usar", funcao = false, descricao = "Corpo de uma arma de fogo, isso pode fazer um armamento letal!" },
        ["placademetal"] = { index = "placademetal", nome = "Placa de Metal", filtro = "arma", type = "usar", funcao = false, descricao = "Placa resistente e geralmente utilizada para criação de armas!" },

        ["mola"] = { index = "mola", nome = "Mola", filtro = "arma", type = "usar", funcao = false, descricao = "Molas utilizadas para fabricação de uma arma de fogo" },
        ["gatilho"] = { index = "gatilho", nome = "Gatilho", filtro = "arma", type = "usar", funcao = false, descricao = "Gatilhos utilizadas para fabricação de uma arma de fogo" },
        ["capsula"] = { index = "capsula", nome = "Capsula", filtro = "arma", type = "usar", funcao = false, descricao = "Capsula utilizada para fabricação da munição de uma arma de fogo" },
        ["polvora"] = { index = "polvora", nome = "Polvora", filtro = "arma", type = "usar", funcao = false, descricao = "Polvora utilizada para fabricação da munição de uma arma de fogo" },
        ["carbono"] = { index = "carbono", nome = "Carbono", filtro = "arma", type = "usar", funcao = false, descricao = "Carbono utilizada para fabricação da munição de uma arma de fogo" },
        ["ferro"] = { index = "ferro", nome = "Ferro", filtro = "arma", type = "usar", funcao = false, descricao = "Ferro" },
        ["aco"] = { index = "aco", nome = "Aço", filtro = "arma", type = "usar", funcao = false, descricao = "Aço utilizado para fabricação de arma de fogo" },
        ["pecadearma"] = { index = "pecadearma", nome = "Peças de armas", filtro = "arma", type = "usar", funcao = false, descricao = "Peças de armas utilizada para fabricação de arma de fogo" },
        --------- [ ARMAS DE MÃO ] ------------
        ["wbody|WEAPON_DAGGER"] = { index = "adaga", nome = "Adaga", type = "equipar" },
        ["wbody|WEAPON_BAT"] = { index = "beisebol", nome = "Taco de Beisebol", type = "equipar" },
        ["wbody|WEAPON_BOTTLE"] = { index = "garrafa", nome = "Garrafa", type = "equipar" },
        ["wbody|WEAPON_CROWBAR"] = { index = "cabra", nome = "Pé de Cabra", type = "equipar" },
        ["wbody|WEAPON_FLASHLIGHT"] = { index = "lanterna", nome = "Lanterna", type = "equipar" },
        ["wbody|WEAPON_GOLFCLUB"] = { index = "golf", nome = "Taco de Golf", type = "equipar" },
        ["wbody|WEAPON_HAMMER"] = { index = "martelo", nome = "Martelo", type = "equipar" },
        ["wbody|WEAPON_HATCHET"] = { index = "machado", nome = "Machado", type = "equipar" },
        ["wbody|WEAPON_KNUCKLE"] = { index = "ingles", nome = "Soco-Inglês", type = "equipar" },
        ["wbody|WEAPON_KNIFE"] = { index = "faca", nome = "Faca", type = "equipar" },
        ["wbody|WEAPON_MACHETE"] = { index = "machete2", nome = "Machete", type = "equipar" },
        ["wbody|WEAPON_SWITCHBLADE"] = { index = "canivete", nome = "Canivete", type = "equipar" },
        ["wbody|WEAPON_NIGHTSTICK"] = { index = "cassetete", nome = "Cassetete", type = "equipar" },
        ["wbody|WEAPON_WRENCH"] = { index = "grifo", nome = "Chave de Grifo", type = "equipar"},
        ["wbody|WEAPON_BATTLEAXE"] = { index = "batalha", nome = "Machado de Batalha", type = "equipar"},
        ["wbody|WEAPON_POOLCUE"] = { index = "sinuca", nome = "Taco de Sinuca", type = "equipar" },
        ["wbody|WEAPON_STONE_HATCHET"] = { index = "pedra", nome = "Machado de Pedra", type = "equipar"},
		----------- [ ARMAS ] -------------	
        ["wbody|WEAPON_APPISTOL"] = { index = "appistol", nome = "Koch VP9", type = "equipar" },
        ["wbody|WEAPON_PISTOL"] = { index = "m1911", nome = "M1911", type = "equipar" },
        ["wbody|WEAPON_PISTOL_MK2"] = { index = "fiveseven", nome = "FN Five Seven", type = "equipar"},
        ["wbody|WEAPON_PISTOL50"] = { index = "desert", nome = "Desert Eagle", type = "equipar"},
        ["wbody|WEAPON_COMBATPISTOL"] = { index = "pistolammo", nome = "Glock 19", type = "equipar"  },
        ["wbody|WEAPON_STUNGUN"] = { index = "stungun", nome = "Taser", type = "equipar" },
        ["wbody|WEAPON_SNSPISTOL"] = { index = "amt380", nome = "AMT 380", type = "equipar"  },
        ["wbody|WEAPON_VINTAGEPISTOL"] = { index = "m1922", nome = "M1922", type = "equipar" },
        ["wbody|WEAPON_REVOLVER"] = { index = "magnum44", nome = "Magnum 44", type = "equipar" },
        ["wbody|WEAPON_MUSKET"] = { index = "winchester22", nome = "Winchester 22", type = "equipar" },
    --    ["wbody|GADGET_PARACHUTE"] = { index = "parachute", nome = "Paraquedas", type = "equipar" },
        ["wbody|WEAPON_FIREEXTINGUISHER"] = { index = "extintor", nome = "Extintor", type = "equipar" },
        ["wbody|WEAPON_MICROSMG"] = { index = "uzi", nome = "Uzi", type = "equipar" },
        ["wbody|WEAPON_SMG"] = { index = "smg", nome = "MP5", type = "equipar"},
        ["wbody|WEAPON_ASSAULTSMG"] = { index = "mtar21", nome = "MTAR-21", type = "equipar" },
        ["wbody|WEAPON_PUMPSHOTGUN"] = { index = "remington", nome = "Remington 870", type = "equipar"},
        ["wbody|WEAPON_CARBINERIFLE"] = { index = "m4a1", nome = "M4a1", type = "equipar"},
        ["wbody|WEAPON_ASSAULTRIFLE"] = { index = "ak47", nome = "AK-47", type = "equipar" },
        ["wbody|WEAPON_GUSENBERG"] = { index = "thompson", nome = "Thompson", type = "equipar"},		
        ["wbody|WEAPON_MACHINEPISTOL"] = { index = "tec9", nome = "Tec-9", type = "equipar"},
        ["wbody|WEAPON_PETROLCAN"] = { index = "combustivel", nome = "Combustivel", type = "equipar"},
        ["wbody|WEAPON_RAYPISTOL"] = { index = "raypistol", nome = "Ray pISTOL", type = "equipar"},
        ["wbody|WEAPON_SPECIALCARBINE_MK2"] = { index = "g36c", nome = "G36", type = "equipar"},
        ["wbody|WEAPON_HEAVYSNIPER_MK2"] = { index = "Sniper", nome = "Sniper", type = "equipar"},

    
        	----------- [ MUNIÇÃO DAS ARMAS ] ---------

            ["P-WEAPON_ASSAULTRIFLE"] = { index = "m-ak47", nome = "Pacote M.Ak-47", filtro = "box", type = "usar", funcao = false, descricao = "Caixa com 30 munições para a arma Ak-103" },
            ["P-WEAPON_PISTOL_MK2"] = { index = "m-fiveseven", nome = "Pacote M.Five Seven", filtro = "box", type = "usar", funcao = false, descricao = "Caixa com 30 munições para a arma Pistol MK2" },
            ["P-WEAPON_ASSAULTSMG"] = { index = "m-mtar21", nome = "Pacote M.MTAR 21", filtro = "box", type = "usar", funcao = false, descricao = "Caixa com 30 munições para a arma Assault SMG" },
            ["P-WEAPON_MICROSMG"] = { index = "m-uzi", nome = "Pacote M.Uzi", filtro = "box", type = "usar", funcao = false, descricao = "Caixa com 30 munições para a arma Micro SMG" },
            ["P-WEAPON_SMG"] = { index = "m-mp5", nome = "Pacote M.MP5", filtro = "box", type = "usar", funcao = false, descricao = "Caixa com 30 munições para a arma SMG" },
            ["P-WEAPON_REVOLVER"] = { index = "m-magnum44", nome = "Pacote M.Magnum 44", filtro = "box", type = "usar", funcao = false, descricao = "Caixa com 30 munições para a arma Revolver" },
            ["P-WEAPON_GUSENBERG"] = { index = "m-thompson", nome = "Pacote M.Thompson", filtro = "box", type = "usar", funcao = false, descricao = "Caixa com 30 munições para a arma Thompson" },
    
            ["wammo|WEAPON_APPISTOL"] = { index = "pistolammo", nome = "M.Koch VP9", type = "recarregar", filtro = "arma", funcao = false, descricao = "Recarregue as munições da sua arma"  },
            ["wammo|WEAPON_PISTOL"] = { index = "pistolammo", nome = "M.M1911", type = "recarregar", filtro = "arma", funcao = false, descricao = "Recarregue as munições da sua arma"  },
            ["wammo|WEAPON_PISTOL_MK2"] = { index = "pistolammo", nome = "M.FN Five Seven", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_PISTOL50"] = { index = "pistolammo", nome = "M.Desert Eagle", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_COMBATPISTOL"] = { index = "pistolammo", nome = "M.Glock 19", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_STUNGUN"] = { index = "m-taser", nome = "M.Taser", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_SNSPISTOL"] = { index = "pistolammo", nome = "M.AMT 380", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_VINTAGEPISTOL"] = { index = "pistolammo", nome = "M.M1922", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_REVOLVER"] = { index = "pistolammo", nome = "M.Magnum 44", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_MUSKET"] = { index = "sniperammo", nome = "M.Winchester 22", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_MICROSMG"] = { index = "smgammo", nome = "M.Uzi", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_SMG"] = { index = "smgammo", nome = "M.MP5", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_ASSAULTSMG"] = { index = "smgammo", nome = "M.MTAR-21", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_PUMPSHOTGUN"] = { index = "shotgunammo", nome = "M.Remington", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_CARBINERIFLE"] = { index = "rifleammo", nome = "M.M4A1", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_ASSAULTRIFLE"] = { index = "rifleammo", nome = "M.AK-47", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_GUSENBERG"] = { index = "rifleammo", nome = "M.Thompson", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_MACHINEPISTOL"] = { index = "smgammo", nome = "M.Tec-9", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_COMPACTRIFLE"] = { index = "rifleammo", nome = "M.Ak Compact", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_PETROLCAN"] = { index = "combustivel", nome = "Combustível", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_HEAVYSNIPER_MK2"] = { index = "sniperammo", nome = "Sniper", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
            ["wammo|WEAPON_SPECIALCARBINE_MK2"] = { index = "rifleammo", nome = "M.G36", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },

        ["GADGET_PARACHUTE"] = { index = "paraquedas", nome = "Paraquedas", type = "equipar" },


        ----- [ ITENS ROUPAS DA POLICIA ] -----
        ["farda-recruta"] = { index = "fardamentopm", nome = "Fardamento Recruta",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Recruta" },
        ["farda-soldado"] = { index = "fardamentopm", nome = "Fardamento Soldado",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Soldado" },
        ["farda-cabo"] = { index = "fardamentopm", nome = "Fardamento Cabo",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Cabo" },
        ["farda-sargento"] = { index = "fardamentopm", nome = "Fardamento Sargento",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Sargento" },
        ["farda-tenente"] = { index = "fardamentopm", nome = "Fardamento Tenente",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Tenente" },
        ["farda-speed"] = { index = "fardamentopm", nome = "Fardamento Speed",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Speed" },
        ["farda-gtm"] = { index = "fardamentopm", nome = "Fardamento G.T.M",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente G.T.M" },
        ["farda-graer"] = { index = "fardamentopm", nome = "Fardamento Graer",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Graer" },
        ["farda-got"] = { index = "fardamentopm", nome = "Fardamento G.O.T",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente G.O.T" },
        -------  [ ITENS ROUPAS DO HP ]  -----
        ["farda-medico"] = { index = "fardamentohp", nome = "Fardamento Medico",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme Hospital Medico" },
        ["farda-enfermeiro"] = { index = "fardamentohp", nome = "Fardamento Enfermeiro",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme Hospital Enfermaria" },

         ----- [ ITENS SEM ROUPAS  ] -----
        ["fardaoff1"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff2"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff3"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff4"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff5"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff6"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff7"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff8"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff9"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff10"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" }, 
        ["fardaoff11"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },         
      
	
    }
}

