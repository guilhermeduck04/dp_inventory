TableFilters = []
ItensFiltrados = []
resetarFilter = false
inchest = false
tipoSecondInventory = null
nomeDoBau = null
nomeTrunckChest = null
nomeHouse = null
tudo = false
metade = false
click = false
update = false
craftUpdate = false

const RESOURCE_NAME = typeof GetParentResourceName === 'function'
    ? GetParentResourceName()
    : 'dpn_inventory_chest';

function nuiPost(endpoint, data = {}, cb = null) {
    $.post(`https://${RESOURCE_NAME}/${endpoint}`, JSON.stringify(data))
        .done(cb)
        .fail((err) => {
            console.error(`Erro no NUI POST -> ${endpoint}`, err)
        });
}

var formatter = new Intl.NumberFormat(config.lang, {
    style: 'currency',
    currency: config.currency,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }),
  caftItens = [
    { item: 'nada', quantidade: 0 },
    { item: 'nada', quantidade: 0 },
    { item: 'nada', quantidade: 0 },
    { item: 'nada', quantidade: 0 },
    { item: 'nada', quantidade: 0 },
    { item: 'nada', quantidade: 0 },
    { item: 'nada', quantidade: 0 },
    { item: 'nada', quantidade: 0 },
    { item: 'nada', quantidade: 0 },
  ]

$(document).ready(function () {
  window.addEventListener('message', function (event) {
    tipoSecondInventory = event.data.secondAction
    if (event.data.url) ip = event.data.url
    
    switch (event.data.action) {
      case 'openInventory':
        $('#menu-principal').fadeIn()
        craftUpdate = false
        update = false
        verificarTipoInventory()
        requsetIdentity()
        requestItens()
        nomeDoBau = null
        break
        
      case 'updateInventory':
        update = true
        requsetIdentity()
        verificarTipoInventory()
        requestItens()
        break
        
      case 'closeInventory':
        $('#menu-principal').fadeOut()
        restFilter()
        $('.filter-menu').css('left', '23vw')
        $('.identity-inicial').css('left', '0')
        $('#box-menu-item').css('right', '0')
        $('.right-menu').css('right', '-14vw')
        $('.top-menu').css('top', '0')
        $('#box-menu-item-chest').css('left', '0')
        $('.right-menu').fadeOut()
        $('#box-menu-item').fadeOut()
        $('.identity-inicial').fadeOut()
        $('.filter-menu').fadeOut()
        $('.top-menu').fadeOut()
        $('#box-menu-item-chest').fadeOut()
        $('.craft').fadeOut()
        $('.margin-bottom-escolha').css('left', '8.8vw')
        $('.escolha-menu').css('opacity', '0.3')
        $('.escolha-menu.personagem').css('opacity', '1')
        break
    }
  })

  function verificarTipoInventory() {
    if (tipoSecondInventory === undefined || tipoSecondInventory === null) {
      inchest = false
    } else {
      inchest = true
    }
    
    if (inchest === true) {
      if (tipoSecondInventory != null && tipoSecondInventory != undefined) {
        $('.box-action').css('opacity', '0')
        $('.inventory-title-menu').hide()
        $('.person-menu-inventory').hide()
        $('.chest-title-menu').show()
        $('.person-menu-chest').show()
        $('.box-circle-mochila').css('opacity', '0')
        requestItemSecondInventory(tipoSecondInventory)
      }
    } else {
      if (inchest === false) {
        $('.box-action').css('opacity', '1')
        $('.inventory-title-menu').show()
        $('.person-menu-inventory').show()
        $('.chest-title-menu').hide()
        $('.person-menu-chest').hide()
        $('.box-circle-mochila').css('opacity', '1')
      }
    }
  }

  function formatMoney(value) {
    return value.toLocaleString('pt-BR')
  }

  function requestItemSecondInventory(secondType) {
    if (secondType === 'jaemuso') {
      $('.box-action').css('opacity', '1')
      $('.box-circle-mochila').css('opacity', '1')
      $('.left-menu-chest').css('opacity', '0')
      $('.name-car').html('Em uso')
      $('#box-menu-item-chest').html('')
      $('#box-menu-item-chest').append(`
        <div class="in-use"> 
          Alguém já está usando este inventário!
          <img src="${ip}/lock.png">
        </div>
      `)
      return
    }
    
    if (secondType === 'carroDeNpc') {
      $('.box-action').css('opacity', '1')
      $('.box-circle-mochila').css('opacity', '1')
      $('.left-menu-chest').css('opacity', '0')
      $('.name-car').html('Não registrado')
      $('#box-menu-item-chest').html('')
      $('#box-menu-item-chest').append(`
        <div class="in-use"> 
          Esse carro não está nos registros
          <img src="${ip}/lock.png" style="right: 11.6vw">
        </div>
      `)
      return
    }
    
    if (secondType === 'carroTrancado') {
      $('.box-action').css('opacity', '1')
      $('.box-circle-mochila').css('opacity', '1')
      $('.left-menu-chest').css('opacity', '0')
      $('.name-car').html('Trancado')
      $('#box-menu-item-chest').html('')
      $('#box-menu-item-chest').append(`
        <div class="in-use"> 
          Esse carro está trancado
          <img src="${ip}/lock.png" style="right: 9vw">
        </div>
      `)
      return
    }
    
nuiPost('requestItemSecondInventory', { tipo: secondType }, (response) => {
  $('.name-car').html(secondType)
  $('#box-menu-item-chest').html('')
  
  if (response.chest === false) {
    const sortedItems = response.itemTable.sort((a, b) => a.name > b.name ? 1 : -1)
    $('.left-menu-chest').css('opacity', '0')
    
    $('#box-menu-item-chest')
      .empty()
      .append(sortedItems.map(item => `
        <div class="slotChest">
          <div class="item-player venda" 
               data-item-price="${item.price}"
               data-item-amount="${item.amount}"
               data-item-type="${item.type}"
               data-item-index="${item.index}"
               data-item-peso="${item.peso}"
               data-item-key="${item.key}"
               data-item-name="${item.name}"
               data-item-desc="${item.descricao}"
               data-item-funcao="${item.funcao}"
               data-weapon-dano="${item.dano}"
               data-weapon-cadencia="${item.cadencia}"
               data-weapon-precisao="${item.precisao}"
               data-weapon-recoil="${item.recoil}"
               style="background-image: url('${ip}/${item.index}.png');">
            <div class="top-item">
              <div class="amount">R$: ${item.price}</div>
              <div class="peso">${item.peso.toFixed(1)}kg</div>
            </div>
            <div class="bottom-item">
              <div class="name-item">${item.name}
                <div class="typeFilter">${item.filter}</div>
              </div>
            </div>
          </div>
        </div>
      `).join(''))
    
    for (let i = 0; i < 50; i++) {
      $('#box-menu-item-chest').append('<div class="slotChest venda"></div>')
    }
    
    getHover()
    getDrag()
  }
 else if (response.chest === true) {
          $('.left-menu-chest').css('opacity', '1')
          nomeDoBau = secondType
          $('#box-menu-item-chest').html('')
          
          for (let i = 0; i < response.slots; i++) {
            $('#box-menu-item-chest').append(`
              <div class="slotChest chest" data-temItem="false" data-slotNovo="${i}"></div>
            `)
          }
          
          for (let i = 0; i < response.slots; i++) {
            if (response.tableChest[i]) {
              let item = response.tableChest[i]
              $('.slotChest').each(function() {
                let slotNovo = $(this).attr('data-slotNovo')
                if (Number(i) === Number(slotNovo)) {
                  const itemHtml = `
                    <div class="item-player chest" 
                         data-item-antigo="${i}"
                         data-item-amount="${item.amount}"
                         data-item-type="${item.type}"
                         data-item-index="${item.index}"
                         data-item-peso="${item.peso}"
                         data-item-key="${item.key}"
                         data-item-name="${item.name}"
                         data-item-desc="${item.descricao}"
                         data-item-funcao="${item.funcao}"
                         data-weapon-dano="${item.dano}"
                         data-weapon-cadencia="${item.cadencia}"
                         data-weapon-precisao="${item.precisao}"
                         data-weapon-recoil="${item.recoil}"
                         style="background-image: url('${ip}/${item.index}.png');">
                      <div class="top-item">
                        <div class="amount">${item.amount}x</div>
                        <div class="peso">${(item.peso * item.amount).toFixed(1)}kg</div>
                      </div>
                      <div class="bottom-item">
                        <div class="name-item">${item.name}
                          <div class="typeFilter">${item.filter}</div>
                        </div>
                      </div>
                    </div>
                  `
                  $(this).attr('data-temItem', 'true')
                  $(this).append(itemHtml)
                }
              })
            }
          }
          
        } else if (response.chest === 'TrunckChest') {
          $('.left-menu-chest').css('opacity', '1')
          nomeTrunckChest = response.nameCar
          $('#box-menu-item-chest').html('')
          $('.name-car').html(nomeTrunckChest)
          
          for (let i = 0; i < response.slots; i++) {
            $('#box-menu-item-chest').append(`
              <div class="slotChest trunckchest" data-temItem="false" data-slotNovo="${i}"></div>
            `)
          }
          
          for (let i = 0; i < response.slots; i++) {
            if (response.tableChest[i]) {
              let item = response.tableChest[i]
              $('.slotChest').each(function() {
                let slotNovo = $(this).attr('data-slotNovo')
                if (Number(i) === Number(slotNovo)) {
                  const itemHtml = `
                    <div class="item-player trunckChest" 
                         data-item-antigo="${i}"
                         data-item-amount="${item.amount}"
                         data-item-type="${item.type}"
                         data-item-index="${item.index}"
                         data-item-peso="${item.peso}"
                         data-item-key="${item.key}"
                         data-item-name="${item.name}"
                         data-item-desc="${item.descricao}"
                         data-item-funcao="${item.funcao}"
                         data-weapon-dano="${item.dano}"
                         data-weapon-cadencia="${item.cadencia}"
                         data-weapon-precisao="${item.precisao}"
                         data-weapon-recoil="${item.recoil}"
                         style="background-image: url('${ip}/${item.index}.png');">
                      <div class="top-item">
                        <div class="amount">${item.amount}x</div>
                        <div class="peso">${(item.peso * item.amount).toFixed(1)}kg</div>
                      </div>
                      <div class="bottom-item">
                        <div class="name-item">${item.name}
                          <div class="typeFilter">${item.filter}</div>
                        </div>
                      </div>
                    </div>
                  `
                  $(this).attr('data-temItem', 'true')
                  $(this).append(itemHtml)
                }
              })
            }
          }
          
        } else if (response.chest === 'house') {
          $('.left-menu-chest').css('opacity', '1')
          nomeHouse = response.nameHouse
          $('#box-menu-item-chest').html('')
          $('.name-car').html(nomeHouse)
          
          for (let i = 0; i < response.slots; i++) {
            $('#box-menu-item-chest').append(`
              <div class="slotChest house" data-temItem="false" data-slotNovo="${i}"></div>
            `)
          }
          
          for (let i = 0; i < response.slots; i++) {
            if (response.tableChest[i]) {
              let item = response.tableChest[i]
              $('.slotChest').each(function() {
                let slotNovo = $(this).attr('data-slotNovo')
                if (Number(i) === Number(slotNovo)) {
                  const itemHtml = `
                    <div class="item-player house" 
                         data-item-antigo="${i}"
                         data-item-amount="${item.amount}"
                         data-item-type="${item.type}"
                         data-item-index="${item.index}"
                         data-item-peso="${item.peso}"
                         data-item-key="${item.key}"
                         data-item-name="${item.name}"
                         data-item-desc="${item.descricao}"
                         data-item-funcao="${item.funcao}"
                         data-weapon-dano="${item.dano}"
                         data-weapon-cadencia="${item.cadencia}"
                         data-weapon-precisao="${item.precisao}"
                         data-weapon-recoil="${item.recoil}"
                         style="background-image: url('${ip}/${item.index}.png');">
                      <div class="top-item">
                        <div class="amount">${item.amount}x</div>
                        <div class="peso">${(item.peso * item.amount).toFixed(1)}kg</div>
                      </div>
                      <div class="bottom-item">
                        <div class="name-item">${item.name}
                          <div class="typeFilter">${item.filter}</div>
                        </div>
                      </div>
                    </div>
                  `
                  $(this).attr('data-temItem', 'true')
                  $(this).append(itemHtml)
                }
              })
            }
          }
        }
        
        updatePesoChest(response.tamanhoMyInv, response.tamanhoChest)
        getHover()
        getDrag()
      }
    )
    getHover()
    getDrag()
  }

function requsetIdentity() {
  nuiPost('requsetIdentity', {}, (response) => {
    $('.identidade-js')
      .empty()
      .html(`
        <div class="title-identity">
          <img src="app/dedao.png">
        </div>
        <div class="itens-identity">
          <div class="primeiro-identity primeiro">${config.nome}</div>
          <div class="primeiro-identity segundo">${response.nome} ${response.sobrenome}</div>
        </div>
        <div class="itens-identity">
          <div class="primeiro-identity primeiro">${config.idade}</div>
          <div class="primeiro-identity segundo">${response.idade} anos</div>
        </div>
        <div class="itens-identity">
          <div class="primeiro-identity primeiro">${config.passaporte}</div>
          <div class="primeiro-identity segundo">${response.id}</div>
        </div>
        <div class="itens-identity">
          <div class="primeiro-identity primeiro">${config.registro}</div>
          <div class="primeiro-identity segundo">${response.registro}</div>
        </div>
        <div class="itens-identity">
          <div class="primeiro-identity primeiro">${config.telefone}</div>
          <div class="primeiro-identity segundo">${response.telefone}</div>
        </div>
        <div class="itens-identity">
          <div class="primeiro-identity primeiro">${config.profissao}</div>
          <div class="primeiro-identity segundo">${response.emprego}</div>
        </div>
        <div class="itens-identity">
          <div class="primeiro-identity primeiro">${config.vip}</div>
          <div class="primeiro-identity segundo">${response.vip}</div>
        </div>
        <div class="itens-identity">
          <div class="primeiro-identity primeiro">${config.multa}</div>
          <div class="primeiro-identity segundo">${response.multas}</div>
        </div>
        <div class="itens-identity admin">
          <div class="primeiro-identity primeiro">${config.admin}</div>
          <div class="primeiro-identity segundo">${config.adminText}</div>
        </div>
      `)

    if (response.admin === true) {
      $('.itens-identity.admin').show()
    } else {
      $('.itens-identity.admin').hide()
    }

    $('.money').html(`
      <div class="carteira-box">
        <div class="title-carteira">carteira</div>
        <div class="saldinho saldo-carteira" data-count="${response.carteira}">
          ${formatter.format(response.carteira)}
        </div>
      </div>
      <div class="banco-box">
        <div class="title-banco">banco</div>
        <div class="saldinho saldo-banco" data-count="${response.banco}">
          ${formatter.format(response.banco)}
        </div>
      </div>
    `)

    if (update === false) {
      $('.saldinho').each(function() {
        let element = $(this)
        let count = element.attr('data-count')

        $({ countNum: element.text() }).animate(
          { countNum: count },
          {
            duration: 2000,
            easing: 'linear',
            step: function() {
              element.text(formatter.format(Math.floor(this.countNum)))
            },
            complete: function() {
              element.text(formatter.format(this.countNum))
            },
          }
        )
      })
    }
  })
}

function requestItens() {
  nuiPost('requestItens', {}, (response) => {
    $('#box-menu-item').html('')
    unidadesDesc = response.un
    numero = 0
    
    for (let i = 0; i < response.slot; i++) {
      if (i <= 4) {
        $('#box-menu-item').append(`
          <div class="slot" data-temItem="false" data-slotNovo="${i}">
            <div class="keyBind">
              <div class="title-keyBind">Keybind</div>
              <div class="number-keyBind">${i + 1}</div>
            </div>
          </div>
        `)
      } else {
        $('#box-menu-item').append(`
          <div class="slot" data-temItem="false" data-slotNovo="${i}"></div>
        `)
      }
    }
    
    for (let i = 0; i < response.slot2; i++) {
      if (response.inventario[i]) {
        let item = response.inventario[i]

        $('.slot').each(function() {
          let slotNovo = $(this).attr('data-slotNovo')

          if (Number(i) === Number(slotNovo)) {
            let baseHtml = `
              <div class="item-player inventory" 
                   data-item-antigo="${i}"
                   data-item-amount="${item.amount}"
                   data-item-type="${item.type}"
                   data-item-index="${item.index}"
                   data-item-peso="${item.peso}"
                   data-item-key="${item.key}"
                   data-item-name="${item.name}"
                   data-item-desc="${item.descricao}"
                   data-item-funcao="${item.funcao}"
                   data-weapon-dano="${item.dano}"
                   data-weapon-cadencia="${item.cadencia}"
                   data-weapon-precisao="${item.precisao}"
                   data-weapon-recoil="${item.recoil}"
                   style="background-image: url('${ip}/${item.index}.png');">

                <div class="top-item">
                  <div class="amount">${item.amount}x</div>
                  <div class="peso">${(item.peso * item.amount).toFixed(1)}kg</div>
                </div>

                <div class="bottom-item">
                  <div class="name-item">${item.name}
                    <div class="typeFilter">${item.filter}</div>
                  </div>
                </div>

                ${slotNovo <= 4 ? `
                  <div class="keyBind-usade">
                    KEYBIND ${Number(slotNovo) + 1}
                  </div>
                ` : ``}

              </div>
            `

            $(this).attr('data-temItem', 'true')
            $(this).empty().append(baseHtml)
          }
        })
      }
    }
    
    for (let a = 0; a < response.slotsComrpavel; a++) {
      $('#box-menu-item').append(`
        <div class="slotVenda">
          <div class="price">Compre esse slot por <br> <b>$${response.slotPrice}</b></div>
          <div class="button-slot-buy">Comprar</div>
        </div>
      `)
    }
    
    $('.button-slot-buy')
      .unbind()
      .click(function() {
        nuiPost('buySlot', {})
        let audio = new Audio('vendido.ogg')
        audio.volume = 1
        audio.play()
      })
    
    let atualPeso = Number(response.atualPeso)
    let maximoPeso = Number(response.maximoPeso)
    let pesoRestante = maximoPeso - atualPeso
    let pesoPercentual = atualPeso / maximoPeso
    
    $('.peso-texto').html(atualPeso.toFixed(1) + '/' + maximoPeso.toFixed(1))
    $('.peso-sobrando').html(pesoRestante.toFixed(1) + ' kg sobrando')
    
    updatePeso(pesoPercentual, maximoPeso)
    getHover()
    getDrag()
    
    if (craftUpdate === false) {
      $('#box-menu-item').fadeIn()
      $('.identity-inicial').fadeIn()
      $('.filter-menu').fadeIn()
      $('.right-menu').fadeIn()
      $('.top-menu').fadeIn()
      $('#box-menu-item-chest').fadeIn()
      
      $('.right-menu').css('right', '0vw')
      $('.filter-menu').css('left', '39vw')
      $('.identity-inicial').css('left', '10vw')
      $('#box-menu-item').css('right', '16.5vw')
      $('.top-menu').css('top', '1.4vw')
      $('#box-menu-item-chest').css('left', '5vw')
      $('.all-loading').hide()
    }
  })
}
  
document.onkeyup = function(event) {
    if (event.which == 27) {
        nuiPost('closeInventory', {}, function() {})
    }
}
})

function verificarItem() {
    craftUpdate = true
    $('.result-craft').html('')

    nuiPost('updateCraft', { tabela: caftItens })
    nuiPost('getResultCraft', {}, (response) => {
        if (response.resultado && response.quantidade) {
            $('.result-craft').html(`
                <div>${response.quantidade}</div>
                <div>${response.resultado}</div>
            `)
            $('.result-craft').css('opacity', '1')
        }

        updateDragCraft()
    })
}

function restFilter() {
  $('.filtro-button').css('filter', 'invert(0%)')
  TableFilters = []
  resetarFilter = true
  $('.filtro-button').attr('click', 'false')
  filterItens()
  document.getElementById('barra-pesquisa').value = ''
}

function getDrag() {
  $('.slotChest').droppable({
    hoverClass: 'hoverControl2',
    drop: function(event, ui) {
      if (ui.draggable.hasClass('chest')) {
        let newSlot = $(this).attr('data-slotNovo')
        let oldSlot = ui.draggable.data('item-antigo')
        let itemKey = ui.draggable.data('item-key')
        
        if (newSlot != oldSlot && itemKey && nomeDoBau != null) {
          let amount = document.getElementById('quantidade').value
          
          if (metade === true && tudo === false) {
            amount = Number(ui.draggable.data('item-amount')) / 2
          } else if (tudo === true && metade === false) {
            amount = Number(ui.draggable.data('item-amount'))
          }
          
          if (amount < 1) amount = 1
          amount = parseInt(amount)
          
          if (Number(amount) > 0) {
            nuiPost('moverItemChest', {
              item: itemKey,
              oldSlot: oldSlot,
              newSlot: newSlot,
              amount: parseInt(amount),
              chest: nomeDoBau,
            })
            let audio = new Audio('slot.ogg')
            audio.volume = 1
            audio.play()
          }
        }
      }
      
      if (ui.draggable.hasClass('trunckChest')) {
        let newSlot = $(this).attr('data-slotNovo')
        let oldSlot = ui.draggable.data('item-antigo')
        let itemKey = ui.draggable.data('item-key')
        
        if (newSlot != oldSlot && itemKey && nomeTrunckChest != null) {
          let amount = document.getElementById('quantidade').value
          
          if (metade === true && tudo === false) {
            amount = Number(ui.draggable.data('item-amount')) / 2
          } else if (tudo === true && metade === false) {
            amount = Number(ui.draggable.data('item-amount'))
          }
          
          if (amount < 1) amount = 1
          amount = parseInt(amount)
          
          if (Number(amount) > 0) {
              nuiPost('moverItemTrunckChest', {
                item: itemKey,
                oldSlot: oldSlot,
                newSlot: newSlot,
                amount: parseInt(amount),
                trunck: nomeTrunckChest,
              })
            let audio = new Audio('slot.ogg')
            audio.volume = 1
            audio.play()
          }
        }
      } else if (ui.draggable.hasClass('house')) {
        let newSlot = $(this).attr('data-slotNovo')
        let oldSlot = ui.draggable.data('item-antigo')
        let itemKey = ui.draggable.data('item-key')
        
        if (newSlot != oldSlot && itemKey && nomeHouse != null) {
          let amount = document.getElementById('quantidade').value
          
          if (metade === true && tudo === false) {
            amount = Number(ui.draggable.data('item-amount')) / 2
          } else if (tudo === true && metade === false) {
            amount = Number(ui.draggable.data('item-amount'))
          }
          
          if (amount < 1) amount = 1
          amount = parseInt(amount)
          
          if (Number(amount) > 0) {
           nuiPost('moverItemHouse', {
              item: itemKey,
              oldSlot: oldSlot,
              newSlot: newSlot,
              amount: parseInt(amount),
              trunck: nomeHouse,
            })
            let audio = new Audio('slot.ogg')
            audio.volume = 1
            audio.play()
          }
        }
      } else if (ui.draggable.hasClass('inventory')) {
        if ($(this).hasClass('chest')) {
          let newSlot = $(this).attr('data-slotNovo')
          let oldSlot = ui.draggable.data('item-antigo')
          let itemKey = ui.draggable.data('item-key')
          
          if (newSlot != oldSlot && itemKey && nomeDoBau != null) {
            let amount = document.getElementById('quantidade').value
            
            if (metade === true && tudo === false) {
              amount = Number(ui.draggable.data('item-amount')) / 2
            } else if (tudo === true && metade === false) {
              amount = Number(ui.draggable.data('item-amount'))
            }
            
            if (amount < 1) amount = 1
            amount = parseInt(amount)
            
            if (Number(amount) > 0) {
              nuiPost('colocarItemInventory', {
                item: itemKey,
                oldSlot: oldSlot,
                newSlot: newSlot,
                amount: parseInt(amount),
                chest: nomeDoBau,
              })
              let audio = new Audio('slot.ogg')
              audio.volume = 1
              audio.play()
            }
          }
        } else if ($(this).hasClass('venda')) {
          let oldSlot = ui.draggable.data('item-antigo')
          let itemKey = ui.draggable.data('item-key')
          
          if (itemKey && oldSlot) {
            let amount = document.getElementById('quantidade').value
            
            if (metade === true && tudo === false) {
              amount = Number(ui.draggable.data('item-amount')) / 2
            } else if (tudo === true && metade === false) {
              amount = Number(ui.draggable.data('item-amount'))
            }
            
            if (amount < 1) amount = 1
            
            if (Number(amount) > 0) {
              nuiPost('venderItem', {
                item: itemKey,
                slot: oldSlot,
                amount: parseInt(amount),
              })
              let audio = new Audio('slot.ogg')
              audio.volume = 1
              audio.play()
            }
          }
        } else if ($(this).hasClass('trunckchest')) {
          let newSlot = $(this).attr('data-slotNovo')
          let oldSlot = ui.draggable.data('item-antigo')
          let itemKey = ui.draggable.data('item-key')
          
          if (newSlot != oldSlot && itemKey && nomeTrunckChest != null) {
            let amount = document.getElementById('quantidade').value
            
            if (metade === true && tudo === false) {
              amount = Number(ui.draggable.data('item-amount')) / 2
            } else if (tudo === true && metade === false) {
              amount = Number(ui.draggable.data('item-amount'))
            }
            
            if (amount < 1) amount = 1
            amount = parseInt(amount)
            
            if (Number(amount) > 0) {
              nuiPost('colocarItemTrunkInventory', {
                item: itemKey,
                oldSlot: oldSlot,
                newSlot: newSlot,
                amount: parseInt(amount),
                chest: nomeTrunckChest,
              })
              let audio = new Audio('slot.ogg')
              audio.volume = 1
              audio.play()
            }
          }
        } else if ($(this).hasClass('house')) {
          let newSlot = $(this).attr('data-slotNovo')
          let oldSlot = ui.draggable.data('item-antigo')
          let itemKey = ui.draggable.data('item-key')
          
          if (newSlot != oldSlot && itemKey && nomeHouse != null) {
            let amount = document.getElementById('quantidade').value
            
            if (metade === true && tudo === false) {
              amount = Number(ui.draggable.data('item-amount')) / 2
            } else if (tudo === true && metade === false) {
              amount = Number(ui.draggable.data('item-amount'))
            }
            
            if (amount < 1) amount = 1
            amount = parseInt(amount)
            
            if (Number(amount) > 0) {
              nuiPost('colocarItemHouse', {
                item: itemKey,
                oldSlot: oldSlot,
                newSlot: newSlot,
                amount: parseInt(amount),
                chest: nomeHouse,
              })
              let audio = new Audio('slot.ogg')
              audio.volume = 1
              audio.play()
            }
          }
        }
      }
    },
  })
  
  $('.slot').droppable({
    hoverClass: 'hoverControl2',
    drop: function(event, ui) {
      if (ui.draggable.hasClass('inventory')) {
        let newSlot = $(this).attr('data-slotNovo')
        let oldSlot = ui.draggable.data('item-antigo')
        
        if (newSlot && newSlot != oldSlot) {
          let itemKey = ui.draggable.data('item-key')
          if ((itemKey && oldSlot) || (itemKey && oldSlot === 0)) {
            let amount = document.getElementById('quantidade').value
            
            if (metade === true && tudo === false) {
              amount = Number(ui.draggable.data('item-amount')) / 2
            } else if (tudo === true && metade === false) {
              amount = Number(ui.draggable.data('item-amount'))
            }
            
            if (amount < 1) amount = 1
            amount = parseInt(amount)
            
            if (Number(amount) > 0) {
              nuiPost('moverItem', {
                item: itemKey,
                oldSlot: oldSlot,
                newSlot: newSlot,
                amount: parseInt(amount),
              })
              let audio = new Audio('slot.ogg')
              audio.volume = 1
              audio.play()
              restFilter()
            }
          }
        }
      } else if (ui.draggable.hasClass('chest')) {
        let newSlot = $(this).attr('data-slotNovo')
        let oldSlot = ui.draggable.data('item-antigo')
        
        if (newSlot) {
          let itemKey = ui.draggable.data('item-key')
          if (itemKey && nomeDoBau != null) {
            let amount = document.getElementById('quantidade').value
            
            if (metade === true && tudo === false) {
              amount = Number(ui.draggable.data('item-amount')) / 2
            } else if (tudo === true && metade === false) {
              amount = Number(ui.draggable.data('item-amount'))
            }
            
            if (amount < 1) amount = 1
            amount = parseInt(amount)
            
            if (Number(amount) > 0) {
              nuiPost('retirarItemChest', {
                item: itemKey,
                oldSlot: oldSlot,
                newSlot: newSlot,
                amount: parseInt(amount),
                chest: nomeDoBau,
              })
              let audio = new Audio('slot.ogg')
              audio.volume = 1
              audio.play()
            }
          }
        }
      } else if (ui.draggable.hasClass('trunckChest')) {
        let newSlot = $(this).attr('data-slotNovo')
        let oldSlot = ui.draggable.data('item-antigo')
        
        if (newSlot) {
          let itemKey = ui.draggable.data('item-key')
          if (itemKey && nomeTrunckChest != null) {
            let amount = document.getElementById('quantidade').value
            
            if (metade === true && tudo === false) {
              amount = Number(ui.draggable.data('item-amount')) / 2
            } else if (tudo === true && metade === false) {
              amount = Number(ui.draggable.data('item-amount'))
            }
            
            if (amount < 1) amount = 1
            amount = parseInt(amount)
            
            if (Number(amount) > 0) {
              nuiPost('retirarItemTrunk', {
                item: itemKey,
                oldSlot: oldSlot,
                newSlot: newSlot,
                amount: parseInt(amount),
                chest: nomeTrunckChest,
              })
              let audio = new Audio('slot.ogg')
              audio.volume = 1
              audio.play()
            }
          }
        }
      } else if (ui.draggable.hasClass('house')) {
        let newSlot = $(this).attr('data-slotNovo')
        let oldSlot = ui.draggable.data('item-antigo')
        
        if (newSlot) {
          let itemKey = ui.draggable.data('item-key')
          if (itemKey && nomeHouse != null) {
            let amount = document.getElementById('quantidade').value
            
            if (metade === true && tudo === false) {
              amount = Number(ui.draggable.data('item-amount')) / 2
            } else if (tudo === true && metade === false) {
              amount = Number(ui.draggable.data('item-amount'))
            }
            
            if (amount < 1) amount = 1
            amount = parseInt(amount)
            
            if (Number(amount) > 0) {
              nuiPost('retirarItemHouse', {
                item: itemKey,
                oldSlot: oldSlot,
                newSlot: newSlot,
                amount: parseInt(amount),
                chest: nomeHouse,
              })
              let audio = new Audio('slot.ogg')
              audio.volume = 1
              audio.play()
            }
          }
        }
      }
      
      let itemPrice = ui.draggable.attr('data-item-price')
      if (itemPrice) {
        let itemKey = ui.draggable.data('item-key')
        let amount = document.getElementById('quantidade').value
        let newSlot = $(this).attr('data-slotNovo')
        
        if (parseInt(amount) > 0) {
          amount = parseInt(amount)
          nuiPost('buyItem', {
            item: itemKey,
            preco: itemPrice,
            newSlot: newSlot,
            amount: amount,
          })
          let audio = new Audio('slot.ogg')
          audio.volume = 1
          audio.play()
        }
      }
      
      let craftItem = ui.draggable.data('item-craft')
      let craftIndex = ui.draggable.data('index-craft')
      let craftAmount = ui.draggable.data('amount-craft')
      let newSlot = $(this).attr('data-slotNovo')
      
      if (craftItem && craftAmount) {
        nuiPost('resgatarItem', {
          slot: newSlot,
          quantidade: craftAmount,
          item: craftItem,
          index: craftIndex,
        })
        
        caftItens = [
          { item: 'nada', quantidade: 0 },
          { item: 'nada', quantidade: 0 },
          { item: 'nada', quantidade: 0 },
          { item: 'nada', quantidade: 0 },
          { item: 'nada', quantidade: 0 },
          { item: 'nada', quantidade: 0 },
          { item: 'nada', quantidade: 0 },
          { item: 'nada', quantidade: 0 },
          { item: 'nada', quantidade: 0 },
        ]
        
        $('.slot-craft').attr('hasItem', 'false')
        $('.slot-craft').css('background-image', '')
        $('.slot-craft').html('')
        verificarItem()
      }
    },
  })
  
  $('.slot-craft').droppable({
    hoverClass: 'hoverControl3',
    drop: function(event, ui) {
      if ($(this).attr('hasItem') != 'true') {
        let itemIndex = ui.draggable.data('item-index')
        let itemKey = ui.draggable.data('item-index')
        let currentSlot = $(this)
        
        if (itemIndex != undefined) {
          let amount = document.getElementById('quantidade').value
          let maxAmount = parseInt(ui.draggable.data('item-amount'))
          
          if (metade === true && tudo === false) {
            amount = parseInt(ui.draggable.data('item-amount')) / 2
          } else if (tudo === true && metade === false) {
            amount = parseInt(ui.draggable.data('item-amount'))
          }
          
          if (amount < 1) amount = 1
          amount = parseInt(amount)
          
          if (parseInt(amount) <= parseInt(maxAmount) && amount > 0) {
            amount = parseInt(amount)
            currentSlot.html(`
              <div class="amount-craft">${amount}x</div>
              <div class="name-craft">${itemIndex}</div>
            `)
            currentSlot.css('opacity', '1')
            let audio = new Audio('slot.ogg')
            audio.volume = 1
            audio.play()
            currentSlot.attr('hasItem', 'true')
            currentSlot.css('background-image', "url('" + ip + '/' + itemIndex + ".png')")
            
            let slotClass = currentSlot.attr('class').split(' ')[1]
            let oldSlot = ui.draggable.data('item-antigo')
            
            caftItens[parseInt(slotClass)].item = itemIndex
            caftItens[parseInt(slotClass)].quantidade = parseInt(amount)
            
            nuiPost('craftItemRemove', {
              item: itemKey,
              oldSlot: oldSlot,
              amount: parseInt(amount),
            })
            verificarItem()
          }
        }
      }
    },
  })
  
  $('.slot-craft')
    .unbind()
    .dblclick(function() {
      $(this).attr('hasItem', 'false')
      $(this).css('background-image', '')
      $(this).html('')
      let currentSlot = $(this)
      let slotClass = currentSlot.attr('class').split(' ')[1]
      let itemName = caftItens[Number(slotClass)].item
      let itemAmount = caftItens[Number(slotClass)].quantidade
      
      nuiPost('craftItemDbClick', {
        item: itemName,
        amount: parseInt(itemAmount),
      })
      
      caftItens[Number(slotClass)].item = 'nada'
      caftItens[Number(slotClass)].quantidade = 0
      $('.slot-craft').css('opacity', '0.6')
      verificarItem()
    })
  
  $('.item-player').draggable({
    helper: 'clone',
    appendTo: '#menu-principal',
    zIndex: 99999,
    revert: 'invalid',
    opacity: 1,
    start: function(event, ui) {
      $(this).children().children('img').hide()
      let element = $(this)
      element.addClass('active')
      $('.desc-normal').show()
    },
    stop: function() {
      $(this).children().children('img').show()
      let element = $(this)
      element.removeClass('active')
    },
  })

$('.item-player')
  .off('contextmenu')
  .on('contextmenu', function(event) {
    event.preventDefault()
    event.stopPropagation()

    let itemType = $(this).data('item-type')
    let itemKey = $(this).data('item-key')
    let slot = $(this).data('item-antigo')
    let amount = document.getElementById('quantidade').value

    if (metade === true && tudo === false) {
      amount = Number($(this).data('item-amount')) / 2
    } else if (tudo === true && metade === false) {
      amount = Number($(this).data('item-amount'))
    }

    if (amount < 1) amount = 1
    amount = parseInt(amount)

    if (!itemKey || slot === undefined || slot === null) {
      return false
    }

    nuiPost('usarItemFechar', {
      item: itemKey,
      amount: amount,
      type: itemType,
      slot: slot
    })

    return false
  })
  
  $('.action').droppable({
    hoverClass: 'actionDropp',
    drop: function(event, ui) {
      if ($(this).hasClass('usar')) {
        let itemType = ui.draggable.data('item-type')
        let itemKey = ui.draggable.data('item-key')
        let slot = ui.draggable.data('item-antigo')
        let amount = document.getElementById('quantidade').value
        
        if (metade === true && tudo === false) {
          amount = Number(ui.draggable.data('item-amount')) / 2
        } else if (tudo === true && metade === false) {
          amount = Number(ui.draggable.data('item-amount'))
        }
        
        if (amount < 1) amount = 1
        amount = parseInt(amount)
        
        nuiPost('usarItem', {
          item: itemKey,
          amount: parseInt(amount),
          type: itemType,
          slot: slot,
        })
      } else if ($(this).hasClass('enviar')) {
        let itemKey = ui.draggable.data('item-key')
        let amount = document.getElementById('quantidade').value
        let slot = ui.draggable.data('item-antigo')
        
        if (metade === true && tudo === false) {
          amount = Number(ui.draggable.data('item-amount')) / 2
        } else if (tudo === true && metade === false) {
          amount = Number(ui.draggable.data('item-amount'))
        }
        
        if (amount < 1) amount = 1
        amount = parseInt(amount)
        
        if (amount > 0) {
          nuiPost('enviarItem', {
          item: itemKey,
          amount: parseInt(amount),
          slot: slot,
        })
        }
      } else if ($(this).hasClass('dropar')) {
        let itemKey = ui.draggable.data('item-key')
        let amount = document.getElementById('quantidade').value
        let slot = ui.draggable.data('item-antigo')
        
        if (metade === true && tudo === false) {
          amount = Number(ui.draggable.data('item-amount')) / 2
        } else if (tudo === true && metade === false) {
          amount = Number(ui.draggable.data('item-amount'))
        }
        
        if (amount < 1) amount = 1
        amount = parseInt(amount)
        
        if (amount > 0) {
          nuiPost('droparItem', {
          item: itemKey,
          amount: parseInt(amount),
          slot: slot,
        })
        }
      }
    },
  })
}

$('.dividendo')
  .unbind()
  .click(function() {
    if (click === false) {
      $('.closeDividendo').empty()
      $('.dividendo').removeClass('active')
      $('.closeDividendo').removeClass()
      $(this).addClass('active')
      $(this).append(`
        <div class="closeDividendo">
          <img src="${ip}/close.png">
        </div>
      `)
      
      let quantidadeInput = document.querySelector('#quantidade')
      quantidadeInput.disabled = true
      $('#quantidade').css('opacity', '0.5')
      document.getElementById('quantidade').value = '🔒'
      
      if ($(this).hasClass('metade-item')) {
        tudo = false
        metade = true
      } else if ($(this).hasClass('todos-itens')) {
        tudo = true
        metade = false
      }
    }
    updateCloseBind()
  })

function updateCloseBind() {
  $('.closeDividendo').click(function() {
    click = true
    $('.closeDividendo').empty()
    $('.dividendo').removeClass('active')
    $('.closeDividendo').removeClass()
    tudo = false
    metade = false
    
    let quantidadeInput = document.querySelector('#quantidade')
    quantidadeInput.disabled = false
    $('#quantidade').css('opacity', '1')
    document.getElementById('quantidade').value = ''
    
    setTimeout(() => {
      click = false
    }, 300)
  })
}

$('.escolha-menu')
  .unbind()
  .click(function() {
    $('.escolha-menu').css('opacity', '0.3')
    
    if ($(this).hasClass('identidade')) {
      $('.weapon-box').fadeOut()
      $('.margin-bottom-escolha').css('left', '18.8vw')
      $(this).css('opacity', '1')
      $('.identity-inicial').slideUp()
      $('.escolha-menu.personagem').html('Identidade')
      $('.hud').fadeOut()
      setTimeout(() => {
        $('.craft').slideDown()
        $('.filter-menu').slideDown()
      }, 300)
    }
    
    if ($(this).hasClass('personagem')) {
      $('.weapon-box').fadeOut()
      $('.margin-bottom-escolha').css('left', '8.8vw')
      $(this).css('opacity', '1')
      $('.craft').slideUp()
      $('.escolha-menu.personagem').html('Identidade')
      setTimeout(() => {
        $('.identity-inicial').slideDown()
        $('.hud').fadeIn()
        $('.filter-menu').slideDown()
      }, 300)
    }
  })

function updateDragCraft() {
  $('.result-item-player').draggable({
    helper: 'clone',
    appendTo: '#menu-principal',
    zIndex: 99999,
    revert: 'invalid',
    opacity: 1,
    start: function(event, ui) {
      $(this).children().children('img').hide()
      let element = $(this)
      element.addClass('active')
    },
    stop: function() {
      $(this).children().children('img').show()
      let element = $(this)
      element.removeClass('active')
    },
  })
}

function getHover() {
  $('.item-player').hover(
    function() {
      if ($(this).hasClass('venda')) {
        let price = $(this).data('item-price')
        $(this).append(`
          <div class="principal-price">
            <div class="hover-price">
              <span>${price},00</span>
            </div>
          </div>
        `)
      }
      
      $('#box-menu-item').css('height', '29vw')
      $('.desc-normal').hide()
      $('.desc-weapon').hide()
      $('.descricao-menu').show()
      
      let itemName = $(this).data('item-name')
      let itemPeso = $(this).data('item-peso')
      let itemIndex = $(this).data('item-index')
      let itemType = $(this).data('item-type')
      let itemDesc = $(this).data('item-desc')
      let itemFuncao = $(this).data('item-funcao')
      let unidades = unidadesDesc
      
      $('.item-name-desc').html(itemName)
      $('.bloco-image').css('background-image', 'url("' + ip + '/' + itemIndex + '.png")')
      
      if (itemType === 'usar' || itemFuncao === 'Arma utilizada para prática de atividades legais e ilegais') {
        $('.desc-normal').show()
        $('.primeira-descricao').html(itemDesc)
        $('.peso-descricao span').html(itemPeso + 'kg por unidade (' + unidades + 'un = ' + Number(itemPeso) * unidades + 'kg)')
        
        if (itemFuncao === false) {
          $('.funcao-descricao').hide()
          $('.peso-descricao').css('top', '1.3vw')
        } else {
          $('.peso-descricao').css('top', '0vw')
          $('.funcao-descricao').show()
          $('.funcao-descricao').html('<b>Função: </b> ' + itemFuncao)
        }
      } else if (itemType === 'equipar') {
        let recoil = $(this).data('weapon-recoil')
        let damage = $(this).data('weapon-dano')
        let cadencia = $(this).data('weapon-cadencia')
        let precisao = $(this).data('weapon-precisao')
        
        if (cadencia) $('.frontbar.cadencia').width(cadencia + '%')
        if (damage) $('.frontbar.dano').width(damage + '%')
        if (recoil) $('.frontbar.recuo').width(recoil + '%')
        if (precisao) $('.frontbar.precisao').width(precisao + '%')
        $('.desc-weapon').show()
      }
    },
    function() {
      $('#box-menu-item').css('height', '33vw')
      $('.descricao-menu').hide()
      $('.principal-price').empty()
    }
  )
}

circulo = new ProgressBar.Circle(circle, {
  strokeWidth: 10,
  easing: 'easeInOut',
  duration: 1400,
  color: '#ffffff',
  trailColor: '#8080802c',
  trailWidth: 8.5,
})

circulochest = new ProgressBar.Circle(circleChest, {
  strokeWidth: 10,
  easing: 'easeInOut',
  duration: 1400,
  color: '#ffffff',
  trailColor: '#8080802c',
  trailWidth: 8.5,
})

function updatePesoChest(atualPeso, maximoPeso) {
  let percentual = atualPeso / maximoPeso
  let pesoRestante = maximoPeso - atualPeso
  circulochest.animate(percentual.toFixed(1))
  $('.peso-sobrando-chest').html(pesoRestante.toFixed(1) + 'kg sobrando')
  $('.peso-texto-chest').html(atualPeso.toFixed(1) + '/' + maximoPeso.toFixed(1))
}

function updatePeso(percentual, maxPeso) {
  $('.circle-mochila').css('background', 'rgba(133, 133, 133, 0.356)')
  $('.circle-mochila').css('box-shadow', '')
  circulo.animate(percentual)
  
  if (maxPeso === 90) {
    $('.circle-mochila').css('background', 'white')
    $('.circle-mochila').css('box-shadow', '0px 0px 7px 1px #ffffffb0')
  } else if (maxPeso === 75) {
    $('.circle-mochila.1').css('background', 'white')
    $('.circle-mochila.2').css('background', 'white')
    $('.circle-mochila.1').css('box-shadow', '0px 0px 7px 1px #ffffffb0')
    $('.circle-mochila.2').css('box-shadow', '0px 0px 7px 1px #ffffffb0')
  } else if (maxPeso === 51) {
    $('.circle-mochila.1').css('background', 'white')
    $('.circle-mochila.1').css('box-shadow', '0px 0px 7px 1px #ffffffb0')
  } else if (maxPeso === 6) {
    $('.circle-mochila').css('background', 'rgba(133, 133, 133, 0.356)')
    $('.circle-mochila').css('box-shadow', '')
  }
}

function filterItens() {
  if (resetarFilter == true) {
    $('.item-player').show()
  } else {
    $('.item-player').css('display', 'none')
    for (let i = 0; i < TableFilters.length; i++) {
      let filterValue = TableFilters[i]
      let typeFilters = $('.typeFilter')
      
      for (let a = 0; a < typeFilters.length; a++) {
        if (typeFilters[a].textContent === filterValue) {
          for (let b = 0; b < typeFilters.length; b++) {
            let item = document.getElementsByClassName('item-player')[b]
            let itemFilter = item.querySelector('.typeFilter')
            if (itemFilter.textContent === typeFilters[a].textContent) {
              item.style.display = 'block'
            }
          }
        }
      }
    }
  }
}

$('.clear-filter').click(function() {
  restFilter()
  let audio = new Audio('slot.ogg')
  audio.volume = 1
  audio.play()
})

$('.filtro-button').click(function() {
  $('.filtro-button').css('filter', 'invert(0%)')
  $(this).css('filter', 'invert(100%)')
  $(this).attr('click', 'true')
  TableFilters = []
  TableFilters.push($(this).attr('class').split(' ')[1])
  resetarFilter = false
  filterItens()
  document.getElementById('barra-pesquisa').value = ''
  let audio = new Audio('slot.ogg')
  audio.volume = 1
  audio.play()
})

function pesquisar() {
  $('.filtro-button').css('filter', 'invert(0%)')
  TableFilters = []
  resetarFilter = true
  $('.filtro-button').attr('click', 'false')
  filterItens()
  
  let input = document.getElementById('barra-pesquisa')
  let filter = input.value.toUpperCase()
  let container = document.getElementById('box-menu-item')
  let items = container.getElementsByClassName('item-player')
  
  for (let i = 0; i < items.length; i++) {
    let nameElement = items[i].getElementsByClassName('name-item')[0]
    let nameValue = nameElement.textContent || nameElement.innerText
    if (nameValue.toUpperCase().indexOf(filter) > -1) {
      items[i].style.display = ''
    } else {
      items[i].style.display = 'none'
    }
  }
}

$('#barra-pesquisa').hover(
  function() {
    $('.toltip-pesquisa').show()
  },
  function() {
    $('.toltip-pesquisa').hide()
  }
)