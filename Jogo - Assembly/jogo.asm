jmp main
;---- Declaracao de Variaveis Globais -----
; Sao todas aquelas que precisam ser vistas por mais de uma funcao: Evita a passagem de parametros!!!
; As variaveis locais de cada funcao serao alocadas nos Registradores internos = r0 - r7
RNG: var #1
MOD_NUMBER: var #1
static MOD_NUMBER + #0, #113
MOD_OFFSET: var #1
static MOD_OFFSET + #0, #7
MOD_MULTIPLY: var #1
static MOD_MULTIPLY + #0, #23

; Status e Itens do Jogador
ATK: var #1
static ATK + #0, #0
DEF: var #1
static DEF + #0, #0
SPA: var #1
static SPA + #0, #0
SPD: var #1
static SPD + #0, #0
SPE: var #1
static SPE + #0, #0
HP: var #1
static HP + #0, #0
POCAO: var #1
static POCAO + #0, #0
ATKUP: var #1
static ATKUP + #0, #0
DEFUP: var #1
static DEFUP + #0, #0
PONTOS: var #1
static PONTOS + #0, #90
MOEDAS: var #1
static MOEDAS + #0, #20

; Última Tecla Pressionada
; Importante para evitar teclas de serem apertadas muito rapidamente
ULTIMA_TECLA: var #1
static ULTIMA_TECLA + #0, #255

; Status e Itens do Inimigo
ATK_INIMIGO: var #1
static ATK_INIMIGO + #0, #20
DEF_INIMIGO: var #1
static DEF_INIMIGO + #0, #25
SPA_INIMIGO: var #1
static SPA_INIMIGO + #0, #20
SPD_INIMIGO: var #1
static SPD_INIMIGO + #0, #25
SPE_INIMIGO: var #1
static SPE_INIMIGO + #0, #25
HP_INIMIGO: var #1
static HP_INIMIGO + #0, #25
POCAO_INIMIGO: var #1
static POCAO_INIMIGO + #0, #2
ATKUP_INIMIGO: var #1
static ATKUP_INIMIGO + #0, #1
DEFUP_INIMIGO: var #1
static DEFUP_INIMIGO + #0, #1

; Mensagens para ações do jogador
MENSAGEM_SOCOU: string "Voce Socou"
MENSAGEM_CHUTOU: string "Voce Chutou"
MENSAGEM_RELAMPAGO: string "Voce lancou um relampago"
MENSAGEM_BOLA_DE_FOGO: string "Voce lancou uma bola de fogo"
MENSAGEM_POCAO: string "Voce usou uma Pocao"
MENSAGEM_ATKUP: string "Voce usou um ATKUP"
MENSAGEM_DEFUP: string "Voce usou um DEFUP"

; Mensagens para ações do inimigo
MENSAGEM_SOCADO: string "Voce levou um Soco"
MENSAGEM_CHUTADO: string "Voce levou um Chute"
MENSAGEM_RELAMPAGADO: string "Voce foi acertado por um relampago"
MENSAGEM_BOLA_DE_FOGADO: string "Voce foi acertado por uma bola de fogo"

; Recebe a mensagem em r0 e imprime na posição 962
imprime_mensagem:
    push r1
    push r2
    
    loadn r1, #962
	loadn r2, #0 ; Comparador para encontrar \0

loop_imprime_mensagem:
	loadi r3, r0
	cmp r3, r2
	jeq fim_loop_imprime_mensagem
	outchar r3, r1
	inc r0
	inc r1
	jmp loop_imprime_mensagem

fim_loop_imprime_mensagem:
    pop r2
    pop r1
	rts

;---- Inicio do Programa Principal -----
main:
	call printTelaInicialScreen
	
	loadn r0, #0
	loadn r2, #32
	loadn r5, #255

	loadn r1, #88
	loadn r3, #232

	store SalvadorenhoPosition, r1
	store VilaozaozaoPosition, r3
	
; Loop para obter valor inicial para o RNG
loop_inicio:
	inchar r1
	
	cmp r1, r2
	jeq fim_loop_inicio
	inc r0
		
	jmp loop_inicio

fim_loop_inicio:
	store RNG, r0
	load r7, RNG
	
    ; Põe valor de ENTER em r2
    loadn r2, #13
    ; Printa a tela da criação de personagem
    call printDefineStatusScreen
    ; Mostra os Status Atuais
    call mostraStatus
    jmp loop_status

; Tela para Criação do Personagem
loop_status:
    inchar r1

    load r5, ULTIMA_TECLA
    cmp r1, r5
    jeq loop_status ; Se a mesma tecla foi pressionada duas vezes consecutivas, volta para o começo do loop
    store ULTIMA_TECLA, r1

    ; Se a tecla pressionada foi ENTER, encerra a criação do personagem
    cmp r1,r2
    jeq fim_loop_status

    ; Abaixo, está implementado um 'switch case' usando a instrução JID que criamos e uma JMP_TABLE

    ; Carrega Conteúdo da Posição r1 na JMP_TABLE para r1
    ; E valor da posição para r4
    loadn r4, #JMP_TABLE_STATUS
    add r4, r4, r1
    loadi r1, r4

    loadn r5, #0

    ; Se posição na JMP_TABLE está preenchida com zero, é o default
    cmp r1, r5
    jeq loop_status

    ; Se não, usa a instrução JID para fazer PC <- mem[r4], ou seja, o conteúdo na posição.
    jid r4

; As labels abaixo são endereçadas pela JMP_TABLE e modificam os status e itens do jogador
; (Da diminui_atk até a aumenta_defup)
diminui_atk:
    ; Checando se pode diminuir mais
    load r5, ATK
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, PONTOS
    inc r6
    store PONTOS, r6
    store ATK, r5
    call mostraATK
    call mostraPontos
    
    jmp loop_status

aumenta_atk:
    ; Checando se pode aumentar mais
    load r5, ATK
    load r6, PONTOS
    loadn r7, #0
    cmp r6, r7
    jeq loop_status

    inc r5
    store ATK, r5
    dec r6
    store PONTOS, r6
    call mostraATK
    call mostraPontos

    jmp loop_status

diminui_def:
    ; Checando se pode diminuir mais
    load r5, DEF
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, PONTOS
    inc r6
    store PONTOS, r6
    store DEF, r5
    call mostraDEF
    call mostraPontos
 
    jmp loop_status

aumenta_def:
    ; Checando se pode aumentar mais
    load r5, DEF
    load r6, PONTOS
    loadn r7, #0
    cmp r6, r7
    jeq loop_status

    inc r5
    store DEF, r5
    dec r6
    store PONTOS, r6
    call mostraDEF
    call mostraPontos

    jmp loop_status

diminui_spa:
    ; Checando se pode diminuir mais
    load r5, SPA
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, PONTOS
    inc r6
    store PONTOS, r6
    store SPA, r5
    call mostraSPA
    call mostraPontos
 
    jmp loop_status

aumenta_spa:
    ; Checando se pode aumentar mais
    load r5, SPA
    load r6, PONTOS
    loadn r7, #0
    cmp r6, r7
    jeq loop_status

    inc r5
    store SPA, r5
    dec r6
    store PONTOS, r6
    call mostraSPA
    call mostraPontos

    jmp loop_status

diminui_spd:
    ; Checando se pode diminuir mais
    load r5, SPD
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, PONTOS
    inc r6
    store PONTOS, r6
    store SPD, r5
    call mostraSPD
    call mostraPontos
 
    jmp loop_status

aumenta_spd:
    ; Checando se pode aumentar mais
    load r5, SPD
    load r6, PONTOS
    loadn r7, #0
    cmp r6, r7
    jeq loop_status

    inc r5
    store SPD, r5
    dec r6
    store PONTOS, r6
    call mostraSPD
    call mostraPontos

    jmp loop_status

diminui_spe:
    ; Checando se pode diminuir mais
    load r5, SPE
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, PONTOS
    inc r6
    store PONTOS, r6
    store SPE, r5
    call mostraSPE
    call mostraPontos
 
    jmp loop_status

aumenta_spe:
    ; Checando se pode aumentar mais
    load r5, SPE
    load r6, PONTOS
    loadn r7, #0
    cmp r6, r7
    jeq loop_status

    inc r5
    store SPE, r5
    dec r6
    store PONTOS, r6
    call mostraSPE
    call mostraPontos

    jmp loop_status

diminui_hp:
    ; Checando se pode diminuir mais
    load r5, HP
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, PONTOS
    inc r6
    store PONTOS, r6
    store HP, r5
    call mostraHP
    call mostraPontos
 
    jmp loop_status

aumenta_hp:
    ; Checando se pode aumentar mais
    load r5, HP
    load r6, PONTOS
    loadn r7, #0
    cmp r6, r7
    jeq loop_status

    inc r5
    store HP, r5
    dec r6
    store PONTOS, r6
    call mostraHP
    call mostraPontos

    jmp loop_status

diminui_pocao:
    ; Checando se pode diminuir mais
    load r5, POCAO
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, MOEDAS
    loadn r7, #5
    add r6, r6, r7
    store MOEDAS, r6
    store POCAO, r5
    call mostraPocao
    call mostraMoedas
 
    jmp loop_status


aumenta_pocao:
    ; Checando se pode aumentar mais
    load r5, POCAO
    load r6, MOEDAS
    loadn r7, #5
    cmp r6, r7
    jle loop_status

    inc r5
    store POCAO, r5
    sub r6, r6, r7
    store MOEDAS, r6
    call mostraPocao
    call mostraMoedas

    jmp loop_status


diminui_atkup:
    ; Checando se pode diminuir mais
    load r5, ATKUP
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, MOEDAS
    loadn r7, #5
    add r6, r6, r7
    store MOEDAS, r6
    store ATKUP, r5
    call mostraATKUP
    call mostraMoedas
 
    jmp loop_status


aumenta_atkup:
    ; Checando se pode aumentar mais
    load r5, ATKUP
    load r6, MOEDAS
    loadn r7, #5
    cmp r6, r7
    jle loop_status

    inc r5
    store ATKUP, r5
    sub r6, r6, r7
    store MOEDAS, r6
    call mostraATKUP
    call mostraMoedas

    jmp loop_status


diminui_defup:
    ; Checando se pode diminuir mais
    load r5, DEFUP
    loadn r6, #0
    cmp r5, r6
    jeq loop_status

    ; Diminuindo e atualizando na tela
    dec r5
    load r6, MOEDAS
    loadn r7, #5
    add r6, r6, r7
    store MOEDAS, r6
    store DEFUP, r5
    call mostraDEFUP
    call mostraMoedas
 
    jmp loop_status


aumenta_defup:
    ; Checando se pode aumentar mais
    load r5, DEFUP
    load r6, MOEDAS
    loadn r7, #5
    cmp r6, r7
    jle loop_status

    inc r5
    store DEFUP, r5
    sub r6, r6, r7
    store MOEDAS, r6
    call mostraDEFUP
    call mostraMoedas

    jmp loop_status

fim_loop_status:
    jmp gera_inimigo

gera_inimigo:
    jmp batalha

mostraHPsBatalha:
    push r0
    push r1

    load r0, HP
    loadn r1, #49
    call printNum

    load r0, HP_INIMIGO
    loadn r1, #152
    call printNum

    pop r1
    pop r0
    rts

fim_loop_batalha:
    halt

batalha:
    call printBatalha1Screen
    call mostraHPsBatalha
    call printSalvadorenho
    call printVilaozaozao
    loadn r0, #0

loop_batalha1:
    ; Checa condições de fim da batalha
    ; HP = 0
    load r2, HP
    cmp r2, r0
    jeq fim_loop_batalha
    ; HP_INIMIGO = 0
    load r2, HP_INIMIGO
    cmp r2, r0
    jeq fim_loop_batalha

    inchar r1

    load r5, ULTIMA_TECLA   
    cmp r1, r5
    jeq loop_batalha1
    store ULTIMA_TECLA, r1

    ; Caso seja 1, vai para tela batalha2
    loadn r5, #49
    cmp r1, r5
    jeq inicio_loop_batalha2

    ; Caso seja 2, vai para a tela batalha3
    loadn r5, #50
    cmp r1, r5
    jeq inicio_loop_batalha3

    ;Em outros casos, continua nessa tela
    jmp loop_batalha1

inicio_loop_batalha2:
    call printBatalha2Screen
    call printSalvadorenho
    call printVilaozaozao
    call mostraHPsBatalha

loop_batalha2:
    inchar r1
   
    load r5, ULTIMA_TECLA   
    cmp r1, r5
    jeq loop_batalha2
    store ULTIMA_TECLA, r1

    ; Caso seja 1, vai dar um soco no inimigo
    loadn r5, #49
    cmp r1, r5
    jeq soco_no_inimigo

    ; Caso seja 2, vai dar um chute no inimigo
    loadn r5, #50
    cmp r1, r5
    jeq chute_no_inimigo

    ; Caso seja 3, vai lançar um relâmpago no inimigo
    loadn r5, #51
    cmp r1, r5
    jeq relampago_no_inimigo

    ; Caso seja 4, vai lançar uma bola de fogo no inimigo
    loadn r5, #52
    cmp r1, r5
    jeq bola_de_fogo_no_inimigo

    ; Qualquer outra coisa, continua nessa tela
    jmp loop_batalha2

inicio_loop_batalha3:
    call printBatalha3Screen
    call printSalvadorenho
    call printVilaozaozao
    call mostraHPsBatalha

loop_batalha3:
    inchar r1

    load r5, ULTIMA_TECLA   
    cmp r1, r5
    jeq loop_batalha3
    store ULTIMA_TECLA, r1

    ; Caso seja 1, vai usar uma poção
    loadn r5, #49
    cmp r1, r5
    jeq usa_pocao

    ; Caso seja 2, vai usar um ATKUP
    loadn r5, #50
    cmp r1, r5
    jeq usa_atk_up

    ; Caso seja 3, vai usar um DEFUP
    loadn r5, #51
    cmp r1, r5
    jeq usa_def_up
    
    ; Caso seja 4, volta para a tela de batalha1
    loadn r5, #52
    cmp r1, r5
    jeq batalha

    ; Qualquer outro caso, continua nessa tela
    jmp loop_batalha3

gera_aleatorio:
    push r2
    push r3
    push r4

    load r1, RNG ; Carrega RNG

    ; Calcula proximo valor na sequência dos números 'aleatórios'
    load r2, MOD_MULTIPLY
    mul r2, r2, r1
    load r3, MOD_OFFSET
    add r3, r2, r3
    load r4, MOD_NUMBER
    mod r4, r3, r4
    store RNG, r4
 
    pop r4
    pop r3
    pop r2
    rts

decisao_inimigo:
    loadn r0, #2
    
    call gera_aleatorio ; Número aleatório para o r1
   
    mod r1, r1, r0  ;r1 vai conter a decisão de atacar (0) ou usar item (1)
    
    loadn r0, #0
    cmp r0, r1
    jne inimigo_usa_item
    
inimigo_usa_item:
inimigo_ataca:
    loadn r0, #4

    call gera_aleatorio ; Número aleatório para o r1

    mod r1, r1, r0
    
    ; r1 vai de 0 a 3, representando os possíveis ataques
    ; 0 - Soco
    ; 1 - Chute
    ; 2 - Relâmpago
    ; 3 - Bola de Fogo

    loadn r0, #0
    cmp r1, r0
    jeq soco_no_jogador

    loadn r0, #1
    cmp r1, r0
    jeq chute_no_jogador

    loadn r0, #2
    cmp r1, r0
    jeq relampago_no_jogador

    loadn r0, #3
    cmp r1, r0
    jeq bola_de_fogo_no_jogador

usa_pocao:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_POCAO
    call imprime_mensagem
    call esperaEnter

    load r0, POCAO
    loadn r1, #0

    ; Se tem 0 poções, não faz nada
    cmp r0, r1
    jeq decisao_inimigo
    
    dec r0
    store POCAO, r0
    
    load r0, HP
    loadn r1, #5
    add r0, r0, r1

    store HP, r0

    jmp decisao_inimigo

usa_atk_up:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_ATKUP
    call imprime_mensagem
    call esperaEnter

    load r0, ATKUP
    loadn r1, #0

    ; Se tem 0 ATKUPs, não faz nada
    cmp r0, r1
    jeq decisao_inimigo
    
    dec r0
    store ATKUP, r0
    
    load r0, ATK
    loadn r1, #5
    add r0, r0, r1

    store ATK, r0

    jmp decisao_inimigo

usa_def_up:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_DEFUP
    call imprime_mensagem
    call esperaEnter

    load r0, DEFUP
    loadn r1, #0

    ; Se tem 0 DEFUPs, não faz nada
    cmp r0, r1
    jeq decisao_inimigo
    
    dec r0
    store DEFUP, r0
    
    load r0, DEF
    loadn r1, #5
    add r0, r0, r1

    store DEF, r0

    jmp decisao_inimigo

; DANO = ATK - DEF_INIMIGO
soco_no_inimigo:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_SOCOU
    call imprime_mensagem
    call esperaEnter

    load r0, HP_INIMIGO
    load r1, ATK
    load r2, DEF_INIMIGO

    ;r3 vai ter o cálculo do dano
    loadn r3, #0

    add r3, r3, r1
    cmp r3, r2
    jle decisao_inimigo

    sub r3, r3, r2
    cmp r3, r0
    jeg fim_loop_batalha_vitoria
    
    sub r0, r0, r3
    store HP_INIMIGO, r0
    
    jmp decisao_inimigo
    
; DANO = (2*ATK - DEF)/3
chute_no_inimigo:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_CHUTOU
    call imprime_mensagem
    call esperaEnter

    load r0, HP_INIMIGO
    load r1, ATK
    loadn r3, #2
    mul r1, r1, r3 ; r1 <- 2 * ATK
    load r2, DEF_INIMIGO

    ;r3 vai ter o cálculo do dano
    loadn r3, #0

    add r3, r3, r1
    cmp r3, r2
    jle decisao_inimigo

    sub r3, r3, r2
    loadn r4, #3
    div r3, r3, r4 ; r3 <- (2 * ATK - DEF) / 3
    cmp r3, r0
    jeg fim_loop_batalha_vitoria
    
    sub r0, r0, r3
    store HP_INIMIGO, r0
    
    jmp decisao_inimigo

; DANO = SPA - SPD
relampago_no_inimigo:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_RELAMPAGO
    call imprime_mensagem
    call esperaEnter

    load r0, HP_INIMIGO
    load r1, SPA
    load r2, SPD_INIMIGO

    ;r3 vai ter o cálculo do dano
    loadn r3, #0

    add r3, r3, r1
    cmp r3, r2
    jle decisao_inimigo

    sub r3, r3, r2
    cmp r3, r0
    jeg fim_loop_batalha_vitoria

    sub r0, r0, r3
    store HP_INIMIGO, r0

    jmp decisao_inimigo

; DANO = (2*SPA - SPD)/3
bola_de_fogo_no_inimigo:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_BOLA_DE_FOGO
    call imprime_mensagem
    call esperaEnter

    load r0, HP_INIMIGO
    load r1, SPA
    loadn r3, #2
    mul r1, r1, r3 ; r1 <- 2 * SPA
    load r2, SPD_INIMIGO

    ;r3 vai ter o cálculo do dano
    loadn r3, #0

    add r3, r3, r1
    cmp r3, r2
    jle decisao_inimigo

    sub r3, r3, r2
    loadn r4, #3
    div r3, r3, r4 ; r3 <- (2*SPA - SPD) / 3
    cmp r3, r0
    jeg fim_loop_batalha_vitoria

    sub r0, r0, r3
    store HP_INIMIGO, r0

    jmp decisao_inimigo

; DANO = ATK_INIMIGO - DEF
soco_no_jogador:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_SOCADO
    call imprime_mensagem
    call esperaEnter

    load r0, HP
    load r1, ATK_INIMIGO
    load r2, DEF

    ;r3 vai ter o cálculo do dano
    loadn r3, #0

    add r3, r3, r1
    cmp r3, r2
    jle batalha

    sub r3, r3, r2
    cmp r3, r0
    jeg fim_loop_batalha_derrota
    
    sub r0, r0, r3
    store HP, r0
    
    jmp batalha
    
; DANO = (2*ATK_INIMIGO - DEF)/3
chute_no_jogador:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_CHUTADO
    call imprime_mensagem
    call esperaEnter

    load r0, HP
    load r1, ATK_INIMIGO
    loadn r3, #2
    mul r1, r1, r3 ; r1 <- 2 * ATK
    load r2, DEF

    ;r3 vai ter o cálculo do dano
    loadn r3, #0

    add r3, r3, r1
    cmp r3, r2
    jle batalha

    sub r3, r3, r2
    loadn r4, #3
    div r3, r3, r4 ; r3 <- (2 * ATK - DEF) / 3
    cmp r3, r0
    jeg fim_loop_batalha_derrota
    
    sub r0, r0, r3
    store HP, r0
    
    jmp batalha

; DANO = SPA - SPD
relampago_no_jogador:
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_RELAMPAGADO
    call imprime_mensagem
    call esperaEnter

    load r0, HP
    load r1, SPA_INIMIGO
    load r2, SPD

    ;r3 vai ter o cálculo do dano
    loadn r3, #0

    add r3, r3, r1
    cmp r3, r2
    jle batalha

    sub r3, r3, r2
    cmp r3, r0
    jeg fim_loop_batalha_derrota

    sub r0, r0, r3
    store HP, r0

    jmp batalha

; DANO = (2*SPA - SPD)/3
bola_de_fogo_no_jogador: 
    call limpaTextoBatalha
    loadn r0, #MENSAGEM_BOLA_DE_FOGADO
    call imprime_mensagem
    call esperaEnter

    load r0, HP
    load r1, SPA_INIMIGO
    loadn r3, #2
    mul r1, r1, r3 ; r1 <- 2 * SPA
    load r2, SPD

    ;r3 vai ter o cálculo do dano
    loadn r3, #0

    add r3, r3, r1
    cmp r3, r2
    jle batalha

    sub r3, r3, r2
    loadn r4, #3
    div r3, r3, r4 ; r3 <- (2*SPA - SPD) / 3
    cmp r3, r0
    jeg fim_loop_batalha_derrota

    sub r0, r0, r3
    store HP, r0

    jmp batalha

fim_loop_batalha_derrota:
    loadn r7, #127
    call printtelaDerrotaScreen

    loadn r6, #340
    store VilaozaozaoPosition, r6

    call printVilaozaozao

    halt

fim_loop_batalha_vitoria:
    loadn r7, #255
    call printtelaVitoriaScreen

    loadn r6, #338
    store SalvadorenhoPosition, r6

    call printSalvadorenho

    halt

; Atualiza o valor do ATK na tela
mostraATK:
    push r0
    push r1
    
    load r0, ATK
    loadn r1, #127
    call printNum

    pop r1
    pop r0
    rts

; Atualiza o valor da DEF na tela
mostraDEF:
    push r0
    push r1

    load r0, DEF
    loadn r1, #207
    call printNum

    pop r1
    pop r0
    rts

mostraSPA:
    push r0
    push r1

    load r0, SPA
    loadn r1, #287
    call printNum

    pop r1
    pop r0
    rts

mostraSPD:
    push r0
    push r1

    load r0, SPD
    loadn r1, #367
    call printNum

    pop r1
    pop r0
    rts

mostraSPE:
    push r0
    push r1

    load r0, SPE
    loadn r1, #447
    call printNum

    pop r1
    pop r0
    rts

mostraHP:
    push r0
    push r1

    load r0, HP
    loadn r1, #527
    call printNum

    pop r1
    pop r0
    rts

mostraPocao:
    push r0
    push r1
    
    load r0, POCAO
    loadn r1, #769
    call printNum

    pop r1
    pop r0
    rts

mostraATKUP:
    push r0
    push r1

    load r0, ATKUP
    loadn r1, #849
    call printNum

    pop r1
    pop r0
    rts

mostraDEFUP:
    push r0
    push r1

    load r0, DEFUP
    loadn r1, #929
    call printNum

    pop r1
    pop r0
    rts

mostraPontos:
    push r0
    push r1

    load r0, PONTOS
    loadn r1, #72
    call printNum

    pop r1
    pop r0
    rts

mostraMoedas:
    push r0
    push r1

    load r0, MOEDAS
    loadn r1, #689
    call printNum

    pop r1
    pop r0
    rts

; Montra todos os status na tela
mostraStatus:
    
    call mostraATK
    call mostraDEF
    call mostraSPA
    call mostraSPD
    call mostraSPE
    call mostraHP
    call mostraPocao
    call mostraATKUP
    call mostraDEFUP
    call mostraPontos
    call mostraMoedas
    rts

; Printa o número em r0 com dois digitos começando na posição r1
printNum:
    push r2
    push r3
    push r4

    ; #3632 é o 0 de cor azul pastel, talvez? É um azul aíkk
    loadn r2, #3632
    loadn r3, #10

    ; Calcula digito das dezenas
    div r4, r0, r3

    ; Imprime digito das dezenas
    add r2, r2, r4
    outchar r2, r1
    inc r1

    ; Calcula digito das unidades
    mod r4, r0, r3
    
    ; Imprime digito das unidades
    ; #3632 é o 0 de cor azul pastel, talvez? É um azul aíkk
    loadn r2, #3632
    add r2, r2, r4
    outchar r2, r1
    dec r1

    pop r4
    pop r3
    pop r2

    rts

limpaTextoBatalha:
    push r0
    push r1
    push r2

    loadn r0, #1200 ; Condição de Parada
    loadn r1, #860 ; Iterador
    loadn r2, #255 ; Caractere que será impresso

loop_limpa_texto_batalha:
    cmp r0, r1
    jeq fim_loop_limpa_texto_batalha
    
    outchar r2, r1
    inc r1
    jmp loop_limpa_texto_batalha

fim_loop_limpa_texto_batalha:
    pop r2
    pop r1
    pop r0
    rts

esperaEnter:
    push r0
    push r1

    loadn r0, #13 ; Condição de Parada ENTER

loop_espera_enter:
    inchar r1
    
    cmp r0, r1
    jeq fim_espera_enter
    jmp loop_espera_enter

fim_espera_enter:
    pop r1
    pop r0
    rts

DefineStatus : var #1200
  ;Linha 0
  static DefineStatus + #0, #3967
  static DefineStatus + #1, #3967
  static DefineStatus + #2, #3967
  static DefineStatus + #3, #3967
  static DefineStatus + #4, #3967
  static DefineStatus + #5, #3967
  static DefineStatus + #6, #3967
  static DefineStatus + #7, #3967
  static DefineStatus + #8, #3967
  static DefineStatus + #9, #3967
  static DefineStatus + #10, #3967
  static DefineStatus + #11, #3967
  static DefineStatus + #12, #3967
  static DefineStatus + #13, #3967
  static DefineStatus + #14, #3967
  static DefineStatus + #15, #3967
  static DefineStatus + #16, #3967
  static DefineStatus + #17, #3967
  static DefineStatus + #18, #3967
  static DefineStatus + #19, #3967
  static DefineStatus + #20, #3967
  static DefineStatus + #21, #3967
  static DefineStatus + #22, #3967
  static DefineStatus + #23, #3967
  static DefineStatus + #24, #3967
  static DefineStatus + #25, #3967
  static DefineStatus + #26, #3967
  static DefineStatus + #27, #3967
  static DefineStatus + #28, #3967
  static DefineStatus + #29, #3967
  static DefineStatus + #30, #3967
  static DefineStatus + #31, #3967
  static DefineStatus + #32, #3967
  static DefineStatus + #33, #3967
  static DefineStatus + #34, #3967
  static DefineStatus + #35, #3967
  static DefineStatus + #36, #3967
  static DefineStatus + #37, #3967
  static DefineStatus + #38, #3967
  static DefineStatus + #39, #3967

  ;Linha 1
  static DefineStatus + #40, #3967
  static DefineStatus + #41, #83
  static DefineStatus + #42, #84
  static DefineStatus + #43, #65
  static DefineStatus + #44, #84
  static DefineStatus + #45, #85
  static DefineStatus + #46, #83
  static DefineStatus + #47, #58
  static DefineStatus + #48, #3967
  static DefineStatus + #49, #3967
  static DefineStatus + #50, #3967
  static DefineStatus + #51, #3967
  static DefineStatus + #52, #3967
  static DefineStatus + #53, #3967
  static DefineStatus + #54, #3967
  static DefineStatus + #55, #3967
  static DefineStatus + #56, #3967
  static DefineStatus + #57, #3967
  static DefineStatus + #58, #3967
  static DefineStatus + #59, #3967
  static DefineStatus + #60, #3967
  static DefineStatus + #61, #3967
  static DefineStatus + #62, #3967
  static DefineStatus + #63, #3967
  static DefineStatus + #64, #80
  static DefineStatus + #65, #79
  static DefineStatus + #66, #78
  static DefineStatus + #67, #84
  static DefineStatus + #68, #79
  static DefineStatus + #69, #83
  static DefineStatus + #70, #58
  static DefineStatus + #71, #3967
  static DefineStatus + #72, #3967
  static DefineStatus + #73, #3967
  static DefineStatus + #74, #3967
  static DefineStatus + #75, #3967
  static DefineStatus + #76, #3967
  static DefineStatus + #77, #3967
  static DefineStatus + #78, #3967
  static DefineStatus + #79, #3967

  ;Linha 2
  static DefineStatus + #80, #3967
  static DefineStatus + #81, #3967
  static DefineStatus + #82, #3967
  static DefineStatus + #83, #3967
  static DefineStatus + #84, #3967
  static DefineStatus + #85, #3967
  static DefineStatus + #86, #3967
  static DefineStatus + #87, #3967
  static DefineStatus + #88, #3967
  static DefineStatus + #89, #3967
  static DefineStatus + #90, #3967
  static DefineStatus + #91, #3967
  static DefineStatus + #92, #3967
  static DefineStatus + #93, #3967
  static DefineStatus + #94, #3967
  static DefineStatus + #95, #3967
  static DefineStatus + #96, #3967
  static DefineStatus + #97, #3967
  static DefineStatus + #98, #3967
  static DefineStatus + #99, #3967
  static DefineStatus + #100, #3967
  static DefineStatus + #101, #3967
  static DefineStatus + #102, #3967
  static DefineStatus + #103, #3967
  static DefineStatus + #104, #3967
  static DefineStatus + #105, #3967
  static DefineStatus + #106, #3967
  static DefineStatus + #107, #3967
  static DefineStatus + #108, #3967
  static DefineStatus + #109, #3967
  static DefineStatus + #110, #3967
  static DefineStatus + #111, #3967
  static DefineStatus + #112, #3967
  static DefineStatus + #113, #3967
  static DefineStatus + #114, #3967
  static DefineStatus + #115, #3967
  static DefineStatus + #116, #3967
  static DefineStatus + #117, #3967
  static DefineStatus + #118, #3967
  static DefineStatus + #119, #3967

  ;Linha 3
  static DefineStatus + #120, #3967
  static DefineStatus + #121, #577
  static DefineStatus + #122, #596
  static DefineStatus + #123, #587
  static DefineStatus + #124, #58
  static DefineStatus + #125, #3967
  static DefineStatus + #126, #3967
  static DefineStatus + #127, #3967
  static DefineStatus + #128, #3967
  static DefineStatus + #129, #3967
  static DefineStatus + #130, #2349
  static DefineStatus + #131, #3967
  static DefineStatus + #132, #555
  static DefineStatus + #133, #3967
  static DefineStatus + #134, #1371
  static DefineStatus + #135, #2353
  static DefineStatus + #136, #3967
  static DefineStatus + #137, #562
  static DefineStatus + #138, #1373
  static DefineStatus + #139, #3967
  static DefineStatus + #140, #3967
  static DefineStatus + #141, #3967
  static DefineStatus + #142, #3967
  static DefineStatus + #143, #3967
  static DefineStatus + #144, #3967
  static DefineStatus + #145, #3967
  static DefineStatus + #146, #3967
  static DefineStatus + #147, #3967
  static DefineStatus + #148, #3967
  static DefineStatus + #149, #3967
  static DefineStatus + #150, #3967
  static DefineStatus + #151, #3967
  static DefineStatus + #152, #3967
  static DefineStatus + #153, #3967
  static DefineStatus + #154, #3967
  static DefineStatus + #155, #3967
  static DefineStatus + #156, #3967
  static DefineStatus + #157, #3967
  static DefineStatus + #158, #3967
  static DefineStatus + #159, #3967

  ;Linha 4
  static DefineStatus + #160, #3967
  static DefineStatus + #161, #3967
  static DefineStatus + #162, #3967
  static DefineStatus + #163, #3967
  static DefineStatus + #164, #3967
  static DefineStatus + #165, #3967
  static DefineStatus + #166, #3967
  static DefineStatus + #167, #3967
  static DefineStatus + #168, #3967
  static DefineStatus + #169, #3967
  static DefineStatus + #170, #3967
  static DefineStatus + #171, #3967
  static DefineStatus + #172, #3967
  static DefineStatus + #173, #3967
  static DefineStatus + #174, #3967
  static DefineStatus + #175, #3967
  static DefineStatus + #176, #3967
  static DefineStatus + #177, #3967
  static DefineStatus + #178, #3967
  static DefineStatus + #179, #3967
  static DefineStatus + #180, #3967
  static DefineStatus + #181, #3967
  static DefineStatus + #182, #3967
  static DefineStatus + #183, #3967
  static DefineStatus + #184, #3967
  static DefineStatus + #185, #3967
  static DefineStatus + #186, #3967
  static DefineStatus + #187, #3967
  static DefineStatus + #188, #3967
  static DefineStatus + #189, #3967
  static DefineStatus + #190, #3967
  static DefineStatus + #191, #3967
  static DefineStatus + #192, #3967
  static DefineStatus + #193, #3967
  static DefineStatus + #194, #3967
  static DefineStatus + #195, #3967
  static DefineStatus + #196, #3967
  static DefineStatus + #197, #3967
  static DefineStatus + #198, #3967
  static DefineStatus + #199, #3967

  ;Linha 5
  static DefineStatus + #200, #3967
  static DefineStatus + #201, #2116
  static DefineStatus + #202, #2117
  static DefineStatus + #203, #2118
  static DefineStatus + #204, #58
  static DefineStatus + #205, #3967
  static DefineStatus + #206, #3967
  static DefineStatus + #207, #3967
  static DefineStatus + #208, #3967
  static DefineStatus + #209, #3967
  static DefineStatus + #210, #2349
  static DefineStatus + #211, #3967
  static DefineStatus + #212, #555
  static DefineStatus + #213, #3967
  static DefineStatus + #214, #1371
  static DefineStatus + #215, #2355
  static DefineStatus + #216, #3967
  static DefineStatus + #217, #564
  static DefineStatus + #218, #1373
  static DefineStatus + #219, #3967
  static DefineStatus + #220, #3967
  static DefineStatus + #221, #3967
  static DefineStatus + #222, #3967
  static DefineStatus + #223, #3967
  static DefineStatus + #224, #3967
  static DefineStatus + #225, #3967
  static DefineStatus + #226, #3967
  static DefineStatus + #227, #3967
  static DefineStatus + #228, #3967
  static DefineStatus + #229, #3967
  static DefineStatus + #230, #3967
  static DefineStatus + #231, #3967
  static DefineStatus + #232, #3967
  static DefineStatus + #233, #3967
  static DefineStatus + #234, #3967
  static DefineStatus + #235, #3967
  static DefineStatus + #236, #3967
  static DefineStatus + #237, #3967
  static DefineStatus + #238, #3967
  static DefineStatus + #239, #3967

  ;Linha 6
  static DefineStatus + #240, #3967
  static DefineStatus + #241, #3967
  static DefineStatus + #242, #3967
  static DefineStatus + #243, #3967
  static DefineStatus + #244, #3967
  static DefineStatus + #245, #3967
  static DefineStatus + #246, #3967
  static DefineStatus + #247, #3967
  static DefineStatus + #248, #3967
  static DefineStatus + #249, #3967
  static DefineStatus + #250, #3967
  static DefineStatus + #251, #3967
  static DefineStatus + #252, #3967
  static DefineStatus + #253, #3967
  static DefineStatus + #254, #3967
  static DefineStatus + #255, #3967
  static DefineStatus + #256, #3967
  static DefineStatus + #257, #3967
  static DefineStatus + #258, #3967
  static DefineStatus + #259, #3967
  static DefineStatus + #260, #3967
  static DefineStatus + #261, #3967
  static DefineStatus + #262, #3967
  static DefineStatus + #263, #3967
  static DefineStatus + #264, #3967
  static DefineStatus + #265, #3967
  static DefineStatus + #266, #3967
  static DefineStatus + #267, #3967
  static DefineStatus + #268, #3967
  static DefineStatus + #269, #3967
  static DefineStatus + #270, #3967
  static DefineStatus + #271, #3967
  static DefineStatus + #272, #3967
  static DefineStatus + #273, #3967
  static DefineStatus + #274, #3967
  static DefineStatus + #275, #3967
  static DefineStatus + #276, #3967
  static DefineStatus + #277, #3967
  static DefineStatus + #278, #3967
  static DefineStatus + #279, #3967

  ;Linha 7
  static DefineStatus + #280, #3967
  static DefineStatus + #281, #83
  static DefineStatus + #282, #80
  static DefineStatus + #283, #65
  static DefineStatus + #284, #58
  static DefineStatus + #285, #3967
  static DefineStatus + #286, #3967
  static DefineStatus + #287, #3967
  static DefineStatus + #288, #3967
  static DefineStatus + #289, #3967
  static DefineStatus + #290, #2349
  static DefineStatus + #291, #3967
  static DefineStatus + #292, #555
  static DefineStatus + #293, #3967
  static DefineStatus + #294, #1371
  static DefineStatus + #295, #2357
  static DefineStatus + #296, #3967
  static DefineStatus + #297, #566
  static DefineStatus + #298, #1373
  static DefineStatus + #299, #3967
  static DefineStatus + #300, #3967
  static DefineStatus + #301, #3967
  static DefineStatus + #302, #3967
  static DefineStatus + #303, #3967
  static DefineStatus + #304, #3967
  static DefineStatus + #305, #3967
  static DefineStatus + #306, #3967
  static DefineStatus + #307, #3967
  static DefineStatus + #308, #3967
  static DefineStatus + #309, #3967
  static DefineStatus + #310, #3967
  static DefineStatus + #311, #3967
  static DefineStatus + #312, #3967
  static DefineStatus + #313, #3967
  static DefineStatus + #314, #3967
  static DefineStatus + #315, #3967
  static DefineStatus + #316, #3967
  static DefineStatus + #317, #3967
  static DefineStatus + #318, #3967
  static DefineStatus + #319, #3967

  ;Linha 8
  static DefineStatus + #320, #3967
  static DefineStatus + #321, #3967
  static DefineStatus + #322, #3967
  static DefineStatus + #323, #3967
  static DefineStatus + #324, #3967
  static DefineStatus + #325, #3967
  static DefineStatus + #326, #3967
  static DefineStatus + #327, #3967
  static DefineStatus + #328, #3967
  static DefineStatus + #329, #3967
  static DefineStatus + #330, #3967
  static DefineStatus + #331, #3967
  static DefineStatus + #332, #3967
  static DefineStatus + #333, #3967
  static DefineStatus + #334, #3967
  static DefineStatus + #335, #3967
  static DefineStatus + #336, #3967
  static DefineStatus + #337, #3967
  static DefineStatus + #338, #3967
  static DefineStatus + #339, #3967
  static DefineStatus + #340, #3967
  static DefineStatus + #341, #3967
  static DefineStatus + #342, #3967
  static DefineStatus + #343, #3967
  static DefineStatus + #344, #3967
  static DefineStatus + #345, #3967
  static DefineStatus + #346, #3967
  static DefineStatus + #347, #3967
  static DefineStatus + #348, #3967
  static DefineStatus + #349, #3967
  static DefineStatus + #350, #3967
  static DefineStatus + #351, #3967
  static DefineStatus + #352, #3967
  static DefineStatus + #353, #3967
  static DefineStatus + #354, #3967
  static DefineStatus + #355, #3967
  static DefineStatus + #356, #3967
  static DefineStatus + #357, #3967
  static DefineStatus + #358, #3967
  static DefineStatus + #359, #3967

  ;Linha 9
  static DefineStatus + #360, #3967
  static DefineStatus + #361, #2899
  static DefineStatus + #362, #2896
  static DefineStatus + #363, #2884
  static DefineStatus + #364, #58
  static DefineStatus + #365, #3967
  static DefineStatus + #366, #3967
  static DefineStatus + #367, #3967
  static DefineStatus + #368, #3967
  static DefineStatus + #369, #3967
  static DefineStatus + #370, #2349
  static DefineStatus + #371, #3967
  static DefineStatus + #372, #555
  static DefineStatus + #373, #3967
  static DefineStatus + #374, #1371
  static DefineStatus + #375, #2359
  static DefineStatus + #376, #3967
  static DefineStatus + #377, #568
  static DefineStatus + #378, #1373
  static DefineStatus + #379, #3967
  static DefineStatus + #380, #3967
  static DefineStatus + #381, #3967
  static DefineStatus + #382, #3967
  static DefineStatus + #383, #3967
  static DefineStatus + #384, #3967
  static DefineStatus + #385, #3967
  static DefineStatus + #386, #3967
  static DefineStatus + #387, #3967
  static DefineStatus + #388, #3967
  static DefineStatus + #389, #3967
  static DefineStatus + #390, #3967
  static DefineStatus + #391, #3967
  static DefineStatus + #392, #3967
  static DefineStatus + #393, #3967
  static DefineStatus + #394, #3967
  static DefineStatus + #395, #3967
  static DefineStatus + #396, #3967
  static DefineStatus + #397, #3967
  static DefineStatus + #398, #3967
  static DefineStatus + #399, #3967

  ;Linha 10
  static DefineStatus + #400, #3967
  static DefineStatus + #401, #3967
  static DefineStatus + #402, #3967
  static DefineStatus + #403, #3967
  static DefineStatus + #404, #3967
  static DefineStatus + #405, #3967
  static DefineStatus + #406, #3967
  static DefineStatus + #407, #3967
  static DefineStatus + #408, #3967
  static DefineStatus + #409, #3967
  static DefineStatus + #410, #3967
  static DefineStatus + #411, #3967
  static DefineStatus + #412, #3967
  static DefineStatus + #413, #3967
  static DefineStatus + #414, #3967
  static DefineStatus + #415, #3967
  static DefineStatus + #416, #3967
  static DefineStatus + #417, #3967
  static DefineStatus + #418, #3967
  static DefineStatus + #419, #3967
  static DefineStatus + #420, #3967
  static DefineStatus + #421, #3967
  static DefineStatus + #422, #3967
  static DefineStatus + #423, #3967
  static DefineStatus + #424, #3967
  static DefineStatus + #425, #3967
  static DefineStatus + #426, #3967
  static DefineStatus + #427, #3967
  static DefineStatus + #428, #3967
  static DefineStatus + #429, #3967
  static DefineStatus + #430, #3967
  static DefineStatus + #431, #3967
  static DefineStatus + #432, #3967
  static DefineStatus + #433, #3967
  static DefineStatus + #434, #3967
  static DefineStatus + #435, #3967
  static DefineStatus + #436, #3967
  static DefineStatus + #437, #3967
  static DefineStatus + #438, #3967
  static DefineStatus + #439, #3967

  ;Linha 11
  static DefineStatus + #440, #3967
  static DefineStatus + #441, #3155
  static DefineStatus + #442, #3152
  static DefineStatus + #443, #3141
  static DefineStatus + #444, #58
  static DefineStatus + #445, #3967
  static DefineStatus + #446, #3967
  static DefineStatus + #447, #3967
  static DefineStatus + #448, #3967
  static DefineStatus + #449, #3967
  static DefineStatus + #450, #2349
  static DefineStatus + #451, #3967
  static DefineStatus + #452, #555
  static DefineStatus + #453, #3967
  static DefineStatus + #454, #1371
  static DefineStatus + #455, #2361
  static DefineStatus + #456, #3967
  static DefineStatus + #457, #560
  static DefineStatus + #458, #1373
  static DefineStatus + #459, #3967
  static DefineStatus + #460, #3967
  static DefineStatus + #461, #3967
  static DefineStatus + #462, #3967
  static DefineStatus + #463, #3967
  static DefineStatus + #464, #3967
  static DefineStatus + #465, #3967
  static DefineStatus + #466, #3967
  static DefineStatus + #467, #3967
  static DefineStatus + #468, #3967
  static DefineStatus + #469, #3967
  static DefineStatus + #470, #127
  static DefineStatus + #471, #3967
  static DefineStatus + #472, #3967
  static DefineStatus + #473, #3967
  static DefineStatus + #474, #3967
  static DefineStatus + #475, #3967
  static DefineStatus + #476, #3967
  static DefineStatus + #477, #3967
  static DefineStatus + #478, #3967
  static DefineStatus + #479, #3967

  ;Linha 12
  static DefineStatus + #480, #3967
  static DefineStatus + #481, #3967
  static DefineStatus + #482, #3967
  static DefineStatus + #483, #3967
  static DefineStatus + #484, #3967
  static DefineStatus + #485, #3967
  static DefineStatus + #486, #3967
  static DefineStatus + #487, #3967
  static DefineStatus + #488, #3967
  static DefineStatus + #489, #3967
  static DefineStatus + #490, #3967
  static DefineStatus + #491, #3967
  static DefineStatus + #492, #127
  static DefineStatus + #493, #3967
  static DefineStatus + #494, #3967
  static DefineStatus + #495, #3967
  static DefineStatus + #496, #3967
  static DefineStatus + #497, #3967
  static DefineStatus + #498, #3967
  static DefineStatus + #499, #3967
  static DefineStatus + #500, #3967
  static DefineStatus + #501, #3967
  static DefineStatus + #502, #3967
  static DefineStatus + #503, #3967
  static DefineStatus + #504, #3967
  static DefineStatus + #505, #3967
  static DefineStatus + #506, #3967
  static DefineStatus + #507, #3967
  static DefineStatus + #508, #3967
  static DefineStatus + #509, #3967
  static DefineStatus + #510, #3967
  static DefineStatus + #511, #3967
  static DefineStatus + #512, #3967
  static DefineStatus + #513, #3967
  static DefineStatus + #514, #3967
  static DefineStatus + #515, #3967
  static DefineStatus + #516, #3967
  static DefineStatus + #517, #3967
  static DefineStatus + #518, #3967
  static DefineStatus + #519, #3967

  ;Linha 13
  static DefineStatus + #520, #3967
  static DefineStatus + #521, #3967
  static DefineStatus + #522, #2376
  static DefineStatus + #523, #2384
  static DefineStatus + #524, #58
  static DefineStatus + #525, #3967
  static DefineStatus + #526, #3967
  static DefineStatus + #527, #3967
  static DefineStatus + #528, #3967
  static DefineStatus + #529, #3967
  static DefineStatus + #530, #2349
  static DefineStatus + #531, #3967
  static DefineStatus + #532, #555
  static DefineStatus + #533, #3967
  static DefineStatus + #534, #1371
  static DefineStatus + #535, #2369
  static DefineStatus + #536, #127
  static DefineStatus + #537, #578
  static DefineStatus + #538, #1373
  static DefineStatus + #539, #3967
  static DefineStatus + #540, #3967
  static DefineStatus + #541, #3967
  static DefineStatus + #542, #3967
  static DefineStatus + #543, #3967
  static DefineStatus + #544, #3967
  static DefineStatus + #545, #3967
  static DefineStatus + #546, #3967
  static DefineStatus + #547, #3967
  static DefineStatus + #548, #3967
  static DefineStatus + #549, #3967
  static DefineStatus + #550, #3967
  static DefineStatus + #551, #3967
  static DefineStatus + #552, #3967
  static DefineStatus + #553, #3967
  static DefineStatus + #554, #3967
  static DefineStatus + #555, #3967
  static DefineStatus + #556, #3967
  static DefineStatus + #557, #3967
  static DefineStatus + #558, #3967
  static DefineStatus + #559, #3967

  ;Linha 14
  static DefineStatus + #560, #3967
  static DefineStatus + #561, #3967
  static DefineStatus + #562, #3967
  static DefineStatus + #563, #3967
  static DefineStatus + #564, #3967
  static DefineStatus + #565, #3967
  static DefineStatus + #566, #3967
  static DefineStatus + #567, #3967
  static DefineStatus + #568, #3967
  static DefineStatus + #569, #3967
  static DefineStatus + #570, #3967
  static DefineStatus + #571, #3967
  static DefineStatus + #572, #3967
  static DefineStatus + #573, #3967
  static DefineStatus + #574, #3967
  static DefineStatus + #575, #3967
  static DefineStatus + #576, #3967
  static DefineStatus + #577, #127
  static DefineStatus + #578, #127
  static DefineStatus + #579, #127
  static DefineStatus + #580, #3967
  static DefineStatus + #581, #3967
  static DefineStatus + #582, #3967
  static DefineStatus + #583, #3967
  static DefineStatus + #584, #3967
  static DefineStatus + #585, #3967
  static DefineStatus + #586, #3967
  static DefineStatus + #587, #3967
  static DefineStatus + #588, #3967
  static DefineStatus + #589, #3967
  static DefineStatus + #590, #3967
  static DefineStatus + #591, #3967
  static DefineStatus + #592, #3967
  static DefineStatus + #593, #3967
  static DefineStatus + #594, #3967
  static DefineStatus + #595, #3967
  static DefineStatus + #596, #3967
  static DefineStatus + #597, #3967
  static DefineStatus + #598, #3967
  static DefineStatus + #599, #3967

  ;Linha 15
  static DefineStatus + #600, #3967
  static DefineStatus + #601, #3967
  static DefineStatus + #602, #3967
  static DefineStatus + #603, #3967
  static DefineStatus + #604, #3967
  static DefineStatus + #605, #3967
  static DefineStatus + #606, #3967
  static DefineStatus + #607, #3967
  static DefineStatus + #608, #3967
  static DefineStatus + #609, #3967
  static DefineStatus + #610, #3967
  static DefineStatus + #611, #3967
  static DefineStatus + #612, #3967
  static DefineStatus + #613, #3967
  static DefineStatus + #614, #3967
  static DefineStatus + #615, #3967
  static DefineStatus + #616, #3967
  static DefineStatus + #617, #3967
  static DefineStatus + #618, #127
  static DefineStatus + #619, #127
  static DefineStatus + #620, #127
  static DefineStatus + #621, #127
  static DefineStatus + #622, #3967
  static DefineStatus + #623, #3967
  static DefineStatus + #624, #3967
  static DefineStatus + #625, #3967
  static DefineStatus + #626, #3967
  static DefineStatus + #627, #3967
  static DefineStatus + #628, #3967
  static DefineStatus + #629, #3967
  static DefineStatus + #630, #3967
  static DefineStatus + #631, #3967
  static DefineStatus + #632, #3967
  static DefineStatus + #633, #3967
  static DefineStatus + #634, #3967
  static DefineStatus + #635, #3967
  static DefineStatus + #636, #3967
  static DefineStatus + #637, #3967
  static DefineStatus + #638, #3967
  static DefineStatus + #639, #3967

  ;Linha 16
  static DefineStatus + #640, #3967
  static DefineStatus + #641, #3967
  static DefineStatus + #642, #3967
  static DefineStatus + #643, #3967
  static DefineStatus + #644, #3967
  static DefineStatus + #645, #3967
  static DefineStatus + #646, #3967
  static DefineStatus + #647, #3967
  static DefineStatus + #648, #3967
  static DefineStatus + #649, #3967
  static DefineStatus + #650, #3967
  static DefineStatus + #651, #3967
  static DefineStatus + #652, #3967
  static DefineStatus + #653, #3967
  static DefineStatus + #654, #3967
  static DefineStatus + #655, #3967
  static DefineStatus + #656, #3967
  static DefineStatus + #657, #3967
  static DefineStatus + #658, #3967
  static DefineStatus + #659, #127
  static DefineStatus + #660, #127
  static DefineStatus + #661, #127
  static DefineStatus + #662, #127
  static DefineStatus + #663, #127
  static DefineStatus + #664, #3967
  static DefineStatus + #665, #3967
  static DefineStatus + #666, #3967
  static DefineStatus + #667, #3967
  static DefineStatus + #668, #3967
  static DefineStatus + #669, #3967
  static DefineStatus + #670, #3967
  static DefineStatus + #671, #3967
  static DefineStatus + #672, #3967
  static DefineStatus + #673, #3967
  static DefineStatus + #674, #3967
  static DefineStatus + #675, #3967
  static DefineStatus + #676, #3967
  static DefineStatus + #677, #3967
  static DefineStatus + #678, #3967
  static DefineStatus + #679, #3967

  ;Linha 17
  static DefineStatus + #680, #3967
  static DefineStatus + #681, #73
  static DefineStatus + #682, #84
  static DefineStatus + #683, #69
  static DefineStatus + #684, #78
  static DefineStatus + #685, #83
  static DefineStatus + #686, #58
  static DefineStatus + #687, #3967
  static DefineStatus + #688, #3967
  static DefineStatus + #689, #3967
  static DefineStatus + #690, #3967
  static DefineStatus + #691, #3967
  static DefineStatus + #692, #77
  static DefineStatus + #693, #79
  static DefineStatus + #694, #69
  static DefineStatus + #695, #68
  static DefineStatus + #696, #65
  static DefineStatus + #697, #83
  static DefineStatus + #698, #3967
  static DefineStatus + #699, #3967
  static DefineStatus + #700, #3967
  static DefineStatus + #701, #127
  static DefineStatus + #702, #127
  static DefineStatus + #703, #127
  static DefineStatus + #704, #80
  static DefineStatus + #705, #82
  static DefineStatus + #706, #69
  static DefineStatus + #707, #83
  static DefineStatus + #708, #83
  static DefineStatus + #709, #83
  static DefineStatus + #710, #73
  static DefineStatus + #711, #79
  static DefineStatus + #712, #78
  static DefineStatus + #713, #69
  static DefineStatus + #714, #3967
  static DefineStatus + #715, #3967
  static DefineStatus + #716, #3967
  static DefineStatus + #717, #3967
  static DefineStatus + #718, #3967
  static DefineStatus + #719, #3967

  ;Linha 18
  static DefineStatus + #720, #3967
  static DefineStatus + #721, #3967
  static DefineStatus + #722, #3967
  static DefineStatus + #723, #3967
  static DefineStatus + #724, #3967
  static DefineStatus + #725, #3967
  static DefineStatus + #726, #3967
  static DefineStatus + #727, #3967
  static DefineStatus + #728, #3967
  static DefineStatus + #729, #3967
  static DefineStatus + #730, #3967
  static DefineStatus + #731, #3967
  static DefineStatus + #732, #3967
  static DefineStatus + #733, #3967
  static DefineStatus + #734, #3967
  static DefineStatus + #735, #3967
  static DefineStatus + #736, #3967
  static DefineStatus + #737, #3967
  static DefineStatus + #738, #3967
  static DefineStatus + #739, #3967
  static DefineStatus + #740, #3967
  static DefineStatus + #741, #3967
  static DefineStatus + #742, #3967
  static DefineStatus + #743, #3967
  static DefineStatus + #744, #3967
  static DefineStatus + #745, #3967
  static DefineStatus + #746, #3967
  static DefineStatus + #747, #3967
  static DefineStatus + #748, #3967
  static DefineStatus + #749, #3967
  static DefineStatus + #750, #3967
  static DefineStatus + #751, #3967
  static DefineStatus + #752, #3967
  static DefineStatus + #753, #3967
  static DefineStatus + #754, #3967
  static DefineStatus + #755, #3967
  static DefineStatus + #756, #3967
  static DefineStatus + #757, #3967
  static DefineStatus + #758, #3967
  static DefineStatus + #759, #3967

  ;Linha 19
  static DefineStatus + #760, #3967
  static DefineStatus + #761, #3408
  static DefineStatus + #762, #3407
  static DefineStatus + #763, #3395
  static DefineStatus + #764, #3393
  static DefineStatus + #765, #3407
  static DefineStatus + #766, #58
  static DefineStatus + #767, #3967
  static DefineStatus + #768, #3967
  static DefineStatus + #769, #3967
  static DefineStatus + #770, #3967
  static DefineStatus + #771, #3967
  static DefineStatus + #772, #2349
  static DefineStatus + #773, #3967
  static DefineStatus + #774, #555
  static DefineStatus + #775, #3967
  static DefineStatus + #776, #1371
  static DefineStatus + #777, #2371
  static DefineStatus + #778, #3967
  static DefineStatus + #779, #580
  static DefineStatus + #780, #1373
  static DefineStatus + #781, #3967
  static DefineStatus + #782, #3967
  static DefineStatus + #783, #3967
  static DefineStatus + #784, #3967
  static DefineStatus + #785, #3967
  static DefineStatus + #786, #2373
  static DefineStatus + #787, #2382
  static DefineStatus + #788, #2388
  static DefineStatus + #789, #2373
  static DefineStatus + #790, #2386
  static DefineStatus + #791, #3967
  static DefineStatus + #792, #3967
  static DefineStatus + #793, #3967
  static DefineStatus + #794, #3967
  static DefineStatus + #795, #3967
  static DefineStatus + #796, #3967
  static DefineStatus + #797, #3967
  static DefineStatus + #798, #3967
  static DefineStatus + #799, #3967

  ;Linha 20
  static DefineStatus + #800, #3967
  static DefineStatus + #801, #3967
  static DefineStatus + #802, #3967
  static DefineStatus + #803, #3967
  static DefineStatus + #804, #3967
  static DefineStatus + #805, #3967
  static DefineStatus + #806, #3967
  static DefineStatus + #807, #3967
  static DefineStatus + #808, #3967
  static DefineStatus + #809, #3967
  static DefineStatus + #810, #3967
  static DefineStatus + #811, #3967
  static DefineStatus + #812, #127
  static DefineStatus + #813, #3967
  static DefineStatus + #814, #3967
  static DefineStatus + #815, #3967
  static DefineStatus + #816, #3967
  static DefineStatus + #817, #3967
  static DefineStatus + #818, #3967
  static DefineStatus + #819, #3967
  static DefineStatus + #820, #3967
  static DefineStatus + #821, #3967
  static DefineStatus + #822, #3967
  static DefineStatus + #823, #3967
  static DefineStatus + #824, #3967
  static DefineStatus + #825, #3967
  static DefineStatus + #826, #3967
  static DefineStatus + #827, #3967
  static DefineStatus + #828, #3967
  static DefineStatus + #829, #3967
  static DefineStatus + #830, #3967
  static DefineStatus + #831, #3967
  static DefineStatus + #832, #3967
  static DefineStatus + #833, #3967
  static DefineStatus + #834, #3967
  static DefineStatus + #835, #3967
  static DefineStatus + #836, #3967
  static DefineStatus + #837, #3967
  static DefineStatus + #838, #3967
  static DefineStatus + #839, #3967

  ;Linha 21
  static DefineStatus + #840, #3967
  static DefineStatus + #841, #577
  static DefineStatus + #842, #596
  static DefineStatus + #843, #587
  static DefineStatus + #844, #597
  static DefineStatus + #845, #592
  static DefineStatus + #846, #58
  static DefineStatus + #847, #3967
  static DefineStatus + #848, #3967
  static DefineStatus + #849, #3967
  static DefineStatus + #850, #3967
  static DefineStatus + #851, #3967
  static DefineStatus + #852, #2349
  static DefineStatus + #853, #3967
  static DefineStatus + #854, #555
  static DefineStatus + #855, #3967
  static DefineStatus + #856, #1371
  static DefineStatus + #857, #2373
  static DefineStatus + #858, #3967
  static DefineStatus + #859, #582
  static DefineStatus + #860, #1373
  static DefineStatus + #861, #3967
  static DefineStatus + #862, #3967
  static DefineStatus + #863, #3967
  static DefineStatus + #864, #80
  static DefineStatus + #865, #65
  static DefineStatus + #866, #82
  static DefineStatus + #867, #65
  static DefineStatus + #868, #3967
  static DefineStatus + #869, #74
  static DefineStatus + #870, #79
  static DefineStatus + #871, #71
  static DefineStatus + #872, #65
  static DefineStatus + #873, #82
  static DefineStatus + #874, #3967
  static DefineStatus + #875, #3967
  static DefineStatus + #876, #3967
  static DefineStatus + #877, #3967
  static DefineStatus + #878, #3967
  static DefineStatus + #879, #3967

  ;Linha 22
  static DefineStatus + #880, #3967
  static DefineStatus + #881, #3967
  static DefineStatus + #882, #3967
  static DefineStatus + #883, #3967
  static DefineStatus + #884, #3967
  static DefineStatus + #885, #3967
  static DefineStatus + #886, #3967
  static DefineStatus + #887, #3967
  static DefineStatus + #888, #3967
  static DefineStatus + #889, #3967
  static DefineStatus + #890, #3967
  static DefineStatus + #891, #3967
  static DefineStatus + #892, #3967
  static DefineStatus + #893, #3967
  static DefineStatus + #894, #3967
  static DefineStatus + #895, #3967
  static DefineStatus + #896, #3967
  static DefineStatus + #897, #3967
  static DefineStatus + #898, #3967
  static DefineStatus + #899, #3967
  static DefineStatus + #900, #3967
  static DefineStatus + #901, #3967
  static DefineStatus + #902, #3967
  static DefineStatus + #903, #3967
  static DefineStatus + #904, #3967
  static DefineStatus + #905, #3967
  static DefineStatus + #906, #3967
  static DefineStatus + #907, #3967
  static DefineStatus + #908, #3967
  static DefineStatus + #909, #3967
  static DefineStatus + #910, #3967
  static DefineStatus + #911, #3967
  static DefineStatus + #912, #3967
  static DefineStatus + #913, #3967
  static DefineStatus + #914, #3967
  static DefineStatus + #915, #3967
  static DefineStatus + #916, #3967
  static DefineStatus + #917, #3967
  static DefineStatus + #918, #3967
  static DefineStatus + #919, #3967

  ;Linha 23
  static DefineStatus + #920, #3967
  static DefineStatus + #921, #2116
  static DefineStatus + #922, #2117
  static DefineStatus + #923, #2118
  static DefineStatus + #924, #2133
  static DefineStatus + #925, #2128
  static DefineStatus + #926, #58
  static DefineStatus + #927, #3967
  static DefineStatus + #928, #3967
  static DefineStatus + #929, #3967
  static DefineStatus + #930, #3967
  static DefineStatus + #931, #3967
  static DefineStatus + #932, #2349
  static DefineStatus + #933, #3967
  static DefineStatus + #934, #555
  static DefineStatus + #935, #3967
  static DefineStatus + #936, #1371
  static DefineStatus + #937, #2375
  static DefineStatus + #938, #3967
  static DefineStatus + #939, #584
  static DefineStatus + #940, #1373
  static DefineStatus + #941, #3967
  static DefineStatus + #942, #3967
  static DefineStatus + #943, #3967
  static DefineStatus + #944, #3967
  static DefineStatus + #945, #3967
  static DefineStatus + #946, #3967
  static DefineStatus + #947, #3967
  static DefineStatus + #948, #3967
  static DefineStatus + #949, #3967
  static DefineStatus + #950, #3967
  static DefineStatus + #951, #3967
  static DefineStatus + #952, #3967
  static DefineStatus + #953, #3967
  static DefineStatus + #954, #3967
  static DefineStatus + #955, #3967
  static DefineStatus + #956, #3967
  static DefineStatus + #957, #3967
  static DefineStatus + #958, #3967
  static DefineStatus + #959, #3967

  ;Linha 24
  static DefineStatus + #960, #3967
  static DefineStatus + #961, #3967
  static DefineStatus + #962, #3967
  static DefineStatus + #963, #3967
  static DefineStatus + #964, #3967
  static DefineStatus + #965, #3967
  static DefineStatus + #966, #3967
  static DefineStatus + #967, #3967
  static DefineStatus + #968, #3967
  static DefineStatus + #969, #3967
  static DefineStatus + #970, #3967
  static DefineStatus + #971, #3967
  static DefineStatus + #972, #3967
  static DefineStatus + #973, #3967
  static DefineStatus + #974, #3967
  static DefineStatus + #975, #3967
  static DefineStatus + #976, #3967
  static DefineStatus + #977, #3967
  static DefineStatus + #978, #3967
  static DefineStatus + #979, #3967
  static DefineStatus + #980, #3967
  static DefineStatus + #981, #3967
  static DefineStatus + #982, #3967
  static DefineStatus + #983, #3967
  static DefineStatus + #984, #3967
  static DefineStatus + #985, #3967
  static DefineStatus + #986, #3967
  static DefineStatus + #987, #3967
  static DefineStatus + #988, #3967
  static DefineStatus + #989, #3967
  static DefineStatus + #990, #3967
  static DefineStatus + #991, #3967
  static DefineStatus + #992, #3967
  static DefineStatus + #993, #3967
  static DefineStatus + #994, #3967
  static DefineStatus + #995, #3967
  static DefineStatus + #996, #3967
  static DefineStatus + #997, #3967
  static DefineStatus + #998, #3967
  static DefineStatus + #999, #3967

  ;Linha 25
  static DefineStatus + #1000, #3967
  static DefineStatus + #1001, #3967
  static DefineStatus + #1002, #3967
  static DefineStatus + #1003, #3967
  static DefineStatus + #1004, #3967
  static DefineStatus + #1005, #3967
  static DefineStatus + #1006, #3967
  static DefineStatus + #1007, #3967
  static DefineStatus + #1008, #3967
  static DefineStatus + #1009, #3967
  static DefineStatus + #1010, #3967
  static DefineStatus + #1011, #3967
  static DefineStatus + #1012, #3967
  static DefineStatus + #1013, #3967
  static DefineStatus + #1014, #3967
  static DefineStatus + #1015, #3967
  static DefineStatus + #1016, #3967
  static DefineStatus + #1017, #3967
  static DefineStatus + #1018, #3967
  static DefineStatus + #1019, #3967
  static DefineStatus + #1020, #3967
  static DefineStatus + #1021, #3967
  static DefineStatus + #1022, #3967
  static DefineStatus + #1023, #3967
  static DefineStatus + #1024, #3967
  static DefineStatus + #1025, #3967
  static DefineStatus + #1026, #3967
  static DefineStatus + #1027, #3967
  static DefineStatus + #1028, #3967
  static DefineStatus + #1029, #3967
  static DefineStatus + #1030, #3967
  static DefineStatus + #1031, #3967
  static DefineStatus + #1032, #3967
  static DefineStatus + #1033, #3967
  static DefineStatus + #1034, #3967
  static DefineStatus + #1035, #3967
  static DefineStatus + #1036, #3967
  static DefineStatus + #1037, #3967
  static DefineStatus + #1038, #3967
  static DefineStatus + #1039, #3967

  ;Linha 26
  static DefineStatus + #1040, #3967
  static DefineStatus + #1041, #3967
  static DefineStatus + #1042, #3967
  static DefineStatus + #1043, #3967
  static DefineStatus + #1044, #3967
  static DefineStatus + #1045, #3967
  static DefineStatus + #1046, #3967
  static DefineStatus + #1047, #3967
  static DefineStatus + #1048, #3967
  static DefineStatus + #1049, #3967
  static DefineStatus + #1050, #3967
  static DefineStatus + #1051, #3967
  static DefineStatus + #1052, #3967
  static DefineStatus + #1053, #3967
  static DefineStatus + #1054, #3967
  static DefineStatus + #1055, #3967
  static DefineStatus + #1056, #3967
  static DefineStatus + #1057, #3967
  static DefineStatus + #1058, #3967
  static DefineStatus + #1059, #3967
  static DefineStatus + #1060, #3967
  static DefineStatus + #1061, #3967
  static DefineStatus + #1062, #3967
  static DefineStatus + #1063, #3967
  static DefineStatus + #1064, #3967
  static DefineStatus + #1065, #3967
  static DefineStatus + #1066, #3967
  static DefineStatus + #1067, #3967
  static DefineStatus + #1068, #3967
  static DefineStatus + #1069, #3967
  static DefineStatus + #1070, #3967
  static DefineStatus + #1071, #3967
  static DefineStatus + #1072, #3967
  static DefineStatus + #1073, #3967
  static DefineStatus + #1074, #3967
  static DefineStatus + #1075, #3967
  static DefineStatus + #1076, #3967
  static DefineStatus + #1077, #3967
  static DefineStatus + #1078, #3967
  static DefineStatus + #1079, #3967

  ;Linha 27
  static DefineStatus + #1080, #3967
  static DefineStatus + #1081, #3967
  static DefineStatus + #1082, #3967
  static DefineStatus + #1083, #3967
  static DefineStatus + #1084, #3967
  static DefineStatus + #1085, #3967
  static DefineStatus + #1086, #3967
  static DefineStatus + #1087, #3967
  static DefineStatus + #1088, #3967
  static DefineStatus + #1089, #3967
  static DefineStatus + #1090, #3967
  static DefineStatus + #1091, #3967
  static DefineStatus + #1092, #3967
  static DefineStatus + #1093, #3967
  static DefineStatus + #1094, #3967
  static DefineStatus + #1095, #3967
  static DefineStatus + #1096, #3967
  static DefineStatus + #1097, #3967
  static DefineStatus + #1098, #3967
  static DefineStatus + #1099, #3967
  static DefineStatus + #1100, #3967
  static DefineStatus + #1101, #3967
  static DefineStatus + #1102, #3967
  static DefineStatus + #1103, #3967
  static DefineStatus + #1104, #3967
  static DefineStatus + #1105, #3967
  static DefineStatus + #1106, #3967
  static DefineStatus + #1107, #3967
  static DefineStatus + #1108, #3967
  static DefineStatus + #1109, #3967
  static DefineStatus + #1110, #3967
  static DefineStatus + #1111, #3967
  static DefineStatus + #1112, #3967
  static DefineStatus + #1113, #3967
  static DefineStatus + #1114, #3967
  static DefineStatus + #1115, #3967
  static DefineStatus + #1116, #3967
  static DefineStatus + #1117, #3967
  static DefineStatus + #1118, #3967
  static DefineStatus + #1119, #3967

  ;Linha 28
  static DefineStatus + #1120, #3967
  static DefineStatus + #1121, #3967
  static DefineStatus + #1122, #3967
  static DefineStatus + #1123, #3967
  static DefineStatus + #1124, #3967
  static DefineStatus + #1125, #3967
  static DefineStatus + #1126, #3967
  static DefineStatus + #1127, #3967
  static DefineStatus + #1128, #3967
  static DefineStatus + #1129, #3967
  static DefineStatus + #1130, #3967
  static DefineStatus + #1131, #3967
  static DefineStatus + #1132, #3967
  static DefineStatus + #1133, #3967
  static DefineStatus + #1134, #3967
  static DefineStatus + #1135, #3967
  static DefineStatus + #1136, #3967
  static DefineStatus + #1137, #3967
  static DefineStatus + #1138, #3967
  static DefineStatus + #1139, #3967
  static DefineStatus + #1140, #3967
  static DefineStatus + #1141, #3967
  static DefineStatus + #1142, #3967
  static DefineStatus + #1143, #3967
  static DefineStatus + #1144, #3967
  static DefineStatus + #1145, #3967
  static DefineStatus + #1146, #3967
  static DefineStatus + #1147, #3967
  static DefineStatus + #1148, #3967
  static DefineStatus + #1149, #3967
  static DefineStatus + #1150, #3967
  static DefineStatus + #1151, #3967
  static DefineStatus + #1152, #3967
  static DefineStatus + #1153, #3967
  static DefineStatus + #1154, #3967
  static DefineStatus + #1155, #3967
  static DefineStatus + #1156, #3967
  static DefineStatus + #1157, #3967
  static DefineStatus + #1158, #3967
  static DefineStatus + #1159, #3967

  ;Linha 29
  static DefineStatus + #1160, #3967
  static DefineStatus + #1161, #3967
  static DefineStatus + #1162, #3967
  static DefineStatus + #1163, #3967
  static DefineStatus + #1164, #3967
  static DefineStatus + #1165, #3967
  static DefineStatus + #1166, #3967
  static DefineStatus + #1167, #3967
  static DefineStatus + #1168, #3967
  static DefineStatus + #1169, #3967
  static DefineStatus + #1170, #3967
  static DefineStatus + #1171, #3967
  static DefineStatus + #1172, #3967
  static DefineStatus + #1173, #3967
  static DefineStatus + #1174, #3967
  static DefineStatus + #1175, #3967
  static DefineStatus + #1176, #3967
  static DefineStatus + #1177, #3967
  static DefineStatus + #1178, #3967
  static DefineStatus + #1179, #3967
  static DefineStatus + #1180, #3967
  static DefineStatus + #1181, #3967
  static DefineStatus + #1182, #3967
  static DefineStatus + #1183, #3967
  static DefineStatus + #1184, #3967
  static DefineStatus + #1185, #3967
  static DefineStatus + #1186, #3967
  static DefineStatus + #1187, #3967
  static DefineStatus + #1188, #3967
  static DefineStatus + #1189, #3967
  static DefineStatus + #1190, #3967
  static DefineStatus + #1191, #3967
  static DefineStatus + #1192, #3967
  static DefineStatus + #1193, #3967
  static DefineStatus + #1194, #3967
  static DefineStatus + #1195, #3967
  static DefineStatus + #1196, #3967
  static DefineStatus + #1197, #3967
  static DefineStatus + #1198, #3967
  static DefineStatus + #1199, #3967

printDefineStatusScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #DefineStatus
  loadn R1, #0
  loadn R2, #1200

  printDefineStatusScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printDefineStatusScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

JMP_TABLE_STATUS: var #256
static JMP_TABLE_STATUS + #0, #0
static JMP_TABLE_STATUS + #1, #0
static JMP_TABLE_STATUS + #2, #0
static JMP_TABLE_STATUS + #3, #0
static JMP_TABLE_STATUS + #4, #0
static JMP_TABLE_STATUS + #5, #0
static JMP_TABLE_STATUS + #6, #0
static JMP_TABLE_STATUS + #7, #0
static JMP_TABLE_STATUS + #8, #0
static JMP_TABLE_STATUS + #9, #0
static JMP_TABLE_STATUS + #10, #0
static JMP_TABLE_STATUS + #11, #0
static JMP_TABLE_STATUS + #12, #0
static JMP_TABLE_STATUS + #13, #0
static JMP_TABLE_STATUS + #14, #0
static JMP_TABLE_STATUS + #15, #0
static JMP_TABLE_STATUS + #16, #0
static JMP_TABLE_STATUS + #17, #0
static JMP_TABLE_STATUS + #18, #0
static JMP_TABLE_STATUS + #19, #0
static JMP_TABLE_STATUS + #20, #0
static JMP_TABLE_STATUS + #21, #0
static JMP_TABLE_STATUS + #22, #0
static JMP_TABLE_STATUS + #23, #0
static JMP_TABLE_STATUS + #24, #0
static JMP_TABLE_STATUS + #25, #0
static JMP_TABLE_STATUS + #26, #0
static JMP_TABLE_STATUS + #27, #0
static JMP_TABLE_STATUS + #28, #0
static JMP_TABLE_STATUS + #29, #0
static JMP_TABLE_STATUS + #30, #0
static JMP_TABLE_STATUS + #31, #0
static JMP_TABLE_STATUS + #32, #0
static JMP_TABLE_STATUS + #33, #0
static JMP_TABLE_STATUS + #34, #0
static JMP_TABLE_STATUS + #35, #0
static JMP_TABLE_STATUS + #36, #0
static JMP_TABLE_STATUS + #37, #0
static JMP_TABLE_STATUS + #38, #0
static JMP_TABLE_STATUS + #39, #0
static JMP_TABLE_STATUS + #40, #0
static JMP_TABLE_STATUS + #41, #0
static JMP_TABLE_STATUS + #42, #0
static JMP_TABLE_STATUS + #43, #0
static JMP_TABLE_STATUS + #44, #0
static JMP_TABLE_STATUS + #45, #0
static JMP_TABLE_STATUS + #46, #0
static JMP_TABLE_STATUS + #47, #0
static JMP_TABLE_STATUS + #48, #aumenta_spe
static JMP_TABLE_STATUS + #49, #diminui_atk
static JMP_TABLE_STATUS + #50, #aumenta_atk
static JMP_TABLE_STATUS + #51, #diminui_def
static JMP_TABLE_STATUS + #52, #aumenta_def
static JMP_TABLE_STATUS + #53, #diminui_spa
static JMP_TABLE_STATUS + #54, #aumenta_spa
static JMP_TABLE_STATUS + #55, #diminui_spd
static JMP_TABLE_STATUS + #56, #aumenta_spd
static JMP_TABLE_STATUS + #57, #diminui_spe
static JMP_TABLE_STATUS + #58, #0
static JMP_TABLE_STATUS + #59, #0
static JMP_TABLE_STATUS + #60, #0
static JMP_TABLE_STATUS + #61, #0
static JMP_TABLE_STATUS + #62, #0
static JMP_TABLE_STATUS + #63, #0
static JMP_TABLE_STATUS + #64, #0
static JMP_TABLE_STATUS + #65, #0
static JMP_TABLE_STATUS + #66, #0
static JMP_TABLE_STATUS + #67, #0
static JMP_TABLE_STATUS + #68, #0
static JMP_TABLE_STATUS + #69, #0
static JMP_TABLE_STATUS + #70, #0
static JMP_TABLE_STATUS + #71, #0
static JMP_TABLE_STATUS + #72, #0
static JMP_TABLE_STATUS + #73, #0
static JMP_TABLE_STATUS + #74, #0
static JMP_TABLE_STATUS + #75, #0
static JMP_TABLE_STATUS + #76, #0
static JMP_TABLE_STATUS + #77, #0
static JMP_TABLE_STATUS + #78, #0
static JMP_TABLE_STATUS + #79, #0
static JMP_TABLE_STATUS + #80, #0
static JMP_TABLE_STATUS + #81, #0
static JMP_TABLE_STATUS + #82, #0
static JMP_TABLE_STATUS + #83, #0
static JMP_TABLE_STATUS + #84, #0
static JMP_TABLE_STATUS + #85, #0
static JMP_TABLE_STATUS + #86, #0
static JMP_TABLE_STATUS + #87, #0
static JMP_TABLE_STATUS + #88, #0
static JMP_TABLE_STATUS + #89, #0
static JMP_TABLE_STATUS + #90, #0
static JMP_TABLE_STATUS + #91, #0
static JMP_TABLE_STATUS + #92, #0
static JMP_TABLE_STATUS + #93, #0
static JMP_TABLE_STATUS + #94, #0
static JMP_TABLE_STATUS + #95, #0
static JMP_TABLE_STATUS + #96, #0
static JMP_TABLE_STATUS + #97, #diminui_hp
static JMP_TABLE_STATUS + #98, #aumenta_hp
static JMP_TABLE_STATUS + #99, #diminui_pocao
static JMP_TABLE_STATUS + #100, #aumenta_pocao
static JMP_TABLE_STATUS + #101, #diminui_atkup
static JMP_TABLE_STATUS + #102, #aumenta_atkup
static JMP_TABLE_STATUS + #103, #diminui_defup
static JMP_TABLE_STATUS + #104, #aumenta_defup
static JMP_TABLE_STATUS + #105, #0
static JMP_TABLE_STATUS + #106, #0
static JMP_TABLE_STATUS + #107, #0
static JMP_TABLE_STATUS + #108, #0
static JMP_TABLE_STATUS + #109, #0
static JMP_TABLE_STATUS + #110, #0
static JMP_TABLE_STATUS + #111, #0
static JMP_TABLE_STATUS + #112, #0
static JMP_TABLE_STATUS + #113, #0
static JMP_TABLE_STATUS + #114, #0
static JMP_TABLE_STATUS + #115, #0
static JMP_TABLE_STATUS + #116, #0
static JMP_TABLE_STATUS + #117, #0
static JMP_TABLE_STATUS + #118, #0
static JMP_TABLE_STATUS + #119, #0
static JMP_TABLE_STATUS + #120, #0
static JMP_TABLE_STATUS + #121, #0
static JMP_TABLE_STATUS + #122, #0
static JMP_TABLE_STATUS + #123, #0
static JMP_TABLE_STATUS + #124, #0
static JMP_TABLE_STATUS + #125, #0
static JMP_TABLE_STATUS + #126, #0
static JMP_TABLE_STATUS + #127, #0
static JMP_TABLE_STATUS + #128, #0
static JMP_TABLE_STATUS + #129, #0
static JMP_TABLE_STATUS + #130, #0
static JMP_TABLE_STATUS + #131, #0
static JMP_TABLE_STATUS + #132, #0
static JMP_TABLE_STATUS + #133, #0
static JMP_TABLE_STATUS + #134, #0
static JMP_TABLE_STATUS + #135, #0
static JMP_TABLE_STATUS + #136, #0
static JMP_TABLE_STATUS + #137, #0
static JMP_TABLE_STATUS + #138, #0
static JMP_TABLE_STATUS + #139, #0
static JMP_TABLE_STATUS + #140, #0
static JMP_TABLE_STATUS + #141, #0
static JMP_TABLE_STATUS + #142, #0
static JMP_TABLE_STATUS + #143, #0
static JMP_TABLE_STATUS + #144, #0
static JMP_TABLE_STATUS + #145, #0
static JMP_TABLE_STATUS + #146, #0
static JMP_TABLE_STATUS + #147, #0
static JMP_TABLE_STATUS + #148, #0
static JMP_TABLE_STATUS + #149, #0
static JMP_TABLE_STATUS + #150, #0
static JMP_TABLE_STATUS + #151, #0
static JMP_TABLE_STATUS + #152, #0
static JMP_TABLE_STATUS + #153, #0
static JMP_TABLE_STATUS + #154, #0
static JMP_TABLE_STATUS + #155, #0
static JMP_TABLE_STATUS + #156, #0
static JMP_TABLE_STATUS + #157, #0
static JMP_TABLE_STATUS + #158, #0
static JMP_TABLE_STATUS + #159, #0
static JMP_TABLE_STATUS + #160, #0
static JMP_TABLE_STATUS + #161, #0
static JMP_TABLE_STATUS + #162, #0
static JMP_TABLE_STATUS + #163, #0
static JMP_TABLE_STATUS + #164, #0
static JMP_TABLE_STATUS + #165, #0
static JMP_TABLE_STATUS + #166, #0
static JMP_TABLE_STATUS + #167, #0
static JMP_TABLE_STATUS + #168, #0
static JMP_TABLE_STATUS + #169, #0
static JMP_TABLE_STATUS + #170, #0
static JMP_TABLE_STATUS + #171, #0
static JMP_TABLE_STATUS + #172, #0
static JMP_TABLE_STATUS + #173, #0
static JMP_TABLE_STATUS + #174, #0
static JMP_TABLE_STATUS + #175, #0
static JMP_TABLE_STATUS + #176, #0
static JMP_TABLE_STATUS + #177, #0
static JMP_TABLE_STATUS + #178, #0
static JMP_TABLE_STATUS + #179, #0
static JMP_TABLE_STATUS + #180, #0
static JMP_TABLE_STATUS + #181, #0
static JMP_TABLE_STATUS + #182, #0
static JMP_TABLE_STATUS + #183, #0
static JMP_TABLE_STATUS + #184, #0
static JMP_TABLE_STATUS + #185, #0
static JMP_TABLE_STATUS + #186, #0
static JMP_TABLE_STATUS + #187, #0
static JMP_TABLE_STATUS + #188, #0
static JMP_TABLE_STATUS + #189, #0
static JMP_TABLE_STATUS + #190, #0
static JMP_TABLE_STATUS + #191, #0
static JMP_TABLE_STATUS + #192, #0
static JMP_TABLE_STATUS + #193, #0
static JMP_TABLE_STATUS + #194, #0
static JMP_TABLE_STATUS + #195, #0
static JMP_TABLE_STATUS + #196, #0
static JMP_TABLE_STATUS + #197, #0
static JMP_TABLE_STATUS + #198, #0
static JMP_TABLE_STATUS + #199, #0
static JMP_TABLE_STATUS + #200, #0
static JMP_TABLE_STATUS + #201, #0
static JMP_TABLE_STATUS + #202, #0
static JMP_TABLE_STATUS + #203, #0
static JMP_TABLE_STATUS + #204, #0
static JMP_TABLE_STATUS + #205, #0
static JMP_TABLE_STATUS + #206, #0
static JMP_TABLE_STATUS + #207, #0
static JMP_TABLE_STATUS + #208, #0
static JMP_TABLE_STATUS + #209, #0
static JMP_TABLE_STATUS + #210, #0
static JMP_TABLE_STATUS + #211, #0
static JMP_TABLE_STATUS + #212, #0
static JMP_TABLE_STATUS + #213, #0
static JMP_TABLE_STATUS + #214, #0
static JMP_TABLE_STATUS + #215, #0
static JMP_TABLE_STATUS + #216, #0
static JMP_TABLE_STATUS + #217, #0
static JMP_TABLE_STATUS + #218, #0
static JMP_TABLE_STATUS + #219, #0
static JMP_TABLE_STATUS + #220, #0
static JMP_TABLE_STATUS + #221, #0
static JMP_TABLE_STATUS + #222, #0
static JMP_TABLE_STATUS + #223, #0
static JMP_TABLE_STATUS + #224, #0
static JMP_TABLE_STATUS + #225, #0
static JMP_TABLE_STATUS + #226, #0
static JMP_TABLE_STATUS + #227, #0
static JMP_TABLE_STATUS + #228, #0
static JMP_TABLE_STATUS + #229, #0
static JMP_TABLE_STATUS + #230, #0
static JMP_TABLE_STATUS + #231, #0
static JMP_TABLE_STATUS + #232, #0
static JMP_TABLE_STATUS + #233, #0
static JMP_TABLE_STATUS + #234, #0
static JMP_TABLE_STATUS + #235, #0
static JMP_TABLE_STATUS + #236, #0
static JMP_TABLE_STATUS + #237, #0
static JMP_TABLE_STATUS + #238, #0
static JMP_TABLE_STATUS + #239, #0
static JMP_TABLE_STATUS + #240, #0
static JMP_TABLE_STATUS + #241, #0
static JMP_TABLE_STATUS + #242, #0
static JMP_TABLE_STATUS + #243, #0
static JMP_TABLE_STATUS + #244, #0
static JMP_TABLE_STATUS + #245, #0
static JMP_TABLE_STATUS + #246, #0
static JMP_TABLE_STATUS + #247, #0
static JMP_TABLE_STATUS + #248, #0
static JMP_TABLE_STATUS + #249, #0
static JMP_TABLE_STATUS + #250, #0
static JMP_TABLE_STATUS + #251, #0
static JMP_TABLE_STATUS + #252, #0
static JMP_TABLE_STATUS + #253, #0
static JMP_TABLE_STATUS + #254, #0
static JMP_TABLE_STATUS + #255, #0

Batalha1 : var #1200
  ;Linha 0
  static Batalha1 + #0, #3967
  static Batalha1 + #1, #3967
  static Batalha1 + #2, #3967
  static Batalha1 + #3, #3967
  static Batalha1 + #4, #3967
  static Batalha1 + #5, #3967
  static Batalha1 + #6, #3967
  static Batalha1 + #7, #3967
  static Batalha1 + #8, #3967
  static Batalha1 + #9, #3967
  static Batalha1 + #10, #3967
  static Batalha1 + #11, #3967
  static Batalha1 + #12, #3967
  static Batalha1 + #13, #3967
  static Batalha1 + #14, #3967
  static Batalha1 + #15, #3967
  static Batalha1 + #16, #3967
  static Batalha1 + #17, #3967
  static Batalha1 + #18, #3967
  static Batalha1 + #19, #3967
  static Batalha1 + #20, #3967
  static Batalha1 + #21, #3967
  static Batalha1 + #22, #3967
  static Batalha1 + #23, #3967
  static Batalha1 + #24, #3967
  static Batalha1 + #25, #3967
  static Batalha1 + #26, #3967
  static Batalha1 + #27, #3967
  static Batalha1 + #28, #3967
  static Batalha1 + #29, #3967
  static Batalha1 + #30, #3967
  static Batalha1 + #31, #3967
  static Batalha1 + #32, #3967
  static Batalha1 + #33, #3967
  static Batalha1 + #34, #3967
  static Batalha1 + #35, #3967
  static Batalha1 + #36, #3967
  static Batalha1 + #37, #3967
  static Batalha1 + #38, #3967
  static Batalha1 + #39, #3967

  ;Linha 1
  static Batalha1 + #40, #3967
  static Batalha1 + #41, #3967
  static Batalha1 + #42, #3967
  static Batalha1 + #43, #3967
  static Batalha1 + #44, #3967
  static Batalha1 + #45, #3967
  static Batalha1 + #46, #3967
  static Batalha1 + #47, #3967
  static Batalha1 + #48, #3967
  static Batalha1 + #49, #3967
  static Batalha1 + #50, #3967
  static Batalha1 + #51, #3967
  static Batalha1 + #52, #3967
  static Batalha1 + #53, #3967
  static Batalha1 + #54, #3967
  static Batalha1 + #55, #3967
  static Batalha1 + #56, #3967
  static Batalha1 + #57, #3967
  static Batalha1 + #58, #3967
  static Batalha1 + #59, #3967
  static Batalha1 + #60, #3967
  static Batalha1 + #61, #3967
  static Batalha1 + #62, #3967
  static Batalha1 + #63, #3967
  static Batalha1 + #64, #3967
  static Batalha1 + #65, #3967
  static Batalha1 + #66, #3967
  static Batalha1 + #67, #3967
  static Batalha1 + #68, #3967
  static Batalha1 + #69, #3967
  static Batalha1 + #70, #3967
  static Batalha1 + #71, #3967
  static Batalha1 + #72, #3967
  static Batalha1 + #73, #3967
  static Batalha1 + #74, #3967
  static Batalha1 + #75, #3967
  static Batalha1 + #76, #3967
  static Batalha1 + #77, #3967
  static Batalha1 + #78, #3967
  static Batalha1 + #79, #3967

  ;Linha 2
  static Batalha1 + #80, #3967
  static Batalha1 + #81, #3967
  static Batalha1 + #82, #3967
  static Batalha1 + #83, #3967
  static Batalha1 + #84, #3967
  static Batalha1 + #85, #3967
  static Batalha1 + #86, #3967
  static Batalha1 + #87, #3967
  static Batalha1 + #88, #3967
  static Batalha1 + #89, #3967
  static Batalha1 + #90, #3967
  static Batalha1 + #91, #3967
  static Batalha1 + #92, #3967
  static Batalha1 + #93, #3967
  static Batalha1 + #94, #3967
  static Batalha1 + #95, #3967
  static Batalha1 + #96, #3967
  static Batalha1 + #97, #3967
  static Batalha1 + #98, #3967
  static Batalha1 + #99, #3967
  static Batalha1 + #100, #3967
  static Batalha1 + #101, #3967
  static Batalha1 + #102, #3967
  static Batalha1 + #103, #3967
  static Batalha1 + #104, #3967
  static Batalha1 + #105, #3967
  static Batalha1 + #106, #3967
  static Batalha1 + #107, #3967
  static Batalha1 + #108, #3967
  static Batalha1 + #109, #3967
  static Batalha1 + #110, #3967
  static Batalha1 + #111, #3967
  static Batalha1 + #112, #3967
  static Batalha1 + #113, #3967
  static Batalha1 + #114, #3967
  static Batalha1 + #115, #3967
  static Batalha1 + #116, #3967
  static Batalha1 + #117, #3967
  static Batalha1 + #118, #3967
  static Batalha1 + #119, #3967

  ;Linha 3
  static Batalha1 + #120, #3967
  static Batalha1 + #121, #3967
  static Batalha1 + #122, #3967
  static Batalha1 + #123, #3967
  static Batalha1 + #124, #3967
  static Batalha1 + #125, #3967
  static Batalha1 + #126, #3967
  static Batalha1 + #127, #3967
  static Batalha1 + #128, #3967
  static Batalha1 + #129, #3967
  static Batalha1 + #130, #3967
  static Batalha1 + #131, #3967
  static Batalha1 + #132, #3967
  static Batalha1 + #133, #3967
  static Batalha1 + #134, #3967
  static Batalha1 + #135, #3967
  static Batalha1 + #136, #3967
  static Batalha1 + #137, #3967
  static Batalha1 + #138, #3967
  static Batalha1 + #139, #3967
  static Batalha1 + #140, #3967
  static Batalha1 + #141, #3967
  static Batalha1 + #142, #3967
  static Batalha1 + #143, #3967
  static Batalha1 + #144, #3967
  static Batalha1 + #145, #3967
  static Batalha1 + #146, #3967
  static Batalha1 + #147, #3967
  static Batalha1 + #148, #3967
  static Batalha1 + #149, #3967
  static Batalha1 + #150, #3967
  static Batalha1 + #151, #3967
  static Batalha1 + #152, #3967
  static Batalha1 + #153, #3967
  static Batalha1 + #154, #3967
  static Batalha1 + #155, #3967
  static Batalha1 + #156, #3967
  static Batalha1 + #157, #3967
  static Batalha1 + #158, #3967
  static Batalha1 + #159, #3967

  ;Linha 4
  static Batalha1 + #160, #3967
  static Batalha1 + #161, #3967
  static Batalha1 + #162, #3967
  static Batalha1 + #163, #3967
  static Batalha1 + #164, #3967
  static Batalha1 + #165, #3967
  static Batalha1 + #166, #3967
  static Batalha1 + #167, #3967
  static Batalha1 + #168, #3967
  static Batalha1 + #169, #3967
  static Batalha1 + #170, #3967
  static Batalha1 + #171, #3967
  static Batalha1 + #172, #3967
  static Batalha1 + #173, #3967
  static Batalha1 + #174, #3967
  static Batalha1 + #175, #3967
  static Batalha1 + #176, #3967
  static Batalha1 + #177, #3967
  static Batalha1 + #178, #3967
  static Batalha1 + #179, #3967
  static Batalha1 + #180, #3967
  static Batalha1 + #181, #3967
  static Batalha1 + #182, #3967
  static Batalha1 + #183, #3967
  static Batalha1 + #184, #3967
  static Batalha1 + #185, #3967
  static Batalha1 + #186, #3967
  static Batalha1 + #187, #3967
  static Batalha1 + #188, #3967
  static Batalha1 + #189, #3967
  static Batalha1 + #190, #3967
  static Batalha1 + #191, #3967
  static Batalha1 + #192, #3967
  static Batalha1 + #193, #3967
  static Batalha1 + #194, #3967
  static Batalha1 + #195, #3967
  static Batalha1 + #196, #3967
  static Batalha1 + #197, #3967
  static Batalha1 + #198, #3967
  static Batalha1 + #199, #3967

  ;Linha 5
  static Batalha1 + #200, #3967
  static Batalha1 + #201, #3967
  static Batalha1 + #202, #3967
  static Batalha1 + #203, #3967
  static Batalha1 + #204, #3967
  static Batalha1 + #205, #3967
  static Batalha1 + #206, #3967
  static Batalha1 + #207, #3967
  static Batalha1 + #208, #3967
  static Batalha1 + #209, #3967
  static Batalha1 + #210, #3967
  static Batalha1 + #211, #3967
  static Batalha1 + #212, #3967
  static Batalha1 + #213, #3967
  static Batalha1 + #214, #3967
  static Batalha1 + #215, #3967
  static Batalha1 + #216, #3967
  static Batalha1 + #217, #3967
  static Batalha1 + #218, #3967
  static Batalha1 + #219, #3967
  static Batalha1 + #220, #3967
  static Batalha1 + #221, #3967
  static Batalha1 + #222, #3967
  static Batalha1 + #223, #3967
  static Batalha1 + #224, #3967
  static Batalha1 + #225, #3967
  static Batalha1 + #226, #3967
  static Batalha1 + #227, #3967
  static Batalha1 + #228, #3967
  static Batalha1 + #229, #3967
  static Batalha1 + #230, #3967
  static Batalha1 + #231, #3967
  static Batalha1 + #232, #3967
  static Batalha1 + #233, #3967
  static Batalha1 + #234, #3967
  static Batalha1 + #235, #3967
  static Batalha1 + #236, #3967
  static Batalha1 + #237, #3967
  static Batalha1 + #238, #3967
  static Batalha1 + #239, #3967

  ;Linha 6
  static Batalha1 + #240, #3967
  static Batalha1 + #241, #3967
  static Batalha1 + #242, #3967
  static Batalha1 + #243, #3967
  static Batalha1 + #244, #3967
  static Batalha1 + #245, #3967
  static Batalha1 + #246, #3967
  static Batalha1 + #247, #3967
  static Batalha1 + #248, #3967
  static Batalha1 + #249, #3967
  static Batalha1 + #250, #3967
  static Batalha1 + #251, #3967
  static Batalha1 + #252, #3967
  static Batalha1 + #253, #3967
  static Batalha1 + #254, #3967
  static Batalha1 + #255, #3967
  static Batalha1 + #256, #3967
  static Batalha1 + #257, #3967
  static Batalha1 + #258, #3967
  static Batalha1 + #259, #3967
  static Batalha1 + #260, #3967
  static Batalha1 + #261, #3967
  static Batalha1 + #262, #3967
  static Batalha1 + #263, #3967
  static Batalha1 + #264, #3967
  static Batalha1 + #265, #3967
  static Batalha1 + #266, #3967
  static Batalha1 + #267, #3967
  static Batalha1 + #268, #3967
  static Batalha1 + #269, #3967
  static Batalha1 + #270, #3967
  static Batalha1 + #271, #3967
  static Batalha1 + #272, #3967
  static Batalha1 + #273, #3967
  static Batalha1 + #274, #3967
  static Batalha1 + #275, #3967
  static Batalha1 + #276, #3967
  static Batalha1 + #277, #3967
  static Batalha1 + #278, #3967
  static Batalha1 + #279, #3967

  ;Linha 7
  static Batalha1 + #280, #3967
  static Batalha1 + #281, #3967
  static Batalha1 + #282, #3967
  static Batalha1 + #283, #3967
  static Batalha1 + #284, #3967
  static Batalha1 + #285, #3967
  static Batalha1 + #286, #3967
  static Batalha1 + #287, #3967
  static Batalha1 + #288, #3967
  static Batalha1 + #289, #3967
  static Batalha1 + #290, #3967
  static Batalha1 + #291, #3967
  static Batalha1 + #292, #3967
  static Batalha1 + #293, #3967
  static Batalha1 + #294, #3967
  static Batalha1 + #295, #3967
  static Batalha1 + #296, #3967
  static Batalha1 + #297, #3967
  static Batalha1 + #298, #3967
  static Batalha1 + #299, #3967
  static Batalha1 + #300, #3967
  static Batalha1 + #301, #3967
  static Batalha1 + #302, #3967
  static Batalha1 + #303, #3967
  static Batalha1 + #304, #3967
  static Batalha1 + #305, #3967
  static Batalha1 + #306, #3967
  static Batalha1 + #307, #3967
  static Batalha1 + #308, #3967
  static Batalha1 + #309, #3967
  static Batalha1 + #310, #3967
  static Batalha1 + #311, #3967
  static Batalha1 + #312, #3967
  static Batalha1 + #313, #3967
  static Batalha1 + #314, #3967
  static Batalha1 + #315, #3967
  static Batalha1 + #316, #3967
  static Batalha1 + #317, #3967
  static Batalha1 + #318, #3967
  static Batalha1 + #319, #3967

  ;Linha 8
  static Batalha1 + #320, #3967
  static Batalha1 + #321, #3967
  static Batalha1 + #322, #3967
  static Batalha1 + #323, #3967
  static Batalha1 + #324, #3967
  static Batalha1 + #325, #3967
  static Batalha1 + #326, #3967
  static Batalha1 + #327, #3967
  static Batalha1 + #328, #3967
  static Batalha1 + #329, #3967
  static Batalha1 + #330, #3967
  static Batalha1 + #331, #3967
  static Batalha1 + #332, #3967
  static Batalha1 + #333, #3967
  static Batalha1 + #334, #3967
  static Batalha1 + #335, #3967
  static Batalha1 + #336, #3967
  static Batalha1 + #337, #3967
  static Batalha1 + #338, #3967
  static Batalha1 + #339, #3967
  static Batalha1 + #340, #3967
  static Batalha1 + #341, #3967
  static Batalha1 + #342, #3967
  static Batalha1 + #343, #3967
  static Batalha1 + #344, #3967
  static Batalha1 + #345, #3967
  static Batalha1 + #346, #3967
  static Batalha1 + #347, #3967
  static Batalha1 + #348, #3967
  static Batalha1 + #349, #3967
  static Batalha1 + #350, #3967
  static Batalha1 + #351, #3967
  static Batalha1 + #352, #3967
  static Batalha1 + #353, #3967
  static Batalha1 + #354, #3967
  static Batalha1 + #355, #3967
  static Batalha1 + #356, #3967
  static Batalha1 + #357, #3967
  static Batalha1 + #358, #3967
  static Batalha1 + #359, #3967

  ;Linha 9
  static Batalha1 + #360, #3967
  static Batalha1 + #361, #3967
  static Batalha1 + #362, #3967
  static Batalha1 + #363, #3967
  static Batalha1 + #364, #3967
  static Batalha1 + #365, #3967
  static Batalha1 + #366, #3967
  static Batalha1 + #367, #3967
  static Batalha1 + #368, #3967
  static Batalha1 + #369, #3967
  static Batalha1 + #370, #3967
  static Batalha1 + #371, #3967
  static Batalha1 + #372, #3967
  static Batalha1 + #373, #3967
  static Batalha1 + #374, #3967
  static Batalha1 + #375, #3967
  static Batalha1 + #376, #3967
  static Batalha1 + #377, #3967
  static Batalha1 + #378, #3967
  static Batalha1 + #379, #3967
  static Batalha1 + #380, #3967
  static Batalha1 + #381, #3967
  static Batalha1 + #382, #3967
  static Batalha1 + #383, #3967
  static Batalha1 + #384, #3967
  static Batalha1 + #385, #3967
  static Batalha1 + #386, #3967
  static Batalha1 + #387, #3967
  static Batalha1 + #388, #3967
  static Batalha1 + #389, #3967
  static Batalha1 + #390, #3967
  static Batalha1 + #391, #3967
  static Batalha1 + #392, #3967
  static Batalha1 + #393, #3967
  static Batalha1 + #394, #3967
  static Batalha1 + #395, #3967
  static Batalha1 + #396, #3967
  static Batalha1 + #397, #3967
  static Batalha1 + #398, #3967
  static Batalha1 + #399, #3967

  ;Linha 10
  static Batalha1 + #400, #3967
  static Batalha1 + #401, #3967
  static Batalha1 + #402, #3967
  static Batalha1 + #403, #3967
  static Batalha1 + #404, #3967
  static Batalha1 + #405, #3967
  static Batalha1 + #406, #3967
  static Batalha1 + #407, #3967
  static Batalha1 + #408, #3967
  static Batalha1 + #409, #3967
  static Batalha1 + #410, #3967
  static Batalha1 + #411, #3967
  static Batalha1 + #412, #3967
  static Batalha1 + #413, #3967
  static Batalha1 + #414, #3967
  static Batalha1 + #415, #3967
  static Batalha1 + #416, #3967
  static Batalha1 + #417, #3967
  static Batalha1 + #418, #3967
  static Batalha1 + #419, #3967
  static Batalha1 + #420, #3967
  static Batalha1 + #421, #3967
  static Batalha1 + #422, #3967
  static Batalha1 + #423, #3967
  static Batalha1 + #424, #3967
  static Batalha1 + #425, #3967
  static Batalha1 + #426, #3967
  static Batalha1 + #427, #3967
  static Batalha1 + #428, #3967
  static Batalha1 + #429, #3967
  static Batalha1 + #430, #3967
  static Batalha1 + #431, #3967
  static Batalha1 + #432, #3967
  static Batalha1 + #433, #3967
  static Batalha1 + #434, #3967
  static Batalha1 + #435, #3967
  static Batalha1 + #436, #3967
  static Batalha1 + #437, #3967
  static Batalha1 + #438, #3967
  static Batalha1 + #439, #3967

  ;Linha 11
  static Batalha1 + #440, #3967
  static Batalha1 + #441, #3967
  static Batalha1 + #442, #3967
  static Batalha1 + #443, #3967
  static Batalha1 + #444, #3967
  static Batalha1 + #445, #3967
  static Batalha1 + #446, #3967
  static Batalha1 + #447, #3967
  static Batalha1 + #448, #3967
  static Batalha1 + #449, #3967
  static Batalha1 + #450, #3967
  static Batalha1 + #451, #3967
  static Batalha1 + #452, #3967
  static Batalha1 + #453, #3967
  static Batalha1 + #454, #3967
  static Batalha1 + #455, #3967
  static Batalha1 + #456, #3967
  static Batalha1 + #457, #3967
  static Batalha1 + #458, #3967
  static Batalha1 + #459, #3967
  static Batalha1 + #460, #3967
  static Batalha1 + #461, #3967
  static Batalha1 + #462, #3967
  static Batalha1 + #463, #3967
  static Batalha1 + #464, #3967
  static Batalha1 + #465, #3967
  static Batalha1 + #466, #3967
  static Batalha1 + #467, #3967
  static Batalha1 + #468, #3967
  static Batalha1 + #469, #3967
  static Batalha1 + #470, #3967
  static Batalha1 + #471, #3967
  static Batalha1 + #472, #3967
  static Batalha1 + #473, #3967
  static Batalha1 + #474, #3967
  static Batalha1 + #475, #3967
  static Batalha1 + #476, #3967
  static Batalha1 + #477, #3967
  static Batalha1 + #478, #3967
  static Batalha1 + #479, #3967

  ;Linha 12
  static Batalha1 + #480, #3967
  static Batalha1 + #481, #3967
  static Batalha1 + #482, #3967
  static Batalha1 + #483, #3967
  static Batalha1 + #484, #3967
  static Batalha1 + #485, #3967
  static Batalha1 + #486, #3967
  static Batalha1 + #487, #3967
  static Batalha1 + #488, #3967
  static Batalha1 + #489, #3967
  static Batalha1 + #490, #3967
  static Batalha1 + #491, #3967
  static Batalha1 + #492, #3967
  static Batalha1 + #493, #3967
  static Batalha1 + #494, #3967
  static Batalha1 + #495, #3967
  static Batalha1 + #496, #3967
  static Batalha1 + #497, #3967
  static Batalha1 + #498, #3967
  static Batalha1 + #499, #3967
  static Batalha1 + #500, #3967
  static Batalha1 + #501, #3967
  static Batalha1 + #502, #3967
  static Batalha1 + #503, #3967
  static Batalha1 + #504, #3967
  static Batalha1 + #505, #3967
  static Batalha1 + #506, #3967
  static Batalha1 + #507, #3967
  static Batalha1 + #508, #3967
  static Batalha1 + #509, #3967
  static Batalha1 + #510, #3967
  static Batalha1 + #511, #3967
  static Batalha1 + #512, #3967
  static Batalha1 + #513, #3967
  static Batalha1 + #514, #3967
  static Batalha1 + #515, #3967
  static Batalha1 + #516, #3967
  static Batalha1 + #517, #3967
  static Batalha1 + #518, #3967
  static Batalha1 + #519, #3967

  ;Linha 13
  static Batalha1 + #520, #3967
  static Batalha1 + #521, #3967
  static Batalha1 + #522, #3967
  static Batalha1 + #523, #3967
  static Batalha1 + #524, #3967
  static Batalha1 + #525, #3967
  static Batalha1 + #526, #3967
  static Batalha1 + #527, #3967
  static Batalha1 + #528, #3967
  static Batalha1 + #529, #3967
  static Batalha1 + #530, #3967
  static Batalha1 + #531, #3967
  static Batalha1 + #532, #3967
  static Batalha1 + #533, #3967
  static Batalha1 + #534, #3967
  static Batalha1 + #535, #3967
  static Batalha1 + #536, #3967
  static Batalha1 + #537, #3967
  static Batalha1 + #538, #3967
  static Batalha1 + #539, #3967
  static Batalha1 + #540, #3967
  static Batalha1 + #541, #3967
  static Batalha1 + #542, #3967
  static Batalha1 + #543, #3967
  static Batalha1 + #544, #3967
  static Batalha1 + #545, #3967
  static Batalha1 + #546, #3967
  static Batalha1 + #547, #3967
  static Batalha1 + #548, #3967
  static Batalha1 + #549, #3967
  static Batalha1 + #550, #3967
  static Batalha1 + #551, #3967
  static Batalha1 + #552, #3967
  static Batalha1 + #553, #3967
  static Batalha1 + #554, #3967
  static Batalha1 + #555, #3967
  static Batalha1 + #556, #3967
  static Batalha1 + #557, #3967
  static Batalha1 + #558, #3967
  static Batalha1 + #559, #3967

  ;Linha 14
  static Batalha1 + #560, #3967
  static Batalha1 + #561, #3967
  static Batalha1 + #562, #3967
  static Batalha1 + #563, #3967
  static Batalha1 + #564, #3967
  static Batalha1 + #565, #3967
  static Batalha1 + #566, #3967
  static Batalha1 + #567, #3967
  static Batalha1 + #568, #3967
  static Batalha1 + #569, #3967
  static Batalha1 + #570, #3967
  static Batalha1 + #571, #3967
  static Batalha1 + #572, #3967
  static Batalha1 + #573, #3967
  static Batalha1 + #574, #3967
  static Batalha1 + #575, #3967
  static Batalha1 + #576, #3967
  static Batalha1 + #577, #3967
  static Batalha1 + #578, #3967
  static Batalha1 + #579, #3967
  static Batalha1 + #580, #3967
  static Batalha1 + #581, #3967
  static Batalha1 + #582, #3967
  static Batalha1 + #583, #3967
  static Batalha1 + #584, #3967
  static Batalha1 + #585, #3967
  static Batalha1 + #586, #3967
  static Batalha1 + #587, #3967
  static Batalha1 + #588, #3967
  static Batalha1 + #589, #3967
  static Batalha1 + #590, #3967
  static Batalha1 + #591, #3967
  static Batalha1 + #592, #3967
  static Batalha1 + #593, #3967
  static Batalha1 + #594, #3967
  static Batalha1 + #595, #3967
  static Batalha1 + #596, #3967
  static Batalha1 + #597, #3967
  static Batalha1 + #598, #3967
  static Batalha1 + #599, #3967

  ;Linha 15
  static Batalha1 + #600, #3967
  static Batalha1 + #601, #3967
  static Batalha1 + #602, #3967
  static Batalha1 + #603, #3967
  static Batalha1 + #604, #3967
  static Batalha1 + #605, #3967
  static Batalha1 + #606, #3967
  static Batalha1 + #607, #3967
  static Batalha1 + #608, #3967
  static Batalha1 + #609, #3967
  static Batalha1 + #610, #3967
  static Batalha1 + #611, #3967
  static Batalha1 + #612, #3967
  static Batalha1 + #613, #3967
  static Batalha1 + #614, #3967
  static Batalha1 + #615, #3967
  static Batalha1 + #616, #3967
  static Batalha1 + #617, #3967
  static Batalha1 + #618, #3967
  static Batalha1 + #619, #3967
  static Batalha1 + #620, #3967
  static Batalha1 + #621, #3967
  static Batalha1 + #622, #3967
  static Batalha1 + #623, #3967
  static Batalha1 + #624, #3967
  static Batalha1 + #625, #3967
  static Batalha1 + #626, #3967
  static Batalha1 + #627, #3967
  static Batalha1 + #628, #3967
  static Batalha1 + #629, #3967
  static Batalha1 + #630, #3967
  static Batalha1 + #631, #3967
  static Batalha1 + #632, #3967
  static Batalha1 + #633, #3967
  static Batalha1 + #634, #3967
  static Batalha1 + #635, #3967
  static Batalha1 + #636, #3967
  static Batalha1 + #637, #3967
  static Batalha1 + #638, #3967
  static Batalha1 + #639, #3967

  ;Linha 16
  static Batalha1 + #640, #3967
  static Batalha1 + #641, #3967
  static Batalha1 + #642, #3967
  static Batalha1 + #643, #3967
  static Batalha1 + #644, #3967
  static Batalha1 + #645, #3967
  static Batalha1 + #646, #3967
  static Batalha1 + #647, #3967
  static Batalha1 + #648, #3967
  static Batalha1 + #649, #3967
  static Batalha1 + #650, #3967
  static Batalha1 + #651, #3967
  static Batalha1 + #652, #3967
  static Batalha1 + #653, #3967
  static Batalha1 + #654, #3967
  static Batalha1 + #655, #3967
  static Batalha1 + #656, #3967
  static Batalha1 + #657, #3967
  static Batalha1 + #658, #3967
  static Batalha1 + #659, #3967
  static Batalha1 + #660, #3967
  static Batalha1 + #661, #3967
  static Batalha1 + #662, #3967
  static Batalha1 + #663, #3967
  static Batalha1 + #664, #3967
  static Batalha1 + #665, #3967
  static Batalha1 + #666, #3967
  static Batalha1 + #667, #3967
  static Batalha1 + #668, #3967
  static Batalha1 + #669, #3967
  static Batalha1 + #670, #3967
  static Batalha1 + #671, #3967
  static Batalha1 + #672, #3967
  static Batalha1 + #673, #3967
  static Batalha1 + #674, #3967
  static Batalha1 + #675, #3967
  static Batalha1 + #676, #3967
  static Batalha1 + #677, #3967
  static Batalha1 + #678, #3967
  static Batalha1 + #679, #3967

  ;Linha 17
  static Batalha1 + #680, #3967
  static Batalha1 + #681, #3967
  static Batalha1 + #682, #3967
  static Batalha1 + #683, #3967
  static Batalha1 + #684, #3967
  static Batalha1 + #685, #3967
  static Batalha1 + #686, #3967
  static Batalha1 + #687, #3967
  static Batalha1 + #688, #3967
  static Batalha1 + #689, #3967
  static Batalha1 + #690, #3967
  static Batalha1 + #691, #3967
  static Batalha1 + #692, #3967
  static Batalha1 + #693, #3967
  static Batalha1 + #694, #3967
  static Batalha1 + #695, #3967
  static Batalha1 + #696, #3967
  static Batalha1 + #697, #3967
  static Batalha1 + #698, #3967
  static Batalha1 + #699, #3967
  static Batalha1 + #700, #3967
  static Batalha1 + #701, #3967
  static Batalha1 + #702, #3967
  static Batalha1 + #703, #3967
  static Batalha1 + #704, #3967
  static Batalha1 + #705, #3967
  static Batalha1 + #706, #3967
  static Batalha1 + #707, #3967
  static Batalha1 + #708, #3967
  static Batalha1 + #709, #3967
  static Batalha1 + #710, #3967
  static Batalha1 + #711, #3967
  static Batalha1 + #712, #3967
  static Batalha1 + #713, #3967
  static Batalha1 + #714, #3967
  static Batalha1 + #715, #3967
  static Batalha1 + #716, #3967
  static Batalha1 + #717, #3967
  static Batalha1 + #718, #3967
  static Batalha1 + #719, #3967

  ;Linha 18
  static Batalha1 + #720, #3967
  static Batalha1 + #721, #3967
  static Batalha1 + #722, #3967
  static Batalha1 + #723, #3967
  static Batalha1 + #724, #3967
  static Batalha1 + #725, #3967
  static Batalha1 + #726, #3967
  static Batalha1 + #727, #3967
  static Batalha1 + #728, #3967
  static Batalha1 + #729, #3967
  static Batalha1 + #730, #3967
  static Batalha1 + #731, #3967
  static Batalha1 + #732, #3967
  static Batalha1 + #733, #3967
  static Batalha1 + #734, #3967
  static Batalha1 + #735, #3967
  static Batalha1 + #736, #3967
  static Batalha1 + #737, #3967
  static Batalha1 + #738, #3967
  static Batalha1 + #739, #3967
  static Batalha1 + #740, #3967
  static Batalha1 + #741, #3967
  static Batalha1 + #742, #3967
  static Batalha1 + #743, #3967
  static Batalha1 + #744, #3967
  static Batalha1 + #745, #3967
  static Batalha1 + #746, #3967
  static Batalha1 + #747, #3967
  static Batalha1 + #748, #3967
  static Batalha1 + #749, #3967
  static Batalha1 + #750, #3967
  static Batalha1 + #751, #3967
  static Batalha1 + #752, #3967
  static Batalha1 + #753, #3967
  static Batalha1 + #754, #3967
  static Batalha1 + #755, #3967
  static Batalha1 + #756, #3967
  static Batalha1 + #757, #3967
  static Batalha1 + #758, #3967
  static Batalha1 + #759, #3967

  ;Linha 19
  static Batalha1 + #760, #3967
  static Batalha1 + #761, #3967
  static Batalha1 + #762, #3967
  static Batalha1 + #763, #3967
  static Batalha1 + #764, #3967
  static Batalha1 + #765, #3967
  static Batalha1 + #766, #3967
  static Batalha1 + #767, #3967
  static Batalha1 + #768, #3967
  static Batalha1 + #769, #3967
  static Batalha1 + #770, #3967
  static Batalha1 + #771, #3967
  static Batalha1 + #772, #3967
  static Batalha1 + #773, #3967
  static Batalha1 + #774, #3967
  static Batalha1 + #775, #3967
  static Batalha1 + #776, #3967
  static Batalha1 + #777, #3967
  static Batalha1 + #778, #3967
  static Batalha1 + #779, #3967
  static Batalha1 + #780, #3967
  static Batalha1 + #781, #3967
  static Batalha1 + #782, #3967
  static Batalha1 + #783, #3967
  static Batalha1 + #784, #3967
  static Batalha1 + #785, #3967
  static Batalha1 + #786, #3967
  static Batalha1 + #787, #3967
  static Batalha1 + #788, #3967
  static Batalha1 + #789, #3967
  static Batalha1 + #790, #3967
  static Batalha1 + #791, #3967
  static Batalha1 + #792, #3967
  static Batalha1 + #793, #3967
  static Batalha1 + #794, #3967
  static Batalha1 + #795, #3967
  static Batalha1 + #796, #3967
  static Batalha1 + #797, #3967
  static Batalha1 + #798, #3967
  static Batalha1 + #799, #3967

  ;Linha 20
  static Batalha1 + #800, #0
  static Batalha1 + #801, #0
  static Batalha1 + #802, #0
  static Batalha1 + #803, #0
  static Batalha1 + #804, #0
  static Batalha1 + #805, #0
  static Batalha1 + #806, #0
  static Batalha1 + #807, #0
  static Batalha1 + #808, #0
  static Batalha1 + #809, #0
  static Batalha1 + #810, #0
  static Batalha1 + #811, #0
  static Batalha1 + #812, #0
  static Batalha1 + #813, #0
  static Batalha1 + #814, #0
  static Batalha1 + #815, #0
  static Batalha1 + #816, #0
  static Batalha1 + #817, #0
  static Batalha1 + #818, #0
  static Batalha1 + #819, #0
  static Batalha1 + #820, #0
  static Batalha1 + #821, #0
  static Batalha1 + #822, #0
  static Batalha1 + #823, #0
  static Batalha1 + #824, #0
  static Batalha1 + #825, #0
  static Batalha1 + #826, #0
  static Batalha1 + #827, #0
  static Batalha1 + #828, #0
  static Batalha1 + #829, #0
  static Batalha1 + #830, #0
  static Batalha1 + #831, #0
  static Batalha1 + #832, #0
  static Batalha1 + #833, #0
  static Batalha1 + #834, #0
  static Batalha1 + #835, #0
  static Batalha1 + #836, #0
  static Batalha1 + #837, #0
  static Batalha1 + #838, #0
  static Batalha1 + #839, #0

  ;Linha 21
  static Batalha1 + #840, #3967
  static Batalha1 + #841, #3967
  static Batalha1 + #842, #3967
  static Batalha1 + #843, #3967
  static Batalha1 + #844, #3967
  static Batalha1 + #845, #3967
  static Batalha1 + #846, #3967
  static Batalha1 + #847, #3967
  static Batalha1 + #848, #3967
  static Batalha1 + #849, #3967
  static Batalha1 + #850, #3967
  static Batalha1 + #851, #3967
  static Batalha1 + #852, #3967
  static Batalha1 + #853, #3967
  static Batalha1 + #854, #3967
  static Batalha1 + #855, #3967
  static Batalha1 + #856, #3967
  static Batalha1 + #857, #127
  static Batalha1 + #858, #127
  static Batalha1 + #859, #127
  static Batalha1 + #860, #127
  static Batalha1 + #861, #127
  static Batalha1 + #862, #3967
  static Batalha1 + #863, #3967
  static Batalha1 + #864, #3967
  static Batalha1 + #865, #3967
  static Batalha1 + #866, #3967
  static Batalha1 + #867, #3967
  static Batalha1 + #868, #3967
  static Batalha1 + #869, #3967
  static Batalha1 + #870, #3967
  static Batalha1 + #871, #3967
  static Batalha1 + #872, #3967
  static Batalha1 + #873, #3967
  static Batalha1 + #874, #3967
  static Batalha1 + #875, #3967
  static Batalha1 + #876, #3967
  static Batalha1 + #877, #127
  static Batalha1 + #878, #127
  static Batalha1 + #879, #3967

  ;Linha 22
  static Batalha1 + #880, #3967
  static Batalha1 + #881, #3967
  static Batalha1 + #882, #3967
  static Batalha1 + #883, #3967
  static Batalha1 + #884, #3967
  static Batalha1 + #885, #3967
  static Batalha1 + #886, #3967
  static Batalha1 + #887, #3967
  static Batalha1 + #888, #3967
  static Batalha1 + #889, #3967
  static Batalha1 + #890, #3967
  static Batalha1 + #891, #3967
  static Batalha1 + #892, #3967
  static Batalha1 + #893, #3967
  static Batalha1 + #894, #3967
  static Batalha1 + #895, #3967
  static Batalha1 + #896, #3967
  static Batalha1 + #897, #3967
  static Batalha1 + #898, #3967
  static Batalha1 + #899, #3967
  static Batalha1 + #900, #3967
  static Batalha1 + #901, #3967
  static Batalha1 + #902, #3967
  static Batalha1 + #903, #3967
  static Batalha1 + #904, #3967
  static Batalha1 + #905, #3967
  static Batalha1 + #906, #3967
  static Batalha1 + #907, #3967
  static Batalha1 + #908, #3967
  static Batalha1 + #909, #3967
  static Batalha1 + #910, #3967
  static Batalha1 + #911, #3967
  static Batalha1 + #912, #3967
  static Batalha1 + #913, #3967
  static Batalha1 + #914, #3967
  static Batalha1 + #915, #3967
  static Batalha1 + #916, #3967
  static Batalha1 + #917, #3967
  static Batalha1 + #918, #3967
  static Batalha1 + #919, #3967

  ;Linha 23
  static Batalha1 + #920, #3967
  static Batalha1 + #921, #3967
  static Batalha1 + #922, #49
  static Batalha1 + #923, #3967
  static Batalha1 + #924, #45
  static Batalha1 + #925, #3967
  static Batalha1 + #926, #65
  static Batalha1 + #927, #84
  static Batalha1 + #928, #65
  static Batalha1 + #929, #67
  static Batalha1 + #930, #65
  static Batalha1 + #931, #82
  static Batalha1 + #932, #3967
  static Batalha1 + #933, #3967
  static Batalha1 + #934, #3967
  static Batalha1 + #935, #3967
  static Batalha1 + #936, #3967
  static Batalha1 + #937, #3967
  static Batalha1 + #938, #3967
  static Batalha1 + #939, #3967
  static Batalha1 + #940, #3967
  static Batalha1 + #941, #3967
  static Batalha1 + #942, #3967
  static Batalha1 + #943, #3967
  static Batalha1 + #944, #3967
  static Batalha1 + #945, #3967
  static Batalha1 + #946, #3967
  static Batalha1 + #947, #3967
  static Batalha1 + #948, #3967
  static Batalha1 + #949, #3967
  static Batalha1 + #950, #3967
  static Batalha1 + #951, #3967
  static Batalha1 + #952, #3967
  static Batalha1 + #953, #3967
  static Batalha1 + #954, #3967
  static Batalha1 + #955, #3967
  static Batalha1 + #956, #3967
  static Batalha1 + #957, #3967
  static Batalha1 + #958, #3967
  static Batalha1 + #959, #3967

  ;Linha 24
  static Batalha1 + #960, #3967
  static Batalha1 + #961, #3967
  static Batalha1 + #962, #3967
  static Batalha1 + #963, #3967
  static Batalha1 + #964, #3967
  static Batalha1 + #965, #3967
  static Batalha1 + #966, #3967
  static Batalha1 + #967, #3967
  static Batalha1 + #968, #3967
  static Batalha1 + #969, #3967
  static Batalha1 + #970, #3967
  static Batalha1 + #971, #3967
  static Batalha1 + #972, #3967
  static Batalha1 + #973, #3967
  static Batalha1 + #974, #3967
  static Batalha1 + #975, #3967
  static Batalha1 + #976, #3967
  static Batalha1 + #977, #3967
  static Batalha1 + #978, #3967
  static Batalha1 + #979, #3967
  static Batalha1 + #980, #3967
  static Batalha1 + #981, #3967
  static Batalha1 + #982, #3967
  static Batalha1 + #983, #3967
  static Batalha1 + #984, #3967
  static Batalha1 + #985, #3967
  static Batalha1 + #986, #3967
  static Batalha1 + #987, #3967
  static Batalha1 + #988, #3967
  static Batalha1 + #989, #3967
  static Batalha1 + #990, #3967
  static Batalha1 + #991, #3967
  static Batalha1 + #992, #3967
  static Batalha1 + #993, #3967
  static Batalha1 + #994, #3967
  static Batalha1 + #995, #3967
  static Batalha1 + #996, #3967
  static Batalha1 + #997, #3967
  static Batalha1 + #998, #3967
  static Batalha1 + #999, #3967

  ;Linha 25
  static Batalha1 + #1000, #3967
  static Batalha1 + #1001, #3967
  static Batalha1 + #1002, #3967
  static Batalha1 + #1003, #3967
  static Batalha1 + #1004, #3967
  static Batalha1 + #1005, #3967
  static Batalha1 + #1006, #3967
  static Batalha1 + #1007, #3967
  static Batalha1 + #1008, #3967
  static Batalha1 + #1009, #3967
  static Batalha1 + #1010, #3967
  static Batalha1 + #1011, #3967
  static Batalha1 + #1012, #3967
  static Batalha1 + #1013, #3967
  static Batalha1 + #1014, #3967
  static Batalha1 + #1015, #3967
  static Batalha1 + #1016, #3967
  static Batalha1 + #1017, #3967
  static Batalha1 + #1018, #3967
  static Batalha1 + #1019, #3967
  static Batalha1 + #1020, #3967
  static Batalha1 + #1021, #3967
  static Batalha1 + #1022, #3967
  static Batalha1 + #1023, #3967
  static Batalha1 + #1024, #3967
  static Batalha1 + #1025, #3967
  static Batalha1 + #1026, #3967
  static Batalha1 + #1027, #3967
  static Batalha1 + #1028, #3967
  static Batalha1 + #1029, #3967
  static Batalha1 + #1030, #3967
  static Batalha1 + #1031, #3967
  static Batalha1 + #1032, #3967
  static Batalha1 + #1033, #3967
  static Batalha1 + #1034, #3967
  static Batalha1 + #1035, #3967
  static Batalha1 + #1036, #3967
  static Batalha1 + #1037, #3967
  static Batalha1 + #1038, #3967
  static Batalha1 + #1039, #3967

  ;Linha 26
  static Batalha1 + #1040, #3967
  static Batalha1 + #1041, #3967
  static Batalha1 + #1042, #50
  static Batalha1 + #1043, #3967
  static Batalha1 + #1044, #45
  static Batalha1 + #1045, #3967
  static Batalha1 + #1046, #85
  static Batalha1 + #1047, #83
  static Batalha1 + #1048, #65
  static Batalha1 + #1049, #82
  static Batalha1 + #1050, #3967
  static Batalha1 + #1051, #73
  static Batalha1 + #1052, #84
  static Batalha1 + #1053, #69
  static Batalha1 + #1054, #77
  static Batalha1 + #1055, #3967
  static Batalha1 + #1056, #3967
  static Batalha1 + #1057, #3967
  static Batalha1 + #1058, #3967
  static Batalha1 + #1059, #3967
  static Batalha1 + #1060, #3967
  static Batalha1 + #1061, #3967
  static Batalha1 + #1062, #3967
  static Batalha1 + #1063, #3967
  static Batalha1 + #1064, #3967
  static Batalha1 + #1065, #3967
  static Batalha1 + #1066, #3967
  static Batalha1 + #1067, #3967
  static Batalha1 + #1068, #3967
  static Batalha1 + #1069, #3967
  static Batalha1 + #1070, #3967
  static Batalha1 + #1071, #3967
  static Batalha1 + #1072, #3967
  static Batalha1 + #1073, #3967
  static Batalha1 + #1074, #3967
  static Batalha1 + #1075, #3967
  static Batalha1 + #1076, #3967
  static Batalha1 + #1077, #3967
  static Batalha1 + #1078, #3967
  static Batalha1 + #1079, #3967

  ;Linha 27
  static Batalha1 + #1080, #3967
  static Batalha1 + #1081, #3967
  static Batalha1 + #1082, #3967
  static Batalha1 + #1083, #3967
  static Batalha1 + #1084, #3967
  static Batalha1 + #1085, #3967
  static Batalha1 + #1086, #3967
  static Batalha1 + #1087, #3967
  static Batalha1 + #1088, #3967
  static Batalha1 + #1089, #3967
  static Batalha1 + #1090, #3967
  static Batalha1 + #1091, #3967
  static Batalha1 + #1092, #3967
  static Batalha1 + #1093, #3967
  static Batalha1 + #1094, #3967
  static Batalha1 + #1095, #3967
  static Batalha1 + #1096, #3967
  static Batalha1 + #1097, #3967
  static Batalha1 + #1098, #3967
  static Batalha1 + #1099, #3967
  static Batalha1 + #1100, #3967
  static Batalha1 + #1101, #3967
  static Batalha1 + #1102, #3967
  static Batalha1 + #1103, #3967
  static Batalha1 + #1104, #3967
  static Batalha1 + #1105, #3967
  static Batalha1 + #1106, #3967
  static Batalha1 + #1107, #3967
  static Batalha1 + #1108, #3967
  static Batalha1 + #1109, #3967
  static Batalha1 + #1110, #3967
  static Batalha1 + #1111, #3967
  static Batalha1 + #1112, #3967
  static Batalha1 + #1113, #3967
  static Batalha1 + #1114, #3967
  static Batalha1 + #1115, #3967
  static Batalha1 + #1116, #3967
  static Batalha1 + #1117, #3967
  static Batalha1 + #1118, #3967
  static Batalha1 + #1119, #3967

  ;Linha 28
  static Batalha1 + #1120, #3967
  static Batalha1 + #1121, #3967
  static Batalha1 + #1122, #3967
  static Batalha1 + #1123, #3967
  static Batalha1 + #1124, #3967
  static Batalha1 + #1125, #3967
  static Batalha1 + #1126, #3967
  static Batalha1 + #1127, #3967
  static Batalha1 + #1128, #3967
  static Batalha1 + #1129, #3967
  static Batalha1 + #1130, #3967
  static Batalha1 + #1131, #3967
  static Batalha1 + #1132, #3967
  static Batalha1 + #1133, #3967
  static Batalha1 + #1134, #3967
  static Batalha1 + #1135, #3967
  static Batalha1 + #1136, #3967
  static Batalha1 + #1137, #3967
  static Batalha1 + #1138, #3967
  static Batalha1 + #1139, #3967
  static Batalha1 + #1140, #3967
  static Batalha1 + #1141, #3967
  static Batalha1 + #1142, #3967
  static Batalha1 + #1143, #3967
  static Batalha1 + #1144, #3967
  static Batalha1 + #1145, #3967
  static Batalha1 + #1146, #3967
  static Batalha1 + #1147, #3967
  static Batalha1 + #1148, #3967
  static Batalha1 + #1149, #3967
  static Batalha1 + #1150, #3967
  static Batalha1 + #1151, #3967
  static Batalha1 + #1152, #3967
  static Batalha1 + #1153, #3967
  static Batalha1 + #1154, #3967
  static Batalha1 + #1155, #3967
  static Batalha1 + #1156, #3967
  static Batalha1 + #1157, #3967
  static Batalha1 + #1158, #3967
  static Batalha1 + #1159, #3967

  ;Linha 29
  static Batalha1 + #1160, #3967
  static Batalha1 + #1161, #3967
  static Batalha1 + #1162, #3967
  static Batalha1 + #1163, #3967
  static Batalha1 + #1164, #3967
  static Batalha1 + #1165, #3967
  static Batalha1 + #1166, #3967
  static Batalha1 + #1167, #3967
  static Batalha1 + #1168, #3967
  static Batalha1 + #1169, #3967
  static Batalha1 + #1170, #3967
  static Batalha1 + #1171, #3967
  static Batalha1 + #1172, #3967
  static Batalha1 + #1173, #3967
  static Batalha1 + #1174, #3967
  static Batalha1 + #1175, #3967
  static Batalha1 + #1176, #3967
  static Batalha1 + #1177, #3967
  static Batalha1 + #1178, #3967
  static Batalha1 + #1179, #3967
  static Batalha1 + #1180, #3967
  static Batalha1 + #1181, #3967
  static Batalha1 + #1182, #3967
  static Batalha1 + #1183, #3967
  static Batalha1 + #1184, #3967
  static Batalha1 + #1185, #3967
  static Batalha1 + #1186, #3967
  static Batalha1 + #1187, #3967
  static Batalha1 + #1188, #3967
  static Batalha1 + #1189, #3967
  static Batalha1 + #1190, #3967
  static Batalha1 + #1191, #3967
  static Batalha1 + #1192, #3967
  static Batalha1 + #1193, #3967
  static Batalha1 + #1194, #3967
  static Batalha1 + #1195, #3967
  static Batalha1 + #1196, #3967
  static Batalha1 + #1197, #3967
  static Batalha1 + #1198, #3967
  static Batalha1 + #1199, #3967

printBatalha1Screen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #Batalha1
  loadn R1, #0
  loadn R2, #1200

  printBatalha1ScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printBatalha1ScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

Batalha2 : var #1200
  ;Linha 0
  static Batalha2 + #0, #127
  static Batalha2 + #1, #127
  static Batalha2 + #2, #127
  static Batalha2 + #3, #127
  static Batalha2 + #4, #127
  static Batalha2 + #5, #127
  static Batalha2 + #6, #127
  static Batalha2 + #7, #127
  static Batalha2 + #8, #127
  static Batalha2 + #9, #127
  static Batalha2 + #10, #127
  static Batalha2 + #11, #127
  static Batalha2 + #12, #127
  static Batalha2 + #13, #127
  static Batalha2 + #14, #127
  static Batalha2 + #15, #127
  static Batalha2 + #16, #127
  static Batalha2 + #17, #127
  static Batalha2 + #18, #127
  static Batalha2 + #19, #127
  static Batalha2 + #20, #127
  static Batalha2 + #21, #127
  static Batalha2 + #22, #127
  static Batalha2 + #23, #127
  static Batalha2 + #24, #127
  static Batalha2 + #25, #127
  static Batalha2 + #26, #127
  static Batalha2 + #27, #127
  static Batalha2 + #28, #127
  static Batalha2 + #29, #127
  static Batalha2 + #30, #127
  static Batalha2 + #31, #127
  static Batalha2 + #32, #127
  static Batalha2 + #33, #127
  static Batalha2 + #34, #127
  static Batalha2 + #35, #127
  static Batalha2 + #36, #127
  static Batalha2 + #37, #127
  static Batalha2 + #38, #127
  static Batalha2 + #39, #127

  ;Linha 1
  static Batalha2 + #40, #127
  static Batalha2 + #41, #127
  static Batalha2 + #42, #127
  static Batalha2 + #43, #127
  static Batalha2 + #44, #127
  static Batalha2 + #45, #127
  static Batalha2 + #46, #127
  static Batalha2 + #47, #127
  static Batalha2 + #48, #127
  static Batalha2 + #49, #127
  static Batalha2 + #50, #127
  static Batalha2 + #51, #127
  static Batalha2 + #52, #127
  static Batalha2 + #53, #127
  static Batalha2 + #54, #127
  static Batalha2 + #55, #127
  static Batalha2 + #56, #127
  static Batalha2 + #57, #127
  static Batalha2 + #58, #127
  static Batalha2 + #59, #127
  static Batalha2 + #60, #127
  static Batalha2 + #61, #127
  static Batalha2 + #62, #127
  static Batalha2 + #63, #127
  static Batalha2 + #64, #127
  static Batalha2 + #65, #127
  static Batalha2 + #66, #127
  static Batalha2 + #67, #127
  static Batalha2 + #68, #127
  static Batalha2 + #69, #127
  static Batalha2 + #70, #127
  static Batalha2 + #71, #127
  static Batalha2 + #72, #127
  static Batalha2 + #73, #127
  static Batalha2 + #74, #127
  static Batalha2 + #75, #127
  static Batalha2 + #76, #127
  static Batalha2 + #77, #127
  static Batalha2 + #78, #127
  static Batalha2 + #79, #127

  ;Linha 2
  static Batalha2 + #80, #127
  static Batalha2 + #81, #127
  static Batalha2 + #82, #127
  static Batalha2 + #83, #127
  static Batalha2 + #84, #127
  static Batalha2 + #85, #127
  static Batalha2 + #86, #127
  static Batalha2 + #87, #127
  static Batalha2 + #88, #127
  static Batalha2 + #89, #127
  static Batalha2 + #90, #127
  static Batalha2 + #91, #127
  static Batalha2 + #92, #127
  static Batalha2 + #93, #127
  static Batalha2 + #94, #127
  static Batalha2 + #95, #127
  static Batalha2 + #96, #127
  static Batalha2 + #97, #127
  static Batalha2 + #98, #127
  static Batalha2 + #99, #127
  static Batalha2 + #100, #127
  static Batalha2 + #101, #127
  static Batalha2 + #102, #127
  static Batalha2 + #103, #127
  static Batalha2 + #104, #127
  static Batalha2 + #105, #127
  static Batalha2 + #106, #127
  static Batalha2 + #107, #127
  static Batalha2 + #108, #127
  static Batalha2 + #109, #127
  static Batalha2 + #110, #127
  static Batalha2 + #111, #127
  static Batalha2 + #112, #127
  static Batalha2 + #113, #127
  static Batalha2 + #114, #127
  static Batalha2 + #115, #127
  static Batalha2 + #116, #127
  static Batalha2 + #117, #127
  static Batalha2 + #118, #127
  static Batalha2 + #119, #127

  ;Linha 3
  static Batalha2 + #120, #127
  static Batalha2 + #121, #127
  static Batalha2 + #122, #127
  static Batalha2 + #123, #127
  static Batalha2 + #124, #127
  static Batalha2 + #125, #127
  static Batalha2 + #126, #127
  static Batalha2 + #127, #127
  static Batalha2 + #128, #127
  static Batalha2 + #129, #127
  static Batalha2 + #130, #127
  static Batalha2 + #131, #127
  static Batalha2 + #132, #127
  static Batalha2 + #133, #127
  static Batalha2 + #134, #127
  static Batalha2 + #135, #127
  static Batalha2 + #136, #127
  static Batalha2 + #137, #127
  static Batalha2 + #138, #127
  static Batalha2 + #139, #127
  static Batalha2 + #140, #127
  static Batalha2 + #141, #127
  static Batalha2 + #142, #127
  static Batalha2 + #143, #127
  static Batalha2 + #144, #127
  static Batalha2 + #145, #127
  static Batalha2 + #146, #127
  static Batalha2 + #147, #127
  static Batalha2 + #148, #127
  static Batalha2 + #149, #127
  static Batalha2 + #150, #127
  static Batalha2 + #151, #127
  static Batalha2 + #152, #127
  static Batalha2 + #153, #127
  static Batalha2 + #154, #127
  static Batalha2 + #155, #127
  static Batalha2 + #156, #127
  static Batalha2 + #157, #127
  static Batalha2 + #158, #127
  static Batalha2 + #159, #127

  ;Linha 4
  static Batalha2 + #160, #127
  static Batalha2 + #161, #127
  static Batalha2 + #162, #127
  static Batalha2 + #163, #127
  static Batalha2 + #164, #127
  static Batalha2 + #165, #127
  static Batalha2 + #166, #127
  static Batalha2 + #167, #127
  static Batalha2 + #168, #127
  static Batalha2 + #169, #127
  static Batalha2 + #170, #127
  static Batalha2 + #171, #127
  static Batalha2 + #172, #127
  static Batalha2 + #173, #127
  static Batalha2 + #174, #127
  static Batalha2 + #175, #127
  static Batalha2 + #176, #127
  static Batalha2 + #177, #127
  static Batalha2 + #178, #127
  static Batalha2 + #179, #127
  static Batalha2 + #180, #127
  static Batalha2 + #181, #127
  static Batalha2 + #182, #127
  static Batalha2 + #183, #127
  static Batalha2 + #184, #127
  static Batalha2 + #185, #127
  static Batalha2 + #186, #127
  static Batalha2 + #187, #127
  static Batalha2 + #188, #127
  static Batalha2 + #189, #127
  static Batalha2 + #190, #127
  static Batalha2 + #191, #127
  static Batalha2 + #192, #127
  static Batalha2 + #193, #127
  static Batalha2 + #194, #127
  static Batalha2 + #195, #127
  static Batalha2 + #196, #127
  static Batalha2 + #197, #127
  static Batalha2 + #198, #127
  static Batalha2 + #199, #127

  ;Linha 5
  static Batalha2 + #200, #127
  static Batalha2 + #201, #127
  static Batalha2 + #202, #127
  static Batalha2 + #203, #127
  static Batalha2 + #204, #127
  static Batalha2 + #205, #127
  static Batalha2 + #206, #127
  static Batalha2 + #207, #127
  static Batalha2 + #208, #127
  static Batalha2 + #209, #127
  static Batalha2 + #210, #127
  static Batalha2 + #211, #127
  static Batalha2 + #212, #127
  static Batalha2 + #213, #127
  static Batalha2 + #214, #127
  static Batalha2 + #215, #127
  static Batalha2 + #216, #127
  static Batalha2 + #217, #127
  static Batalha2 + #218, #127
  static Batalha2 + #219, #127
  static Batalha2 + #220, #127
  static Batalha2 + #221, #127
  static Batalha2 + #222, #127
  static Batalha2 + #223, #127
  static Batalha2 + #224, #127
  static Batalha2 + #225, #127
  static Batalha2 + #226, #127
  static Batalha2 + #227, #127
  static Batalha2 + #228, #127
  static Batalha2 + #229, #127
  static Batalha2 + #230, #127
  static Batalha2 + #231, #127
  static Batalha2 + #232, #127
  static Batalha2 + #233, #127
  static Batalha2 + #234, #127
  static Batalha2 + #235, #127
  static Batalha2 + #236, #127
  static Batalha2 + #237, #127
  static Batalha2 + #238, #127
  static Batalha2 + #239, #127

  ;Linha 6
  static Batalha2 + #240, #127
  static Batalha2 + #241, #127
  static Batalha2 + #242, #127
  static Batalha2 + #243, #127
  static Batalha2 + #244, #127
  static Batalha2 + #245, #127
  static Batalha2 + #246, #127
  static Batalha2 + #247, #127
  static Batalha2 + #248, #127
  static Batalha2 + #249, #127
  static Batalha2 + #250, #127
  static Batalha2 + #251, #127
  static Batalha2 + #252, #127
  static Batalha2 + #253, #127
  static Batalha2 + #254, #127
  static Batalha2 + #255, #127
  static Batalha2 + #256, #127
  static Batalha2 + #257, #127
  static Batalha2 + #258, #127
  static Batalha2 + #259, #127
  static Batalha2 + #260, #127
  static Batalha2 + #261, #127
  static Batalha2 + #262, #127
  static Batalha2 + #263, #127
  static Batalha2 + #264, #127
  static Batalha2 + #265, #127
  static Batalha2 + #266, #127
  static Batalha2 + #267, #127
  static Batalha2 + #268, #127
  static Batalha2 + #269, #127
  static Batalha2 + #270, #127
  static Batalha2 + #271, #127
  static Batalha2 + #272, #127
  static Batalha2 + #273, #127
  static Batalha2 + #274, #127
  static Batalha2 + #275, #127
  static Batalha2 + #276, #127
  static Batalha2 + #277, #127
  static Batalha2 + #278, #127
  static Batalha2 + #279, #127

  ;Linha 7
  static Batalha2 + #280, #127
  static Batalha2 + #281, #127
  static Batalha2 + #282, #127
  static Batalha2 + #283, #127
  static Batalha2 + #284, #127
  static Batalha2 + #285, #127
  static Batalha2 + #286, #127
  static Batalha2 + #287, #127
  static Batalha2 + #288, #127
  static Batalha2 + #289, #127
  static Batalha2 + #290, #127
  static Batalha2 + #291, #127
  static Batalha2 + #292, #127
  static Batalha2 + #293, #127
  static Batalha2 + #294, #127
  static Batalha2 + #295, #127
  static Batalha2 + #296, #127
  static Batalha2 + #297, #127
  static Batalha2 + #298, #127
  static Batalha2 + #299, #127
  static Batalha2 + #300, #127
  static Batalha2 + #301, #127
  static Batalha2 + #302, #127
  static Batalha2 + #303, #127
  static Batalha2 + #304, #127
  static Batalha2 + #305, #127
  static Batalha2 + #306, #127
  static Batalha2 + #307, #127
  static Batalha2 + #308, #127
  static Batalha2 + #309, #127
  static Batalha2 + #310, #127
  static Batalha2 + #311, #127
  static Batalha2 + #312, #127
  static Batalha2 + #313, #127
  static Batalha2 + #314, #127
  static Batalha2 + #315, #127
  static Batalha2 + #316, #127
  static Batalha2 + #317, #127
  static Batalha2 + #318, #127
  static Batalha2 + #319, #127

  ;Linha 8
  static Batalha2 + #320, #127
  static Batalha2 + #321, #127
  static Batalha2 + #322, #127
  static Batalha2 + #323, #127
  static Batalha2 + #324, #127
  static Batalha2 + #325, #127
  static Batalha2 + #326, #127
  static Batalha2 + #327, #127
  static Batalha2 + #328, #127
  static Batalha2 + #329, #127
  static Batalha2 + #330, #127
  static Batalha2 + #331, #127
  static Batalha2 + #332, #127
  static Batalha2 + #333, #127
  static Batalha2 + #334, #127
  static Batalha2 + #335, #127
  static Batalha2 + #336, #127
  static Batalha2 + #337, #127
  static Batalha2 + #338, #127
  static Batalha2 + #339, #127
  static Batalha2 + #340, #127
  static Batalha2 + #341, #127
  static Batalha2 + #342, #127
  static Batalha2 + #343, #127
  static Batalha2 + #344, #127
  static Batalha2 + #345, #127
  static Batalha2 + #346, #127
  static Batalha2 + #347, #127
  static Batalha2 + #348, #127
  static Batalha2 + #349, #127
  static Batalha2 + #350, #127
  static Batalha2 + #351, #127
  static Batalha2 + #352, #127
  static Batalha2 + #353, #127
  static Batalha2 + #354, #127
  static Batalha2 + #355, #127
  static Batalha2 + #356, #127
  static Batalha2 + #357, #127
  static Batalha2 + #358, #127
  static Batalha2 + #359, #127

  ;Linha 9
  static Batalha2 + #360, #127
  static Batalha2 + #361, #127
  static Batalha2 + #362, #127
  static Batalha2 + #363, #127
  static Batalha2 + #364, #127
  static Batalha2 + #365, #127
  static Batalha2 + #366, #127
  static Batalha2 + #367, #127
  static Batalha2 + #368, #127
  static Batalha2 + #369, #127
  static Batalha2 + #370, #127
  static Batalha2 + #371, #127
  static Batalha2 + #372, #127
  static Batalha2 + #373, #127
  static Batalha2 + #374, #127
  static Batalha2 + #375, #127
  static Batalha2 + #376, #127
  static Batalha2 + #377, #127
  static Batalha2 + #378, #127
  static Batalha2 + #379, #127
  static Batalha2 + #380, #127
  static Batalha2 + #381, #127
  static Batalha2 + #382, #127
  static Batalha2 + #383, #127
  static Batalha2 + #384, #127
  static Batalha2 + #385, #127
  static Batalha2 + #386, #127
  static Batalha2 + #387, #127
  static Batalha2 + #388, #127
  static Batalha2 + #389, #127
  static Batalha2 + #390, #127
  static Batalha2 + #391, #127
  static Batalha2 + #392, #127
  static Batalha2 + #393, #127
  static Batalha2 + #394, #127
  static Batalha2 + #395, #127
  static Batalha2 + #396, #127
  static Batalha2 + #397, #127
  static Batalha2 + #398, #127
  static Batalha2 + #399, #127

  ;Linha 10
  static Batalha2 + #400, #127
  static Batalha2 + #401, #127
  static Batalha2 + #402, #127
  static Batalha2 + #403, #127
  static Batalha2 + #404, #127
  static Batalha2 + #405, #127
  static Batalha2 + #406, #127
  static Batalha2 + #407, #127
  static Batalha2 + #408, #127
  static Batalha2 + #409, #127
  static Batalha2 + #410, #127
  static Batalha2 + #411, #127
  static Batalha2 + #412, #127
  static Batalha2 + #413, #127
  static Batalha2 + #414, #127
  static Batalha2 + #415, #127
  static Batalha2 + #416, #127
  static Batalha2 + #417, #127
  static Batalha2 + #418, #127
  static Batalha2 + #419, #127
  static Batalha2 + #420, #127
  static Batalha2 + #421, #127
  static Batalha2 + #422, #127
  static Batalha2 + #423, #127
  static Batalha2 + #424, #127
  static Batalha2 + #425, #127
  static Batalha2 + #426, #127
  static Batalha2 + #427, #127
  static Batalha2 + #428, #127
  static Batalha2 + #429, #127
  static Batalha2 + #430, #127
  static Batalha2 + #431, #127
  static Batalha2 + #432, #127
  static Batalha2 + #433, #127
  static Batalha2 + #434, #127
  static Batalha2 + #435, #127
  static Batalha2 + #436, #127
  static Batalha2 + #437, #127
  static Batalha2 + #438, #127
  static Batalha2 + #439, #127

  ;Linha 11
  static Batalha2 + #440, #127
  static Batalha2 + #441, #127
  static Batalha2 + #442, #127
  static Batalha2 + #443, #127
  static Batalha2 + #444, #127
  static Batalha2 + #445, #127
  static Batalha2 + #446, #127
  static Batalha2 + #447, #127
  static Batalha2 + #448, #127
  static Batalha2 + #449, #127
  static Batalha2 + #450, #127
  static Batalha2 + #451, #127
  static Batalha2 + #452, #127
  static Batalha2 + #453, #127
  static Batalha2 + #454, #127
  static Batalha2 + #455, #127
  static Batalha2 + #456, #127
  static Batalha2 + #457, #127
  static Batalha2 + #458, #127
  static Batalha2 + #459, #127
  static Batalha2 + #460, #127
  static Batalha2 + #461, #127
  static Batalha2 + #462, #127
  static Batalha2 + #463, #127
  static Batalha2 + #464, #127
  static Batalha2 + #465, #127
  static Batalha2 + #466, #127
  static Batalha2 + #467, #127
  static Batalha2 + #468, #127
  static Batalha2 + #469, #127
  static Batalha2 + #470, #127
  static Batalha2 + #471, #127
  static Batalha2 + #472, #127
  static Batalha2 + #473, #127
  static Batalha2 + #474, #127
  static Batalha2 + #475, #127
  static Batalha2 + #476, #127
  static Batalha2 + #477, #127
  static Batalha2 + #478, #127
  static Batalha2 + #479, #127

  ;Linha 12
  static Batalha2 + #480, #127
  static Batalha2 + #481, #127
  static Batalha2 + #482, #127
  static Batalha2 + #483, #127
  static Batalha2 + #484, #127
  static Batalha2 + #485, #127
  static Batalha2 + #486, #127
  static Batalha2 + #487, #127
  static Batalha2 + #488, #127
  static Batalha2 + #489, #127
  static Batalha2 + #490, #127
  static Batalha2 + #491, #127
  static Batalha2 + #492, #127
  static Batalha2 + #493, #127
  static Batalha2 + #494, #127
  static Batalha2 + #495, #127
  static Batalha2 + #496, #127
  static Batalha2 + #497, #127
  static Batalha2 + #498, #127
  static Batalha2 + #499, #127
  static Batalha2 + #500, #127
  static Batalha2 + #501, #127
  static Batalha2 + #502, #127
  static Batalha2 + #503, #127
  static Batalha2 + #504, #127
  static Batalha2 + #505, #127
  static Batalha2 + #506, #127
  static Batalha2 + #507, #127
  static Batalha2 + #508, #127
  static Batalha2 + #509, #127
  static Batalha2 + #510, #127
  static Batalha2 + #511, #127
  static Batalha2 + #512, #127
  static Batalha2 + #513, #127
  static Batalha2 + #514, #127
  static Batalha2 + #515, #127
  static Batalha2 + #516, #127
  static Batalha2 + #517, #127
  static Batalha2 + #518, #127
  static Batalha2 + #519, #127

  ;Linha 13
  static Batalha2 + #520, #127
  static Batalha2 + #521, #127
  static Batalha2 + #522, #127
  static Batalha2 + #523, #127
  static Batalha2 + #524, #127
  static Batalha2 + #525, #127
  static Batalha2 + #526, #127
  static Batalha2 + #527, #127
  static Batalha2 + #528, #127
  static Batalha2 + #529, #127
  static Batalha2 + #530, #127
  static Batalha2 + #531, #127
  static Batalha2 + #532, #127
  static Batalha2 + #533, #127
  static Batalha2 + #534, #127
  static Batalha2 + #535, #127
  static Batalha2 + #536, #127
  static Batalha2 + #537, #127
  static Batalha2 + #538, #127
  static Batalha2 + #539, #127
  static Batalha2 + #540, #127
  static Batalha2 + #541, #127
  static Batalha2 + #542, #127
  static Batalha2 + #543, #127
  static Batalha2 + #544, #127
  static Batalha2 + #545, #127
  static Batalha2 + #546, #127
  static Batalha2 + #547, #127
  static Batalha2 + #548, #127
  static Batalha2 + #549, #127
  static Batalha2 + #550, #127
  static Batalha2 + #551, #127
  static Batalha2 + #552, #127
  static Batalha2 + #553, #127
  static Batalha2 + #554, #127
  static Batalha2 + #555, #127
  static Batalha2 + #556, #127
  static Batalha2 + #557, #127
  static Batalha2 + #558, #127
  static Batalha2 + #559, #127

  ;Linha 14
  static Batalha2 + #560, #127
  static Batalha2 + #561, #127
  static Batalha2 + #562, #127
  static Batalha2 + #563, #127
  static Batalha2 + #564, #127
  static Batalha2 + #565, #127
  static Batalha2 + #566, #127
  static Batalha2 + #567, #127
  static Batalha2 + #568, #127
  static Batalha2 + #569, #127
  static Batalha2 + #570, #127
  static Batalha2 + #571, #127
  static Batalha2 + #572, #127
  static Batalha2 + #573, #127
  static Batalha2 + #574, #127
  static Batalha2 + #575, #127
  static Batalha2 + #576, #127
  static Batalha2 + #577, #127
  static Batalha2 + #578, #127
  static Batalha2 + #579, #127
  static Batalha2 + #580, #127
  static Batalha2 + #581, #127
  static Batalha2 + #582, #127
  static Batalha2 + #583, #127
  static Batalha2 + #584, #127
  static Batalha2 + #585, #127
  static Batalha2 + #586, #127
  static Batalha2 + #587, #127
  static Batalha2 + #588, #127
  static Batalha2 + #589, #127
  static Batalha2 + #590, #127
  static Batalha2 + #591, #127
  static Batalha2 + #592, #127
  static Batalha2 + #593, #127
  static Batalha2 + #594, #127
  static Batalha2 + #595, #127
  static Batalha2 + #596, #127
  static Batalha2 + #597, #127
  static Batalha2 + #598, #127
  static Batalha2 + #599, #127

  ;Linha 15
  static Batalha2 + #600, #127
  static Batalha2 + #601, #127
  static Batalha2 + #602, #127
  static Batalha2 + #603, #127
  static Batalha2 + #604, #127
  static Batalha2 + #605, #127
  static Batalha2 + #606, #127
  static Batalha2 + #607, #127
  static Batalha2 + #608, #127
  static Batalha2 + #609, #127
  static Batalha2 + #610, #127
  static Batalha2 + #611, #127
  static Batalha2 + #612, #127
  static Batalha2 + #613, #127
  static Batalha2 + #614, #127
  static Batalha2 + #615, #127
  static Batalha2 + #616, #127
  static Batalha2 + #617, #127
  static Batalha2 + #618, #127
  static Batalha2 + #619, #127
  static Batalha2 + #620, #127
  static Batalha2 + #621, #127
  static Batalha2 + #622, #127
  static Batalha2 + #623, #127
  static Batalha2 + #624, #127
  static Batalha2 + #625, #127
  static Batalha2 + #626, #127
  static Batalha2 + #627, #127
  static Batalha2 + #628, #127
  static Batalha2 + #629, #127
  static Batalha2 + #630, #127
  static Batalha2 + #631, #127
  static Batalha2 + #632, #127
  static Batalha2 + #633, #127
  static Batalha2 + #634, #127
  static Batalha2 + #635, #127
  static Batalha2 + #636, #127
  static Batalha2 + #637, #127
  static Batalha2 + #638, #127
  static Batalha2 + #639, #127

  ;Linha 16
  static Batalha2 + #640, #127
  static Batalha2 + #641, #127
  static Batalha2 + #642, #127
  static Batalha2 + #643, #127
  static Batalha2 + #644, #127
  static Batalha2 + #645, #127
  static Batalha2 + #646, #127
  static Batalha2 + #647, #127
  static Batalha2 + #648, #127
  static Batalha2 + #649, #127
  static Batalha2 + #650, #127
  static Batalha2 + #651, #127
  static Batalha2 + #652, #127
  static Batalha2 + #653, #127
  static Batalha2 + #654, #127
  static Batalha2 + #655, #127
  static Batalha2 + #656, #127
  static Batalha2 + #657, #127
  static Batalha2 + #658, #127
  static Batalha2 + #659, #127
  static Batalha2 + #660, #127
  static Batalha2 + #661, #127
  static Batalha2 + #662, #127
  static Batalha2 + #663, #127
  static Batalha2 + #664, #127
  static Batalha2 + #665, #127
  static Batalha2 + #666, #127
  static Batalha2 + #667, #127
  static Batalha2 + #668, #127
  static Batalha2 + #669, #127
  static Batalha2 + #670, #127
  static Batalha2 + #671, #127
  static Batalha2 + #672, #127
  static Batalha2 + #673, #127
  static Batalha2 + #674, #127
  static Batalha2 + #675, #127
  static Batalha2 + #676, #127
  static Batalha2 + #677, #127
  static Batalha2 + #678, #127
  static Batalha2 + #679, #127

  ;Linha 17
  static Batalha2 + #680, #127
  static Batalha2 + #681, #127
  static Batalha2 + #682, #127
  static Batalha2 + #683, #127
  static Batalha2 + #684, #127
  static Batalha2 + #685, #127
  static Batalha2 + #686, #127
  static Batalha2 + #687, #127
  static Batalha2 + #688, #127
  static Batalha2 + #689, #127
  static Batalha2 + #690, #127
  static Batalha2 + #691, #127
  static Batalha2 + #692, #127
  static Batalha2 + #693, #127
  static Batalha2 + #694, #127
  static Batalha2 + #695, #127
  static Batalha2 + #696, #127
  static Batalha2 + #697, #127
  static Batalha2 + #698, #127
  static Batalha2 + #699, #127
  static Batalha2 + #700, #127
  static Batalha2 + #701, #127
  static Batalha2 + #702, #127
  static Batalha2 + #703, #127
  static Batalha2 + #704, #127
  static Batalha2 + #705, #127
  static Batalha2 + #706, #127
  static Batalha2 + #707, #127
  static Batalha2 + #708, #127
  static Batalha2 + #709, #127
  static Batalha2 + #710, #127
  static Batalha2 + #711, #127
  static Batalha2 + #712, #127
  static Batalha2 + #713, #127
  static Batalha2 + #714, #127
  static Batalha2 + #715, #127
  static Batalha2 + #716, #127
  static Batalha2 + #717, #127
  static Batalha2 + #718, #127
  static Batalha2 + #719, #127

  ;Linha 18
  static Batalha2 + #720, #127
  static Batalha2 + #721, #127
  static Batalha2 + #722, #127
  static Batalha2 + #723, #127
  static Batalha2 + #724, #127
  static Batalha2 + #725, #127
  static Batalha2 + #726, #127
  static Batalha2 + #727, #127
  static Batalha2 + #728, #127
  static Batalha2 + #729, #127
  static Batalha2 + #730, #127
  static Batalha2 + #731, #127
  static Batalha2 + #732, #127
  static Batalha2 + #733, #127
  static Batalha2 + #734, #127
  static Batalha2 + #735, #127
  static Batalha2 + #736, #127
  static Batalha2 + #737, #127
  static Batalha2 + #738, #127
  static Batalha2 + #739, #127
  static Batalha2 + #740, #127
  static Batalha2 + #741, #127
  static Batalha2 + #742, #127
  static Batalha2 + #743, #127
  static Batalha2 + #744, #127
  static Batalha2 + #745, #127
  static Batalha2 + #746, #127
  static Batalha2 + #747, #127
  static Batalha2 + #748, #127
  static Batalha2 + #749, #127
  static Batalha2 + #750, #127
  static Batalha2 + #751, #127
  static Batalha2 + #752, #127
  static Batalha2 + #753, #127
  static Batalha2 + #754, #127
  static Batalha2 + #755, #127
  static Batalha2 + #756, #127
  static Batalha2 + #757, #127
  static Batalha2 + #758, #127
  static Batalha2 + #759, #127

  ;Linha 19
  static Batalha2 + #760, #127
  static Batalha2 + #761, #127
  static Batalha2 + #762, #127
  static Batalha2 + #763, #127
  static Batalha2 + #764, #127
  static Batalha2 + #765, #127
  static Batalha2 + #766, #127
  static Batalha2 + #767, #127
  static Batalha2 + #768, #127
  static Batalha2 + #769, #127
  static Batalha2 + #770, #127
  static Batalha2 + #771, #127
  static Batalha2 + #772, #127
  static Batalha2 + #773, #127
  static Batalha2 + #774, #127
  static Batalha2 + #775, #127
  static Batalha2 + #776, #127
  static Batalha2 + #777, #127
  static Batalha2 + #778, #127
  static Batalha2 + #779, #127
  static Batalha2 + #780, #127
  static Batalha2 + #781, #127
  static Batalha2 + #782, #127
  static Batalha2 + #783, #127
  static Batalha2 + #784, #127
  static Batalha2 + #785, #127
  static Batalha2 + #786, #127
  static Batalha2 + #787, #127
  static Batalha2 + #788, #127
  static Batalha2 + #789, #127
  static Batalha2 + #790, #127
  static Batalha2 + #791, #127
  static Batalha2 + #792, #127
  static Batalha2 + #793, #127
  static Batalha2 + #794, #127
  static Batalha2 + #795, #127
  static Batalha2 + #796, #127
  static Batalha2 + #797, #127
  static Batalha2 + #798, #127
  static Batalha2 + #799, #127

  ;Linha 20
  static Batalha2 + #800, #0
  static Batalha2 + #801, #0
  static Batalha2 + #802, #0
  static Batalha2 + #803, #0
  static Batalha2 + #804, #0
  static Batalha2 + #805, #0
  static Batalha2 + #806, #0
  static Batalha2 + #807, #0
  static Batalha2 + #808, #0
  static Batalha2 + #809, #0
  static Batalha2 + #810, #0
  static Batalha2 + #811, #0
  static Batalha2 + #812, #0
  static Batalha2 + #813, #0
  static Batalha2 + #814, #0
  static Batalha2 + #815, #0
  static Batalha2 + #816, #0
  static Batalha2 + #817, #0
  static Batalha2 + #818, #0
  static Batalha2 + #819, #0
  static Batalha2 + #820, #0
  static Batalha2 + #821, #0
  static Batalha2 + #822, #0
  static Batalha2 + #823, #0
  static Batalha2 + #824, #0
  static Batalha2 + #825, #0
  static Batalha2 + #826, #0
  static Batalha2 + #827, #0
  static Batalha2 + #828, #0
  static Batalha2 + #829, #0
  static Batalha2 + #830, #0
  static Batalha2 + #831, #0
  static Batalha2 + #832, #0
  static Batalha2 + #833, #0
  static Batalha2 + #834, #0
  static Batalha2 + #835, #0
  static Batalha2 + #836, #0
  static Batalha2 + #837, #0
  static Batalha2 + #838, #0
  static Batalha2 + #839, #0

  ;Linha 21
  static Batalha2 + #840, #127
  static Batalha2 + #841, #127
  static Batalha2 + #842, #127
  static Batalha2 + #843, #127
  static Batalha2 + #844, #127
  static Batalha2 + #845, #127
  static Batalha2 + #846, #127
  static Batalha2 + #847, #127
  static Batalha2 + #848, #127
  static Batalha2 + #849, #127
  static Batalha2 + #850, #127
  static Batalha2 + #851, #127
  static Batalha2 + #852, #127
  static Batalha2 + #853, #127
  static Batalha2 + #854, #127
  static Batalha2 + #855, #127
  static Batalha2 + #856, #127
  static Batalha2 + #857, #127
  static Batalha2 + #858, #127
  static Batalha2 + #859, #127
  static Batalha2 + #860, #127
  static Batalha2 + #861, #127
  static Batalha2 + #862, #127
  static Batalha2 + #863, #127
  static Batalha2 + #864, #127
  static Batalha2 + #865, #127
  static Batalha2 + #866, #127
  static Batalha2 + #867, #127
  static Batalha2 + #868, #127
  static Batalha2 + #869, #127
  static Batalha2 + #870, #127
  static Batalha2 + #871, #127
  static Batalha2 + #872, #127
  static Batalha2 + #873, #127
  static Batalha2 + #874, #127
  static Batalha2 + #875, #127
  static Batalha2 + #876, #127
  static Batalha2 + #877, #127
  static Batalha2 + #878, #127
  static Batalha2 + #879, #127

  ;Linha 22
  static Batalha2 + #880, #127
  static Batalha2 + #881, #127
  static Batalha2 + #882, #127
  static Batalha2 + #883, #127
  static Batalha2 + #884, #127
  static Batalha2 + #885, #127
  static Batalha2 + #886, #127
  static Batalha2 + #887, #127
  static Batalha2 + #888, #127
  static Batalha2 + #889, #127
  static Batalha2 + #890, #127
  static Batalha2 + #891, #127
  static Batalha2 + #892, #127
  static Batalha2 + #893, #127
  static Batalha2 + #894, #127
  static Batalha2 + #895, #127
  static Batalha2 + #896, #127
  static Batalha2 + #897, #127
  static Batalha2 + #898, #127
  static Batalha2 + #899, #127
  static Batalha2 + #900, #127
  static Batalha2 + #901, #127
  static Batalha2 + #902, #127
  static Batalha2 + #903, #127
  static Batalha2 + #904, #127
  static Batalha2 + #905, #127
  static Batalha2 + #906, #127
  static Batalha2 + #907, #127
  static Batalha2 + #908, #127
  static Batalha2 + #909, #127
  static Batalha2 + #910, #127
  static Batalha2 + #911, #127
  static Batalha2 + #912, #127
  static Batalha2 + #913, #127
  static Batalha2 + #914, #127
  static Batalha2 + #915, #127
  static Batalha2 + #916, #127
  static Batalha2 + #917, #127
  static Batalha2 + #918, #127
  static Batalha2 + #919, #127

  ;Linha 23
  static Batalha2 + #920, #127
  static Batalha2 + #921, #127
  static Batalha2 + #922, #49
  static Batalha2 + #923, #127
  static Batalha2 + #924, #45
  static Batalha2 + #925, #127
  static Batalha2 + #926, #83
  static Batalha2 + #927, #79
  static Batalha2 + #928, #67
  static Batalha2 + #929, #65
  static Batalha2 + #930, #82
  static Batalha2 + #931, #127
  static Batalha2 + #932, #127
  static Batalha2 + #933, #127
  static Batalha2 + #934, #127
  static Batalha2 + #935, #127
  static Batalha2 + #936, #127
  static Batalha2 + #937, #127
  static Batalha2 + #938, #127
  static Batalha2 + #939, #127
  static Batalha2 + #940, #127
  static Batalha2 + #941, #127
  static Batalha2 + #942, #51
  static Batalha2 + #943, #127
  static Batalha2 + #944, #45
  static Batalha2 + #945, #127
  static Batalha2 + #946, #82
  static Batalha2 + #947, #69
  static Batalha2 + #948, #76
  static Batalha2 + #949, #65
  static Batalha2 + #950, #77
  static Batalha2 + #951, #80
  static Batalha2 + #952, #65
  static Batalha2 + #953, #71
  static Batalha2 + #954, #79
  static Batalha2 + #955, #127
  static Batalha2 + #956, #127
  static Batalha2 + #957, #127
  static Batalha2 + #958, #127
  static Batalha2 + #959, #127

  ;Linha 24
  static Batalha2 + #960, #127
  static Batalha2 + #961, #127
  static Batalha2 + #962, #127
  static Batalha2 + #963, #127
  static Batalha2 + #964, #127
  static Batalha2 + #965, #127
  static Batalha2 + #966, #127
  static Batalha2 + #967, #127
  static Batalha2 + #968, #127
  static Batalha2 + #969, #127
  static Batalha2 + #970, #127
  static Batalha2 + #971, #127
  static Batalha2 + #972, #127
  static Batalha2 + #973, #127
  static Batalha2 + #974, #127
  static Batalha2 + #975, #127
  static Batalha2 + #976, #127
  static Batalha2 + #977, #127
  static Batalha2 + #978, #127
  static Batalha2 + #979, #127
  static Batalha2 + #980, #127
  static Batalha2 + #981, #127
  static Batalha2 + #982, #127
  static Batalha2 + #983, #127
  static Batalha2 + #984, #127
  static Batalha2 + #985, #127
  static Batalha2 + #986, #127
  static Batalha2 + #987, #127
  static Batalha2 + #988, #127
  static Batalha2 + #989, #127
  static Batalha2 + #990, #127
  static Batalha2 + #991, #127
  static Batalha2 + #992, #127
  static Batalha2 + #993, #127
  static Batalha2 + #994, #127
  static Batalha2 + #995, #127
  static Batalha2 + #996, #127
  static Batalha2 + #997, #127
  static Batalha2 + #998, #127
  static Batalha2 + #999, #127

  ;Linha 25
  static Batalha2 + #1000, #127
  static Batalha2 + #1001, #127
  static Batalha2 + #1002, #127
  static Batalha2 + #1003, #127
  static Batalha2 + #1004, #127
  static Batalha2 + #1005, #127
  static Batalha2 + #1006, #127
  static Batalha2 + #1007, #127
  static Batalha2 + #1008, #127
  static Batalha2 + #1009, #127
  static Batalha2 + #1010, #127
  static Batalha2 + #1011, #127
  static Batalha2 + #1012, #127
  static Batalha2 + #1013, #127
  static Batalha2 + #1014, #127
  static Batalha2 + #1015, #127
  static Batalha2 + #1016, #127
  static Batalha2 + #1017, #127
  static Batalha2 + #1018, #127
  static Batalha2 + #1019, #127
  static Batalha2 + #1020, #127
  static Batalha2 + #1021, #127
  static Batalha2 + #1022, #127
  static Batalha2 + #1023, #127
  static Batalha2 + #1024, #127
  static Batalha2 + #1025, #127
  static Batalha2 + #1026, #127
  static Batalha2 + #1027, #127
  static Batalha2 + #1028, #127
  static Batalha2 + #1029, #127
  static Batalha2 + #1030, #127
  static Batalha2 + #1031, #127
  static Batalha2 + #1032, #127
  static Batalha2 + #1033, #127
  static Batalha2 + #1034, #127
  static Batalha2 + #1035, #127
  static Batalha2 + #1036, #127
  static Batalha2 + #1037, #127
  static Batalha2 + #1038, #127
  static Batalha2 + #1039, #127

  ;Linha 26
  static Batalha2 + #1040, #127
  static Batalha2 + #1041, #127
  static Batalha2 + #1042, #50
  static Batalha2 + #1043, #127
  static Batalha2 + #1044, #45
  static Batalha2 + #1045, #127
  static Batalha2 + #1046, #67
  static Batalha2 + #1047, #72
  static Batalha2 + #1048, #85
  static Batalha2 + #1049, #84
  static Batalha2 + #1050, #65
  static Batalha2 + #1051, #82
  static Batalha2 + #1052, #127
  static Batalha2 + #1053, #127
  static Batalha2 + #1054, #127
  static Batalha2 + #1055, #127
  static Batalha2 + #1056, #127
  static Batalha2 + #1057, #127
  static Batalha2 + #1058, #127
  static Batalha2 + #1059, #127
  static Batalha2 + #1060, #127
  static Batalha2 + #1061, #127
  static Batalha2 + #1062, #52
  static Batalha2 + #1063, #127
  static Batalha2 + #1064, #45
  static Batalha2 + #1065, #127
  static Batalha2 + #1066, #66
  static Batalha2 + #1067, #79
  static Batalha2 + #1068, #76
  static Batalha2 + #1069, #65
  static Batalha2 + #1070, #127
  static Batalha2 + #1071, #68
  static Batalha2 + #1072, #69
  static Batalha2 + #1073, #127
  static Batalha2 + #1074, #70
  static Batalha2 + #1075, #79
  static Batalha2 + #1076, #71
  static Batalha2 + #1077, #79
  static Batalha2 + #1078, #127
  static Batalha2 + #1079, #127

  ;Linha 27
  static Batalha2 + #1080, #127
  static Batalha2 + #1081, #127
  static Batalha2 + #1082, #127
  static Batalha2 + #1083, #127
  static Batalha2 + #1084, #127
  static Batalha2 + #1085, #127
  static Batalha2 + #1086, #127
  static Batalha2 + #1087, #127
  static Batalha2 + #1088, #127
  static Batalha2 + #1089, #127
  static Batalha2 + #1090, #127
  static Batalha2 + #1091, #127
  static Batalha2 + #1092, #127
  static Batalha2 + #1093, #127
  static Batalha2 + #1094, #127
  static Batalha2 + #1095, #127
  static Batalha2 + #1096, #127
  static Batalha2 + #1097, #127
  static Batalha2 + #1098, #127
  static Batalha2 + #1099, #127
  static Batalha2 + #1100, #127
  static Batalha2 + #1101, #127
  static Batalha2 + #1102, #127
  static Batalha2 + #1103, #127
  static Batalha2 + #1104, #127
  static Batalha2 + #1105, #127
  static Batalha2 + #1106, #127
  static Batalha2 + #1107, #127
  static Batalha2 + #1108, #127
  static Batalha2 + #1109, #127
  static Batalha2 + #1110, #127
  static Batalha2 + #1111, #127
  static Batalha2 + #1112, #127
  static Batalha2 + #1113, #127
  static Batalha2 + #1114, #127
  static Batalha2 + #1115, #127
  static Batalha2 + #1116, #127
  static Batalha2 + #1117, #127
  static Batalha2 + #1118, #127
  static Batalha2 + #1119, #127

  ;Linha 28
  static Batalha2 + #1120, #127
  static Batalha2 + #1121, #127
  static Batalha2 + #1122, #127
  static Batalha2 + #1123, #127
  static Batalha2 + #1124, #127
  static Batalha2 + #1125, #127
  static Batalha2 + #1126, #127
  static Batalha2 + #1127, #127
  static Batalha2 + #1128, #127
  static Batalha2 + #1129, #127
  static Batalha2 + #1130, #127
  static Batalha2 + #1131, #127
  static Batalha2 + #1132, #127
  static Batalha2 + #1133, #127
  static Batalha2 + #1134, #127
  static Batalha2 + #1135, #127
  static Batalha2 + #1136, #127
  static Batalha2 + #1137, #127
  static Batalha2 + #1138, #127
  static Batalha2 + #1139, #127
  static Batalha2 + #1140, #127
  static Batalha2 + #1141, #127
  static Batalha2 + #1142, #127
  static Batalha2 + #1143, #127
  static Batalha2 + #1144, #127
  static Batalha2 + #1145, #127
  static Batalha2 + #1146, #127
  static Batalha2 + #1147, #127
  static Batalha2 + #1148, #127
  static Batalha2 + #1149, #127
  static Batalha2 + #1150, #127
  static Batalha2 + #1151, #127
  static Batalha2 + #1152, #127
  static Batalha2 + #1153, #127
  static Batalha2 + #1154, #127
  static Batalha2 + #1155, #127
  static Batalha2 + #1156, #127
  static Batalha2 + #1157, #127
  static Batalha2 + #1158, #127
  static Batalha2 + #1159, #127

  ;Linha 29
  static Batalha2 + #1160, #127
  static Batalha2 + #1161, #127
  static Batalha2 + #1162, #127
  static Batalha2 + #1163, #127
  static Batalha2 + #1164, #127
  static Batalha2 + #1165, #127
  static Batalha2 + #1166, #127
  static Batalha2 + #1167, #127
  static Batalha2 + #1168, #127
  static Batalha2 + #1169, #127
  static Batalha2 + #1170, #127
  static Batalha2 + #1171, #127
  static Batalha2 + #1172, #127
  static Batalha2 + #1173, #127
  static Batalha2 + #1174, #127
  static Batalha2 + #1175, #127
  static Batalha2 + #1176, #127
  static Batalha2 + #1177, #127
  static Batalha2 + #1178, #127
  static Batalha2 + #1179, #127
  static Batalha2 + #1180, #127
  static Batalha2 + #1181, #127
  static Batalha2 + #1182, #127
  static Batalha2 + #1183, #127
  static Batalha2 + #1184, #127
  static Batalha2 + #1185, #127
  static Batalha2 + #1186, #127
  static Batalha2 + #1187, #127
  static Batalha2 + #1188, #127
  static Batalha2 + #1189, #127
  static Batalha2 + #1190, #127
  static Batalha2 + #1191, #127
  static Batalha2 + #1192, #127
  static Batalha2 + #1193, #127
  static Batalha2 + #1194, #127
  static Batalha2 + #1195, #127
  static Batalha2 + #1196, #127
  static Batalha2 + #1197, #127
  static Batalha2 + #1198, #127
  static Batalha2 + #1199, #127

printBatalha2Screen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #Batalha2
  loadn R1, #0
  loadn R2, #1200

  printBatalha2ScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printBatalha2ScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

Batalha3 : var #1200
  ;Linha 0
  static Batalha3 + #0, #127
  static Batalha3 + #1, #127
  static Batalha3 + #2, #127
  static Batalha3 + #3, #127
  static Batalha3 + #4, #127
  static Batalha3 + #5, #127
  static Batalha3 + #6, #127
  static Batalha3 + #7, #127
  static Batalha3 + #8, #127
  static Batalha3 + #9, #127
  static Batalha3 + #10, #127
  static Batalha3 + #11, #127
  static Batalha3 + #12, #127
  static Batalha3 + #13, #127
  static Batalha3 + #14, #127
  static Batalha3 + #15, #127
  static Batalha3 + #16, #127
  static Batalha3 + #17, #127
  static Batalha3 + #18, #127
  static Batalha3 + #19, #127
  static Batalha3 + #20, #127
  static Batalha3 + #21, #127
  static Batalha3 + #22, #127
  static Batalha3 + #23, #127
  static Batalha3 + #24, #127
  static Batalha3 + #25, #127
  static Batalha3 + #26, #127
  static Batalha3 + #27, #127
  static Batalha3 + #28, #127
  static Batalha3 + #29, #127
  static Batalha3 + #30, #127
  static Batalha3 + #31, #127
  static Batalha3 + #32, #127
  static Batalha3 + #33, #127
  static Batalha3 + #34, #127
  static Batalha3 + #35, #127
  static Batalha3 + #36, #127
  static Batalha3 + #37, #127
  static Batalha3 + #38, #127
  static Batalha3 + #39, #127

  ;Linha 1
  static Batalha3 + #40, #127
  static Batalha3 + #41, #127
  static Batalha3 + #42, #127
  static Batalha3 + #43, #127
  static Batalha3 + #44, #127
  static Batalha3 + #45, #127
  static Batalha3 + #46, #127
  static Batalha3 + #47, #127
  static Batalha3 + #48, #127
  static Batalha3 + #49, #127
  static Batalha3 + #50, #127
  static Batalha3 + #51, #127
  static Batalha3 + #52, #127
  static Batalha3 + #53, #127
  static Batalha3 + #54, #127
  static Batalha3 + #55, #127
  static Batalha3 + #56, #127
  static Batalha3 + #57, #127
  static Batalha3 + #58, #127
  static Batalha3 + #59, #127
  static Batalha3 + #60, #127
  static Batalha3 + #61, #127
  static Batalha3 + #62, #127
  static Batalha3 + #63, #127
  static Batalha3 + #64, #127
  static Batalha3 + #65, #127
  static Batalha3 + #66, #127
  static Batalha3 + #67, #127
  static Batalha3 + #68, #127
  static Batalha3 + #69, #127
  static Batalha3 + #70, #127
  static Batalha3 + #71, #127
  static Batalha3 + #72, #127
  static Batalha3 + #73, #127
  static Batalha3 + #74, #127
  static Batalha3 + #75, #127
  static Batalha3 + #76, #127
  static Batalha3 + #77, #127
  static Batalha3 + #78, #127
  static Batalha3 + #79, #127

  ;Linha 2
  static Batalha3 + #80, #127
  static Batalha3 + #81, #127
  static Batalha3 + #82, #127
  static Batalha3 + #83, #127
  static Batalha3 + #84, #127
  static Batalha3 + #85, #127
  static Batalha3 + #86, #127
  static Batalha3 + #87, #127
  static Batalha3 + #88, #127
  static Batalha3 + #89, #127
  static Batalha3 + #90, #127
  static Batalha3 + #91, #127
  static Batalha3 + #92, #127
  static Batalha3 + #93, #127
  static Batalha3 + #94, #127
  static Batalha3 + #95, #127
  static Batalha3 + #96, #127
  static Batalha3 + #97, #127
  static Batalha3 + #98, #127
  static Batalha3 + #99, #127
  static Batalha3 + #100, #127
  static Batalha3 + #101, #127
  static Batalha3 + #102, #127
  static Batalha3 + #103, #127
  static Batalha3 + #104, #127
  static Batalha3 + #105, #127
  static Batalha3 + #106, #127
  static Batalha3 + #107, #127
  static Batalha3 + #108, #127
  static Batalha3 + #109, #127
  static Batalha3 + #110, #127
  static Batalha3 + #111, #127
  static Batalha3 + #112, #127
  static Batalha3 + #113, #127
  static Batalha3 + #114, #127
  static Batalha3 + #115, #127
  static Batalha3 + #116, #127
  static Batalha3 + #117, #127
  static Batalha3 + #118, #127
  static Batalha3 + #119, #127

  ;Linha 3
  static Batalha3 + #120, #127
  static Batalha3 + #121, #127
  static Batalha3 + #122, #127
  static Batalha3 + #123, #127
  static Batalha3 + #124, #127
  static Batalha3 + #125, #127
  static Batalha3 + #126, #127
  static Batalha3 + #127, #127
  static Batalha3 + #128, #127
  static Batalha3 + #129, #127
  static Batalha3 + #130, #127
  static Batalha3 + #131, #127
  static Batalha3 + #132, #127
  static Batalha3 + #133, #127
  static Batalha3 + #134, #127
  static Batalha3 + #135, #127
  static Batalha3 + #136, #127
  static Batalha3 + #137, #127
  static Batalha3 + #138, #127
  static Batalha3 + #139, #127
  static Batalha3 + #140, #127
  static Batalha3 + #141, #127
  static Batalha3 + #142, #127
  static Batalha3 + #143, #127
  static Batalha3 + #144, #127
  static Batalha3 + #145, #127
  static Batalha3 + #146, #127
  static Batalha3 + #147, #127
  static Batalha3 + #148, #127
  static Batalha3 + #149, #127
  static Batalha3 + #150, #127
  static Batalha3 + #151, #127
  static Batalha3 + #152, #127
  static Batalha3 + #153, #127
  static Batalha3 + #154, #127
  static Batalha3 + #155, #127
  static Batalha3 + #156, #127
  static Batalha3 + #157, #127
  static Batalha3 + #158, #127
  static Batalha3 + #159, #127

  ;Linha 4
  static Batalha3 + #160, #127
  static Batalha3 + #161, #127
  static Batalha3 + #162, #127
  static Batalha3 + #163, #127
  static Batalha3 + #164, #127
  static Batalha3 + #165, #127
  static Batalha3 + #166, #127
  static Batalha3 + #167, #127
  static Batalha3 + #168, #127
  static Batalha3 + #169, #127
  static Batalha3 + #170, #127
  static Batalha3 + #171, #127
  static Batalha3 + #172, #127
  static Batalha3 + #173, #127
  static Batalha3 + #174, #127
  static Batalha3 + #175, #127
  static Batalha3 + #176, #127
  static Batalha3 + #177, #127
  static Batalha3 + #178, #127
  static Batalha3 + #179, #127
  static Batalha3 + #180, #127
  static Batalha3 + #181, #127
  static Batalha3 + #182, #127
  static Batalha3 + #183, #127
  static Batalha3 + #184, #127
  static Batalha3 + #185, #127
  static Batalha3 + #186, #127
  static Batalha3 + #187, #127
  static Batalha3 + #188, #127
  static Batalha3 + #189, #127
  static Batalha3 + #190, #127
  static Batalha3 + #191, #127
  static Batalha3 + #192, #127
  static Batalha3 + #193, #127
  static Batalha3 + #194, #127
  static Batalha3 + #195, #127
  static Batalha3 + #196, #127
  static Batalha3 + #197, #127
  static Batalha3 + #198, #127
  static Batalha3 + #199, #127

  ;Linha 5
  static Batalha3 + #200, #127
  static Batalha3 + #201, #127
  static Batalha3 + #202, #127
  static Batalha3 + #203, #127
  static Batalha3 + #204, #127
  static Batalha3 + #205, #127
  static Batalha3 + #206, #127
  static Batalha3 + #207, #127
  static Batalha3 + #208, #127
  static Batalha3 + #209, #127
  static Batalha3 + #210, #127
  static Batalha3 + #211, #127
  static Batalha3 + #212, #127
  static Batalha3 + #213, #127
  static Batalha3 + #214, #127
  static Batalha3 + #215, #127
  static Batalha3 + #216, #127
  static Batalha3 + #217, #127
  static Batalha3 + #218, #127
  static Batalha3 + #219, #127
  static Batalha3 + #220, #127
  static Batalha3 + #221, #127
  static Batalha3 + #222, #127
  static Batalha3 + #223, #127
  static Batalha3 + #224, #127
  static Batalha3 + #225, #127
  static Batalha3 + #226, #127
  static Batalha3 + #227, #127
  static Batalha3 + #228, #127
  static Batalha3 + #229, #127
  static Batalha3 + #230, #127
  static Batalha3 + #231, #127
  static Batalha3 + #232, #127
  static Batalha3 + #233, #127
  static Batalha3 + #234, #127
  static Batalha3 + #235, #127
  static Batalha3 + #236, #127
  static Batalha3 + #237, #127
  static Batalha3 + #238, #127
  static Batalha3 + #239, #127

  ;Linha 6
  static Batalha3 + #240, #127
  static Batalha3 + #241, #127
  static Batalha3 + #242, #127
  static Batalha3 + #243, #127
  static Batalha3 + #244, #127
  static Batalha3 + #245, #127
  static Batalha3 + #246, #127
  static Batalha3 + #247, #127
  static Batalha3 + #248, #127
  static Batalha3 + #249, #127
  static Batalha3 + #250, #127
  static Batalha3 + #251, #127
  static Batalha3 + #252, #127
  static Batalha3 + #253, #127
  static Batalha3 + #254, #127
  static Batalha3 + #255, #127
  static Batalha3 + #256, #127
  static Batalha3 + #257, #127
  static Batalha3 + #258, #127
  static Batalha3 + #259, #127
  static Batalha3 + #260, #127
  static Batalha3 + #261, #127
  static Batalha3 + #262, #127
  static Batalha3 + #263, #127
  static Batalha3 + #264, #127
  static Batalha3 + #265, #127
  static Batalha3 + #266, #127
  static Batalha3 + #267, #127
  static Batalha3 + #268, #127
  static Batalha3 + #269, #127
  static Batalha3 + #270, #127
  static Batalha3 + #271, #127
  static Batalha3 + #272, #127
  static Batalha3 + #273, #127
  static Batalha3 + #274, #127
  static Batalha3 + #275, #127
  static Batalha3 + #276, #127
  static Batalha3 + #277, #127
  static Batalha3 + #278, #127
  static Batalha3 + #279, #127

  ;Linha 7
  static Batalha3 + #280, #127
  static Batalha3 + #281, #127
  static Batalha3 + #282, #127
  static Batalha3 + #283, #127
  static Batalha3 + #284, #127
  static Batalha3 + #285, #127
  static Batalha3 + #286, #127
  static Batalha3 + #287, #127
  static Batalha3 + #288, #127
  static Batalha3 + #289, #127
  static Batalha3 + #290, #127
  static Batalha3 + #291, #127
  static Batalha3 + #292, #127
  static Batalha3 + #293, #127
  static Batalha3 + #294, #127
  static Batalha3 + #295, #127
  static Batalha3 + #296, #127
  static Batalha3 + #297, #127
  static Batalha3 + #298, #127
  static Batalha3 + #299, #127
  static Batalha3 + #300, #127
  static Batalha3 + #301, #127
  static Batalha3 + #302, #127
  static Batalha3 + #303, #127
  static Batalha3 + #304, #127
  static Batalha3 + #305, #127
  static Batalha3 + #306, #127
  static Batalha3 + #307, #127
  static Batalha3 + #308, #127
  static Batalha3 + #309, #127
  static Batalha3 + #310, #127
  static Batalha3 + #311, #127
  static Batalha3 + #312, #127
  static Batalha3 + #313, #127
  static Batalha3 + #314, #127
  static Batalha3 + #315, #127
  static Batalha3 + #316, #127
  static Batalha3 + #317, #127
  static Batalha3 + #318, #127
  static Batalha3 + #319, #127

  ;Linha 8
  static Batalha3 + #320, #127
  static Batalha3 + #321, #127
  static Batalha3 + #322, #127
  static Batalha3 + #323, #127
  static Batalha3 + #324, #127
  static Batalha3 + #325, #127
  static Batalha3 + #326, #127
  static Batalha3 + #327, #127
  static Batalha3 + #328, #127
  static Batalha3 + #329, #127
  static Batalha3 + #330, #127
  static Batalha3 + #331, #127
  static Batalha3 + #332, #127
  static Batalha3 + #333, #127
  static Batalha3 + #334, #127
  static Batalha3 + #335, #127
  static Batalha3 + #336, #127
  static Batalha3 + #337, #127
  static Batalha3 + #338, #127
  static Batalha3 + #339, #127
  static Batalha3 + #340, #127
  static Batalha3 + #341, #127
  static Batalha3 + #342, #127
  static Batalha3 + #343, #127
  static Batalha3 + #344, #127
  static Batalha3 + #345, #127
  static Batalha3 + #346, #127
  static Batalha3 + #347, #127
  static Batalha3 + #348, #127
  static Batalha3 + #349, #127
  static Batalha3 + #350, #127
  static Batalha3 + #351, #127
  static Batalha3 + #352, #127
  static Batalha3 + #353, #127
  static Batalha3 + #354, #127
  static Batalha3 + #355, #127
  static Batalha3 + #356, #127
  static Batalha3 + #357, #127
  static Batalha3 + #358, #127
  static Batalha3 + #359, #127

  ;Linha 9
  static Batalha3 + #360, #127
  static Batalha3 + #361, #127
  static Batalha3 + #362, #127
  static Batalha3 + #363, #127
  static Batalha3 + #364, #127
  static Batalha3 + #365, #127
  static Batalha3 + #366, #127
  static Batalha3 + #367, #127
  static Batalha3 + #368, #127
  static Batalha3 + #369, #127
  static Batalha3 + #370, #127
  static Batalha3 + #371, #127
  static Batalha3 + #372, #127
  static Batalha3 + #373, #127
  static Batalha3 + #374, #127
  static Batalha3 + #375, #127
  static Batalha3 + #376, #127
  static Batalha3 + #377, #127
  static Batalha3 + #378, #127
  static Batalha3 + #379, #127
  static Batalha3 + #380, #127
  static Batalha3 + #381, #127
  static Batalha3 + #382, #127
  static Batalha3 + #383, #127
  static Batalha3 + #384, #127
  static Batalha3 + #385, #127
  static Batalha3 + #386, #127
  static Batalha3 + #387, #127
  static Batalha3 + #388, #127
  static Batalha3 + #389, #127
  static Batalha3 + #390, #127
  static Batalha3 + #391, #127
  static Batalha3 + #392, #127
  static Batalha3 + #393, #127
  static Batalha3 + #394, #127
  static Batalha3 + #395, #127
  static Batalha3 + #396, #127
  static Batalha3 + #397, #127
  static Batalha3 + #398, #127
  static Batalha3 + #399, #127

  ;Linha 10
  static Batalha3 + #400, #127
  static Batalha3 + #401, #127
  static Batalha3 + #402, #127
  static Batalha3 + #403, #127
  static Batalha3 + #404, #127
  static Batalha3 + #405, #127
  static Batalha3 + #406, #127
  static Batalha3 + #407, #127
  static Batalha3 + #408, #127
  static Batalha3 + #409, #127
  static Batalha3 + #410, #127
  static Batalha3 + #411, #127
  static Batalha3 + #412, #127
  static Batalha3 + #413, #127
  static Batalha3 + #414, #127
  static Batalha3 + #415, #127
  static Batalha3 + #416, #127
  static Batalha3 + #417, #127
  static Batalha3 + #418, #127
  static Batalha3 + #419, #127
  static Batalha3 + #420, #127
  static Batalha3 + #421, #127
  static Batalha3 + #422, #127
  static Batalha3 + #423, #127
  static Batalha3 + #424, #127
  static Batalha3 + #425, #127
  static Batalha3 + #426, #127
  static Batalha3 + #427, #127
  static Batalha3 + #428, #127
  static Batalha3 + #429, #127
  static Batalha3 + #430, #127
  static Batalha3 + #431, #127
  static Batalha3 + #432, #127
  static Batalha3 + #433, #127
  static Batalha3 + #434, #127
  static Batalha3 + #435, #127
  static Batalha3 + #436, #127
  static Batalha3 + #437, #127
  static Batalha3 + #438, #127
  static Batalha3 + #439, #127

  ;Linha 11
  static Batalha3 + #440, #127
  static Batalha3 + #441, #127
  static Batalha3 + #442, #127
  static Batalha3 + #443, #127
  static Batalha3 + #444, #127
  static Batalha3 + #445, #127
  static Batalha3 + #446, #127
  static Batalha3 + #447, #127
  static Batalha3 + #448, #127
  static Batalha3 + #449, #127
  static Batalha3 + #450, #127
  static Batalha3 + #451, #127
  static Batalha3 + #452, #127
  static Batalha3 + #453, #127
  static Batalha3 + #454, #127
  static Batalha3 + #455, #127
  static Batalha3 + #456, #127
  static Batalha3 + #457, #127
  static Batalha3 + #458, #127
  static Batalha3 + #459, #127
  static Batalha3 + #460, #127
  static Batalha3 + #461, #127
  static Batalha3 + #462, #127
  static Batalha3 + #463, #127
  static Batalha3 + #464, #127
  static Batalha3 + #465, #127
  static Batalha3 + #466, #127
  static Batalha3 + #467, #127
  static Batalha3 + #468, #127
  static Batalha3 + #469, #127
  static Batalha3 + #470, #127
  static Batalha3 + #471, #127
  static Batalha3 + #472, #127
  static Batalha3 + #473, #127
  static Batalha3 + #474, #127
  static Batalha3 + #475, #127
  static Batalha3 + #476, #127
  static Batalha3 + #477, #127
  static Batalha3 + #478, #127
  static Batalha3 + #479, #127

  ;Linha 12
  static Batalha3 + #480, #127
  static Batalha3 + #481, #127
  static Batalha3 + #482, #127
  static Batalha3 + #483, #127
  static Batalha3 + #484, #127
  static Batalha3 + #485, #127
  static Batalha3 + #486, #127
  static Batalha3 + #487, #127
  static Batalha3 + #488, #127
  static Batalha3 + #489, #127
  static Batalha3 + #490, #127
  static Batalha3 + #491, #127
  static Batalha3 + #492, #127
  static Batalha3 + #493, #127
  static Batalha3 + #494, #127
  static Batalha3 + #495, #127
  static Batalha3 + #496, #127
  static Batalha3 + #497, #127
  static Batalha3 + #498, #127
  static Batalha3 + #499, #127
  static Batalha3 + #500, #127
  static Batalha3 + #501, #127
  static Batalha3 + #502, #127
  static Batalha3 + #503, #127
  static Batalha3 + #504, #127
  static Batalha3 + #505, #127
  static Batalha3 + #506, #127
  static Batalha3 + #507, #127
  static Batalha3 + #508, #127
  static Batalha3 + #509, #127
  static Batalha3 + #510, #127
  static Batalha3 + #511, #127
  static Batalha3 + #512, #127
  static Batalha3 + #513, #127
  static Batalha3 + #514, #127
  static Batalha3 + #515, #127
  static Batalha3 + #516, #127
  static Batalha3 + #517, #127
  static Batalha3 + #518, #127
  static Batalha3 + #519, #127

  ;Linha 13
  static Batalha3 + #520, #127
  static Batalha3 + #521, #127
  static Batalha3 + #522, #127
  static Batalha3 + #523, #127
  static Batalha3 + #524, #127
  static Batalha3 + #525, #127
  static Batalha3 + #526, #127
  static Batalha3 + #527, #127
  static Batalha3 + #528, #127
  static Batalha3 + #529, #127
  static Batalha3 + #530, #127
  static Batalha3 + #531, #127
  static Batalha3 + #532, #127
  static Batalha3 + #533, #127
  static Batalha3 + #534, #127
  static Batalha3 + #535, #127
  static Batalha3 + #536, #127
  static Batalha3 + #537, #127
  static Batalha3 + #538, #127
  static Batalha3 + #539, #127
  static Batalha3 + #540, #127
  static Batalha3 + #541, #127
  static Batalha3 + #542, #127
  static Batalha3 + #543, #127
  static Batalha3 + #544, #127
  static Batalha3 + #545, #127
  static Batalha3 + #546, #127
  static Batalha3 + #547, #127
  static Batalha3 + #548, #127
  static Batalha3 + #549, #127
  static Batalha3 + #550, #127
  static Batalha3 + #551, #127
  static Batalha3 + #552, #127
  static Batalha3 + #553, #127
  static Batalha3 + #554, #127
  static Batalha3 + #555, #127
  static Batalha3 + #556, #127
  static Batalha3 + #557, #127
  static Batalha3 + #558, #127
  static Batalha3 + #559, #127

  ;Linha 14
  static Batalha3 + #560, #127
  static Batalha3 + #561, #127
  static Batalha3 + #562, #127
  static Batalha3 + #563, #127
  static Batalha3 + #564, #127
  static Batalha3 + #565, #127
  static Batalha3 + #566, #127
  static Batalha3 + #567, #127
  static Batalha3 + #568, #127
  static Batalha3 + #569, #127
  static Batalha3 + #570, #127
  static Batalha3 + #571, #127
  static Batalha3 + #572, #127
  static Batalha3 + #573, #127
  static Batalha3 + #574, #127
  static Batalha3 + #575, #127
  static Batalha3 + #576, #127
  static Batalha3 + #577, #127
  static Batalha3 + #578, #127
  static Batalha3 + #579, #127
  static Batalha3 + #580, #127
  static Batalha3 + #581, #127
  static Batalha3 + #582, #127
  static Batalha3 + #583, #127
  static Batalha3 + #584, #127
  static Batalha3 + #585, #127
  static Batalha3 + #586, #127
  static Batalha3 + #587, #127
  static Batalha3 + #588, #127
  static Batalha3 + #589, #127
  static Batalha3 + #590, #127
  static Batalha3 + #591, #127
  static Batalha3 + #592, #127
  static Batalha3 + #593, #127
  static Batalha3 + #594, #127
  static Batalha3 + #595, #127
  static Batalha3 + #596, #127
  static Batalha3 + #597, #127
  static Batalha3 + #598, #127
  static Batalha3 + #599, #127

  ;Linha 15
  static Batalha3 + #600, #127
  static Batalha3 + #601, #127
  static Batalha3 + #602, #127
  static Batalha3 + #603, #127
  static Batalha3 + #604, #127
  static Batalha3 + #605, #127
  static Batalha3 + #606, #127
  static Batalha3 + #607, #127
  static Batalha3 + #608, #127
  static Batalha3 + #609, #127
  static Batalha3 + #610, #127
  static Batalha3 + #611, #127
  static Batalha3 + #612, #127
  static Batalha3 + #613, #127
  static Batalha3 + #614, #127
  static Batalha3 + #615, #127
  static Batalha3 + #616, #127
  static Batalha3 + #617, #127
  static Batalha3 + #618, #127
  static Batalha3 + #619, #127
  static Batalha3 + #620, #127
  static Batalha3 + #621, #127
  static Batalha3 + #622, #127
  static Batalha3 + #623, #127
  static Batalha3 + #624, #127
  static Batalha3 + #625, #127
  static Batalha3 + #626, #127
  static Batalha3 + #627, #127
  static Batalha3 + #628, #127
  static Batalha3 + #629, #127
  static Batalha3 + #630, #127
  static Batalha3 + #631, #127
  static Batalha3 + #632, #127
  static Batalha3 + #633, #127
  static Batalha3 + #634, #127
  static Batalha3 + #635, #127
  static Batalha3 + #636, #127
  static Batalha3 + #637, #127
  static Batalha3 + #638, #127
  static Batalha3 + #639, #127

  ;Linha 16
  static Batalha3 + #640, #127
  static Batalha3 + #641, #127
  static Batalha3 + #642, #127
  static Batalha3 + #643, #127
  static Batalha3 + #644, #127
  static Batalha3 + #645, #127
  static Batalha3 + #646, #127
  static Batalha3 + #647, #127
  static Batalha3 + #648, #127
  static Batalha3 + #649, #127
  static Batalha3 + #650, #127
  static Batalha3 + #651, #127
  static Batalha3 + #652, #127
  static Batalha3 + #653, #127
  static Batalha3 + #654, #127
  static Batalha3 + #655, #127
  static Batalha3 + #656, #127
  static Batalha3 + #657, #127
  static Batalha3 + #658, #127
  static Batalha3 + #659, #127
  static Batalha3 + #660, #127
  static Batalha3 + #661, #127
  static Batalha3 + #662, #127
  static Batalha3 + #663, #127
  static Batalha3 + #664, #127
  static Batalha3 + #665, #127
  static Batalha3 + #666, #127
  static Batalha3 + #667, #127
  static Batalha3 + #668, #127
  static Batalha3 + #669, #127
  static Batalha3 + #670, #127
  static Batalha3 + #671, #127
  static Batalha3 + #672, #127
  static Batalha3 + #673, #127
  static Batalha3 + #674, #127
  static Batalha3 + #675, #127
  static Batalha3 + #676, #127
  static Batalha3 + #677, #127
  static Batalha3 + #678, #127
  static Batalha3 + #679, #127

  ;Linha 17
  static Batalha3 + #680, #127
  static Batalha3 + #681, #127
  static Batalha3 + #682, #127
  static Batalha3 + #683, #127
  static Batalha3 + #684, #127
  static Batalha3 + #685, #127
  static Batalha3 + #686, #127
  static Batalha3 + #687, #127
  static Batalha3 + #688, #127
  static Batalha3 + #689, #127
  static Batalha3 + #690, #127
  static Batalha3 + #691, #127
  static Batalha3 + #692, #127
  static Batalha3 + #693, #127
  static Batalha3 + #694, #127
  static Batalha3 + #695, #127
  static Batalha3 + #696, #127
  static Batalha3 + #697, #127
  static Batalha3 + #698, #127
  static Batalha3 + #699, #127
  static Batalha3 + #700, #127
  static Batalha3 + #701, #127
  static Batalha3 + #702, #127
  static Batalha3 + #703, #127
  static Batalha3 + #704, #127
  static Batalha3 + #705, #127
  static Batalha3 + #706, #127
  static Batalha3 + #707, #127
  static Batalha3 + #708, #127
  static Batalha3 + #709, #127
  static Batalha3 + #710, #127
  static Batalha3 + #711, #127
  static Batalha3 + #712, #127
  static Batalha3 + #713, #127
  static Batalha3 + #714, #127
  static Batalha3 + #715, #127
  static Batalha3 + #716, #127
  static Batalha3 + #717, #127
  static Batalha3 + #718, #127
  static Batalha3 + #719, #127

  ;Linha 18
  static Batalha3 + #720, #127
  static Batalha3 + #721, #127
  static Batalha3 + #722, #127
  static Batalha3 + #723, #127
  static Batalha3 + #724, #127
  static Batalha3 + #725, #127
  static Batalha3 + #726, #127
  static Batalha3 + #727, #127
  static Batalha3 + #728, #127
  static Batalha3 + #729, #127
  static Batalha3 + #730, #127
  static Batalha3 + #731, #127
  static Batalha3 + #732, #127
  static Batalha3 + #733, #127
  static Batalha3 + #734, #127
  static Batalha3 + #735, #127
  static Batalha3 + #736, #127
  static Batalha3 + #737, #127
  static Batalha3 + #738, #127
  static Batalha3 + #739, #127
  static Batalha3 + #740, #127
  static Batalha3 + #741, #127
  static Batalha3 + #742, #127
  static Batalha3 + #743, #127
  static Batalha3 + #744, #127
  static Batalha3 + #745, #127
  static Batalha3 + #746, #127
  static Batalha3 + #747, #127
  static Batalha3 + #748, #127
  static Batalha3 + #749, #127
  static Batalha3 + #750, #127
  static Batalha3 + #751, #127
  static Batalha3 + #752, #127
  static Batalha3 + #753, #127
  static Batalha3 + #754, #127
  static Batalha3 + #755, #127
  static Batalha3 + #756, #127
  static Batalha3 + #757, #127
  static Batalha3 + #758, #127
  static Batalha3 + #759, #127

  ;Linha 19
  static Batalha3 + #760, #127
  static Batalha3 + #761, #127
  static Batalha3 + #762, #127
  static Batalha3 + #763, #127
  static Batalha3 + #764, #127
  static Batalha3 + #765, #127
  static Batalha3 + #766, #127
  static Batalha3 + #767, #127
  static Batalha3 + #768, #127
  static Batalha3 + #769, #127
  static Batalha3 + #770, #127
  static Batalha3 + #771, #127
  static Batalha3 + #772, #127
  static Batalha3 + #773, #127
  static Batalha3 + #774, #127
  static Batalha3 + #775, #127
  static Batalha3 + #776, #127
  static Batalha3 + #777, #127
  static Batalha3 + #778, #127
  static Batalha3 + #779, #127
  static Batalha3 + #780, #127
  static Batalha3 + #781, #127
  static Batalha3 + #782, #127
  static Batalha3 + #783, #127
  static Batalha3 + #784, #127
  static Batalha3 + #785, #127
  static Batalha3 + #786, #127
  static Batalha3 + #787, #127
  static Batalha3 + #788, #127
  static Batalha3 + #789, #127
  static Batalha3 + #790, #127
  static Batalha3 + #791, #127
  static Batalha3 + #792, #127
  static Batalha3 + #793, #127
  static Batalha3 + #794, #127
  static Batalha3 + #795, #127
  static Batalha3 + #796, #127
  static Batalha3 + #797, #127
  static Batalha3 + #798, #127
  static Batalha3 + #799, #127

  ;Linha 20
  static Batalha3 + #800, #0
  static Batalha3 + #801, #0
  static Batalha3 + #802, #0
  static Batalha3 + #803, #0
  static Batalha3 + #804, #0
  static Batalha3 + #805, #0
  static Batalha3 + #806, #0
  static Batalha3 + #807, #0
  static Batalha3 + #808, #0
  static Batalha3 + #809, #0
  static Batalha3 + #810, #0
  static Batalha3 + #811, #0
  static Batalha3 + #812, #0
  static Batalha3 + #813, #0
  static Batalha3 + #814, #0
  static Batalha3 + #815, #0
  static Batalha3 + #816, #0
  static Batalha3 + #817, #0
  static Batalha3 + #818, #0
  static Batalha3 + #819, #0
  static Batalha3 + #820, #0
  static Batalha3 + #821, #0
  static Batalha3 + #822, #0
  static Batalha3 + #823, #0
  static Batalha3 + #824, #0
  static Batalha3 + #825, #0
  static Batalha3 + #826, #0
  static Batalha3 + #827, #0
  static Batalha3 + #828, #0
  static Batalha3 + #829, #0
  static Batalha3 + #830, #0
  static Batalha3 + #831, #0
  static Batalha3 + #832, #0
  static Batalha3 + #833, #0
  static Batalha3 + #834, #0
  static Batalha3 + #835, #0
  static Batalha3 + #836, #0
  static Batalha3 + #837, #0
  static Batalha3 + #838, #0
  static Batalha3 + #839, #0

  ;Linha 21
  static Batalha3 + #840, #127
  static Batalha3 + #841, #127
  static Batalha3 + #842, #127
  static Batalha3 + #843, #127
  static Batalha3 + #844, #127
  static Batalha3 + #845, #127
  static Batalha3 + #846, #127
  static Batalha3 + #847, #127
  static Batalha3 + #848, #127
  static Batalha3 + #849, #127
  static Batalha3 + #850, #127
  static Batalha3 + #851, #127
  static Batalha3 + #852, #127
  static Batalha3 + #853, #127
  static Batalha3 + #854, #127
  static Batalha3 + #855, #127
  static Batalha3 + #856, #127
  static Batalha3 + #857, #127
  static Batalha3 + #858, #127
  static Batalha3 + #859, #127
  static Batalha3 + #860, #127
  static Batalha3 + #861, #127
  static Batalha3 + #862, #127
  static Batalha3 + #863, #127
  static Batalha3 + #864, #127
  static Batalha3 + #865, #127
  static Batalha3 + #866, #127
  static Batalha3 + #867, #127
  static Batalha3 + #868, #127
  static Batalha3 + #869, #127
  static Batalha3 + #870, #127
  static Batalha3 + #871, #127
  static Batalha3 + #872, #127
  static Batalha3 + #873, #127
  static Batalha3 + #874, #127
  static Batalha3 + #875, #127
  static Batalha3 + #876, #127
  static Batalha3 + #877, #127
  static Batalha3 + #878, #127
  static Batalha3 + #879, #127

  ;Linha 22
  static Batalha3 + #880, #127
  static Batalha3 + #881, #127
  static Batalha3 + #882, #127
  static Batalha3 + #883, #127
  static Batalha3 + #884, #127
  static Batalha3 + #885, #127
  static Batalha3 + #886, #127
  static Batalha3 + #887, #127
  static Batalha3 + #888, #127
  static Batalha3 + #889, #127
  static Batalha3 + #890, #127
  static Batalha3 + #891, #127
  static Batalha3 + #892, #127
  static Batalha3 + #893, #127
  static Batalha3 + #894, #127
  static Batalha3 + #895, #127
  static Batalha3 + #896, #127
  static Batalha3 + #897, #127
  static Batalha3 + #898, #127
  static Batalha3 + #899, #127
  static Batalha3 + #900, #127
  static Batalha3 + #901, #127
  static Batalha3 + #902, #127
  static Batalha3 + #903, #127
  static Batalha3 + #904, #127
  static Batalha3 + #905, #127
  static Batalha3 + #906, #127
  static Batalha3 + #907, #127
  static Batalha3 + #908, #127
  static Batalha3 + #909, #127
  static Batalha3 + #910, #127
  static Batalha3 + #911, #127
  static Batalha3 + #912, #127
  static Batalha3 + #913, #127
  static Batalha3 + #914, #127
  static Batalha3 + #915, #127
  static Batalha3 + #916, #127
  static Batalha3 + #917, #127
  static Batalha3 + #918, #127
  static Batalha3 + #919, #127

  ;Linha 23
  static Batalha3 + #920, #127
  static Batalha3 + #921, #127
  static Batalha3 + #922, #49
  static Batalha3 + #923, #127
  static Batalha3 + #924, #45
  static Batalha3 + #925, #127
  static Batalha3 + #926, #80
  static Batalha3 + #927, #79
  static Batalha3 + #928, #67
  static Batalha3 + #929, #65
  static Batalha3 + #930, #79
  static Batalha3 + #931, #127
  static Batalha3 + #932, #127
  static Batalha3 + #933, #127
  static Batalha3 + #934, #127
  static Batalha3 + #935, #127
  static Batalha3 + #936, #127
  static Batalha3 + #937, #127
  static Batalha3 + #938, #127
  static Batalha3 + #939, #127
  static Batalha3 + #940, #127
  static Batalha3 + #941, #127
  static Batalha3 + #942, #51
  static Batalha3 + #943, #127
  static Batalha3 + #944, #45
  static Batalha3 + #945, #127
  static Batalha3 + #946, #68
  static Batalha3 + #947, #69
  static Batalha3 + #948, #70
  static Batalha3 + #949, #85
  static Batalha3 + #950, #80
  static Batalha3 + #951, #127
  static Batalha3 + #952, #127
  static Batalha3 + #953, #127
  static Batalha3 + #954, #127
  static Batalha3 + #955, #127
  static Batalha3 + #956, #127
  static Batalha3 + #957, #127
  static Batalha3 + #958, #127
  static Batalha3 + #959, #127

  ;Linha 24
  static Batalha3 + #960, #127
  static Batalha3 + #961, #127
  static Batalha3 + #962, #127
  static Batalha3 + #963, #127
  static Batalha3 + #964, #127
  static Batalha3 + #965, #127
  static Batalha3 + #966, #127
  static Batalha3 + #967, #127
  static Batalha3 + #968, #127
  static Batalha3 + #969, #127
  static Batalha3 + #970, #127
  static Batalha3 + #971, #127
  static Batalha3 + #972, #127
  static Batalha3 + #973, #127
  static Batalha3 + #974, #127
  static Batalha3 + #975, #127
  static Batalha3 + #976, #127
  static Batalha3 + #977, #127
  static Batalha3 + #978, #127
  static Batalha3 + #979, #127
  static Batalha3 + #980, #127
  static Batalha3 + #981, #127
  static Batalha3 + #982, #127
  static Batalha3 + #983, #127
  static Batalha3 + #984, #127
  static Batalha3 + #985, #127
  static Batalha3 + #986, #127
  static Batalha3 + #987, #127
  static Batalha3 + #988, #127
  static Batalha3 + #989, #127
  static Batalha3 + #990, #127
  static Batalha3 + #991, #127
  static Batalha3 + #992, #127
  static Batalha3 + #993, #127
  static Batalha3 + #994, #127
  static Batalha3 + #995, #127
  static Batalha3 + #996, #127
  static Batalha3 + #997, #127
  static Batalha3 + #998, #127
  static Batalha3 + #999, #127

  ;Linha 25
  static Batalha3 + #1000, #127
  static Batalha3 + #1001, #127
  static Batalha3 + #1002, #127
  static Batalha3 + #1003, #127
  static Batalha3 + #1004, #127
  static Batalha3 + #1005, #127
  static Batalha3 + #1006, #127
  static Batalha3 + #1007, #127
  static Batalha3 + #1008, #127
  static Batalha3 + #1009, #127
  static Batalha3 + #1010, #127
  static Batalha3 + #1011, #127
  static Batalha3 + #1012, #127
  static Batalha3 + #1013, #127
  static Batalha3 + #1014, #127
  static Batalha3 + #1015, #127
  static Batalha3 + #1016, #127
  static Batalha3 + #1017, #127
  static Batalha3 + #1018, #127
  static Batalha3 + #1019, #127
  static Batalha3 + #1020, #127
  static Batalha3 + #1021, #127
  static Batalha3 + #1022, #127
  static Batalha3 + #1023, #127
  static Batalha3 + #1024, #127
  static Batalha3 + #1025, #127
  static Batalha3 + #1026, #127
  static Batalha3 + #1027, #127
  static Batalha3 + #1028, #127
  static Batalha3 + #1029, #127
  static Batalha3 + #1030, #127
  static Batalha3 + #1031, #127
  static Batalha3 + #1032, #127
  static Batalha3 + #1033, #127
  static Batalha3 + #1034, #127
  static Batalha3 + #1035, #127
  static Batalha3 + #1036, #127
  static Batalha3 + #1037, #127
  static Batalha3 + #1038, #127
  static Batalha3 + #1039, #127

  ;Linha 26
  static Batalha3 + #1040, #127
  static Batalha3 + #1041, #127
  static Batalha3 + #1042, #50
  static Batalha3 + #1043, #127
  static Batalha3 + #1044, #45
  static Batalha3 + #1045, #127
  static Batalha3 + #1046, #65
  static Batalha3 + #1047, #84
  static Batalha3 + #1048, #75
  static Batalha3 + #1049, #85
  static Batalha3 + #1050, #80
  static Batalha3 + #1051, #127
  static Batalha3 + #1052, #127
  static Batalha3 + #1053, #127
  static Batalha3 + #1054, #127
  static Batalha3 + #1055, #127
  static Batalha3 + #1056, #127
  static Batalha3 + #1057, #127
  static Batalha3 + #1058, #127
  static Batalha3 + #1059, #127
  static Batalha3 + #1060, #127
  static Batalha3 + #1061, #127
  static Batalha3 + #1062, #52
  static Batalha3 + #1063, #127
  static Batalha3 + #1064, #45
  static Batalha3 + #1065, #127
  static Batalha3 + #1066, #86
  static Batalha3 + #1067, #79
  static Batalha3 + #1068, #76
  static Batalha3 + #1069, #84
  static Batalha3 + #1070, #65
  static Batalha3 + #1071, #82
  static Batalha3 + #1072, #127
  static Batalha3 + #1073, #127
  static Batalha3 + #1074, #127
  static Batalha3 + #1075, #127
  static Batalha3 + #1076, #127
  static Batalha3 + #1077, #127
  static Batalha3 + #1078, #127
  static Batalha3 + #1079, #127

  ;Linha 27
  static Batalha3 + #1080, #127
  static Batalha3 + #1081, #127
  static Batalha3 + #1082, #127
  static Batalha3 + #1083, #127
  static Batalha3 + #1084, #127
  static Batalha3 + #1085, #127
  static Batalha3 + #1086, #127
  static Batalha3 + #1087, #127
  static Batalha3 + #1088, #127
  static Batalha3 + #1089, #127
  static Batalha3 + #1090, #127
  static Batalha3 + #1091, #127
  static Batalha3 + #1092, #127
  static Batalha3 + #1093, #127
  static Batalha3 + #1094, #127
  static Batalha3 + #1095, #127
  static Batalha3 + #1096, #127
  static Batalha3 + #1097, #127
  static Batalha3 + #1098, #127
  static Batalha3 + #1099, #127
  static Batalha3 + #1100, #127
  static Batalha3 + #1101, #127
  static Batalha3 + #1102, #127
  static Batalha3 + #1103, #127
  static Batalha3 + #1104, #127
  static Batalha3 + #1105, #127
  static Batalha3 + #1106, #127
  static Batalha3 + #1107, #127
  static Batalha3 + #1108, #127
  static Batalha3 + #1109, #127
  static Batalha3 + #1110, #127
  static Batalha3 + #1111, #127
  static Batalha3 + #1112, #127
  static Batalha3 + #1113, #127
  static Batalha3 + #1114, #127
  static Batalha3 + #1115, #127
  static Batalha3 + #1116, #127
  static Batalha3 + #1117, #127
  static Batalha3 + #1118, #127
  static Batalha3 + #1119, #127

  ;Linha 28
  static Batalha3 + #1120, #127
  static Batalha3 + #1121, #127
  static Batalha3 + #1122, #127
  static Batalha3 + #1123, #127
  static Batalha3 + #1124, #127
  static Batalha3 + #1125, #127
  static Batalha3 + #1126, #127
  static Batalha3 + #1127, #127
  static Batalha3 + #1128, #127
  static Batalha3 + #1129, #127
  static Batalha3 + #1130, #127
  static Batalha3 + #1131, #127
  static Batalha3 + #1132, #127
  static Batalha3 + #1133, #127
  static Batalha3 + #1134, #127
  static Batalha3 + #1135, #127
  static Batalha3 + #1136, #127
  static Batalha3 + #1137, #127
  static Batalha3 + #1138, #127
  static Batalha3 + #1139, #127
  static Batalha3 + #1140, #127
  static Batalha3 + #1141, #127
  static Batalha3 + #1142, #127
  static Batalha3 + #1143, #127
  static Batalha3 + #1144, #127
  static Batalha3 + #1145, #127
  static Batalha3 + #1146, #127
  static Batalha3 + #1147, #127
  static Batalha3 + #1148, #127
  static Batalha3 + #1149, #127
  static Batalha3 + #1150, #127
  static Batalha3 + #1151, #127
  static Batalha3 + #1152, #127
  static Batalha3 + #1153, #127
  static Batalha3 + #1154, #127
  static Batalha3 + #1155, #127
  static Batalha3 + #1156, #127
  static Batalha3 + #1157, #127
  static Batalha3 + #1158, #127
  static Batalha3 + #1159, #127

  ;Linha 29
  static Batalha3 + #1160, #127
  static Batalha3 + #1161, #127
  static Batalha3 + #1162, #127
  static Batalha3 + #1163, #127
  static Batalha3 + #1164, #127
  static Batalha3 + #1165, #127
  static Batalha3 + #1166, #127
  static Batalha3 + #1167, #127
  static Batalha3 + #1168, #127
  static Batalha3 + #1169, #127
  static Batalha3 + #1170, #127
  static Batalha3 + #1171, #127
  static Batalha3 + #1172, #127
  static Batalha3 + #1173, #127
  static Batalha3 + #1174, #127
  static Batalha3 + #1175, #127
  static Batalha3 + #1176, #127
  static Batalha3 + #1177, #127
  static Batalha3 + #1178, #127
  static Batalha3 + #1179, #127
  static Batalha3 + #1180, #127
  static Batalha3 + #1181, #127
  static Batalha3 + #1182, #127
  static Batalha3 + #1183, #127
  static Batalha3 + #1184, #127
  static Batalha3 + #1185, #127
  static Batalha3 + #1186, #127
  static Batalha3 + #1187, #127
  static Batalha3 + #1188, #127
  static Batalha3 + #1189, #127
  static Batalha3 + #1190, #127
  static Batalha3 + #1191, #127
  static Batalha3 + #1192, #127
  static Batalha3 + #1193, #127
  static Batalha3 + #1194, #127
  static Batalha3 + #1195, #127
  static Batalha3 + #1196, #127
  static Batalha3 + #1197, #127
  static Batalha3 + #1198, #127
  static Batalha3 + #1199, #127

printBatalha3Screen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #Batalha3
  loadn R1, #0
  loadn R2, #1200

  printBatalha3ScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printBatalha3ScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

SalvadorenhoPosition : var #1
    static SalvadorenhoPosition + #0, #20

Salvadorenho : var #90
  static Salvadorenho + #0, #1284 ; 
  static Salvadorenho + #1, #1284 ; 
  static Salvadorenho + #2, #1284 ; 
  static Salvadorenho + #3, #1284 ; 
  ;37  espacos para o proximo caractere
  static Salvadorenho + #4, #1282 ; 
  static Salvadorenho + #5, #3626 ; *
  static Salvadorenho + #6, #3626 ; *
  static Salvadorenho + #7, #1286 ; 
  ;37  espacos para o proximo caractere
  static Salvadorenho + #8, #1282 ; 
  static Salvadorenho + #9, #3626 ; *
  static Salvadorenho + #10, #3626 ; *
  static Salvadorenho + #11, #1286 ; 
  ;36  espacos para o proximo caractere
  static Salvadorenho + #12, #1280 ; 
  static Salvadorenho + #13, #1280 ; 
  static Salvadorenho + #14, #1280 ; 
  static Salvadorenho + #15, #1280 ; 
  static Salvadorenho + #16, #1280 ; 
  static Salvadorenho + #17, #1280 ; 
  ;36  espacos para o proximo caractere
  static Salvadorenho + #18, #1 ; 
  static Salvadorenho + #19, #0 ; 
  static Salvadorenho + #20, #0 ; 
  static Salvadorenho + #21, #7 ; 
  ;37  espacos para o proximo caractere
  static Salvadorenho + #22, #2 ; 
  static Salvadorenho + #23, #3080 ; 
  static Salvadorenho + #24, #3080 ; 
  static Salvadorenho + #25, #6 ; 
  ;37  espacos para o proximo caractere
  static Salvadorenho + #26, #2 ; 
  static Salvadorenho + #27, #2820 ; 
  static Salvadorenho + #28, #2309 ; 
  static Salvadorenho + #29, #6 ; 
  ;4  espacos para o proximo caractere
  static Salvadorenho + #30, #2858 ; *
  static Salvadorenho + #31, #2858 ; *
  ;32  espacos para o proximo caractere
  static Salvadorenho + #32, #3 ; 
  static Salvadorenho + #33, #4 ; 
  static Salvadorenho + #34, #4 ; 
  static Salvadorenho + #35, #5 ; 
  ;4  espacos para o proximo caractere
  static Salvadorenho + #36, #2858 ; *
  static Salvadorenho + #37, #2858 ; *
  ;25  espacos para o proximo caractere
  static Salvadorenho + #38, #2080 ; SPACE
  static Salvadorenho + #39, #2080 ; SPACE
  ;7  espacos para o proximo caractere
  static Salvadorenho + #40, #1538 ; 
  static Salvadorenho + #41, #1542 ; 
  ;5  espacos para o proximo caractere
  static Salvadorenho + #42, #2858 ; *
  static Salvadorenho + #43, #2858 ; *
  ;26  espacos para o proximo caractere
  static Salvadorenho + #44, #2059 ; 
  static Salvadorenho + #45, #2057 ; 
  static Salvadorenho + #46, #4 ; 
  static Salvadorenho + #47, #4 ; 
  static Salvadorenho + #48, #1542 ; 
  static Salvadorenho + #49, #1536 ; 
  static Salvadorenho + #50, #1536 ; 
  static Salvadorenho + #51, #2347 ; +
  static Salvadorenho + #52, #2347 ; +
  static Salvadorenho + #53, #1536 ; 
  static Salvadorenho + #54, #1536 ; 
  static Salvadorenho + #55, #1538 ; 
  static Salvadorenho + #56, #2858 ; *
  static Salvadorenho + #57, #2858 ; *
  static Salvadorenho + #58, #2858 ; *
  ;26  espacos para o proximo caractere
  static Salvadorenho + #59, #2060 ; 
  static Salvadorenho + #60, #2058 ; 
  static Salvadorenho + #61, #0 ; 
  static Salvadorenho + #62, #0 ; 
  static Salvadorenho + #63, #1542 ; 
  static Salvadorenho + #64, #1540 ; 
  static Salvadorenho + #65, #1540 ; 
  static Salvadorenho + #66, #2347 ; +
  static Salvadorenho + #67, #2347 ; +
  static Salvadorenho + #68, #1540 ; 
  static Salvadorenho + #69, #1540 ; 
  static Salvadorenho + #70, #1538 ; 
  static Salvadorenho + #71, #2858 ; *
  static Salvadorenho + #72, #2858 ; *
  ;26  espacos para o proximo caractere
  static Salvadorenho + #73, #2080 ; SPACE
  static Salvadorenho + #74, #2080 ; SPACE
  ;7  espacos para o proximo caractere
  static Salvadorenho + #75, #1538 ; 
  static Salvadorenho + #76, #2350 ; .
  static Salvadorenho + #77, #1538 ; 
  ;38  espacos para o proximo caractere
  static Salvadorenho + #78, #1538 ; 
  static Salvadorenho + #79, #2350 ; .
  static Salvadorenho + #80, #1538 ; 
  ;38  espacos para o proximo caractere
  static Salvadorenho + #81, #1538 ; 
  static Salvadorenho + #82, #2350 ; .
  static Salvadorenho + #83, #1538 ; 
  ;38  espacos para o proximo caractere
  static Salvadorenho + #84, #1536 ; 
  static Salvadorenho + #85, #1536 ; 
  ;39  espacos para o proximo caractere
  static Salvadorenho + #86, #2061 ; 
  static Salvadorenho + #87, #2061 ; 
  ;39  espacos para o proximo caractere
  static Salvadorenho + #88, #2061 ; 
  static Salvadorenho + #89, #2061 ; 

SalvadorenhoGaps : var #90
  static SalvadorenhoGaps + #0, #0
  static SalvadorenhoGaps + #1, #0
  static SalvadorenhoGaps + #2, #0
  static SalvadorenhoGaps + #3, #0
  static SalvadorenhoGaps + #4, #36
  static SalvadorenhoGaps + #5, #0
  static SalvadorenhoGaps + #6, #0
  static SalvadorenhoGaps + #7, #0
  static SalvadorenhoGaps + #8, #36
  static SalvadorenhoGaps + #9, #0
  static SalvadorenhoGaps + #10, #0
  static SalvadorenhoGaps + #11, #0
  static SalvadorenhoGaps + #12, #35
  static SalvadorenhoGaps + #13, #0
  static SalvadorenhoGaps + #14, #0
  static SalvadorenhoGaps + #15, #0
  static SalvadorenhoGaps + #16, #0
  static SalvadorenhoGaps + #17, #0
  static SalvadorenhoGaps + #18, #35
  static SalvadorenhoGaps + #19, #0
  static SalvadorenhoGaps + #20, #0
  static SalvadorenhoGaps + #21, #0
  static SalvadorenhoGaps + #22, #36
  static SalvadorenhoGaps + #23, #0
  static SalvadorenhoGaps + #24, #0
  static SalvadorenhoGaps + #25, #0
  static SalvadorenhoGaps + #26, #36
  static SalvadorenhoGaps + #27, #0
  static SalvadorenhoGaps + #28, #0
  static SalvadorenhoGaps + #29, #0
  static SalvadorenhoGaps + #30, #3
  static SalvadorenhoGaps + #31, #0
  static SalvadorenhoGaps + #32, #31
  static SalvadorenhoGaps + #33, #0
  static SalvadorenhoGaps + #34, #0
  static SalvadorenhoGaps + #35, #0
  static SalvadorenhoGaps + #36, #3
  static SalvadorenhoGaps + #37, #0
  static SalvadorenhoGaps + #38, #24
  static SalvadorenhoGaps + #39, #0
  static SalvadorenhoGaps + #40, #6
  static SalvadorenhoGaps + #41, #0
  static SalvadorenhoGaps + #42, #4
  static SalvadorenhoGaps + #43, #0
  static SalvadorenhoGaps + #44, #25
  static SalvadorenhoGaps + #45, #0
  static SalvadorenhoGaps + #46, #0
  static SalvadorenhoGaps + #47, #0
  static SalvadorenhoGaps + #48, #0
  static SalvadorenhoGaps + #49, #0
  static SalvadorenhoGaps + #50, #0
  static SalvadorenhoGaps + #51, #0
  static SalvadorenhoGaps + #52, #0
  static SalvadorenhoGaps + #53, #0
  static SalvadorenhoGaps + #54, #0
  static SalvadorenhoGaps + #55, #0
  static SalvadorenhoGaps + #56, #0
  static SalvadorenhoGaps + #57, #0
  static SalvadorenhoGaps + #58, #0
  static SalvadorenhoGaps + #59, #25
  static SalvadorenhoGaps + #60, #0
  static SalvadorenhoGaps + #61, #0
  static SalvadorenhoGaps + #62, #0
  static SalvadorenhoGaps + #63, #0
  static SalvadorenhoGaps + #64, #0
  static SalvadorenhoGaps + #65, #0
  static SalvadorenhoGaps + #66, #0
  static SalvadorenhoGaps + #67, #0
  static SalvadorenhoGaps + #68, #0
  static SalvadorenhoGaps + #69, #0
  static SalvadorenhoGaps + #70, #0
  static SalvadorenhoGaps + #71, #0
  static SalvadorenhoGaps + #72, #0
  static SalvadorenhoGaps + #73, #25
  static SalvadorenhoGaps + #74, #0
  static SalvadorenhoGaps + #75, #6
  static SalvadorenhoGaps + #76, #0
  static SalvadorenhoGaps + #77, #0
  static SalvadorenhoGaps + #78, #37
  static SalvadorenhoGaps + #79, #0
  static SalvadorenhoGaps + #80, #0
  static SalvadorenhoGaps + #81, #37
  static SalvadorenhoGaps + #82, #0
  static SalvadorenhoGaps + #83, #0
  static SalvadorenhoGaps + #84, #37
  static SalvadorenhoGaps + #85, #0
  static SalvadorenhoGaps + #86, #38
  static SalvadorenhoGaps + #87, #0
  static SalvadorenhoGaps + #88, #38
  static SalvadorenhoGaps + #89, #0

printSalvadorenho:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #Salvadorenho
  loadn R1, #SalvadorenhoGaps
  load R2, SalvadorenhoPosition
  loadn R3, #90 ;tamanho Salvadorenho
  loadn R4, #0 ;incremetador

  printSalvadorenhoLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
     inc R4
     cmp R3, R4
    jne printSalvadorenhoLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarSalvadorenho:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R0, #3967
  loadn R1, #SalvadorenhoGaps
  load R2, SalvadorenhoPosition
  loadn R3, #90 ;tamanho Salvadorenho
  loadn R4, #0 ;incremetador

  apagarSalvadorenhoLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarSalvadorenhoLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts
TelaInicial : var #1200
  ;Linha 0
  static TelaInicial + #0, #3967
  static TelaInicial + #1, #3967
  static TelaInicial + #2, #3967
  static TelaInicial + #3, #3967
  static TelaInicial + #4, #3967
  static TelaInicial + #5, #3967
  static TelaInicial + #6, #3967
  static TelaInicial + #7, #3967
  static TelaInicial + #8, #3967
  static TelaInicial + #9, #3967
  static TelaInicial + #10, #3967
  static TelaInicial + #11, #3967
  static TelaInicial + #12, #3967
  static TelaInicial + #13, #3967
  static TelaInicial + #14, #3967
  static TelaInicial + #15, #3967
  static TelaInicial + #16, #3967
  static TelaInicial + #17, #3967
  static TelaInicial + #18, #3967
  static TelaInicial + #19, #3967
  static TelaInicial + #20, #3967
  static TelaInicial + #21, #3967
  static TelaInicial + #22, #3967
  static TelaInicial + #23, #3967
  static TelaInicial + #24, #3967
  static TelaInicial + #25, #3967
  static TelaInicial + #26, #3967
  static TelaInicial + #27, #3967
  static TelaInicial + #28, #3967
  static TelaInicial + #29, #3967
  static TelaInicial + #30, #3967
  static TelaInicial + #31, #3967
  static TelaInicial + #32, #3967
  static TelaInicial + #33, #3967
  static TelaInicial + #34, #3967
  static TelaInicial + #35, #3967
  static TelaInicial + #36, #3967
  static TelaInicial + #37, #3967
  static TelaInicial + #38, #3967
  static TelaInicial + #39, #3967

  ;Linha 1
  static TelaInicial + #40, #3967
  static TelaInicial + #41, #3967
  static TelaInicial + #42, #3967
  static TelaInicial + #43, #3967
  static TelaInicial + #44, #3967
  static TelaInicial + #45, #3967
  static TelaInicial + #46, #3967
  static TelaInicial + #47, #3967
  static TelaInicial + #48, #3967
  static TelaInicial + #49, #3967
  static TelaInicial + #50, #3967
  static TelaInicial + #51, #3967
  static TelaInicial + #52, #3967
  static TelaInicial + #53, #3967
  static TelaInicial + #54, #3967
  static TelaInicial + #55, #3967
  static TelaInicial + #56, #3967
  static TelaInicial + #57, #3967
  static TelaInicial + #58, #3967
  static TelaInicial + #59, #3083
  static TelaInicial + #60, #3081
  static TelaInicial + #61, #3967
  static TelaInicial + #62, #3967
  static TelaInicial + #63, #3967
  static TelaInicial + #64, #3967
  static TelaInicial + #65, #3967
  static TelaInicial + #66, #3967
  static TelaInicial + #67, #3967
  static TelaInicial + #68, #3967
  static TelaInicial + #69, #3967
  static TelaInicial + #70, #3967
  static TelaInicial + #71, #3967
  static TelaInicial + #72, #3967
  static TelaInicial + #73, #3967
  static TelaInicial + #74, #3967
  static TelaInicial + #75, #3967
  static TelaInicial + #76, #3967
  static TelaInicial + #77, #3967
  static TelaInicial + #78, #3967
  static TelaInicial + #79, #3967

  ;Linha 2
  static TelaInicial + #80, #3967
  static TelaInicial + #81, #3967
  static TelaInicial + #82, #3967
  static TelaInicial + #83, #3967
  static TelaInicial + #84, #3967
  static TelaInicial + #85, #3967
  static TelaInicial + #86, #3967
  static TelaInicial + #87, #3967
  static TelaInicial + #88, #3967
  static TelaInicial + #89, #3967
  static TelaInicial + #90, #3967
  static TelaInicial + #91, #3967
  static TelaInicial + #92, #3967
  static TelaInicial + #93, #3967
  static TelaInicial + #94, #3967
  static TelaInicial + #95, #3967
  static TelaInicial + #96, #3967
  static TelaInicial + #97, #3967
  static TelaInicial + #98, #3083
  static TelaInicial + #99, #3967
  static TelaInicial + #100, #3967
  static TelaInicial + #101, #3081
  static TelaInicial + #102, #3967
  static TelaInicial + #103, #3967
  static TelaInicial + #104, #3967
  static TelaInicial + #105, #3967
  static TelaInicial + #106, #3967
  static TelaInicial + #107, #3967
  static TelaInicial + #108, #3967
  static TelaInicial + #109, #3967
  static TelaInicial + #110, #3967
  static TelaInicial + #111, #3967
  static TelaInicial + #112, #3967
  static TelaInicial + #113, #3967
  static TelaInicial + #114, #3967
  static TelaInicial + #115, #3967
  static TelaInicial + #116, #3967
  static TelaInicial + #117, #3967
  static TelaInicial + #118, #3967
  static TelaInicial + #119, #3967

  ;Linha 3
  static TelaInicial + #120, #3967
  static TelaInicial + #121, #3967
  static TelaInicial + #122, #3967
  static TelaInicial + #123, #3967
  static TelaInicial + #124, #3967
  static TelaInicial + #125, #3967
  static TelaInicial + #126, #3967
  static TelaInicial + #127, #3967
  static TelaInicial + #128, #3967
  static TelaInicial + #129, #3967
  static TelaInicial + #130, #3967
  static TelaInicial + #131, #3967
  static TelaInicial + #132, #3967
  static TelaInicial + #133, #3967
  static TelaInicial + #134, #3967
  static TelaInicial + #135, #3967
  static TelaInicial + #136, #3967
  static TelaInicial + #137, #3083
  static TelaInicial + #138, #3967
  static TelaInicial + #139, #3967
  static TelaInicial + #140, #3967
  static TelaInicial + #141, #3967
  static TelaInicial + #142, #3081
  static TelaInicial + #143, #3967
  static TelaInicial + #144, #3967
  static TelaInicial + #145, #3967
  static TelaInicial + #146, #3967
  static TelaInicial + #147, #3967
  static TelaInicial + #148, #3967
  static TelaInicial + #149, #3967
  static TelaInicial + #150, #3967
  static TelaInicial + #151, #3967
  static TelaInicial + #152, #3967
  static TelaInicial + #153, #3967
  static TelaInicial + #154, #3967
  static TelaInicial + #155, #3967
  static TelaInicial + #156, #3967
  static TelaInicial + #157, #3967
  static TelaInicial + #158, #3967
  static TelaInicial + #159, #3967

  ;Linha 4
  static TelaInicial + #160, #3967
  static TelaInicial + #161, #3967
  static TelaInicial + #162, #3967
  static TelaInicial + #163, #3967
  static TelaInicial + #164, #3967
  static TelaInicial + #165, #3967
  static TelaInicial + #166, #3967
  static TelaInicial + #167, #3967
  static TelaInicial + #168, #3967
  static TelaInicial + #169, #3967
  static TelaInicial + #170, #3967
  static TelaInicial + #171, #3967
  static TelaInicial + #172, #3967
  static TelaInicial + #173, #3967
  static TelaInicial + #174, #3967
  static TelaInicial + #175, #3967
  static TelaInicial + #176, #3967
  static TelaInicial + #177, #3084
  static TelaInicial + #178, #3967
  static TelaInicial + #179, #3967
  static TelaInicial + #180, #3967
  static TelaInicial + #181, #3967
  static TelaInicial + #182, #3082
  static TelaInicial + #183, #3967
  static TelaInicial + #184, #3967
  static TelaInicial + #185, #3967
  static TelaInicial + #186, #3967
  static TelaInicial + #187, #3967
  static TelaInicial + #188, #3967
  static TelaInicial + #189, #3967
  static TelaInicial + #190, #3967
  static TelaInicial + #191, #3967
  static TelaInicial + #192, #3967
  static TelaInicial + #193, #3967
  static TelaInicial + #194, #3967
  static TelaInicial + #195, #3967
  static TelaInicial + #196, #3967
  static TelaInicial + #197, #3967
  static TelaInicial + #198, #3967
  static TelaInicial + #199, #3967

  ;Linha 5
  static TelaInicial + #200, #3967
  static TelaInicial + #201, #3967
  static TelaInicial + #202, #3967
  static TelaInicial + #203, #3967
  static TelaInicial + #204, #3967
  static TelaInicial + #205, #3967
  static TelaInicial + #206, #3967
  static TelaInicial + #207, #3967
  static TelaInicial + #208, #3967
  static TelaInicial + #209, #3967
  static TelaInicial + #210, #3967
  static TelaInicial + #211, #3967
  static TelaInicial + #212, #3967
  static TelaInicial + #213, #3967
  static TelaInicial + #214, #3967
  static TelaInicial + #215, #3967
  static TelaInicial + #216, #3967
  static TelaInicial + #217, #3967
  static TelaInicial + #218, #3084
  static TelaInicial + #219, #3967
  static TelaInicial + #220, #3967
  static TelaInicial + #221, #3082
  static TelaInicial + #222, #3967
  static TelaInicial + #223, #3967
  static TelaInicial + #224, #3967
  static TelaInicial + #225, #3967
  static TelaInicial + #226, #3967
  static TelaInicial + #227, #3967
  static TelaInicial + #228, #3967
  static TelaInicial + #229, #3967
  static TelaInicial + #230, #3967
  static TelaInicial + #231, #3967
  static TelaInicial + #232, #3967
  static TelaInicial + #233, #3967
  static TelaInicial + #234, #3967
  static TelaInicial + #235, #3967
  static TelaInicial + #236, #3967
  static TelaInicial + #237, #3967
  static TelaInicial + #238, #3967
  static TelaInicial + #239, #3967

  ;Linha 6
  static TelaInicial + #240, #3967
  static TelaInicial + #241, #3967
  static TelaInicial + #242, #3967
  static TelaInicial + #243, #3967
  static TelaInicial + #244, #3967
  static TelaInicial + #245, #3967
  static TelaInicial + #246, #3967
  static TelaInicial + #247, #3967
  static TelaInicial + #248, #3967
  static TelaInicial + #249, #3967
  static TelaInicial + #250, #3967
  static TelaInicial + #251, #3967
  static TelaInicial + #252, #3967
  static TelaInicial + #253, #3967
  static TelaInicial + #254, #3967
  static TelaInicial + #255, #3967
  static TelaInicial + #256, #3967
  static TelaInicial + #257, #3967
  static TelaInicial + #258, #3967
  static TelaInicial + #259, #3084
  static TelaInicial + #260, #3082
  static TelaInicial + #261, #3967
  static TelaInicial + #262, #3967
  static TelaInicial + #263, #3967
  static TelaInicial + #264, #3967
  static TelaInicial + #265, #3967
  static TelaInicial + #266, #3967
  static TelaInicial + #267, #3967
  static TelaInicial + #268, #3967
  static TelaInicial + #269, #3967
  static TelaInicial + #270, #3967
  static TelaInicial + #271, #127
  static TelaInicial + #272, #127
  static TelaInicial + #273, #3967
  static TelaInicial + #274, #3967
  static TelaInicial + #275, #3967
  static TelaInicial + #276, #3967
  static TelaInicial + #277, #3967
  static TelaInicial + #278, #3967
  static TelaInicial + #279, #3967

  ;Linha 7
  static TelaInicial + #280, #3967
  static TelaInicial + #281, #3967
  static TelaInicial + #282, #3967
  static TelaInicial + #283, #3967
  static TelaInicial + #284, #3967
  static TelaInicial + #285, #3967
  static TelaInicial + #286, #3967
  static TelaInicial + #287, #3967
  static TelaInicial + #288, #3967
  static TelaInicial + #289, #3967
  static TelaInicial + #290, #3967
  static TelaInicial + #291, #3967
  static TelaInicial + #292, #3967
  static TelaInicial + #293, #3967
  static TelaInicial + #294, #3967
  static TelaInicial + #295, #3967
  static TelaInicial + #296, #3967
  static TelaInicial + #297, #3967
  static TelaInicial + #298, #3967
  static TelaInicial + #299, #3967
  static TelaInicial + #300, #3967
  static TelaInicial + #301, #3967
  static TelaInicial + #302, #3967
  static TelaInicial + #303, #3967
  static TelaInicial + #304, #3967
  static TelaInicial + #305, #3967
  static TelaInicial + #306, #3967
  static TelaInicial + #307, #3967
  static TelaInicial + #308, #3967
  static TelaInicial + #309, #3967
  static TelaInicial + #310, #3967
  static TelaInicial + #311, #3967
  static TelaInicial + #312, #127
  static TelaInicial + #313, #3967
  static TelaInicial + #314, #3967
  static TelaInicial + #315, #3967
  static TelaInicial + #316, #3967
  static TelaInicial + #317, #3967
  static TelaInicial + #318, #3967
  static TelaInicial + #319, #3967

  ;Linha 8
  static TelaInicial + #320, #3967
  static TelaInicial + #321, #3967
  static TelaInicial + #322, #3967
  static TelaInicial + #323, #3967
  static TelaInicial + #324, #3967
  static TelaInicial + #325, #3967
  static TelaInicial + #326, #3967
  static TelaInicial + #327, #3967
  static TelaInicial + #328, #3967
  static TelaInicial + #329, #3967
  static TelaInicial + #330, #3967
  static TelaInicial + #331, #3967
  static TelaInicial + #332, #3967
  static TelaInicial + #333, #3967
  static TelaInicial + #334, #3967
  static TelaInicial + #335, #3967
  static TelaInicial + #336, #3967
  static TelaInicial + #337, #3967
  static TelaInicial + #338, #3967
  static TelaInicial + #339, #3967
  static TelaInicial + #340, #3967
  static TelaInicial + #341, #3967
  static TelaInicial + #342, #3967
  static TelaInicial + #343, #3967
  static TelaInicial + #344, #3967
  static TelaInicial + #345, #3967
  static TelaInicial + #346, #3967
  static TelaInicial + #347, #3967
  static TelaInicial + #348, #3967
  static TelaInicial + #349, #3967
  static TelaInicial + #350, #3967
  static TelaInicial + #351, #3967
  static TelaInicial + #352, #3967
  static TelaInicial + #353, #3967
  static TelaInicial + #354, #3967
  static TelaInicial + #355, #3967
  static TelaInicial + #356, #3967
  static TelaInicial + #357, #3967
  static TelaInicial + #358, #3967
  static TelaInicial + #359, #3967

  ;Linha 9
  static TelaInicial + #360, #3967
  static TelaInicial + #361, #3967
  static TelaInicial + #362, #3967
  static TelaInicial + #363, #3967
  static TelaInicial + #364, #3967
  static TelaInicial + #365, #3967
  static TelaInicial + #366, #3967
  static TelaInicial + #367, #3967
  static TelaInicial + #368, #3967
  static TelaInicial + #369, #3967
  static TelaInicial + #370, #3967
  static TelaInicial + #371, #3967
  static TelaInicial + #372, #3967
  static TelaInicial + #373, #3967
  static TelaInicial + #374, #3967
  static TelaInicial + #375, #3967
  static TelaInicial + #376, #3967
  static TelaInicial + #377, #3967
  static TelaInicial + #378, #3967
  static TelaInicial + #379, #3967
  static TelaInicial + #380, #3967
  static TelaInicial + #381, #3967
  static TelaInicial + #382, #3967
  static TelaInicial + #383, #3967
  static TelaInicial + #384, #3967
  static TelaInicial + #385, #3967
  static TelaInicial + #386, #3967
  static TelaInicial + #387, #3967
  static TelaInicial + #388, #3967
  static TelaInicial + #389, #3967
  static TelaInicial + #390, #3967
  static TelaInicial + #391, #3967
  static TelaInicial + #392, #3967
  static TelaInicial + #393, #3967
  static TelaInicial + #394, #3967
  static TelaInicial + #395, #3967
  static TelaInicial + #396, #3967
  static TelaInicial + #397, #3967
  static TelaInicial + #398, #3967
  static TelaInicial + #399, #3967

  ;Linha 10
  static TelaInicial + #400, #3967
  static TelaInicial + #401, #3967
  static TelaInicial + #402, #3967
  static TelaInicial + #403, #3967
  static TelaInicial + #404, #3967
  static TelaInicial + #405, #3967
  static TelaInicial + #406, #3967
  static TelaInicial + #407, #3967
  static TelaInicial + #408, #3967
  static TelaInicial + #409, #3967
  static TelaInicial + #410, #3967
  static TelaInicial + #411, #3967
  static TelaInicial + #412, #3967
  static TelaInicial + #413, #3967
  static TelaInicial + #414, #3967
  static TelaInicial + #415, #3967
  static TelaInicial + #416, #3967
  static TelaInicial + #417, #3967
  static TelaInicial + #418, #3967
  static TelaInicial + #419, #3967
  static TelaInicial + #420, #3967
  static TelaInicial + #421, #3967
  static TelaInicial + #422, #3967
  static TelaInicial + #423, #3967
  static TelaInicial + #424, #3967
  static TelaInicial + #425, #3967
  static TelaInicial + #426, #3967
  static TelaInicial + #427, #3967
  static TelaInicial + #428, #3967
  static TelaInicial + #429, #3967
  static TelaInicial + #430, #3967
  static TelaInicial + #431, #3967
  static TelaInicial + #432, #3967
  static TelaInicial + #433, #3967
  static TelaInicial + #434, #3967
  static TelaInicial + #435, #3967
  static TelaInicial + #436, #3967
  static TelaInicial + #437, #3967
  static TelaInicial + #438, #3967
  static TelaInicial + #439, #3967

  ;Linha 11
  static TelaInicial + #440, #127
  static TelaInicial + #441, #127
  static TelaInicial + #442, #127
  static TelaInicial + #443, #127
  static TelaInicial + #444, #127
  static TelaInicial + #445, #127
  static TelaInicial + #446, #80
  static TelaInicial + #447, #114
  static TelaInicial + #448, #101
  static TelaInicial + #449, #115
  static TelaInicial + #450, #115
  static TelaInicial + #451, #105
  static TelaInicial + #452, #111
  static TelaInicial + #453, #110
  static TelaInicial + #454, #101
  static TelaInicial + #455, #127
  static TelaInicial + #456, #101
  static TelaInicial + #457, #115
  static TelaInicial + #458, #112
  static TelaInicial + #459, #97
  static TelaInicial + #460, #99
  static TelaInicial + #461, #111
  static TelaInicial + #462, #127
  static TelaInicial + #463, #112
  static TelaInicial + #464, #97
  static TelaInicial + #465, #114
  static TelaInicial + #466, #97
  static TelaInicial + #467, #127
  static TelaInicial + #468, #105
  static TelaInicial + #469, #110
  static TelaInicial + #470, #105
  static TelaInicial + #471, #99
  static TelaInicial + #472, #105
  static TelaInicial + #473, #97
  static TelaInicial + #474, #114
  static TelaInicial + #475, #3967
  static TelaInicial + #476, #3967
  static TelaInicial + #477, #3967
  static TelaInicial + #478, #3967
  static TelaInicial + #479, #3967

  ;Linha 12
  static TelaInicial + #480, #3967
  static TelaInicial + #481, #3967
  static TelaInicial + #482, #3967
  static TelaInicial + #483, #3967
  static TelaInicial + #484, #3967
  static TelaInicial + #485, #3967
  static TelaInicial + #486, #3967
  static TelaInicial + #487, #3967
  static TelaInicial + #488, #3967
  static TelaInicial + #489, #3967
  static TelaInicial + #490, #3967
  static TelaInicial + #491, #3967
  static TelaInicial + #492, #3967
  static TelaInicial + #493, #3967
  static TelaInicial + #494, #3967
  static TelaInicial + #495, #3967
  static TelaInicial + #496, #3967
  static TelaInicial + #497, #3967
  static TelaInicial + #498, #3967
  static TelaInicial + #499, #3967
  static TelaInicial + #500, #3967
  static TelaInicial + #501, #3967
  static TelaInicial + #502, #3967
  static TelaInicial + #503, #3967
  static TelaInicial + #504, #3967
  static TelaInicial + #505, #3967
  static TelaInicial + #506, #3967
  static TelaInicial + #507, #3967
  static TelaInicial + #508, #3967
  static TelaInicial + #509, #3967
  static TelaInicial + #510, #3967
  static TelaInicial + #511, #3967
  static TelaInicial + #512, #3967
  static TelaInicial + #513, #3967
  static TelaInicial + #514, #3967
  static TelaInicial + #515, #3967
  static TelaInicial + #516, #3967
  static TelaInicial + #517, #3967
  static TelaInicial + #518, #3967
  static TelaInicial + #519, #3967

  ;Linha 13
  static TelaInicial + #520, #3967
  static TelaInicial + #521, #127
  static TelaInicial + #522, #3967
  static TelaInicial + #523, #3967
  static TelaInicial + #524, #3967
  static TelaInicial + #525, #3967
  static TelaInicial + #526, #3967
  static TelaInicial + #527, #3967
  static TelaInicial + #528, #3967
  static TelaInicial + #529, #3967
  static TelaInicial + #530, #3967
  static TelaInicial + #531, #3967
  static TelaInicial + #532, #3967
  static TelaInicial + #533, #3967
  static TelaInicial + #534, #3967
  static TelaInicial + #535, #3967
  static TelaInicial + #536, #3967
  static TelaInicial + #537, #3967
  static TelaInicial + #538, #3967
  static TelaInicial + #539, #3967
  static TelaInicial + #540, #3967
  static TelaInicial + #541, #3967
  static TelaInicial + #542, #3967
  static TelaInicial + #543, #3967
  static TelaInicial + #544, #3967
  static TelaInicial + #545, #3967
  static TelaInicial + #546, #3967
  static TelaInicial + #547, #3967
  static TelaInicial + #548, #3967
  static TelaInicial + #549, #3967
  static TelaInicial + #550, #3967
  static TelaInicial + #551, #3967
  static TelaInicial + #552, #3967
  static TelaInicial + #553, #3967
  static TelaInicial + #554, #3967
  static TelaInicial + #555, #3967
  static TelaInicial + #556, #3967
  static TelaInicial + #557, #3967
  static TelaInicial + #558, #3967
  static TelaInicial + #559, #3967

  ;Linha 14
  static TelaInicial + #560, #3967
  static TelaInicial + #561, #3967
  static TelaInicial + #562, #3967
  static TelaInicial + #563, #3967
  static TelaInicial + #564, #3967
  static TelaInicial + #565, #3967
  static TelaInicial + #566, #3967
  static TelaInicial + #567, #3967
  static TelaInicial + #568, #3967
  static TelaInicial + #569, #127
  static TelaInicial + #570, #3967
  static TelaInicial + #571, #3967
  static TelaInicial + #572, #3967
  static TelaInicial + #573, #3967
  static TelaInicial + #574, #3967
  static TelaInicial + #575, #3967
  static TelaInicial + #576, #3967
  static TelaInicial + #577, #3967
  static TelaInicial + #578, #3967
  static TelaInicial + #579, #3967
  static TelaInicial + #580, #3967
  static TelaInicial + #581, #3967
  static TelaInicial + #582, #3967
  static TelaInicial + #583, #3967
  static TelaInicial + #584, #3967
  static TelaInicial + #585, #3967
  static TelaInicial + #586, #3967
  static TelaInicial + #587, #3967
  static TelaInicial + #588, #3967
  static TelaInicial + #589, #3967
  static TelaInicial + #590, #3967
  static TelaInicial + #591, #3967
  static TelaInicial + #592, #3967
  static TelaInicial + #593, #3967
  static TelaInicial + #594, #3967
  static TelaInicial + #595, #3967
  static TelaInicial + #596, #3967
  static TelaInicial + #597, #3967
  static TelaInicial + #598, #3967
  static TelaInicial + #599, #3967

  ;Linha 15
  static TelaInicial + #600, #3967
  static TelaInicial + #601, #3967
  static TelaInicial + #602, #3967
  static TelaInicial + #603, #3967
  static TelaInicial + #604, #3967
  static TelaInicial + #605, #3967
  static TelaInicial + #606, #3967
  static TelaInicial + #607, #3967
  static TelaInicial + #608, #3967
  static TelaInicial + #609, #127
  static TelaInicial + #610, #3967
  static TelaInicial + #611, #3967
  static TelaInicial + #612, #3967
  static TelaInicial + #613, #3967
  static TelaInicial + #614, #3967
  static TelaInicial + #615, #3967
  static TelaInicial + #616, #3967
  static TelaInicial + #617, #3967
  static TelaInicial + #618, #3967
  static TelaInicial + #619, #3967
  static TelaInicial + #620, #3967
  static TelaInicial + #621, #3967
  static TelaInicial + #622, #3967
  static TelaInicial + #623, #3967
  static TelaInicial + #624, #3967
  static TelaInicial + #625, #3967
  static TelaInicial + #626, #3967
  static TelaInicial + #627, #3967
  static TelaInicial + #628, #3967
  static TelaInicial + #629, #3967
  static TelaInicial + #630, #3967
  static TelaInicial + #631, #3967
  static TelaInicial + #632, #3967
  static TelaInicial + #633, #3967
  static TelaInicial + #634, #3967
  static TelaInicial + #635, #3967
  static TelaInicial + #636, #3967
  static TelaInicial + #637, #3967
  static TelaInicial + #638, #3967
  static TelaInicial + #639, #3967

  ;Linha 16
  static TelaInicial + #640, #3967
  static TelaInicial + #641, #3967
  static TelaInicial + #642, #3967
  static TelaInicial + #643, #3967
  static TelaInicial + #644, #3967
  static TelaInicial + #645, #3967
  static TelaInicial + #646, #3967
  static TelaInicial + #647, #3967
  static TelaInicial + #648, #3967
  static TelaInicial + #649, #3967
  static TelaInicial + #650, #3967
  static TelaInicial + #651, #3967
  static TelaInicial + #652, #127
  static TelaInicial + #653, #127
  static TelaInicial + #654, #127
  static TelaInicial + #655, #127
  static TelaInicial + #656, #3967
  static TelaInicial + #657, #3967
  static TelaInicial + #658, #3967
  static TelaInicial + #659, #3967
  static TelaInicial + #660, #3967
  static TelaInicial + #661, #3967
  static TelaInicial + #662, #3967
  static TelaInicial + #663, #3967
  static TelaInicial + #664, #3967
  static TelaInicial + #665, #3967
  static TelaInicial + #666, #3967
  static TelaInicial + #667, #3967
  static TelaInicial + #668, #3967
  static TelaInicial + #669, #3967
  static TelaInicial + #670, #3967
  static TelaInicial + #671, #3967
  static TelaInicial + #672, #3967
  static TelaInicial + #673, #3967
  static TelaInicial + #674, #3967
  static TelaInicial + #675, #3967
  static TelaInicial + #676, #3967
  static TelaInicial + #677, #3967
  static TelaInicial + #678, #3967
  static TelaInicial + #679, #3967

  ;Linha 17
  static TelaInicial + #680, #3967
  static TelaInicial + #681, #3967
  static TelaInicial + #682, #3967
  static TelaInicial + #683, #3967
  static TelaInicial + #684, #3967
  static TelaInicial + #685, #3967
  static TelaInicial + #686, #3967
  static TelaInicial + #687, #3967
  static TelaInicial + #688, #3967
  static TelaInicial + #689, #3967
  static TelaInicial + #690, #3967
  static TelaInicial + #691, #3967
  static TelaInicial + #692, #127
  static TelaInicial + #693, #127
  static TelaInicial + #694, #127
  static TelaInicial + #695, #127
  static TelaInicial + #696, #2343
  static TelaInicial + #697, #127
  static TelaInicial + #698, #127
  static TelaInicial + #699, #127
  static TelaInicial + #700, #127
  static TelaInicial + #701, #2910
  static TelaInicial + #702, #127
  static TelaInicial + #703, #3166
  static TelaInicial + #704, #3967
  static TelaInicial + #705, #3967
  static TelaInicial + #706, #3967
  static TelaInicial + #707, #3967
  static TelaInicial + #708, #3967
  static TelaInicial + #709, #3967
  static TelaInicial + #710, #3967
  static TelaInicial + #711, #3967
  static TelaInicial + #712, #3967
  static TelaInicial + #713, #3967
  static TelaInicial + #714, #3967
  static TelaInicial + #715, #3967
  static TelaInicial + #716, #3967
  static TelaInicial + #717, #3967
  static TelaInicial + #718, #3967
  static TelaInicial + #719, #3967

  ;Linha 18
  static TelaInicial + #720, #3967
  static TelaInicial + #721, #3967
  static TelaInicial + #722, #3967
  static TelaInicial + #723, #3967
  static TelaInicial + #724, #3967
  static TelaInicial + #725, #3967
  static TelaInicial + #726, #3967
  static TelaInicial + #727, #3967
  static TelaInicial + #728, #3967
  static TelaInicial + #729, #3967
  static TelaInicial + #730, #3967
  static TelaInicial + #731, #127
  static TelaInicial + #732, #127
  static TelaInicial + #733, #127
  static TelaInicial + #734, #127
  static TelaInicial + #735, #3967
  static TelaInicial + #736, #2373
  static TelaInicial + #737, #2418
  static TelaInicial + #738, #2418
  static TelaInicial + #739, #2405
  static TelaInicial + #740, #2896
  static TelaInicial + #741, #2917
  static TelaInicial + #742, #3143
  static TelaInicial + #743, #3173
  static TelaInicial + #744, #3967
  static TelaInicial + #745, #3967
  static TelaInicial + #746, #3967
  static TelaInicial + #747, #3967
  static TelaInicial + #748, #3967
  static TelaInicial + #749, #3967
  static TelaInicial + #750, #3967
  static TelaInicial + #751, #3967
  static TelaInicial + #752, #3967
  static TelaInicial + #753, #3967
  static TelaInicial + #754, #3967
  static TelaInicial + #755, #3967
  static TelaInicial + #756, #3967
  static TelaInicial + #757, #3967
  static TelaInicial + #758, #3967
  static TelaInicial + #759, #3967

  ;Linha 19
  static TelaInicial + #760, #3967
  static TelaInicial + #761, #3967
  static TelaInicial + #762, #3967
  static TelaInicial + #763, #3967
  static TelaInicial + #764, #3967
  static TelaInicial + #765, #3967
  static TelaInicial + #766, #3967
  static TelaInicial + #767, #3967
  static TelaInicial + #768, #3967
  static TelaInicial + #769, #3967
  static TelaInicial + #770, #3967
  static TelaInicial + #771, #127
  static TelaInicial + #772, #127
  static TelaInicial + #773, #127
  static TelaInicial + #774, #3967
  static TelaInicial + #775, #3967
  static TelaInicial + #776, #127
  static TelaInicial + #777, #3967
  static TelaInicial + #778, #127
  static TelaInicial + #779, #127
  static TelaInicial + #780, #3967
  static TelaInicial + #781, #127
  static TelaInicial + #782, #127
  static TelaInicial + #783, #127
  static TelaInicial + #784, #3967
  static TelaInicial + #785, #3967
  static TelaInicial + #786, #3967
  static TelaInicial + #787, #3967
  static TelaInicial + #788, #3967
  static TelaInicial + #789, #3967
  static TelaInicial + #790, #3967
  static TelaInicial + #791, #3967
  static TelaInicial + #792, #3967
  static TelaInicial + #793, #3967
  static TelaInicial + #794, #3967
  static TelaInicial + #795, #3967
  static TelaInicial + #796, #3967
  static TelaInicial + #797, #3967
  static TelaInicial + #798, #3967
  static TelaInicial + #799, #3967

  ;Linha 20
  static TelaInicial + #800, #3967
  static TelaInicial + #801, #3967
  static TelaInicial + #802, #3967
  static TelaInicial + #803, #127
  static TelaInicial + #804, #127
  static TelaInicial + #805, #127
  static TelaInicial + #806, #127
  static TelaInicial + #807, #127
  static TelaInicial + #808, #127
  static TelaInicial + #809, #3967
  static TelaInicial + #810, #3967
  static TelaInicial + #811, #127
  static TelaInicial + #812, #127
  static TelaInicial + #813, #127
  static TelaInicial + #814, #3967
  static TelaInicial + #815, #3967
  static TelaInicial + #816, #127
  static TelaInicial + #817, #127
  static TelaInicial + #818, #3967
  static TelaInicial + #819, #127
  static TelaInicial + #820, #3967
  static TelaInicial + #821, #127
  static TelaInicial + #822, #127
  static TelaInicial + #823, #127
  static TelaInicial + #824, #3967
  static TelaInicial + #825, #3967
  static TelaInicial + #826, #3967
  static TelaInicial + #827, #3967
  static TelaInicial + #828, #3967
  static TelaInicial + #829, #3967
  static TelaInicial + #830, #3967
  static TelaInicial + #831, #3967
  static TelaInicial + #832, #3967
  static TelaInicial + #833, #3967
  static TelaInicial + #834, #3967
  static TelaInicial + #835, #3967
  static TelaInicial + #836, #3967
  static TelaInicial + #837, #3967
  static TelaInicial + #838, #3967
  static TelaInicial + #839, #3967

  ;Linha 21
  static TelaInicial + #840, #3967
  static TelaInicial + #841, #3967
  static TelaInicial + #842, #3967
  static TelaInicial + #843, #127
  static TelaInicial + #844, #127
  static TelaInicial + #845, #127
  static TelaInicial + #846, #127
  static TelaInicial + #847, #127
  static TelaInicial + #848, #127
  static TelaInicial + #849, #3967
  static TelaInicial + #850, #127
  static TelaInicial + #851, #127
  static TelaInicial + #852, #127
  static TelaInicial + #853, #127
  static TelaInicial + #854, #127
  static TelaInicial + #855, #127
  static TelaInicial + #856, #127
  static TelaInicial + #857, #127
  static TelaInicial + #858, #127
  static TelaInicial + #859, #127
  static TelaInicial + #860, #127
  static TelaInicial + #861, #127
  static TelaInicial + #862, #127
  static TelaInicial + #863, #3967
  static TelaInicial + #864, #3967
  static TelaInicial + #865, #3967
  static TelaInicial + #866, #3967
  static TelaInicial + #867, #3967
  static TelaInicial + #868, #3967
  static TelaInicial + #869, #3967
  static TelaInicial + #870, #3967
  static TelaInicial + #871, #3967
  static TelaInicial + #872, #3967
  static TelaInicial + #873, #3967
  static TelaInicial + #874, #3967
  static TelaInicial + #875, #3967
  static TelaInicial + #876, #3967
  static TelaInicial + #877, #3967
  static TelaInicial + #878, #3967
  static TelaInicial + #879, #3967

  ;Linha 22
  static TelaInicial + #880, #3967
  static TelaInicial + #881, #3967
  static TelaInicial + #882, #3967
  static TelaInicial + #883, #127
  static TelaInicial + #884, #127
  static TelaInicial + #885, #127
  static TelaInicial + #886, #127
  static TelaInicial + #887, #127
  static TelaInicial + #888, #127
  static TelaInicial + #889, #3967
  static TelaInicial + #890, #127
  static TelaInicial + #891, #127
  static TelaInicial + #892, #127
  static TelaInicial + #893, #3967
  static TelaInicial + #894, #3967
  static TelaInicial + #895, #3967
  static TelaInicial + #896, #3967
  static TelaInicial + #897, #3967
  static TelaInicial + #898, #127
  static TelaInicial + #899, #3967
  static TelaInicial + #900, #3967
  static TelaInicial + #901, #3967
  static TelaInicial + #902, #3967
  static TelaInicial + #903, #3967
  static TelaInicial + #904, #3967
  static TelaInicial + #905, #3967
  static TelaInicial + #906, #3967
  static TelaInicial + #907, #3967
  static TelaInicial + #908, #3967
  static TelaInicial + #909, #3967
  static TelaInicial + #910, #3967
  static TelaInicial + #911, #3967
  static TelaInicial + #912, #3967
  static TelaInicial + #913, #3967
  static TelaInicial + #914, #3967
  static TelaInicial + #915, #3967
  static TelaInicial + #916, #3967
  static TelaInicial + #917, #3967
  static TelaInicial + #918, #3967
  static TelaInicial + #919, #3967

  ;Linha 23
  static TelaInicial + #920, #3967
  static TelaInicial + #921, #3967
  static TelaInicial + #922, #3967
  static TelaInicial + #923, #3967
  static TelaInicial + #924, #3967
  static TelaInicial + #925, #127
  static TelaInicial + #926, #127
  static TelaInicial + #927, #127
  static TelaInicial + #928, #127
  static TelaInicial + #929, #3967
  static TelaInicial + #930, #127
  static TelaInicial + #931, #127
  static TelaInicial + #932, #127
  static TelaInicial + #933, #127
  static TelaInicial + #934, #4
  static TelaInicial + #935, #4
  static TelaInicial + #936, #4
  static TelaInicial + #937, #4
  static TelaInicial + #938, #3967
  static TelaInicial + #939, #3967
  static TelaInicial + #940, #3967
  static TelaInicial + #941, #3967
  static TelaInicial + #942, #3967
  static TelaInicial + #943, #3967
  static TelaInicial + #944, #3967
  static TelaInicial + #945, #3967
  static TelaInicial + #946, #3967
  static TelaInicial + #947, #3967
  static TelaInicial + #948, #3967
  static TelaInicial + #949, #3967
  static TelaInicial + #950, #3967
  static TelaInicial + #951, #3967
  static TelaInicial + #952, #3967
  static TelaInicial + #953, #3967
  static TelaInicial + #954, #3967
  static TelaInicial + #955, #3967
  static TelaInicial + #956, #3967
  static TelaInicial + #957, #3967
  static TelaInicial + #958, #3967
  static TelaInicial + #959, #3967

  ;Linha 24
  static TelaInicial + #960, #3967
  static TelaInicial + #961, #3967
  static TelaInicial + #962, #3967
  static TelaInicial + #963, #3967
  static TelaInicial + #964, #3967
  static TelaInicial + #965, #127
  static TelaInicial + #966, #127
  static TelaInicial + #967, #3967
  static TelaInicial + #968, #127
  static TelaInicial + #969, #127
  static TelaInicial + #970, #127
  static TelaInicial + #971, #127
  static TelaInicial + #972, #127
  static TelaInicial + #973, #127
  static TelaInicial + #974, #2
  static TelaInicial + #975, #127
  static TelaInicial + #976, #2
  static TelaInicial + #977, #127
  static TelaInicial + #978, #1
  static TelaInicial + #979, #0
  static TelaInicial + #980, #0
  static TelaInicial + #981, #7
  static TelaInicial + #982, #1
  static TelaInicial + #983, #0
  static TelaInicial + #984, #0
  static TelaInicial + #985, #7
  static TelaInicial + #986, #3967
  static TelaInicial + #987, #3967
  static TelaInicial + #988, #3967
  static TelaInicial + #989, #3967
  static TelaInicial + #990, #3967
  static TelaInicial + #991, #3967
  static TelaInicial + #992, #3967
  static TelaInicial + #993, #3967
  static TelaInicial + #994, #3967
  static TelaInicial + #995, #3967
  static TelaInicial + #996, #3967
  static TelaInicial + #997, #3967
  static TelaInicial + #998, #3967
  static TelaInicial + #999, #3967

  ;Linha 25
  static TelaInicial + #1000, #3967
  static TelaInicial + #1001, #3967
  static TelaInicial + #1002, #3967
  static TelaInicial + #1003, #3967
  static TelaInicial + #1004, #3967
  static TelaInicial + #1005, #127
  static TelaInicial + #1006, #127
  static TelaInicial + #1007, #127
  static TelaInicial + #1008, #127
  static TelaInicial + #1009, #127
  static TelaInicial + #1010, #127
  static TelaInicial + #1011, #127
  static TelaInicial + #1012, #127
  static TelaInicial + #1013, #127
  static TelaInicial + #1014, #2
  static TelaInicial + #1015, #127
  static TelaInicial + #1016, #2
  static TelaInicial + #1017, #127
  static TelaInicial + #1018, #2
  static TelaInicial + #1019, #127
  static TelaInicial + #1020, #18
  static TelaInicial + #1021, #3967
  static TelaInicial + #1022, #3967
  static TelaInicial + #1023, #3967
  static TelaInicial + #1024, #127
  static TelaInicial + #1025, #6
  static TelaInicial + #1026, #3967
  static TelaInicial + #1027, #3967
  static TelaInicial + #1028, #3967
  static TelaInicial + #1029, #3967
  static TelaInicial + #1030, #3967
  static TelaInicial + #1031, #3967
  static TelaInicial + #1032, #3967
  static TelaInicial + #1033, #3967
  static TelaInicial + #1034, #3967
  static TelaInicial + #1035, #3967
  static TelaInicial + #1036, #3967
  static TelaInicial + #1037, #3967
  static TelaInicial + #1038, #3967
  static TelaInicial + #1039, #3967

  ;Linha 26
  static TelaInicial + #1040, #3967
  static TelaInicial + #1041, #3967
  static TelaInicial + #1042, #3967
  static TelaInicial + #1043, #3967
  static TelaInicial + #1044, #3967
  static TelaInicial + #1045, #3967
  static TelaInicial + #1046, #3967
  static TelaInicial + #1047, #3967
  static TelaInicial + #1048, #3967
  static TelaInicial + #1049, #3967
  static TelaInicial + #1050, #3967
  static TelaInicial + #1051, #3967
  static TelaInicial + #1052, #3967
  static TelaInicial + #1053, #127
  static TelaInicial + #1054, #2
  static TelaInicial + #1055, #127
  static TelaInicial + #1056, #2
  static TelaInicial + #1057, #127
  static TelaInicial + #1058, #18
  static TelaInicial + #1059, #3967
  static TelaInicial + #1060, #127
  static TelaInicial + #1061, #18
  static TelaInicial + #1062, #127
  static TelaInicial + #1063, #127
  static TelaInicial + #1064, #2
  static TelaInicial + #1065, #6
  static TelaInicial + #1066, #3967
  static TelaInicial + #1067, #3967
  static TelaInicial + #1068, #3967
  static TelaInicial + #1069, #3967
  static TelaInicial + #1070, #3967
  static TelaInicial + #1071, #3967
  static TelaInicial + #1072, #3967
  static TelaInicial + #1073, #3967
  static TelaInicial + #1074, #3967
  static TelaInicial + #1075, #3967
  static TelaInicial + #1076, #3967
  static TelaInicial + #1077, #3967
  static TelaInicial + #1078, #3967
  static TelaInicial + #1079, #3967

  ;Linha 27
  static TelaInicial + #1080, #3967
  static TelaInicial + #1081, #3967
  static TelaInicial + #1082, #3967
  static TelaInicial + #1083, #3967
  static TelaInicial + #1084, #3967
  static TelaInicial + #1085, #3967
  static TelaInicial + #1086, #3967
  static TelaInicial + #1087, #3967
  static TelaInicial + #1088, #3967
  static TelaInicial + #1089, #3967
  static TelaInicial + #1090, #3967
  static TelaInicial + #1091, #3967
  static TelaInicial + #1092, #3967
  static TelaInicial + #1093, #127
  static TelaInicial + #1094, #2
  static TelaInicial + #1095, #127
  static TelaInicial + #1096, #2
  static TelaInicial + #1097, #3967
  static TelaInicial + #1098, #127
  static TelaInicial + #1099, #18
  static TelaInicial + #1100, #127
  static TelaInicial + #1101, #6
  static TelaInicial + #1102, #127
  static TelaInicial + #1103, #127
  static TelaInicial + #1104, #2
  static TelaInicial + #1105, #0
  static TelaInicial + #1106, #3967
  static TelaInicial + #1107, #3967
  static TelaInicial + #1108, #3967
  static TelaInicial + #1109, #3967
  static TelaInicial + #1110, #3967
  static TelaInicial + #1111, #3967
  static TelaInicial + #1112, #3967
  static TelaInicial + #1113, #3967
  static TelaInicial + #1114, #3967
  static TelaInicial + #1115, #3967
  static TelaInicial + #1116, #3967
  static TelaInicial + #1117, #3967
  static TelaInicial + #1118, #3967
  static TelaInicial + #1119, #3967

  ;Linha 28
  static TelaInicial + #1120, #3967
  static TelaInicial + #1121, #3967
  static TelaInicial + #1122, #3967
  static TelaInicial + #1123, #3967
  static TelaInicial + #1124, #3967
  static TelaInicial + #1125, #3967
  static TelaInicial + #1126, #3967
  static TelaInicial + #1127, #3967
  static TelaInicial + #1128, #3967
  static TelaInicial + #1129, #3967
  static TelaInicial + #1130, #3967
  static TelaInicial + #1131, #3967
  static TelaInicial + #1132, #3967
  static TelaInicial + #1133, #127
  static TelaInicial + #1134, #3
  static TelaInicial + #1135, #4
  static TelaInicial + #1136, #4
  static TelaInicial + #1137, #5
  static TelaInicial + #1138, #3
  static TelaInicial + #1139, #4
  static TelaInicial + #1140, #4
  static TelaInicial + #1141, #5
  static TelaInicial + #1142, #4
  static TelaInicial + #1143, #4
  static TelaInicial + #1144, #2
  static TelaInicial + #1145, #3967
  static TelaInicial + #1146, #3967
  static TelaInicial + #1147, #3967
  static TelaInicial + #1148, #3967
  static TelaInicial + #1149, #3967
  static TelaInicial + #1150, #3967
  static TelaInicial + #1151, #3967
  static TelaInicial + #1152, #3967
  static TelaInicial + #1153, #3967
  static TelaInicial + #1154, #3967
  static TelaInicial + #1155, #3967
  static TelaInicial + #1156, #3967
  static TelaInicial + #1157, #3967
  static TelaInicial + #1158, #3967
  static TelaInicial + #1159, #3967

  ;Linha 29
  static TelaInicial + #1160, #3967
  static TelaInicial + #1161, #3967
  static TelaInicial + #1162, #3967
  static TelaInicial + #1163, #3967
  static TelaInicial + #1164, #3967
  static TelaInicial + #1165, #3967
  static TelaInicial + #1166, #3967
  static TelaInicial + #1167, #3967
  static TelaInicial + #1168, #3967
  static TelaInicial + #1169, #3967
  static TelaInicial + #1170, #3967
  static TelaInicial + #1171, #3967
  static TelaInicial + #1172, #3967
  static TelaInicial + #1173, #3967
  static TelaInicial + #1174, #3967
  static TelaInicial + #1175, #3967
  static TelaInicial + #1176, #3967
  static TelaInicial + #1177, #3967
  static TelaInicial + #1178, #3967
  static TelaInicial + #1179, #3967
  static TelaInicial + #1180, #3967
  static TelaInicial + #1181, #127
  static TelaInicial + #1182, #127
  static TelaInicial + #1183, #3967
  static TelaInicial + #1184, #3967
  static TelaInicial + #1185, #3967
  static TelaInicial + #1186, #3967
  static TelaInicial + #1187, #3967
  static TelaInicial + #1188, #3967
  static TelaInicial + #1189, #3967
  static TelaInicial + #1190, #3967
  static TelaInicial + #1191, #3967
  static TelaInicial + #1192, #3967
  static TelaInicial + #1193, #3967
  static TelaInicial + #1194, #3967
  static TelaInicial + #1195, #3967
  static TelaInicial + #1196, #3967
  static TelaInicial + #1197, #3967
  static TelaInicial + #1198, #3967
  static TelaInicial + #1199, #3967

printTelaInicialScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #TelaInicial
  loadn R1, #0
  loadn R2, #1200

  printTelaInicialScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printTelaInicialScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts
printTelaInicialScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #TelaInicial
  loadn R1, #0
  loadn R2, #1200

  printTelaInicialScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printTelaInicialScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

SalvadorenhoPosition : var #1

Salvadorenho : var #90
  static Salvadorenho + #0, #1284 ; 
  static Salvadorenho + #1, #1284 ; 
  static Salvadorenho + #2, #1284 ; 
  static Salvadorenho + #3, #1284 ; 
  ;37  espacos para o proximo caractere
  static Salvadorenho + #4, #1282 ; 
  static Salvadorenho + #5, #3626 ; *
  static Salvadorenho + #6, #3626 ; *
  static Salvadorenho + #7, #1286 ; 
  ;37  espacos para o proximo caractere
  static Salvadorenho + #8, #1282 ; 
  static Salvadorenho + #9, #3626 ; *
  static Salvadorenho + #10, #3626 ; *
  static Salvadorenho + #11, #1286 ; 
  ;36  espacos para o proximo caractere
  static Salvadorenho + #12, #1280 ; 
  static Salvadorenho + #13, #1280 ; 
  static Salvadorenho + #14, #1280 ; 
  static Salvadorenho + #15, #1280 ; 
  static Salvadorenho + #16, #1280 ; 
  static Salvadorenho + #17, #1280 ; 
  ;36  espacos para o proximo caractere
  static Salvadorenho + #18, #1 ; 
  static Salvadorenho + #19, #0 ; 
  static Salvadorenho + #20, #0 ; 
  static Salvadorenho + #21, #7 ; 
  ;37  espacos para o proximo caractere
  static Salvadorenho + #22, #2 ; 
  static Salvadorenho + #23, #3080 ; 
  static Salvadorenho + #24, #3080 ; 
  static Salvadorenho + #25, #6 ; 
  ;37  espacos para o proximo caractere
  static Salvadorenho + #26, #2 ; 
  static Salvadorenho + #27, #2820 ; 
  static Salvadorenho + #28, #2309 ; 
  static Salvadorenho + #29, #6 ; 
  ;4  espacos para o proximo caractere
  static Salvadorenho + #30, #2858 ; *
  static Salvadorenho + #31, #2858 ; *
  ;32  espacos para o proximo caractere
  static Salvadorenho + #32, #3 ; 
  static Salvadorenho + #33, #4 ; 
  static Salvadorenho + #34, #4 ; 
  static Salvadorenho + #35, #5 ; 
  ;4  espacos para o proximo caractere
  static Salvadorenho + #36, #2858 ; *
  static Salvadorenho + #37, #2858 ; *
  ;25  espacos para o proximo caractere
  static Salvadorenho + #38, #2080 ; SPACE
  static Salvadorenho + #39, #2080 ; SPACE
  ;7  espacos para o proximo caractere
  static Salvadorenho + #40, #1538 ; 
  static Salvadorenho + #41, #1542 ; 
  ;5  espacos para o proximo caractere
  static Salvadorenho + #42, #2858 ; *
  static Salvadorenho + #43, #2858 ; *
  ;26  espacos para o proximo caractere
  static Salvadorenho + #44, #2059 ; 
  static Salvadorenho + #45, #2057 ; 
  static Salvadorenho + #46, #4 ; 
  static Salvadorenho + #47, #4 ; 
  static Salvadorenho + #48, #1542 ; 
  static Salvadorenho + #49, #1536 ; 
  static Salvadorenho + #50, #1536 ; 
  static Salvadorenho + #51, #2347 ; +
  static Salvadorenho + #52, #2347 ; +
  static Salvadorenho + #53, #1536 ; 
  static Salvadorenho + #54, #1536 ; 
  static Salvadorenho + #55, #1538 ; 
  static Salvadorenho + #56, #2858 ; *
  static Salvadorenho + #57, #2858 ; *
  static Salvadorenho + #58, #2858 ; *
  ;26  espacos para o proximo caractere
  static Salvadorenho + #59, #2060 ; 
  static Salvadorenho + #60, #2058 ; 
  static Salvadorenho + #61, #0 ; 
  static Salvadorenho + #62, #0 ; 
  static Salvadorenho + #63, #1542 ; 
  static Salvadorenho + #64, #1540 ; 
  static Salvadorenho + #65, #1540 ; 
  static Salvadorenho + #66, #2347 ; +
  static Salvadorenho + #67, #2347 ; +
  static Salvadorenho + #68, #1540 ; 
  static Salvadorenho + #69, #1540 ; 
  static Salvadorenho + #70, #1538 ; 
  static Salvadorenho + #71, #2858 ; *
  static Salvadorenho + #72, #2858 ; *
  ;26  espacos para o proximo caractere
  static Salvadorenho + #73, #2080 ; SPACE
  static Salvadorenho + #74, #2080 ; SPACE
  ;7  espacos para o proximo caractere
  static Salvadorenho + #75, #1538 ; 
  static Salvadorenho + #76, #2350 ; .
  static Salvadorenho + #77, #1538 ; 
  ;38  espacos para o proximo caractere
  static Salvadorenho + #78, #1538 ; 
  static Salvadorenho + #79, #2350 ; .
  static Salvadorenho + #80, #1538 ; 
  ;38  espacos para o proximo caractere
  static Salvadorenho + #81, #1538 ; 
  static Salvadorenho + #82, #2350 ; .
  static Salvadorenho + #83, #1538 ; 
  ;38  espacos para o proximo caractere
  static Salvadorenho + #84, #1536 ; 
  static Salvadorenho + #85, #1536 ; 
  ;39  espacos para o proximo caractere
  static Salvadorenho + #86, #2061 ; 
  static Salvadorenho + #87, #2061 ; 
  ;39  espacos para o proximo caractere
  static Salvadorenho + #88, #2061 ; 
  static Salvadorenho + #89, #2061 ; 

SalvadorenhoGaps : var #90
  static SalvadorenhoGaps + #0, #0
  static SalvadorenhoGaps + #1, #0
  static SalvadorenhoGaps + #2, #0
  static SalvadorenhoGaps + #3, #0
  static SalvadorenhoGaps + #4, #36
  static SalvadorenhoGaps + #5, #0
  static SalvadorenhoGaps + #6, #0
  static SalvadorenhoGaps + #7, #0
  static SalvadorenhoGaps + #8, #36
  static SalvadorenhoGaps + #9, #0
  static SalvadorenhoGaps + #10, #0
  static SalvadorenhoGaps + #11, #0
  static SalvadorenhoGaps + #12, #35
  static SalvadorenhoGaps + #13, #0
  static SalvadorenhoGaps + #14, #0
  static SalvadorenhoGaps + #15, #0
  static SalvadorenhoGaps + #16, #0
  static SalvadorenhoGaps + #17, #0
  static SalvadorenhoGaps + #18, #35
  static SalvadorenhoGaps + #19, #0
  static SalvadorenhoGaps + #20, #0
  static SalvadorenhoGaps + #21, #0
  static SalvadorenhoGaps + #22, #36
  static SalvadorenhoGaps + #23, #0
  static SalvadorenhoGaps + #24, #0
  static SalvadorenhoGaps + #25, #0
  static SalvadorenhoGaps + #26, #36
  static SalvadorenhoGaps + #27, #0
  static SalvadorenhoGaps + #28, #0
  static SalvadorenhoGaps + #29, #0
  static SalvadorenhoGaps + #30, #3
  static SalvadorenhoGaps + #31, #0
  static SalvadorenhoGaps + #32, #31
  static SalvadorenhoGaps + #33, #0
  static SalvadorenhoGaps + #34, #0
  static SalvadorenhoGaps + #35, #0
  static SalvadorenhoGaps + #36, #3
  static SalvadorenhoGaps + #37, #0
  static SalvadorenhoGaps + #38, #24
  static SalvadorenhoGaps + #39, #0
  static SalvadorenhoGaps + #40, #6
  static SalvadorenhoGaps + #41, #0
  static SalvadorenhoGaps + #42, #4
  static SalvadorenhoGaps + #43, #0
  static SalvadorenhoGaps + #44, #25
  static SalvadorenhoGaps + #45, #0
  static SalvadorenhoGaps + #46, #0
  static SalvadorenhoGaps + #47, #0
  static SalvadorenhoGaps + #48, #0
  static SalvadorenhoGaps + #49, #0
  static SalvadorenhoGaps + #50, #0
  static SalvadorenhoGaps + #51, #0
  static SalvadorenhoGaps + #52, #0
  static SalvadorenhoGaps + #53, #0
  static SalvadorenhoGaps + #54, #0
  static SalvadorenhoGaps + #55, #0
  static SalvadorenhoGaps + #56, #0
  static SalvadorenhoGaps + #57, #0
  static SalvadorenhoGaps + #58, #0
  static SalvadorenhoGaps + #59, #25
  static SalvadorenhoGaps + #60, #0
  static SalvadorenhoGaps + #61, #0
  static SalvadorenhoGaps + #62, #0
  static SalvadorenhoGaps + #63, #0
  static SalvadorenhoGaps + #64, #0
  static SalvadorenhoGaps + #65, #0
  static SalvadorenhoGaps + #66, #0
  static SalvadorenhoGaps + #67, #0
  static SalvadorenhoGaps + #68, #0
  static SalvadorenhoGaps + #69, #0
  static SalvadorenhoGaps + #70, #0
  static SalvadorenhoGaps + #71, #0
  static SalvadorenhoGaps + #72, #0
  static SalvadorenhoGaps + #73, #25
  static SalvadorenhoGaps + #74, #0
  static SalvadorenhoGaps + #75, #6
  static SalvadorenhoGaps + #76, #0
  static SalvadorenhoGaps + #77, #0
  static SalvadorenhoGaps + #78, #37
  static SalvadorenhoGaps + #79, #0
  static SalvadorenhoGaps + #80, #0
  static SalvadorenhoGaps + #81, #37
  static SalvadorenhoGaps + #82, #0
  static SalvadorenhoGaps + #83, #0
  static SalvadorenhoGaps + #84, #37
  static SalvadorenhoGaps + #85, #0
  static SalvadorenhoGaps + #86, #38
  static SalvadorenhoGaps + #87, #0
  static SalvadorenhoGaps + #88, #38
  static SalvadorenhoGaps + #89, #0

printSalvadorenho:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #Salvadorenho
  loadn R1, #SalvadorenhoGaps
  load R2, SalvadorenhoPosition
  loadn R3, #90 ;tamanho Salvadorenho
  loadn R4, #0 ;incremetador

  printSalvadorenhoLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
     inc R4
     cmp R3, R4
    jne printSalvadorenhoLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarSalvadorenho:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R0, #3967
  loadn R1, #SalvadorenhoGaps
  load R2, SalvadorenhoPosition
  loadn R3, #90 ;tamanho Salvadorenho
  loadn R4, #0 ;incremetador

  apagarSalvadorenhoLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarSalvadorenhoLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

VilaozaozaoPosition : var #1

Vilaozaozao : var #61
  static Vilaozaozao + #0, #2832 ; 
  static Vilaozaozao + #1, #2832 ; 
  ;38  espacos para o proximo caractere
  static Vilaozaozao + #2, #2320 ; 
  static Vilaozaozao + #3, #2320 ; 
  static Vilaozaozao + #4, #2320 ; 
  static Vilaozaozao + #5, #2320 ; 
  ;74  espacos para o proximo caractere
  static Vilaozaozao + #6, #2362 ; :
  ;3  espacos para o proximo caractere
  static Vilaozaozao + #7, #2305 ; 
  static Vilaozaozao + #8, #2304 ; 
  static Vilaozaozao + #9, #2304 ; 
  static Vilaozaozao + #10, #2311 ; 
  ;33  espacos para o proximo caractere
  static Vilaozaozao + #11, #2362 ; :
  static Vilaozaozao + #12, #2362 ; :
  ;3  espacos para o proximo caractere
  static Vilaozaozao + #13, #2818 ; 
  static Vilaozaozao + #14, #2318 ; 
  static Vilaozaozao + #15, #2319 ; 
  static Vilaozaozao + #16, #2822 ; 
  ;32  espacos para o proximo caractere
  static Vilaozaozao + #17, #2362 ; :
  static Vilaozaozao + #18, #2362 ; :
  static Vilaozaozao + #19, #2362 ; :
  ;3  espacos para o proximo caractere
  static Vilaozaozao + #20, #2818 ; 
  static Vilaozaozao + #21, #2817 ; 
  static Vilaozaozao + #22, #2823 ; 
  static Vilaozaozao + #23, #2822 ; 
  ;31  espacos para o proximo caractere
  static Vilaozaozao + #24, #2362 ; :
  static Vilaozaozao + #25, #2362 ; :
  static Vilaozaozao + #26, #2362 ; :
  static Vilaozaozao + #27, #2362 ; :
  ;3  espacos para o proximo caractere
  static Vilaozaozao + #28, #2307 ; 
  static Vilaozaozao + #29, #2308 ; 
  static Vilaozaozao + #30, #2308 ; 
  static Vilaozaozao + #31, #2309 ; 
  ;32  espacos para o proximo caractere
  static Vilaozaozao + #32, #2362 ; :
  static Vilaozaozao + #33, #2362 ; :
  static Vilaozaozao + #34, #2362 ; :
  ;4  espacos para o proximo caractere
  static Vilaozaozao + #35, #2059 ; 
  static Vilaozaozao + #36, #2057 ; 
  ;34  espacos para o proximo caractere
  static Vilaozaozao + #37, #2362 ; :
  static Vilaozaozao + #38, #2362 ; :
  static Vilaozaozao + #39, #2304 ; 
  static Vilaozaozao + #40, #2304 ; 
  static Vilaozaozao + #41, #2310 ; 
  static Vilaozaozao + #42, #2316 ; 
  static Vilaozaozao + #43, #2314 ; 
  static Vilaozaozao + #44, #2306 ; 
  static Vilaozaozao + #45, #2304 ; 
  static Vilaozaozao + #46, #2304 ; 
  static Vilaozaozao + #47, #2322 ; 
  ;31  espacos para o proximo caractere
  static Vilaozaozao + #48, #2362 ; :
  ;3  espacos para o proximo caractere
  static Vilaozaozao + #49, #2310 ; 
  ;3  espacos para o proximo caractere
  static Vilaozaozao + #50, #2306 ; 
  ;4  espacos para o proximo caractere
  static Vilaozaozao + #51, #2430 ; ~
  ;33  espacos para o proximo caractere
  static Vilaozaozao + #52, #2310 ; 
  static Vilaozaozao + #53, #2308 ; 
  static Vilaozaozao + #54, #2308 ; 
  static Vilaozaozao + #55, #2306 ; 
  ;38  espacos para o proximo caractere
  static Vilaozaozao + #56, #2310 ; 
  ;40  espacos para o proximo caractere
  static Vilaozaozao + #57, #2321 ; 
  static Vilaozaozao + #58, #2322 ; 
  ;38  espacos para o proximo caractere
  static Vilaozaozao + #59, #2321 ; 
  ;3  espacos para o proximo caractere
  static Vilaozaozao + #60, #2322 ; 

VilaozaozaoGaps : var #61
  static VilaozaozaoGaps + #0, #0
  static VilaozaozaoGaps + #1, #0
  static VilaozaozaoGaps + #2, #37
  static VilaozaozaoGaps + #3, #0
  static VilaozaozaoGaps + #4, #0
  static VilaozaozaoGaps + #5, #0
  static VilaozaozaoGaps + #6, #73
  static VilaozaozaoGaps + #7, #2
  static VilaozaozaoGaps + #8, #0
  static VilaozaozaoGaps + #9, #0
  static VilaozaozaoGaps + #10, #0
  static VilaozaozaoGaps + #11, #32
  static VilaozaozaoGaps + #12, #0
  static VilaozaozaoGaps + #13, #2
  static VilaozaozaoGaps + #14, #0
  static VilaozaozaoGaps + #15, #0
  static VilaozaozaoGaps + #16, #0
  static VilaozaozaoGaps + #17, #31
  static VilaozaozaoGaps + #18, #0
  static VilaozaozaoGaps + #19, #0
  static VilaozaozaoGaps + #20, #2
  static VilaozaozaoGaps + #21, #0
  static VilaozaozaoGaps + #22, #0
  static VilaozaozaoGaps + #23, #0
  static VilaozaozaoGaps + #24, #30
  static VilaozaozaoGaps + #25, #0
  static VilaozaozaoGaps + #26, #0
  static VilaozaozaoGaps + #27, #0
  static VilaozaozaoGaps + #28, #2
  static VilaozaozaoGaps + #29, #0
  static VilaozaozaoGaps + #30, #0
  static VilaozaozaoGaps + #31, #0
  static VilaozaozaoGaps + #32, #31
  static VilaozaozaoGaps + #33, #0
  static VilaozaozaoGaps + #34, #0
  static VilaozaozaoGaps + #35, #3
  static VilaozaozaoGaps + #36, #0
  static VilaozaozaoGaps + #37, #33
  static VilaozaozaoGaps + #38, #0
  static VilaozaozaoGaps + #39, #0
  static VilaozaozaoGaps + #40, #0
  static VilaozaozaoGaps + #41, #0
  static VilaozaozaoGaps + #42, #0
  static VilaozaozaoGaps + #43, #0
  static VilaozaozaoGaps + #44, #0
  static VilaozaozaoGaps + #45, #0
  static VilaozaozaoGaps + #46, #0
  static VilaozaozaoGaps + #47, #0
  static VilaozaozaoGaps + #48, #30
  static VilaozaozaoGaps + #49, #2
  static VilaozaozaoGaps + #50, #2
  static VilaozaozaoGaps + #51, #3
  static VilaozaozaoGaps + #52, #32
  static VilaozaozaoGaps + #53, #0
  static VilaozaozaoGaps + #54, #0
  static VilaozaozaoGaps + #55, #0
  static VilaozaozaoGaps + #56, #37
  static VilaozaozaoGaps + #57, #39
  static VilaozaozaoGaps + #58, #0
  static VilaozaozaoGaps + #59, #37
  static VilaozaozaoGaps + #60, #2

printVilaozaozao:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #Vilaozaozao
  loadn R1, #VilaozaozaoGaps
  load R2, VilaozaozaoPosition
  loadn R3, #61 ;tamanho Vilaozaozao
  loadn R4, #0 ;incremetador

  printVilaozaozaoLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
     inc R4
     cmp R3, R4
    jne printVilaozaozaoLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarVilaozaozao:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R0, #3967
  loadn R1, #VilaozaozaoGaps
  load R2, VilaozaozaoPosition
  loadn R3, #61 ;tamanho Vilaozaozao
  loadn R4, #0 ;incremetador

  apagarVilaozaozaoLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarVilaozaozaoLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

telaVitoria : var #1200
  ;Linha 0
  static telaVitoria + #0, #3967
  static telaVitoria + #1, #3967
  static telaVitoria + #2, #3967
  static telaVitoria + #3, #3967
  static telaVitoria + #4, #3967
  static telaVitoria + #5, #3967
  static telaVitoria + #6, #3967
  static telaVitoria + #7, #3967
  static telaVitoria + #8, #3967
  static telaVitoria + #9, #3967
  static telaVitoria + #10, #3967
  static telaVitoria + #11, #3967
  static telaVitoria + #12, #3967
  static telaVitoria + #13, #3967
  static telaVitoria + #14, #3967
  static telaVitoria + #15, #3967
  static telaVitoria + #16, #3967
  static telaVitoria + #17, #3967
  static telaVitoria + #18, #3967
  static telaVitoria + #19, #3967
  static telaVitoria + #20, #3967
  static telaVitoria + #21, #3967
  static telaVitoria + #22, #3967
  static telaVitoria + #23, #3967
  static telaVitoria + #24, #3967
  static telaVitoria + #25, #3967
  static telaVitoria + #26, #3967
  static telaVitoria + #27, #3967
  static telaVitoria + #28, #3967
  static telaVitoria + #29, #3967
  static telaVitoria + #30, #3967
  static telaVitoria + #31, #3967
  static telaVitoria + #32, #3967
  static telaVitoria + #33, #3967
  static telaVitoria + #34, #3967
  static telaVitoria + #35, #3967
  static telaVitoria + #36, #3967
  static telaVitoria + #37, #3967
  static telaVitoria + #38, #3967
  static telaVitoria + #39, #3967

  ;Linha 1
  static telaVitoria + #40, #3967
  static telaVitoria + #41, #3967
  static telaVitoria + #42, #3967
  static telaVitoria + #43, #3967
  static telaVitoria + #44, #3967
  static telaVitoria + #45, #3967
  static telaVitoria + #46, #3967
  static telaVitoria + #47, #3967
  static telaVitoria + #48, #3967
  static telaVitoria + #49, #3967
  static telaVitoria + #50, #3967
  static telaVitoria + #51, #3967
  static telaVitoria + #52, #3967
  static telaVitoria + #53, #3967
  static telaVitoria + #54, #3967
  static telaVitoria + #55, #3967
  static telaVitoria + #56, #3967
  static telaVitoria + #57, #3967
  static telaVitoria + #58, #3967
  static telaVitoria + #59, #3967
  static telaVitoria + #60, #3967
  static telaVitoria + #61, #3967
  static telaVitoria + #62, #3967
  static telaVitoria + #63, #3967
  static telaVitoria + #64, #3967
  static telaVitoria + #65, #3967
  static telaVitoria + #66, #3967
  static telaVitoria + #67, #3967
  static telaVitoria + #68, #3967
  static telaVitoria + #69, #3967
  static telaVitoria + #70, #3967
  static telaVitoria + #71, #3967
  static telaVitoria + #72, #3967
  static telaVitoria + #73, #3967
  static telaVitoria + #74, #3967
  static telaVitoria + #75, #3967
  static telaVitoria + #76, #3967
  static telaVitoria + #77, #3967
  static telaVitoria + #78, #3967
  static telaVitoria + #79, #3967

  ;Linha 2
  static telaVitoria + #80, #3967
  static telaVitoria + #81, #3967
  static telaVitoria + #82, #3967
  static telaVitoria + #83, #3967
  static telaVitoria + #84, #3967
  static telaVitoria + #85, #3967
  static telaVitoria + #86, #3967
  static telaVitoria + #87, #3967
  static telaVitoria + #88, #3967
  static telaVitoria + #89, #3967
  static telaVitoria + #90, #3967
  static telaVitoria + #91, #3967
  static telaVitoria + #92, #3967
  static telaVitoria + #93, #3967
  static telaVitoria + #94, #3967
  static telaVitoria + #95, #3967
  static telaVitoria + #96, #3967
  static telaVitoria + #97, #3166
  static telaVitoria + #98, #3967
  static telaVitoria + #99, #3967
  static telaVitoria + #100, #3967
  static telaVitoria + #101, #3967
  static telaVitoria + #102, #3967
  static telaVitoria + #103, #3967
  static telaVitoria + #104, #3967
  static telaVitoria + #105, #3967
  static telaVitoria + #106, #3967
  static telaVitoria + #107, #3967
  static telaVitoria + #108, #3967
  static telaVitoria + #109, #3967
  static telaVitoria + #110, #3967
  static telaVitoria + #111, #3967
  static telaVitoria + #112, #3967
  static telaVitoria + #113, #3967
  static telaVitoria + #114, #3967
  static telaVitoria + #115, #3967
  static telaVitoria + #116, #3967
  static telaVitoria + #117, #3967
  static telaVitoria + #118, #3967
  static telaVitoria + #119, #3967

  ;Linha 3
  static telaVitoria + #120, #3967
  static telaVitoria + #121, #3967
  static telaVitoria + #122, #3967
  static telaVitoria + #123, #3967
  static telaVitoria + #124, #3967
  static telaVitoria + #125, #3967
  static telaVitoria + #126, #3967
  static telaVitoria + #127, #3967
  static telaVitoria + #128, #3967
  static telaVitoria + #129, #3967
  static telaVitoria + #130, #3967
  static telaVitoria + #131, #3967
  static telaVitoria + #132, #3967
  static telaVitoria + #133, #3967
  static telaVitoria + #134, #3158
  static telaVitoria + #135, #3183
  static telaVitoria + #136, #3171
  static telaVitoria + #137, #3173
  static telaVitoria + #138, #3967
  static telaVitoria + #139, #2934
  static telaVitoria + #140, #2917
  static telaVitoria + #141, #2926
  static telaVitoria + #142, #2915
  static telaVitoria + #143, #2917
  static telaVitoria + #144, #2933
  static telaVitoria + #145, #2849
  static telaVitoria + #146, #3967
  static telaVitoria + #147, #3967
  static telaVitoria + #148, #3967
  static telaVitoria + #149, #3967
  static telaVitoria + #150, #3967
  static telaVitoria + #151, #3967
  static telaVitoria + #152, #3967
  static telaVitoria + #153, #3967
  static telaVitoria + #154, #3967
  static telaVitoria + #155, #3967
  static telaVitoria + #156, #3967
  static telaVitoria + #157, #3967
  static telaVitoria + #158, #3967
  static telaVitoria + #159, #3967

  ;Linha 4
  static telaVitoria + #160, #3967
  static telaVitoria + #161, #3967
  static telaVitoria + #162, #3967
  static telaVitoria + #163, #3967
  static telaVitoria + #164, #3967
  static telaVitoria + #165, #3967
  static telaVitoria + #166, #3967
  static telaVitoria + #167, #3967
  static telaVitoria + #168, #3967
  static telaVitoria + #169, #3967
  static telaVitoria + #170, #3967
  static telaVitoria + #171, #3967
  static telaVitoria + #172, #3967
  static telaVitoria + #173, #3967
  static telaVitoria + #174, #3091
  static telaVitoria + #175, #3967
  static telaVitoria + #176, #3967
  static telaVitoria + #177, #3967
  static telaVitoria + #178, #3967
  static telaVitoria + #179, #3967
  static telaVitoria + #180, #3967
  static telaVitoria + #181, #3967
  static telaVitoria + #182, #3967
  static telaVitoria + #183, #3967
  static telaVitoria + #184, #3967
  static telaVitoria + #185, #3967
  static telaVitoria + #186, #3967
  static telaVitoria + #187, #3967
  static telaVitoria + #188, #3967
  static telaVitoria + #189, #3967
  static telaVitoria + #190, #3967
  static telaVitoria + #191, #3967
  static telaVitoria + #192, #3967
  static telaVitoria + #193, #3967
  static telaVitoria + #194, #3967
  static telaVitoria + #195, #3967
  static telaVitoria + #196, #3967
  static telaVitoria + #197, #3967
  static telaVitoria + #198, #3967
  static telaVitoria + #199, #3967

  ;Linha 5
  static telaVitoria + #200, #3967
  static telaVitoria + #201, #3967
  static telaVitoria + #202, #3967
  static telaVitoria + #203, #3967
  static telaVitoria + #204, #3967
  static telaVitoria + #205, #3967
  static telaVitoria + #206, #3967
  static telaVitoria + #207, #3967
  static telaVitoria + #208, #3967
  static telaVitoria + #209, #3967
  static telaVitoria + #210, #3967
  static telaVitoria + #211, #3967
  static telaVitoria + #212, #3967
  static telaVitoria + #213, #3967
  static telaVitoria + #214, #3967
  static telaVitoria + #215, #3967
  static telaVitoria + #216, #3967
  static telaVitoria + #217, #3967
  static telaVitoria + #218, #3967
  static telaVitoria + #219, #3967
  static telaVitoria + #220, #3967
  static telaVitoria + #221, #3967
  static telaVitoria + #222, #3967
  static telaVitoria + #223, #3967
  static telaVitoria + #224, #3967
  static telaVitoria + #225, #3967
  static telaVitoria + #226, #3967
  static telaVitoria + #227, #3967
  static telaVitoria + #228, #3967
  static telaVitoria + #229, #3967
  static telaVitoria + #230, #3967
  static telaVitoria + #231, #3967
  static telaVitoria + #232, #3967
  static telaVitoria + #233, #3967
  static telaVitoria + #234, #3967
  static telaVitoria + #235, #3967
  static telaVitoria + #236, #3967
  static telaVitoria + #237, #3967
  static telaVitoria + #238, #3967
  static telaVitoria + #239, #3967

  ;Linha 6
  static telaVitoria + #240, #3967
  static telaVitoria + #241, #3967
  static telaVitoria + #242, #3967
  static telaVitoria + #243, #3967
  static telaVitoria + #244, #3967
  static telaVitoria + #245, #3967
  static telaVitoria + #246, #3967
  static telaVitoria + #247, #3967
  static telaVitoria + #248, #3967
  static telaVitoria + #249, #3967
  static telaVitoria + #250, #3967
  static telaVitoria + #251, #3967
  static telaVitoria + #252, #3967
  static telaVitoria + #253, #3967
  static telaVitoria + #254, #3967
  static telaVitoria + #255, #3967
  static telaVitoria + #256, #3967
  static telaVitoria + #257, #3967
  static telaVitoria + #258, #3967
  static telaVitoria + #259, #3967
  static telaVitoria + #260, #3967
  static telaVitoria + #261, #3967
  static telaVitoria + #262, #3967
  static telaVitoria + #263, #3967
  static telaVitoria + #264, #3967
  static telaVitoria + #265, #3967
  static telaVitoria + #266, #3967
  static telaVitoria + #267, #3967
  static telaVitoria + #268, #3967
  static telaVitoria + #269, #3967
  static telaVitoria + #270, #3967
  static telaVitoria + #271, #3967
  static telaVitoria + #272, #3967
  static telaVitoria + #273, #3967
  static telaVitoria + #274, #3967
  static telaVitoria + #275, #3967
  static telaVitoria + #276, #3967
  static telaVitoria + #277, #3967
  static telaVitoria + #278, #3967
  static telaVitoria + #279, #3967

  ;Linha 7
  static telaVitoria + #280, #3967
  static telaVitoria + #281, #3967
  static telaVitoria + #282, #3967
  static telaVitoria + #283, #3967
  static telaVitoria + #284, #3967
  static telaVitoria + #285, #3967
  static telaVitoria + #286, #3967
  static telaVitoria + #287, #3967
  static telaVitoria + #288, #3967
  static telaVitoria + #289, #3967
  static telaVitoria + #290, #3967
  static telaVitoria + #291, #3967
  static telaVitoria + #292, #3967
  static telaVitoria + #293, #3967
  static telaVitoria + #294, #3967
  static telaVitoria + #295, #3967
  static telaVitoria + #296, #3967
  static telaVitoria + #297, #3967
  static telaVitoria + #298, #3967
  static telaVitoria + #299, #3967
  static telaVitoria + #300, #3967
  static telaVitoria + #301, #3967
  static telaVitoria + #302, #3967
  static telaVitoria + #303, #3967
  static telaVitoria + #304, #3967
  static telaVitoria + #305, #3967
  static telaVitoria + #306, #3967
  static telaVitoria + #307, #3967
  static telaVitoria + #308, #3967
  static telaVitoria + #309, #3967
  static telaVitoria + #310, #3967
  static telaVitoria + #311, #3967
  static telaVitoria + #312, #3967
  static telaVitoria + #313, #3967
  static telaVitoria + #314, #3967
  static telaVitoria + #315, #3967
  static telaVitoria + #316, #3967
  static telaVitoria + #317, #3967
  static telaVitoria + #318, #3967
  static telaVitoria + #319, #3967

  ;Linha 8
  static telaVitoria + #320, #3967
  static telaVitoria + #321, #3967
  static telaVitoria + #322, #3967
  static telaVitoria + #323, #3967
  static telaVitoria + #324, #3967
  static telaVitoria + #325, #3967
  static telaVitoria + #326, #3967
  static telaVitoria + #327, #3967
  static telaVitoria + #328, #3967
  static telaVitoria + #329, #3967
  static telaVitoria + #330, #3967
  static telaVitoria + #331, #3967
  static telaVitoria + #332, #3967
  static telaVitoria + #333, #3967
  static telaVitoria + #334, #3967
  static telaVitoria + #335, #3967
  static telaVitoria + #336, #3967
  static telaVitoria + #337, #3967
  static telaVitoria + #338, #3967
  static telaVitoria + #339, #3967
  static telaVitoria + #340, #3967
  static telaVitoria + #341, #3967
  static telaVitoria + #342, #3967
  static telaVitoria + #343, #3967
  static telaVitoria + #344, #3967
  static telaVitoria + #345, #3967
  static telaVitoria + #346, #3967
  static telaVitoria + #347, #3967
  static telaVitoria + #348, #3967
  static telaVitoria + #349, #3967
  static telaVitoria + #350, #3967
  static telaVitoria + #351, #3967
  static telaVitoria + #352, #3967
  static telaVitoria + #353, #3967
  static telaVitoria + #354, #3967
  static telaVitoria + #355, #3967
  static telaVitoria + #356, #3967
  static telaVitoria + #357, #3967
  static telaVitoria + #358, #3967
  static telaVitoria + #359, #3967

  ;Linha 9
  static telaVitoria + #360, #3967
  static telaVitoria + #361, #3967
  static telaVitoria + #362, #3967
  static telaVitoria + #363, #3967
  static telaVitoria + #364, #3967
  static telaVitoria + #365, #3967
  static telaVitoria + #366, #3967
  static telaVitoria + #367, #3967
  static telaVitoria + #368, #3967
  static telaVitoria + #369, #3967
  static telaVitoria + #370, #3967
  static telaVitoria + #371, #3967
  static telaVitoria + #372, #3967
  static telaVitoria + #373, #3967
  static telaVitoria + #374, #3967
  static telaVitoria + #375, #3967
  static telaVitoria + #376, #3967
  static telaVitoria + #377, #3967
  static telaVitoria + #378, #3967
  static telaVitoria + #379, #3967
  static telaVitoria + #380, #3967
  static telaVitoria + #381, #3967
  static telaVitoria + #382, #3967
  static telaVitoria + #383, #3967
  static telaVitoria + #384, #3967
  static telaVitoria + #385, #3967
  static telaVitoria + #386, #3967
  static telaVitoria + #387, #3967
  static telaVitoria + #388, #3967
  static telaVitoria + #389, #3967
  static telaVitoria + #390, #3967
  static telaVitoria + #391, #3967
  static telaVitoria + #392, #3967
  static telaVitoria + #393, #3967
  static telaVitoria + #394, #3967
  static telaVitoria + #395, #3967
  static telaVitoria + #396, #3967
  static telaVitoria + #397, #3967
  static telaVitoria + #398, #3967
  static telaVitoria + #399, #3967

  ;Linha 10
  static telaVitoria + #400, #3967
  static telaVitoria + #401, #3967
  static telaVitoria + #402, #3967
  static telaVitoria + #403, #3967
  static telaVitoria + #404, #3967
  static telaVitoria + #405, #3967
  static telaVitoria + #406, #3967
  static telaVitoria + #407, #3967
  static telaVitoria + #408, #3967
  static telaVitoria + #409, #3967
  static telaVitoria + #410, #3967
  static telaVitoria + #411, #3967
  static telaVitoria + #412, #3967
  static telaVitoria + #413, #3967
  static telaVitoria + #414, #3967
  static telaVitoria + #415, #3967
  static telaVitoria + #416, #3967
  static telaVitoria + #417, #3967
  static telaVitoria + #418, #3967
  static telaVitoria + #419, #3967
  static telaVitoria + #420, #3967
  static telaVitoria + #421, #3967
  static telaVitoria + #422, #3967
  static telaVitoria + #423, #3967
  static telaVitoria + #424, #3967
  static telaVitoria + #425, #3967
  static telaVitoria + #426, #3967
  static telaVitoria + #427, #3967
  static telaVitoria + #428, #3967
  static telaVitoria + #429, #3967
  static telaVitoria + #430, #3967
  static telaVitoria + #431, #3967
  static telaVitoria + #432, #3967
  static telaVitoria + #433, #3967
  static telaVitoria + #434, #3967
  static telaVitoria + #435, #3967
  static telaVitoria + #436, #3967
  static telaVitoria + #437, #3967
  static telaVitoria + #438, #3967
  static telaVitoria + #439, #3967

  ;Linha 11
  static telaVitoria + #440, #3967
  static telaVitoria + #441, #3967
  static telaVitoria + #442, #3967
  static telaVitoria + #443, #3967
  static telaVitoria + #444, #3967
  static telaVitoria + #445, #3967
  static telaVitoria + #446, #3967
  static telaVitoria + #447, #3967
  static telaVitoria + #448, #3967
  static telaVitoria + #449, #3967
  static telaVitoria + #450, #3967
  static telaVitoria + #451, #3967
  static telaVitoria + #452, #3967
  static telaVitoria + #453, #3967
  static telaVitoria + #454, #3967
  static telaVitoria + #455, #3967
  static telaVitoria + #456, #3967
  static telaVitoria + #457, #3967
  static telaVitoria + #458, #3967
  static telaVitoria + #459, #3967
  static telaVitoria + #460, #3967
  static telaVitoria + #461, #3967
  static telaVitoria + #462, #3967
  static telaVitoria + #463, #3967
  static telaVitoria + #464, #3967
  static telaVitoria + #465, #3967
  static telaVitoria + #466, #3967
  static telaVitoria + #467, #3967
  static telaVitoria + #468, #3967
  static telaVitoria + #469, #3967
  static telaVitoria + #470, #3967
  static telaVitoria + #471, #3967
  static telaVitoria + #472, #3967
  static telaVitoria + #473, #3967
  static telaVitoria + #474, #3967
  static telaVitoria + #475, #3967
  static telaVitoria + #476, #3967
  static telaVitoria + #477, #3967
  static telaVitoria + #478, #3967
  static telaVitoria + #479, #3967

  ;Linha 12
  static telaVitoria + #480, #3967
  static telaVitoria + #481, #3967
  static telaVitoria + #482, #3967
  static telaVitoria + #483, #3967
  static telaVitoria + #484, #3967
  static telaVitoria + #485, #3967
  static telaVitoria + #486, #3967
  static telaVitoria + #487, #3967
  static telaVitoria + #488, #3967
  static telaVitoria + #489, #3967
  static telaVitoria + #490, #3967
  static telaVitoria + #491, #3967
  static telaVitoria + #492, #3967
  static telaVitoria + #493, #3967
  static telaVitoria + #494, #3967
  static telaVitoria + #495, #3967
  static telaVitoria + #496, #3967
  static telaVitoria + #497, #3967
  static telaVitoria + #498, #3967
  static telaVitoria + #499, #3967
  static telaVitoria + #500, #3967
  static telaVitoria + #501, #3967
  static telaVitoria + #502, #3967
  static telaVitoria + #503, #3967
  static telaVitoria + #504, #3967
  static telaVitoria + #505, #3967
  static telaVitoria + #506, #3967
  static telaVitoria + #507, #3967
  static telaVitoria + #508, #3967
  static telaVitoria + #509, #3967
  static telaVitoria + #510, #3967
  static telaVitoria + #511, #3967
  static telaVitoria + #512, #3967
  static telaVitoria + #513, #3967
  static telaVitoria + #514, #3967
  static telaVitoria + #515, #3967
  static telaVitoria + #516, #3967
  static telaVitoria + #517, #3967
  static telaVitoria + #518, #3967
  static telaVitoria + #519, #3967

  ;Linha 13
  static telaVitoria + #520, #3967
  static telaVitoria + #521, #3967
  static telaVitoria + #522, #3967
  static telaVitoria + #523, #3967
  static telaVitoria + #524, #3967
  static telaVitoria + #525, #3967
  static telaVitoria + #526, #3967
  static telaVitoria + #527, #3967
  static telaVitoria + #528, #3967
  static telaVitoria + #529, #3967
  static telaVitoria + #530, #3967
  static telaVitoria + #531, #3967
  static telaVitoria + #532, #3967
  static telaVitoria + #533, #3967
  static telaVitoria + #534, #3967
  static telaVitoria + #535, #3967
  static telaVitoria + #536, #3967
  static telaVitoria + #537, #3967
  static telaVitoria + #538, #3967
  static telaVitoria + #539, #3967
  static telaVitoria + #540, #3967
  static telaVitoria + #541, #3967
  static telaVitoria + #542, #3967
  static telaVitoria + #543, #3967
  static telaVitoria + #544, #3967
  static telaVitoria + #545, #3967
  static telaVitoria + #546, #3967
  static telaVitoria + #547, #3967
  static telaVitoria + #548, #3967
  static telaVitoria + #549, #3967
  static telaVitoria + #550, #3967
  static telaVitoria + #551, #3967
  static telaVitoria + #552, #3967
  static telaVitoria + #553, #3967
  static telaVitoria + #554, #3967
  static telaVitoria + #555, #3967
  static telaVitoria + #556, #3967
  static telaVitoria + #557, #3967
  static telaVitoria + #558, #3967
  static telaVitoria + #559, #3967

  ;Linha 14
  static telaVitoria + #560, #3967
  static telaVitoria + #561, #3967
  static telaVitoria + #562, #3967
  static telaVitoria + #563, #3967
  static telaVitoria + #564, #3967
  static telaVitoria + #565, #3967
  static telaVitoria + #566, #3967
  static telaVitoria + #567, #3967
  static telaVitoria + #568, #3967
  static telaVitoria + #569, #3967
  static telaVitoria + #570, #3967
  static telaVitoria + #571, #3967
  static telaVitoria + #572, #3967
  static telaVitoria + #573, #3967
  static telaVitoria + #574, #3967
  static telaVitoria + #575, #3967
  static telaVitoria + #576, #3967
  static telaVitoria + #577, #3967
  static telaVitoria + #578, #3967
  static telaVitoria + #579, #3967
  static telaVitoria + #580, #3967
  static telaVitoria + #581, #3967
  static telaVitoria + #582, #3967
  static telaVitoria + #583, #3967
  static telaVitoria + #584, #3967
  static telaVitoria + #585, #3967
  static telaVitoria + #586, #3967
  static telaVitoria + #587, #3967
  static telaVitoria + #588, #3967
  static telaVitoria + #589, #3967
  static telaVitoria + #590, #3967
  static telaVitoria + #591, #3967
  static telaVitoria + #592, #3967
  static telaVitoria + #593, #3967
  static telaVitoria + #594, #3967
  static telaVitoria + #595, #3967
  static telaVitoria + #596, #3967
  static telaVitoria + #597, #3967
  static telaVitoria + #598, #3967
  static telaVitoria + #599, #3967

  ;Linha 15
  static telaVitoria + #600, #3967
  static telaVitoria + #601, #3967
  static telaVitoria + #602, #3967
  static telaVitoria + #603, #3967
  static telaVitoria + #604, #3967
  static telaVitoria + #605, #3967
  static telaVitoria + #606, #3967
  static telaVitoria + #607, #3967
  static telaVitoria + #608, #3967
  static telaVitoria + #609, #3967
  static telaVitoria + #610, #3967
  static telaVitoria + #611, #3967
  static telaVitoria + #612, #3967
  static telaVitoria + #613, #3967
  static telaVitoria + #614, #3967
  static telaVitoria + #615, #3967
  static telaVitoria + #616, #3967
  static telaVitoria + #617, #3967
  static telaVitoria + #618, #3967
  static telaVitoria + #619, #3967
  static telaVitoria + #620, #3967
  static telaVitoria + #621, #3967
  static telaVitoria + #622, #3967
  static telaVitoria + #623, #3967
  static telaVitoria + #624, #3967
  static telaVitoria + #625, #3967
  static telaVitoria + #626, #3967
  static telaVitoria + #627, #3967
  static telaVitoria + #628, #3967
  static telaVitoria + #629, #3967
  static telaVitoria + #630, #3967
  static telaVitoria + #631, #3967
  static telaVitoria + #632, #3967
  static telaVitoria + #633, #3967
  static telaVitoria + #634, #3967
  static telaVitoria + #635, #3967
  static telaVitoria + #636, #3967
  static telaVitoria + #637, #3967
  static telaVitoria + #638, #3967
  static telaVitoria + #639, #3967

  ;Linha 16
  static telaVitoria + #640, #3967
  static telaVitoria + #641, #3967
  static telaVitoria + #642, #3967
  static telaVitoria + #643, #3967
  static telaVitoria + #644, #3967
  static telaVitoria + #645, #3967
  static telaVitoria + #646, #3967
  static telaVitoria + #647, #3967
  static telaVitoria + #648, #3967
  static telaVitoria + #649, #3967
  static telaVitoria + #650, #3967
  static telaVitoria + #651, #3967
  static telaVitoria + #652, #3967
  static telaVitoria + #653, #3967
  static telaVitoria + #654, #3967
  static telaVitoria + #655, #3967
  static telaVitoria + #656, #3967
  static telaVitoria + #657, #3967
  static telaVitoria + #658, #3967
  static telaVitoria + #659, #3967
  static telaVitoria + #660, #3967
  static telaVitoria + #661, #3967
  static telaVitoria + #662, #3967
  static telaVitoria + #663, #3967
  static telaVitoria + #664, #3967
  static telaVitoria + #665, #3967
  static telaVitoria + #666, #3967
  static telaVitoria + #667, #3967
  static telaVitoria + #668, #3967
  static telaVitoria + #669, #3967
  static telaVitoria + #670, #3967
  static telaVitoria + #671, #3967
  static telaVitoria + #672, #3967
  static telaVitoria + #673, #3967
  static telaVitoria + #674, #3967
  static telaVitoria + #675, #3967
  static telaVitoria + #676, #3967
  static telaVitoria + #677, #3967
  static telaVitoria + #678, #3967
  static telaVitoria + #679, #3967

  ;Linha 17
  static telaVitoria + #680, #3967
  static telaVitoria + #681, #3967
  static telaVitoria + #682, #3967
  static telaVitoria + #683, #3967
  static telaVitoria + #684, #3967
  static telaVitoria + #685, #3967
  static telaVitoria + #686, #3967
  static telaVitoria + #687, #3967
  static telaVitoria + #688, #3967
  static telaVitoria + #689, #3967
  static telaVitoria + #690, #3967
  static telaVitoria + #691, #3967
  static telaVitoria + #692, #3967
  static telaVitoria + #693, #3967
  static telaVitoria + #694, #3967
  static telaVitoria + #695, #3967
  static telaVitoria + #696, #3967
  static telaVitoria + #697, #3967
  static telaVitoria + #698, #3967
  static telaVitoria + #699, #3967
  static telaVitoria + #700, #3967
  static telaVitoria + #701, #3967
  static telaVitoria + #702, #3967
  static telaVitoria + #703, #3967
  static telaVitoria + #704, #3967
  static telaVitoria + #705, #3967
  static telaVitoria + #706, #3967
  static telaVitoria + #707, #3967
  static telaVitoria + #708, #3967
  static telaVitoria + #709, #3967
  static telaVitoria + #710, #3967
  static telaVitoria + #711, #3967
  static telaVitoria + #712, #3967
  static telaVitoria + #713, #3967
  static telaVitoria + #714, #3967
  static telaVitoria + #715, #3967
  static telaVitoria + #716, #3967
  static telaVitoria + #717, #3967
  static telaVitoria + #718, #3967
  static telaVitoria + #719, #3967

  ;Linha 18
  static telaVitoria + #720, #3967
  static telaVitoria + #721, #3967
  static telaVitoria + #722, #3967
  static telaVitoria + #723, #3967
  static telaVitoria + #724, #3967
  static telaVitoria + #725, #3967
  static telaVitoria + #726, #3967
  static telaVitoria + #727, #3967
  static telaVitoria + #728, #3967
  static telaVitoria + #729, #3967
  static telaVitoria + #730, #3967
  static telaVitoria + #731, #3967
  static telaVitoria + #732, #3967
  static telaVitoria + #733, #3967
  static telaVitoria + #734, #3967
  static telaVitoria + #735, #3967
  static telaVitoria + #736, #3967
  static telaVitoria + #737, #3967
  static telaVitoria + #738, #3967
  static telaVitoria + #739, #3967
  static telaVitoria + #740, #3967
  static telaVitoria + #741, #3967
  static telaVitoria + #742, #3967
  static telaVitoria + #743, #3967
  static telaVitoria + #744, #3967
  static telaVitoria + #745, #3967
  static telaVitoria + #746, #3967
  static telaVitoria + #747, #3967
  static telaVitoria + #748, #3967
  static telaVitoria + #749, #3967
  static telaVitoria + #750, #3967
  static telaVitoria + #751, #3967
  static telaVitoria + #752, #3967
  static telaVitoria + #753, #3967
  static telaVitoria + #754, #3967
  static telaVitoria + #755, #3967
  static telaVitoria + #756, #3967
  static telaVitoria + #757, #3967
  static telaVitoria + #758, #3967
  static telaVitoria + #759, #3967

  ;Linha 19
  static telaVitoria + #760, #3967
  static telaVitoria + #761, #3967
  static telaVitoria + #762, #3967
  static telaVitoria + #763, #3967
  static telaVitoria + #764, #3967
  static telaVitoria + #765, #3967
  static telaVitoria + #766, #3967
  static telaVitoria + #767, #3967
  static telaVitoria + #768, #3967
  static telaVitoria + #769, #3967
  static telaVitoria + #770, #3967
  static telaVitoria + #771, #3967
  static telaVitoria + #772, #3967
  static telaVitoria + #773, #3967
  static telaVitoria + #774, #3967
  static telaVitoria + #775, #3967
  static telaVitoria + #776, #3967
  static telaVitoria + #777, #3967
  static telaVitoria + #778, #3967
  static telaVitoria + #779, #3967
  static telaVitoria + #780, #3967
  static telaVitoria + #781, #3967
  static telaVitoria + #782, #3967
  static telaVitoria + #783, #3967
  static telaVitoria + #784, #3967
  static telaVitoria + #785, #3967
  static telaVitoria + #786, #3967
  static telaVitoria + #787, #3967
  static telaVitoria + #788, #3967
  static telaVitoria + #789, #3967
  static telaVitoria + #790, #3967
  static telaVitoria + #791, #3967
  static telaVitoria + #792, #3967
  static telaVitoria + #793, #3967
  static telaVitoria + #794, #3967
  static telaVitoria + #795, #3967
  static telaVitoria + #796, #3967
  static telaVitoria + #797, #3967
  static telaVitoria + #798, #3967
  static telaVitoria + #799, #3967

  ;Linha 20
  static telaVitoria + #800, #3967
  static telaVitoria + #801, #3967
  static telaVitoria + #802, #3967
  static telaVitoria + #803, #3967
  static telaVitoria + #804, #3967
  static telaVitoria + #805, #3967
  static telaVitoria + #806, #3967
  static telaVitoria + #807, #3967
  static telaVitoria + #808, #3967
  static telaVitoria + #809, #3967
  static telaVitoria + #810, #3967
  static telaVitoria + #811, #3967
  static telaVitoria + #812, #3967
  static telaVitoria + #813, #3967
  static telaVitoria + #814, #3967
  static telaVitoria + #815, #3967
  static telaVitoria + #816, #3967
  static telaVitoria + #817, #3967
  static telaVitoria + #818, #3967
  static telaVitoria + #819, #3967
  static telaVitoria + #820, #3967
  static telaVitoria + #821, #3967
  static telaVitoria + #822, #3967
  static telaVitoria + #823, #3967
  static telaVitoria + #824, #3967
  static telaVitoria + #825, #3967
  static telaVitoria + #826, #3967
  static telaVitoria + #827, #3967
  static telaVitoria + #828, #3967
  static telaVitoria + #829, #3967
  static telaVitoria + #830, #3967
  static telaVitoria + #831, #3967
  static telaVitoria + #832, #3967
  static telaVitoria + #833, #3967
  static telaVitoria + #834, #3967
  static telaVitoria + #835, #3967
  static telaVitoria + #836, #3967
  static telaVitoria + #837, #3967
  static telaVitoria + #838, #3967
  static telaVitoria + #839, #3967

  ;Linha 21
  static telaVitoria + #840, #3967
  static telaVitoria + #841, #3967
  static telaVitoria + #842, #3967
  static telaVitoria + #843, #3967
  static telaVitoria + #844, #3967
  static telaVitoria + #845, #3967
  static telaVitoria + #846, #3967
  static telaVitoria + #847, #3967
  static telaVitoria + #848, #3967
  static telaVitoria + #849, #3967
  static telaVitoria + #850, #3967
  static telaVitoria + #851, #3967
  static telaVitoria + #852, #3967
  static telaVitoria + #853, #3967
  static telaVitoria + #854, #3967
  static telaVitoria + #855, #3967
  static telaVitoria + #856, #3967
  static telaVitoria + #857, #3967
  static telaVitoria + #858, #3967
  static telaVitoria + #859, #3967
  static telaVitoria + #860, #3967
  static telaVitoria + #861, #3967
  static telaVitoria + #862, #3967
  static telaVitoria + #863, #3967
  static telaVitoria + #864, #3967
  static telaVitoria + #865, #3967
  static telaVitoria + #866, #3967
  static telaVitoria + #867, #3967
  static telaVitoria + #868, #3967
  static telaVitoria + #869, #3967
  static telaVitoria + #870, #3967
  static telaVitoria + #871, #3967
  static telaVitoria + #872, #3967
  static telaVitoria + #873, #3967
  static telaVitoria + #874, #3967
  static telaVitoria + #875, #3967
  static telaVitoria + #876, #3967
  static telaVitoria + #877, #3967
  static telaVitoria + #878, #3967
  static telaVitoria + #879, #3967

  ;Linha 22
  static telaVitoria + #880, #3967
  static telaVitoria + #881, #3967
  static telaVitoria + #882, #3967
  static telaVitoria + #883, #3967
  static telaVitoria + #884, #3967
  static telaVitoria + #885, #3967
  static telaVitoria + #886, #3967
  static telaVitoria + #887, #3967
  static telaVitoria + #888, #3967
  static telaVitoria + #889, #3967
  static telaVitoria + #890, #3967
  static telaVitoria + #891, #3967
  static telaVitoria + #892, #3967
  static telaVitoria + #893, #3967
  static telaVitoria + #894, #3967
  static telaVitoria + #895, #3967
  static telaVitoria + #896, #3967
  static telaVitoria + #897, #3967
  static telaVitoria + #898, #3967
  static telaVitoria + #899, #3967
  static telaVitoria + #900, #3967
  static telaVitoria + #901, #3967
  static telaVitoria + #902, #3967
  static telaVitoria + #903, #3967
  static telaVitoria + #904, #3967
  static telaVitoria + #905, #3967
  static telaVitoria + #906, #3967
  static telaVitoria + #907, #3967
  static telaVitoria + #908, #3967
  static telaVitoria + #909, #3967
  static telaVitoria + #910, #3967
  static telaVitoria + #911, #3967
  static telaVitoria + #912, #3967
  static telaVitoria + #913, #3967
  static telaVitoria + #914, #3967
  static telaVitoria + #915, #3967
  static telaVitoria + #916, #3967
  static telaVitoria + #917, #3967
  static telaVitoria + #918, #3967
  static telaVitoria + #919, #3967

  ;Linha 23
  static telaVitoria + #920, #3967
  static telaVitoria + #921, #3967
  static telaVitoria + #922, #3967
  static telaVitoria + #923, #3967
  static telaVitoria + #924, #3967
  static telaVitoria + #925, #3967
  static telaVitoria + #926, #3967
  static telaVitoria + #927, #3967
  static telaVitoria + #928, #3967
  static telaVitoria + #929, #3967
  static telaVitoria + #930, #3967
  static telaVitoria + #931, #3967
  static telaVitoria + #932, #3967
  static telaVitoria + #933, #3967
  static telaVitoria + #934, #3967
  static telaVitoria + #935, #3967
  static telaVitoria + #936, #3967
  static telaVitoria + #937, #3967
  static telaVitoria + #938, #3967
  static telaVitoria + #939, #3967
  static telaVitoria + #940, #3967
  static telaVitoria + #941, #3967
  static telaVitoria + #942, #3967
  static telaVitoria + #943, #3967
  static telaVitoria + #944, #3967
  static telaVitoria + #945, #3967
  static telaVitoria + #946, #3967
  static telaVitoria + #947, #3967
  static telaVitoria + #948, #3967
  static telaVitoria + #949, #3967
  static telaVitoria + #950, #3967
  static telaVitoria + #951, #3967
  static telaVitoria + #952, #3967
  static telaVitoria + #953, #3967
  static telaVitoria + #954, #3967
  static telaVitoria + #955, #3967
  static telaVitoria + #956, #3967
  static telaVitoria + #957, #3967
  static telaVitoria + #958, #3967
  static telaVitoria + #959, #3967

  ;Linha 24
  static telaVitoria + #960, #3967
  static telaVitoria + #961, #3967
  static telaVitoria + #962, #3967
  static telaVitoria + #963, #3967
  static telaVitoria + #964, #3967
  static telaVitoria + #965, #3967
  static telaVitoria + #966, #3967
  static telaVitoria + #967, #3967
  static telaVitoria + #968, #3967
  static telaVitoria + #969, #3967
  static telaVitoria + #970, #3967
  static telaVitoria + #971, #3967
  static telaVitoria + #972, #3967
  static telaVitoria + #973, #3967
  static telaVitoria + #974, #3967
  static telaVitoria + #975, #3967
  static telaVitoria + #976, #3967
  static telaVitoria + #977, #3967
  static telaVitoria + #978, #3967
  static telaVitoria + #979, #3967
  static telaVitoria + #980, #3967
  static telaVitoria + #981, #3967
  static telaVitoria + #982, #3967
  static telaVitoria + #983, #3967
  static telaVitoria + #984, #3967
  static telaVitoria + #985, #3967
  static telaVitoria + #986, #3967
  static telaVitoria + #987, #3967
  static telaVitoria + #988, #3967
  static telaVitoria + #989, #3967
  static telaVitoria + #990, #3967
  static telaVitoria + #991, #3967
  static telaVitoria + #992, #3967
  static telaVitoria + #993, #3967
  static telaVitoria + #994, #3967
  static telaVitoria + #995, #3967
  static telaVitoria + #996, #3967
  static telaVitoria + #997, #3967
  static telaVitoria + #998, #3967
  static telaVitoria + #999, #3967

  ;Linha 25
  static telaVitoria + #1000, #3967
  static telaVitoria + #1001, #3967
  static telaVitoria + #1002, #3967
  static telaVitoria + #1003, #3967
  static telaVitoria + #1004, #3967
  static telaVitoria + #1005, #3967
  static telaVitoria + #1006, #3967
  static telaVitoria + #1007, #3967
  static telaVitoria + #1008, #3967
  static telaVitoria + #1009, #3967
  static telaVitoria + #1010, #3967
  static telaVitoria + #1011, #3967
  static telaVitoria + #1012, #3967
  static telaVitoria + #1013, #3967
  static telaVitoria + #1014, #3967
  static telaVitoria + #1015, #3967
  static telaVitoria + #1016, #3967
  static telaVitoria + #1017, #3967
  static telaVitoria + #1018, #3967
  static telaVitoria + #1019, #3967
  static telaVitoria + #1020, #3967
  static telaVitoria + #1021, #3967
  static telaVitoria + #1022, #3967
  static telaVitoria + #1023, #3967
  static telaVitoria + #1024, #3967
  static telaVitoria + #1025, #3967
  static telaVitoria + #1026, #3967
  static telaVitoria + #1027, #3967
  static telaVitoria + #1028, #3967
  static telaVitoria + #1029, #3967
  static telaVitoria + #1030, #3967
  static telaVitoria + #1031, #3967
  static telaVitoria + #1032, #3967
  static telaVitoria + #1033, #3967
  static telaVitoria + #1034, #3967
  static telaVitoria + #1035, #3967
  static telaVitoria + #1036, #3967
  static telaVitoria + #1037, #3967
  static telaVitoria + #1038, #3967
  static telaVitoria + #1039, #3967

  ;Linha 26
  static telaVitoria + #1040, #3967
  static telaVitoria + #1041, #3967
  static telaVitoria + #1042, #3967
  static telaVitoria + #1043, #3967
  static telaVitoria + #1044, #3967
  static telaVitoria + #1045, #3967
  static telaVitoria + #1046, #3967
  static telaVitoria + #1047, #3967
  static telaVitoria + #1048, #3967
  static telaVitoria + #1049, #3967
  static telaVitoria + #1050, #3967
  static telaVitoria + #1051, #3967
  static telaVitoria + #1052, #3967
  static telaVitoria + #1053, #3967
  static telaVitoria + #1054, #3967
  static telaVitoria + #1055, #3967
  static telaVitoria + #1056, #3967
  static telaVitoria + #1057, #3967
  static telaVitoria + #1058, #3967
  static telaVitoria + #1059, #3967
  static telaVitoria + #1060, #3967
  static telaVitoria + #1061, #3967
  static telaVitoria + #1062, #3967
  static telaVitoria + #1063, #3967
  static telaVitoria + #1064, #3967
  static telaVitoria + #1065, #3967
  static telaVitoria + #1066, #3967
  static telaVitoria + #1067, #3967
  static telaVitoria + #1068, #3967
  static telaVitoria + #1069, #3967
  static telaVitoria + #1070, #3967
  static telaVitoria + #1071, #3967
  static telaVitoria + #1072, #3967
  static telaVitoria + #1073, #3967
  static telaVitoria + #1074, #3967
  static telaVitoria + #1075, #3967
  static telaVitoria + #1076, #3967
  static telaVitoria + #1077, #3967
  static telaVitoria + #1078, #3967
  static telaVitoria + #1079, #3967

  ;Linha 27
  static telaVitoria + #1080, #3967
  static telaVitoria + #1081, #3967
  static telaVitoria + #1082, #3967
  static telaVitoria + #1083, #3967
  static telaVitoria + #1084, #3967
  static telaVitoria + #1085, #3967
  static telaVitoria + #1086, #3967
  static telaVitoria + #1087, #3967
  static telaVitoria + #1088, #3967
  static telaVitoria + #1089, #3967
  static telaVitoria + #1090, #3967
  static telaVitoria + #1091, #3967
  static telaVitoria + #1092, #3967
  static telaVitoria + #1093, #3967
  static telaVitoria + #1094, #3967
  static telaVitoria + #1095, #3967
  static telaVitoria + #1096, #3967
  static telaVitoria + #1097, #3967
  static telaVitoria + #1098, #3967
  static telaVitoria + #1099, #3967
  static telaVitoria + #1100, #3967
  static telaVitoria + #1101, #3967
  static telaVitoria + #1102, #3967
  static telaVitoria + #1103, #3967
  static telaVitoria + #1104, #3967
  static telaVitoria + #1105, #3967
  static telaVitoria + #1106, #3967
  static telaVitoria + #1107, #3967
  static telaVitoria + #1108, #3967
  static telaVitoria + #1109, #3967
  static telaVitoria + #1110, #3967
  static telaVitoria + #1111, #3967
  static telaVitoria + #1112, #3967
  static telaVitoria + #1113, #3967
  static telaVitoria + #1114, #3967
  static telaVitoria + #1115, #3967
  static telaVitoria + #1116, #3967
  static telaVitoria + #1117, #3967
  static telaVitoria + #1118, #3967
  static telaVitoria + #1119, #3967

  ;Linha 28
  static telaVitoria + #1120, #3967
  static telaVitoria + #1121, #3967
  static telaVitoria + #1122, #3967
  static telaVitoria + #1123, #3967
  static telaVitoria + #1124, #3967
  static telaVitoria + #1125, #3967
  static telaVitoria + #1126, #3967
  static telaVitoria + #1127, #3967
  static telaVitoria + #1128, #3967
  static telaVitoria + #1129, #3967
  static telaVitoria + #1130, #3967
  static telaVitoria + #1131, #3967
  static telaVitoria + #1132, #3967
  static telaVitoria + #1133, #3967
  static telaVitoria + #1134, #3967
  static telaVitoria + #1135, #3967
  static telaVitoria + #1136, #3967
  static telaVitoria + #1137, #3967
  static telaVitoria + #1138, #3967
  static telaVitoria + #1139, #3967
  static telaVitoria + #1140, #3967
  static telaVitoria + #1141, #3967
  static telaVitoria + #1142, #3967
  static telaVitoria + #1143, #3967
  static telaVitoria + #1144, #3967
  static telaVitoria + #1145, #3967
  static telaVitoria + #1146, #3967
  static telaVitoria + #1147, #3967
  static telaVitoria + #1148, #3967
  static telaVitoria + #1149, #3967
  static telaVitoria + #1150, #3967
  static telaVitoria + #1151, #3967
  static telaVitoria + #1152, #3967
  static telaVitoria + #1153, #3967
  static telaVitoria + #1154, #3967
  static telaVitoria + #1155, #3967
  static telaVitoria + #1156, #3967
  static telaVitoria + #1157, #3967
  static telaVitoria + #1158, #3967
  static telaVitoria + #1159, #3967

  ;Linha 29
  static telaVitoria + #1160, #3967
  static telaVitoria + #1161, #3967
  static telaVitoria + #1162, #3967
  static telaVitoria + #1163, #3967
  static telaVitoria + #1164, #3967
  static telaVitoria + #1165, #3967
  static telaVitoria + #1166, #3967
  static telaVitoria + #1167, #3967
  static telaVitoria + #1168, #3967
  static telaVitoria + #1169, #3967
  static telaVitoria + #1170, #3967
  static telaVitoria + #1171, #3967
  static telaVitoria + #1172, #3967
  static telaVitoria + #1173, #3967
  static telaVitoria + #1174, #3967
  static telaVitoria + #1175, #3967
  static telaVitoria + #1176, #3967
  static telaVitoria + #1177, #3967
  static telaVitoria + #1178, #3967
  static telaVitoria + #1179, #3967
  static telaVitoria + #1180, #3967
  static telaVitoria + #1181, #3967
  static telaVitoria + #1182, #3967
  static telaVitoria + #1183, #3967
  static telaVitoria + #1184, #3967
  static telaVitoria + #1185, #3967
  static telaVitoria + #1186, #3967
  static telaVitoria + #1187, #3967
  static telaVitoria + #1188, #3967
  static telaVitoria + #1189, #3967
  static telaVitoria + #1190, #3967
  static telaVitoria + #1191, #3967
  static telaVitoria + #1192, #3967
  static telaVitoria + #1193, #3967
  static telaVitoria + #1194, #3967
  static telaVitoria + #1195, #3967
  static telaVitoria + #1196, #3967
  static telaVitoria + #1197, #3967
  static telaVitoria + #1198, #3967
  static telaVitoria + #1199, #3967

printtelaVitoriaScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #telaVitoria
  loadn R1, #0
  loadn R2, #1200

  printtelaVitoriaScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printtelaVitoriaScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

telaDerrota : var #1200
  ;Linha 0
  static telaDerrota + #0, #3967
  static telaDerrota + #1, #3967
  static telaDerrota + #2, #3967
  static telaDerrota + #3, #3967
  static telaDerrota + #4, #3967
  static telaDerrota + #5, #3967
  static telaDerrota + #6, #3967
  static telaDerrota + #7, #3967
  static telaDerrota + #8, #3967
  static telaDerrota + #9, #3967
  static telaDerrota + #10, #3967
  static telaDerrota + #11, #3967
  static telaDerrota + #12, #3967
  static telaDerrota + #13, #3967
  static telaDerrota + #14, #3967
  static telaDerrota + #15, #3967
  static telaDerrota + #16, #3967
  static telaDerrota + #17, #3967
  static telaDerrota + #18, #3967
  static telaDerrota + #19, #3967
  static telaDerrota + #20, #3967
  static telaDerrota + #21, #3967
  static telaDerrota + #22, #3967
  static telaDerrota + #23, #3967
  static telaDerrota + #24, #3967
  static telaDerrota + #25, #3967
  static telaDerrota + #26, #3967
  static telaDerrota + #27, #3967
  static telaDerrota + #28, #3967
  static telaDerrota + #29, #3967
  static telaDerrota + #30, #3967
  static telaDerrota + #31, #3967
  static telaDerrota + #32, #3967
  static telaDerrota + #33, #3967
  static telaDerrota + #34, #3967
  static telaDerrota + #35, #3967
  static telaDerrota + #36, #3967
  static telaDerrota + #37, #3967
  static telaDerrota + #38, #3967
  static telaDerrota + #39, #3967

  ;Linha 1
  static telaDerrota + #40, #3967
  static telaDerrota + #41, #3967
  static telaDerrota + #42, #3967
  static telaDerrota + #43, #3967
  static telaDerrota + #44, #3967
  static telaDerrota + #45, #3967
  static telaDerrota + #46, #3967
  static telaDerrota + #47, #3967
  static telaDerrota + #48, #3967
  static telaDerrota + #49, #3967
  static telaDerrota + #50, #3967
  static telaDerrota + #51, #3967
  static telaDerrota + #52, #3967
  static telaDerrota + #53, #3967
  static telaDerrota + #54, #3967
  static telaDerrota + #55, #3967
  static telaDerrota + #56, #3967
  static telaDerrota + #57, #3967
  static telaDerrota + #58, #3967
  static telaDerrota + #59, #3967
  static telaDerrota + #60, #3967
  static telaDerrota + #61, #3967
  static telaDerrota + #62, #3967
  static telaDerrota + #63, #3967
  static telaDerrota + #64, #3967
  static telaDerrota + #65, #3967
  static telaDerrota + #66, #3967
  static telaDerrota + #67, #3967
  static telaDerrota + #68, #3967
  static telaDerrota + #69, #3967
  static telaDerrota + #70, #3967
  static telaDerrota + #71, #3967
  static telaDerrota + #72, #3967
  static telaDerrota + #73, #3967
  static telaDerrota + #74, #3967
  static telaDerrota + #75, #3967
  static telaDerrota + #76, #3967
  static telaDerrota + #77, #3967
  static telaDerrota + #78, #3967
  static telaDerrota + #79, #3967

  ;Linha 2
  static telaDerrota + #80, #3967
  static telaDerrota + #81, #3967
  static telaDerrota + #82, #3967
  static telaDerrota + #83, #3967
  static telaDerrota + #84, #3967
  static telaDerrota + #85, #3967
  static telaDerrota + #86, #3967
  static telaDerrota + #87, #3967
  static telaDerrota + #88, #3967
  static telaDerrota + #89, #3967
  static telaDerrota + #90, #3967
  static telaDerrota + #91, #3967
  static telaDerrota + #92, #3967
  static telaDerrota + #93, #3967
  static telaDerrota + #94, #3967
  static telaDerrota + #95, #3967
  static telaDerrota + #96, #3967
  static telaDerrota + #97, #3166
  static telaDerrota + #98, #3967
  static telaDerrota + #99, #3967
  static telaDerrota + #100, #3967
  static telaDerrota + #101, #3967
  static telaDerrota + #102, #3967
  static telaDerrota + #103, #3967
  static telaDerrota + #104, #3967
  static telaDerrota + #105, #3967
  static telaDerrota + #106, #3967
  static telaDerrota + #107, #3967
  static telaDerrota + #108, #3967
  static telaDerrota + #109, #3967
  static telaDerrota + #110, #3967
  static telaDerrota + #111, #3967
  static telaDerrota + #112, #3967
  static telaDerrota + #113, #3967
  static telaDerrota + #114, #3967
  static telaDerrota + #115, #3967
  static telaDerrota + #116, #3967
  static telaDerrota + #117, #3967
  static telaDerrota + #118, #3967
  static telaDerrota + #119, #3967

  ;Linha 3
  static telaDerrota + #120, #3967
  static telaDerrota + #121, #3967
  static telaDerrota + #122, #3967
  static telaDerrota + #123, #3967
  static telaDerrota + #124, #3967
  static telaDerrota + #125, #3967
  static telaDerrota + #126, #3967
  static telaDerrota + #127, #3967
  static telaDerrota + #128, #3967
  static telaDerrota + #129, #3967
  static telaDerrota + #130, #3967
  static telaDerrota + #131, #3967
  static telaDerrota + #132, #3967
  static telaDerrota + #133, #3967
  static telaDerrota + #134, #3158
  static telaDerrota + #135, #3183
  static telaDerrota + #136, #3171
  static telaDerrota + #137, #3173
  static telaDerrota + #138, #3967
  static telaDerrota + #139, #2416
  static telaDerrota + #140, #2405
  static telaDerrota + #141, #2418
  static telaDerrota + #142, #2404
  static telaDerrota + #143, #2405
  static telaDerrota + #144, #2421
  static telaDerrota + #145, #2337
  static telaDerrota + #146, #3967
  static telaDerrota + #147, #3967
  static telaDerrota + #148, #3967
  static telaDerrota + #149, #3967
  static telaDerrota + #150, #3967
  static telaDerrota + #151, #3967
  static telaDerrota + #152, #3967
  static telaDerrota + #153, #3967
  static telaDerrota + #154, #3967
  static telaDerrota + #155, #3967
  static telaDerrota + #156, #3967
  static telaDerrota + #157, #3967
  static telaDerrota + #158, #3967
  static telaDerrota + #159, #3967

  ;Linha 4
  static telaDerrota + #160, #3967
  static telaDerrota + #161, #3967
  static telaDerrota + #162, #3967
  static telaDerrota + #163, #3967
  static telaDerrota + #164, #3967
  static telaDerrota + #165, #3967
  static telaDerrota + #166, #3967
  static telaDerrota + #167, #3967
  static telaDerrota + #168, #3967
  static telaDerrota + #169, #3967
  static telaDerrota + #170, #3967
  static telaDerrota + #171, #3967
  static telaDerrota + #172, #3967
  static telaDerrota + #173, #3967
  static telaDerrota + #174, #3091
  static telaDerrota + #175, #3967
  static telaDerrota + #176, #3967
  static telaDerrota + #177, #3967
  static telaDerrota + #178, #3967
  static telaDerrota + #179, #3967
  static telaDerrota + #180, #3967
  static telaDerrota + #181, #3967
  static telaDerrota + #182, #3967
  static telaDerrota + #183, #3967
  static telaDerrota + #184, #3967
  static telaDerrota + #185, #3967
  static telaDerrota + #186, #3967
  static telaDerrota + #187, #3967
  static telaDerrota + #188, #3967
  static telaDerrota + #189, #3967
  static telaDerrota + #190, #3967
  static telaDerrota + #191, #3967
  static telaDerrota + #192, #3967
  static telaDerrota + #193, #3967
  static telaDerrota + #194, #3967
  static telaDerrota + #195, #3967
  static telaDerrota + #196, #3967
  static telaDerrota + #197, #3967
  static telaDerrota + #198, #3967
  static telaDerrota + #199, #3967

  ;Linha 5
  static telaDerrota + #200, #3967
  static telaDerrota + #201, #3967
  static telaDerrota + #202, #3967
  static telaDerrota + #203, #3967
  static telaDerrota + #204, #3967
  static telaDerrota + #205, #3967
  static telaDerrota + #206, #3967
  static telaDerrota + #207, #3967
  static telaDerrota + #208, #3967
  static telaDerrota + #209, #3967
  static telaDerrota + #210, #3967
  static telaDerrota + #211, #3967
  static telaDerrota + #212, #3967
  static telaDerrota + #213, #3967
  static telaDerrota + #214, #3967
  static telaDerrota + #215, #3967
  static telaDerrota + #216, #3967
  static telaDerrota + #217, #3967
  static telaDerrota + #218, #3967
  static telaDerrota + #219, #3967
  static telaDerrota + #220, #3967
  static telaDerrota + #221, #3967
  static telaDerrota + #222, #3967
  static telaDerrota + #223, #3967
  static telaDerrota + #224, #3967
  static telaDerrota + #225, #3967
  static telaDerrota + #226, #3967
  static telaDerrota + #227, #3967
  static telaDerrota + #228, #3967
  static telaDerrota + #229, #3967
  static telaDerrota + #230, #3967
  static telaDerrota + #231, #3967
  static telaDerrota + #232, #3967
  static telaDerrota + #233, #3967
  static telaDerrota + #234, #3967
  static telaDerrota + #235, #3967
  static telaDerrota + #236, #3967
  static telaDerrota + #237, #3967
  static telaDerrota + #238, #3967
  static telaDerrota + #239, #3967

  ;Linha 6
  static telaDerrota + #240, #3967
  static telaDerrota + #241, #3967
  static telaDerrota + #242, #3967
  static telaDerrota + #243, #3967
  static telaDerrota + #244, #3967
  static telaDerrota + #245, #3967
  static telaDerrota + #246, #3967
  static telaDerrota + #247, #3967
  static telaDerrota + #248, #3967
  static telaDerrota + #249, #3967
  static telaDerrota + #250, #3967
  static telaDerrota + #251, #3967
  static telaDerrota + #252, #3967
  static telaDerrota + #253, #3967
  static telaDerrota + #254, #3967
  static telaDerrota + #255, #3967
  static telaDerrota + #256, #3967
  static telaDerrota + #257, #3967
  static telaDerrota + #258, #3967
  static telaDerrota + #259, #3967
  static telaDerrota + #260, #3967
  static telaDerrota + #261, #3967
  static telaDerrota + #262, #3967
  static telaDerrota + #263, #3967
  static telaDerrota + #264, #3967
  static telaDerrota + #265, #3967
  static telaDerrota + #266, #3967
  static telaDerrota + #267, #3967
  static telaDerrota + #268, #3967
  static telaDerrota + #269, #3967
  static telaDerrota + #270, #3967
  static telaDerrota + #271, #3967
  static telaDerrota + #272, #3967
  static telaDerrota + #273, #3967
  static telaDerrota + #274, #3967
  static telaDerrota + #275, #3967
  static telaDerrota + #276, #3967
  static telaDerrota + #277, #3967
  static telaDerrota + #278, #3967
  static telaDerrota + #279, #3967

  ;Linha 7
  static telaDerrota + #280, #3967
  static telaDerrota + #281, #3967
  static telaDerrota + #282, #3967
  static telaDerrota + #283, #3967
  static telaDerrota + #284, #3967
  static telaDerrota + #285, #3967
  static telaDerrota + #286, #3967
  static telaDerrota + #287, #3967
  static telaDerrota + #288, #3967
  static telaDerrota + #289, #3967
  static telaDerrota + #290, #3967
  static telaDerrota + #291, #3967
  static telaDerrota + #292, #3967
  static telaDerrota + #293, #3967
  static telaDerrota + #294, #3967
  static telaDerrota + #295, #3967
  static telaDerrota + #296, #3967
  static telaDerrota + #297, #3967
  static telaDerrota + #298, #3967
  static telaDerrota + #299, #3967
  static telaDerrota + #300, #3967
  static telaDerrota + #301, #3967
  static telaDerrota + #302, #3967
  static telaDerrota + #303, #3967
  static telaDerrota + #304, #3967
  static telaDerrota + #305, #3967
  static telaDerrota + #306, #3967
  static telaDerrota + #307, #3967
  static telaDerrota + #308, #3967
  static telaDerrota + #309, #3967
  static telaDerrota + #310, #3967
  static telaDerrota + #311, #3967
  static telaDerrota + #312, #3967
  static telaDerrota + #313, #3967
  static telaDerrota + #314, #3967
  static telaDerrota + #315, #3967
  static telaDerrota + #316, #3967
  static telaDerrota + #317, #3967
  static telaDerrota + #318, #3967
  static telaDerrota + #319, #3967

  ;Linha 8
  static telaDerrota + #320, #3967
  static telaDerrota + #321, #3967
  static telaDerrota + #322, #3967
  static telaDerrota + #323, #3967
  static telaDerrota + #324, #3967
  static telaDerrota + #325, #3967
  static telaDerrota + #326, #3967
  static telaDerrota + #327, #3967
  static telaDerrota + #328, #3967
  static telaDerrota + #329, #3967
  static telaDerrota + #330, #3967
  static telaDerrota + #331, #3967
  static telaDerrota + #332, #3967
  static telaDerrota + #333, #3967
  static telaDerrota + #334, #3967
  static telaDerrota + #335, #3967
  static telaDerrota + #336, #3967
  static telaDerrota + #337, #3967
  static telaDerrota + #338, #3967
  static telaDerrota + #339, #3967
  static telaDerrota + #340, #3967
  static telaDerrota + #341, #3967
  static telaDerrota + #342, #3967
  static telaDerrota + #343, #3967
  static telaDerrota + #344, #3967
  static telaDerrota + #345, #3967
  static telaDerrota + #346, #3967
  static telaDerrota + #347, #3967
  static telaDerrota + #348, #3967
  static telaDerrota + #349, #3967
  static telaDerrota + #350, #3967
  static telaDerrota + #351, #3967
  static telaDerrota + #352, #3967
  static telaDerrota + #353, #3967
  static telaDerrota + #354, #3967
  static telaDerrota + #355, #3967
  static telaDerrota + #356, #3967
  static telaDerrota + #357, #3967
  static telaDerrota + #358, #3967
  static telaDerrota + #359, #3967

  ;Linha 9
  static telaDerrota + #360, #3967
  static telaDerrota + #361, #3967
  static telaDerrota + #362, #3967
  static telaDerrota + #363, #3967
  static telaDerrota + #364, #3967
  static telaDerrota + #365, #3967
  static telaDerrota + #366, #3967
  static telaDerrota + #367, #3967
  static telaDerrota + #368, #3967
  static telaDerrota + #369, #3967
  static telaDerrota + #370, #3967
  static telaDerrota + #371, #3967
  static telaDerrota + #372, #3967
  static telaDerrota + #373, #3967
  static telaDerrota + #374, #3967
  static telaDerrota + #375, #3967
  static telaDerrota + #376, #3967
  static telaDerrota + #377, #3967
  static telaDerrota + #378, #3967
  static telaDerrota + #379, #3967
  static telaDerrota + #380, #3967
  static telaDerrota + #381, #3967
  static telaDerrota + #382, #3967
  static telaDerrota + #383, #3967
  static telaDerrota + #384, #3967
  static telaDerrota + #385, #3967
  static telaDerrota + #386, #3967
  static telaDerrota + #387, #3967
  static telaDerrota + #388, #3967
  static telaDerrota + #389, #3967
  static telaDerrota + #390, #3967
  static telaDerrota + #391, #3967
  static telaDerrota + #392, #3967
  static telaDerrota + #393, #3967
  static telaDerrota + #394, #3967
  static telaDerrota + #395, #3967
  static telaDerrota + #396, #3967
  static telaDerrota + #397, #3967
  static telaDerrota + #398, #3967
  static telaDerrota + #399, #3967

  ;Linha 10
  static telaDerrota + #400, #3967
  static telaDerrota + #401, #3967
  static telaDerrota + #402, #3967
  static telaDerrota + #403, #3967
  static telaDerrota + #404, #3967
  static telaDerrota + #405, #3967
  static telaDerrota + #406, #3967
  static telaDerrota + #407, #3967
  static telaDerrota + #408, #3967
  static telaDerrota + #409, #3967
  static telaDerrota + #410, #3967
  static telaDerrota + #411, #3967
  static telaDerrota + #412, #3967
  static telaDerrota + #413, #3967
  static telaDerrota + #414, #3967
  static telaDerrota + #415, #3967
  static telaDerrota + #416, #3967
  static telaDerrota + #417, #3967
  static telaDerrota + #418, #3967
  static telaDerrota + #419, #3967
  static telaDerrota + #420, #3967
  static telaDerrota + #421, #3967
  static telaDerrota + #422, #3967
  static telaDerrota + #423, #3967
  static telaDerrota + #424, #3967
  static telaDerrota + #425, #3967
  static telaDerrota + #426, #3967
  static telaDerrota + #427, #3967
  static telaDerrota + #428, #3967
  static telaDerrota + #429, #3967
  static telaDerrota + #430, #3967
  static telaDerrota + #431, #3967
  static telaDerrota + #432, #3967
  static telaDerrota + #433, #3967
  static telaDerrota + #434, #3967
  static telaDerrota + #435, #3967
  static telaDerrota + #436, #3967
  static telaDerrota + #437, #3967
  static telaDerrota + #438, #3967
  static telaDerrota + #439, #3967

  ;Linha 11
  static telaDerrota + #440, #3967
  static telaDerrota + #441, #3967
  static telaDerrota + #442, #3967
  static telaDerrota + #443, #3967
  static telaDerrota + #444, #3967
  static telaDerrota + #445, #3967
  static telaDerrota + #446, #3967
  static telaDerrota + #447, #3967
  static telaDerrota + #448, #3967
  static telaDerrota + #449, #3967
  static telaDerrota + #450, #3967
  static telaDerrota + #451, #3967
  static telaDerrota + #452, #3967
  static telaDerrota + #453, #3967
  static telaDerrota + #454, #3967
  static telaDerrota + #455, #3967
  static telaDerrota + #456, #3967
  static telaDerrota + #457, #3967
  static telaDerrota + #458, #3967
  static telaDerrota + #459, #3967
  static telaDerrota + #460, #3967
  static telaDerrota + #461, #3967
  static telaDerrota + #462, #3967
  static telaDerrota + #463, #3967
  static telaDerrota + #464, #3967
  static telaDerrota + #465, #3967
  static telaDerrota + #466, #3967
  static telaDerrota + #467, #3967
  static telaDerrota + #468, #3967
  static telaDerrota + #469, #3967
  static telaDerrota + #470, #3967
  static telaDerrota + #471, #3967
  static telaDerrota + #472, #3967
  static telaDerrota + #473, #3967
  static telaDerrota + #474, #3967
  static telaDerrota + #475, #3967
  static telaDerrota + #476, #3967
  static telaDerrota + #477, #3967
  static telaDerrota + #478, #3967
  static telaDerrota + #479, #3967

  ;Linha 12
  static telaDerrota + #480, #3967
  static telaDerrota + #481, #3967
  static telaDerrota + #482, #3967
  static telaDerrota + #483, #3967
  static telaDerrota + #484, #3967
  static telaDerrota + #485, #3967
  static telaDerrota + #486, #3967
  static telaDerrota + #487, #3967
  static telaDerrota + #488, #3967
  static telaDerrota + #489, #3967
  static telaDerrota + #490, #3967
  static telaDerrota + #491, #3967
  static telaDerrota + #492, #3967
  static telaDerrota + #493, #3967
  static telaDerrota + #494, #3967
  static telaDerrota + #495, #3967
  static telaDerrota + #496, #3967
  static telaDerrota + #497, #3967
  static telaDerrota + #498, #3967
  static telaDerrota + #499, #3967
  static telaDerrota + #500, #3967
  static telaDerrota + #501, #3967
  static telaDerrota + #502, #3967
  static telaDerrota + #503, #3967
  static telaDerrota + #504, #3967
  static telaDerrota + #505, #3967
  static telaDerrota + #506, #3967
  static telaDerrota + #507, #3967
  static telaDerrota + #508, #3967
  static telaDerrota + #509, #3967
  static telaDerrota + #510, #3967
  static telaDerrota + #511, #3967
  static telaDerrota + #512, #3967
  static telaDerrota + #513, #3967
  static telaDerrota + #514, #3967
  static telaDerrota + #515, #3967
  static telaDerrota + #516, #3967
  static telaDerrota + #517, #3967
  static telaDerrota + #518, #3967
  static telaDerrota + #519, #3967

  ;Linha 13
  static telaDerrota + #520, #3967
  static telaDerrota + #521, #3967
  static telaDerrota + #522, #3967
  static telaDerrota + #523, #3967
  static telaDerrota + #524, #3967
  static telaDerrota + #525, #3967
  static telaDerrota + #526, #3967
  static telaDerrota + #527, #3967
  static telaDerrota + #528, #3967
  static telaDerrota + #529, #3967
  static telaDerrota + #530, #3967
  static telaDerrota + #531, #3967
  static telaDerrota + #532, #3967
  static telaDerrota + #533, #3967
  static telaDerrota + #534, #3967
  static telaDerrota + #535, #3967
  static telaDerrota + #536, #3967
  static telaDerrota + #537, #3967
  static telaDerrota + #538, #3967
  static telaDerrota + #539, #3967
  static telaDerrota + #540, #3967
  static telaDerrota + #541, #3967
  static telaDerrota + #542, #3967
  static telaDerrota + #543, #3967
  static telaDerrota + #544, #3967
  static telaDerrota + #545, #3967
  static telaDerrota + #546, #3967
  static telaDerrota + #547, #3967
  static telaDerrota + #548, #3967
  static telaDerrota + #549, #3967
  static telaDerrota + #550, #3967
  static telaDerrota + #551, #3967
  static telaDerrota + #552, #3967
  static telaDerrota + #553, #3967
  static telaDerrota + #554, #3967
  static telaDerrota + #555, #3967
  static telaDerrota + #556, #3967
  static telaDerrota + #557, #3967
  static telaDerrota + #558, #3967
  static telaDerrota + #559, #3967

  ;Linha 14
  static telaDerrota + #560, #3967
  static telaDerrota + #561, #3967
  static telaDerrota + #562, #3967
  static telaDerrota + #563, #3967
  static telaDerrota + #564, #3967
  static telaDerrota + #565, #3967
  static telaDerrota + #566, #3967
  static telaDerrota + #567, #3967
  static telaDerrota + #568, #3967
  static telaDerrota + #569, #3967
  static telaDerrota + #570, #3967
  static telaDerrota + #571, #3967
  static telaDerrota + #572, #3967
  static telaDerrota + #573, #3967
  static telaDerrota + #574, #3967
  static telaDerrota + #575, #3967
  static telaDerrota + #576, #3967
  static telaDerrota + #577, #3967
  static telaDerrota + #578, #3967
  static telaDerrota + #579, #3967
  static telaDerrota + #580, #3967
  static telaDerrota + #581, #3967
  static telaDerrota + #582, #3967
  static telaDerrota + #583, #3967
  static telaDerrota + #584, #3967
  static telaDerrota + #585, #3967
  static telaDerrota + #586, #3967
  static telaDerrota + #587, #3967
  static telaDerrota + #588, #3967
  static telaDerrota + #589, #3967
  static telaDerrota + #590, #3967
  static telaDerrota + #591, #3967
  static telaDerrota + #592, #3967
  static telaDerrota + #593, #3967
  static telaDerrota + #594, #3967
  static telaDerrota + #595, #3967
  static telaDerrota + #596, #3967
  static telaDerrota + #597, #3967
  static telaDerrota + #598, #3967
  static telaDerrota + #599, #3967

  ;Linha 15
  static telaDerrota + #600, #3967
  static telaDerrota + #601, #3967
  static telaDerrota + #602, #3967
  static telaDerrota + #603, #3967
  static telaDerrota + #604, #3967
  static telaDerrota + #605, #3967
  static telaDerrota + #606, #3967
  static telaDerrota + #607, #3967
  static telaDerrota + #608, #3967
  static telaDerrota + #609, #3967
  static telaDerrota + #610, #3967
  static telaDerrota + #611, #3967
  static telaDerrota + #612, #3967
  static telaDerrota + #613, #3967
  static telaDerrota + #614, #3967
  static telaDerrota + #615, #3967
  static telaDerrota + #616, #3967
  static telaDerrota + #617, #3967
  static telaDerrota + #618, #3967
  static telaDerrota + #619, #3967
  static telaDerrota + #620, #3967
  static telaDerrota + #621, #3967
  static telaDerrota + #622, #3967
  static telaDerrota + #623, #3967
  static telaDerrota + #624, #3967
  static telaDerrota + #625, #3967
  static telaDerrota + #626, #3967
  static telaDerrota + #627, #3967
  static telaDerrota + #628, #3967
  static telaDerrota + #629, #3967
  static telaDerrota + #630, #3967
  static telaDerrota + #631, #3967
  static telaDerrota + #632, #3967
  static telaDerrota + #633, #3967
  static telaDerrota + #634, #3967
  static telaDerrota + #635, #3967
  static telaDerrota + #636, #3967
  static telaDerrota + #637, #3967
  static telaDerrota + #638, #3967
  static telaDerrota + #639, #3967

  ;Linha 16
  static telaDerrota + #640, #3967
  static telaDerrota + #641, #3967
  static telaDerrota + #642, #3967
  static telaDerrota + #643, #3967
  static telaDerrota + #644, #3967
  static telaDerrota + #645, #3967
  static telaDerrota + #646, #3967
  static telaDerrota + #647, #3967
  static telaDerrota + #648, #3967
  static telaDerrota + #649, #3967
  static telaDerrota + #650, #3967
  static telaDerrota + #651, #3967
  static telaDerrota + #652, #3967
  static telaDerrota + #653, #3967
  static telaDerrota + #654, #3967
  static telaDerrota + #655, #3967
  static telaDerrota + #656, #3967
  static telaDerrota + #657, #3967
  static telaDerrota + #658, #3967
  static telaDerrota + #659, #3967
  static telaDerrota + #660, #3967
  static telaDerrota + #661, #3967
  static telaDerrota + #662, #3967
  static telaDerrota + #663, #3967
  static telaDerrota + #664, #3967
  static telaDerrota + #665, #3967
  static telaDerrota + #666, #3967
  static telaDerrota + #667, #3967
  static telaDerrota + #668, #3967
  static telaDerrota + #669, #3967
  static telaDerrota + #670, #3967
  static telaDerrota + #671, #3967
  static telaDerrota + #672, #3967
  static telaDerrota + #673, #3967
  static telaDerrota + #674, #3967
  static telaDerrota + #675, #3967
  static telaDerrota + #676, #3967
  static telaDerrota + #677, #3967
  static telaDerrota + #678, #3967
  static telaDerrota + #679, #3967

  ;Linha 17
  static telaDerrota + #680, #3967
  static telaDerrota + #681, #3967
  static telaDerrota + #682, #3967
  static telaDerrota + #683, #3967
  static telaDerrota + #684, #3967
  static telaDerrota + #685, #3967
  static telaDerrota + #686, #3967
  static telaDerrota + #687, #3967
  static telaDerrota + #688, #3967
  static telaDerrota + #689, #3967
  static telaDerrota + #690, #3967
  static telaDerrota + #691, #3967
  static telaDerrota + #692, #3967
  static telaDerrota + #693, #3967
  static telaDerrota + #694, #3967
  static telaDerrota + #695, #3967
  static telaDerrota + #696, #3967
  static telaDerrota + #697, #3967
  static telaDerrota + #698, #3967
  static telaDerrota + #699, #3967
  static telaDerrota + #700, #3967
  static telaDerrota + #701, #3967
  static telaDerrota + #702, #3967
  static telaDerrota + #703, #3967
  static telaDerrota + #704, #3967
  static telaDerrota + #705, #3967
  static telaDerrota + #706, #3967
  static telaDerrota + #707, #3967
  static telaDerrota + #708, #3967
  static telaDerrota + #709, #3967
  static telaDerrota + #710, #3967
  static telaDerrota + #711, #3967
  static telaDerrota + #712, #3967
  static telaDerrota + #713, #3967
  static telaDerrota + #714, #3967
  static telaDerrota + #715, #3967
  static telaDerrota + #716, #3967
  static telaDerrota + #717, #3967
  static telaDerrota + #718, #3967
  static telaDerrota + #719, #3967

  ;Linha 18
  static telaDerrota + #720, #3967
  static telaDerrota + #721, #3967
  static telaDerrota + #722, #3967
  static telaDerrota + #723, #3967
  static telaDerrota + #724, #3967
  static telaDerrota + #725, #3967
  static telaDerrota + #726, #3967
  static telaDerrota + #727, #3967
  static telaDerrota + #728, #3967
  static telaDerrota + #729, #3967
  static telaDerrota + #730, #3967
  static telaDerrota + #731, #3967
  static telaDerrota + #732, #3967
  static telaDerrota + #733, #3967
  static telaDerrota + #734, #3967
  static telaDerrota + #735, #3967
  static telaDerrota + #736, #3967
  static telaDerrota + #737, #3967
  static telaDerrota + #738, #3967
  static telaDerrota + #739, #3967
  static telaDerrota + #740, #3967
  static telaDerrota + #741, #3967
  static telaDerrota + #742, #3967
  static telaDerrota + #743, #3967
  static telaDerrota + #744, #3967
  static telaDerrota + #745, #3967
  static telaDerrota + #746, #3967
  static telaDerrota + #747, #3967
  static telaDerrota + #748, #3967
  static telaDerrota + #749, #3967
  static telaDerrota + #750, #3967
  static telaDerrota + #751, #3967
  static telaDerrota + #752, #3967
  static telaDerrota + #753, #3967
  static telaDerrota + #754, #3967
  static telaDerrota + #755, #3967
  static telaDerrota + #756, #3967
  static telaDerrota + #757, #3967
  static telaDerrota + #758, #3967
  static telaDerrota + #759, #3967

  ;Linha 19
  static telaDerrota + #760, #3967
  static telaDerrota + #761, #3967
  static telaDerrota + #762, #3967
  static telaDerrota + #763, #3967
  static telaDerrota + #764, #3967
  static telaDerrota + #765, #3967
  static telaDerrota + #766, #3967
  static telaDerrota + #767, #3967
  static telaDerrota + #768, #3967
  static telaDerrota + #769, #3967
  static telaDerrota + #770, #3967
  static telaDerrota + #771, #3967
  static telaDerrota + #772, #3967
  static telaDerrota + #773, #3967
  static telaDerrota + #774, #3967
  static telaDerrota + #775, #3967
  static telaDerrota + #776, #3967
  static telaDerrota + #777, #3967
  static telaDerrota + #778, #3967
  static telaDerrota + #779, #3967
  static telaDerrota + #780, #3967
  static telaDerrota + #781, #3967
  static telaDerrota + #782, #3967
  static telaDerrota + #783, #3967
  static telaDerrota + #784, #3967
  static telaDerrota + #785, #3967
  static telaDerrota + #786, #3967
  static telaDerrota + #787, #3967
  static telaDerrota + #788, #3967
  static telaDerrota + #789, #3967
  static telaDerrota + #790, #3967
  static telaDerrota + #791, #3967
  static telaDerrota + #792, #3967
  static telaDerrota + #793, #3967
  static telaDerrota + #794, #3967
  static telaDerrota + #795, #3967
  static telaDerrota + #796, #3967
  static telaDerrota + #797, #3967
  static telaDerrota + #798, #3967
  static telaDerrota + #799, #3967

  ;Linha 20
  static telaDerrota + #800, #3967
  static telaDerrota + #801, #3967
  static telaDerrota + #802, #3967
  static telaDerrota + #803, #3967
  static telaDerrota + #804, #3967
  static telaDerrota + #805, #3967
  static telaDerrota + #806, #3967
  static telaDerrota + #807, #3967
  static telaDerrota + #808, #3967
  static telaDerrota + #809, #3967
  static telaDerrota + #810, #3967
  static telaDerrota + #811, #3967
  static telaDerrota + #812, #3967
  static telaDerrota + #813, #3967
  static telaDerrota + #814, #3967
  static telaDerrota + #815, #3967
  static telaDerrota + #816, #3967
  static telaDerrota + #817, #3967
  static telaDerrota + #818, #3967
  static telaDerrota + #819, #3967
  static telaDerrota + #820, #3967
  static telaDerrota + #821, #3967
  static telaDerrota + #822, #3967
  static telaDerrota + #823, #3967
  static telaDerrota + #824, #3967
  static telaDerrota + #825, #3967
  static telaDerrota + #826, #3967
  static telaDerrota + #827, #3967
  static telaDerrota + #828, #3967
  static telaDerrota + #829, #3967
  static telaDerrota + #830, #3967
  static telaDerrota + #831, #3967
  static telaDerrota + #832, #3967
  static telaDerrota + #833, #3967
  static telaDerrota + #834, #3967
  static telaDerrota + #835, #3967
  static telaDerrota + #836, #3967
  static telaDerrota + #837, #3967
  static telaDerrota + #838, #3967
  static telaDerrota + #839, #3967

  ;Linha 21
  static telaDerrota + #840, #3967
  static telaDerrota + #841, #3967
  static telaDerrota + #842, #3967
  static telaDerrota + #843, #3967
  static telaDerrota + #844, #3967
  static telaDerrota + #845, #3967
  static telaDerrota + #846, #3967
  static telaDerrota + #847, #3967
  static telaDerrota + #848, #3967
  static telaDerrota + #849, #3967
  static telaDerrota + #850, #3967
  static telaDerrota + #851, #3967
  static telaDerrota + #852, #3967
  static telaDerrota + #853, #3967
  static telaDerrota + #854, #3967
  static telaDerrota + #855, #3967
  static telaDerrota + #856, #3967
  static telaDerrota + #857, #3967
  static telaDerrota + #858, #3967
  static telaDerrota + #859, #3967
  static telaDerrota + #860, #3967
  static telaDerrota + #861, #3967
  static telaDerrota + #862, #3967
  static telaDerrota + #863, #3967
  static telaDerrota + #864, #3967
  static telaDerrota + #865, #3967
  static telaDerrota + #866, #3967
  static telaDerrota + #867, #3967
  static telaDerrota + #868, #3967
  static telaDerrota + #869, #3967
  static telaDerrota + #870, #3967
  static telaDerrota + #871, #3967
  static telaDerrota + #872, #3967
  static telaDerrota + #873, #3967
  static telaDerrota + #874, #3967
  static telaDerrota + #875, #3967
  static telaDerrota + #876, #3967
  static telaDerrota + #877, #3967
  static telaDerrota + #878, #3967
  static telaDerrota + #879, #3967

  ;Linha 22
  static telaDerrota + #880, #3967
  static telaDerrota + #881, #3967
  static telaDerrota + #882, #3967
  static telaDerrota + #883, #3967
  static telaDerrota + #884, #3967
  static telaDerrota + #885, #3967
  static telaDerrota + #886, #3967
  static telaDerrota + #887, #3967
  static telaDerrota + #888, #3967
  static telaDerrota + #889, #3967
  static telaDerrota + #890, #3967
  static telaDerrota + #891, #3967
  static telaDerrota + #892, #3967
  static telaDerrota + #893, #3967
  static telaDerrota + #894, #3967
  static telaDerrota + #895, #3967
  static telaDerrota + #896, #3967
  static telaDerrota + #897, #3967
  static telaDerrota + #898, #3967
  static telaDerrota + #899, #3967
  static telaDerrota + #900, #3967
  static telaDerrota + #901, #3967
  static telaDerrota + #902, #3967
  static telaDerrota + #903, #3967
  static telaDerrota + #904, #3967
  static telaDerrota + #905, #3967
  static telaDerrota + #906, #3967
  static telaDerrota + #907, #3967
  static telaDerrota + #908, #3967
  static telaDerrota + #909, #3967
  static telaDerrota + #910, #3967
  static telaDerrota + #911, #3967
  static telaDerrota + #912, #3967
  static telaDerrota + #913, #3967
  static telaDerrota + #914, #3967
  static telaDerrota + #915, #3967
  static telaDerrota + #916, #3967
  static telaDerrota + #917, #3967
  static telaDerrota + #918, #3967
  static telaDerrota + #919, #3967

  ;Linha 23
  static telaDerrota + #920, #3967
  static telaDerrota + #921, #3967
  static telaDerrota + #922, #3967
  static telaDerrota + #923, #3967
  static telaDerrota + #924, #3967
  static telaDerrota + #925, #3967
  static telaDerrota + #926, #3967
  static telaDerrota + #927, #3967
  static telaDerrota + #928, #3967
  static telaDerrota + #929, #3967
  static telaDerrota + #930, #3967
  static telaDerrota + #931, #3967
  static telaDerrota + #932, #3967
  static telaDerrota + #933, #3967
  static telaDerrota + #934, #3967
  static telaDerrota + #935, #3967
  static telaDerrota + #936, #3967
  static telaDerrota + #937, #3967
  static telaDerrota + #938, #3967
  static telaDerrota + #939, #3967
  static telaDerrota + #940, #3967
  static telaDerrota + #941, #3967
  static telaDerrota + #942, #3967
  static telaDerrota + #943, #3967
  static telaDerrota + #944, #3967
  static telaDerrota + #945, #3967
  static telaDerrota + #946, #3967
  static telaDerrota + #947, #3967
  static telaDerrota + #948, #3967
  static telaDerrota + #949, #3967
  static telaDerrota + #950, #3967
  static telaDerrota + #951, #3967
  static telaDerrota + #952, #3967
  static telaDerrota + #953, #3967
  static telaDerrota + #954, #3967
  static telaDerrota + #955, #3967
  static telaDerrota + #956, #3967
  static telaDerrota + #957, #3967
  static telaDerrota + #958, #3967
  static telaDerrota + #959, #3967

  ;Linha 24
  static telaDerrota + #960, #3967
  static telaDerrota + #961, #3967
  static telaDerrota + #962, #3967
  static telaDerrota + #963, #3967
  static telaDerrota + #964, #3967
  static telaDerrota + #965, #3967
  static telaDerrota + #966, #3967
  static telaDerrota + #967, #3967
  static telaDerrota + #968, #3967
  static telaDerrota + #969, #3967
  static telaDerrota + #970, #3967
  static telaDerrota + #971, #3967
  static telaDerrota + #972, #3967
  static telaDerrota + #973, #3967
  static telaDerrota + #974, #3967
  static telaDerrota + #975, #3967
  static telaDerrota + #976, #3967
  static telaDerrota + #977, #3967
  static telaDerrota + #978, #3967
  static telaDerrota + #979, #3967
  static telaDerrota + #980, #3967
  static telaDerrota + #981, #3967
  static telaDerrota + #982, #3967
  static telaDerrota + #983, #3967
  static telaDerrota + #984, #3967
  static telaDerrota + #985, #3967
  static telaDerrota + #986, #3967
  static telaDerrota + #987, #3967
  static telaDerrota + #988, #3967
  static telaDerrota + #989, #3967
  static telaDerrota + #990, #3967
  static telaDerrota + #991, #3967
  static telaDerrota + #992, #3967
  static telaDerrota + #993, #3967
  static telaDerrota + #994, #3967
  static telaDerrota + #995, #3967
  static telaDerrota + #996, #3967
  static telaDerrota + #997, #3967
  static telaDerrota + #998, #3967
  static telaDerrota + #999, #3967

  ;Linha 25
  static telaDerrota + #1000, #3967
  static telaDerrota + #1001, #3967
  static telaDerrota + #1002, #3967
  static telaDerrota + #1003, #3967
  static telaDerrota + #1004, #3967
  static telaDerrota + #1005, #3967
  static telaDerrota + #1006, #3967
  static telaDerrota + #1007, #3967
  static telaDerrota + #1008, #3967
  static telaDerrota + #1009, #3967
  static telaDerrota + #1010, #3967
  static telaDerrota + #1011, #3967
  static telaDerrota + #1012, #3967
  static telaDerrota + #1013, #3967
  static telaDerrota + #1014, #3967
  static telaDerrota + #1015, #3967
  static telaDerrota + #1016, #3967
  static telaDerrota + #1017, #3967
  static telaDerrota + #1018, #3967
  static telaDerrota + #1019, #3967
  static telaDerrota + #1020, #3967
  static telaDerrota + #1021, #3967
  static telaDerrota + #1022, #3967
  static telaDerrota + #1023, #3967
  static telaDerrota + #1024, #3967
  static telaDerrota + #1025, #3967
  static telaDerrota + #1026, #3967
  static telaDerrota + #1027, #3967
  static telaDerrota + #1028, #3967
  static telaDerrota + #1029, #3967
  static telaDerrota + #1030, #3967
  static telaDerrota + #1031, #3967
  static telaDerrota + #1032, #3967
  static telaDerrota + #1033, #3967
  static telaDerrota + #1034, #3967
  static telaDerrota + #1035, #3967
  static telaDerrota + #1036, #3967
  static telaDerrota + #1037, #3967
  static telaDerrota + #1038, #3967
  static telaDerrota + #1039, #3967

  ;Linha 26
  static telaDerrota + #1040, #3967
  static telaDerrota + #1041, #3967
  static telaDerrota + #1042, #3967
  static telaDerrota + #1043, #3967
  static telaDerrota + #1044, #3967
  static telaDerrota + #1045, #3967
  static telaDerrota + #1046, #3967
  static telaDerrota + #1047, #3967
  static telaDerrota + #1048, #3967
  static telaDerrota + #1049, #3967
  static telaDerrota + #1050, #3967
  static telaDerrota + #1051, #3967
  static telaDerrota + #1052, #3967
  static telaDerrota + #1053, #3967
  static telaDerrota + #1054, #3967
  static telaDerrota + #1055, #3967
  static telaDerrota + #1056, #3967
  static telaDerrota + #1057, #3967
  static telaDerrota + #1058, #3967
  static telaDerrota + #1059, #3967
  static telaDerrota + #1060, #3967
  static telaDerrota + #1061, #3967
  static telaDerrota + #1062, #3967
  static telaDerrota + #1063, #3967
  static telaDerrota + #1064, #3967
  static telaDerrota + #1065, #3967
  static telaDerrota + #1066, #3967
  static telaDerrota + #1067, #3967
  static telaDerrota + #1068, #3967
  static telaDerrota + #1069, #3967
  static telaDerrota + #1070, #3967
  static telaDerrota + #1071, #3967
  static telaDerrota + #1072, #3967
  static telaDerrota + #1073, #3967
  static telaDerrota + #1074, #3967
  static telaDerrota + #1075, #3967
  static telaDerrota + #1076, #3967
  static telaDerrota + #1077, #3967
  static telaDerrota + #1078, #3967
  static telaDerrota + #1079, #3967

  ;Linha 27
  static telaDerrota + #1080, #3967
  static telaDerrota + #1081, #3967
  static telaDerrota + #1082, #3967
  static telaDerrota + #1083, #3967
  static telaDerrota + #1084, #3967
  static telaDerrota + #1085, #3967
  static telaDerrota + #1086, #3967
  static telaDerrota + #1087, #3967
  static telaDerrota + #1088, #3967
  static telaDerrota + #1089, #3967
  static telaDerrota + #1090, #3967
  static telaDerrota + #1091, #3967
  static telaDerrota + #1092, #3967
  static telaDerrota + #1093, #3967
  static telaDerrota + #1094, #3967
  static telaDerrota + #1095, #3967
  static telaDerrota + #1096, #3967
  static telaDerrota + #1097, #3967
  static telaDerrota + #1098, #3967
  static telaDerrota + #1099, #3967
  static telaDerrota + #1100, #3967
  static telaDerrota + #1101, #3967
  static telaDerrota + #1102, #3967
  static telaDerrota + #1103, #3967
  static telaDerrota + #1104, #3967
  static telaDerrota + #1105, #3967
  static telaDerrota + #1106, #3967
  static telaDerrota + #1107, #3967
  static telaDerrota + #1108, #3967
  static telaDerrota + #1109, #3967
  static telaDerrota + #1110, #3967
  static telaDerrota + #1111, #3967
  static telaDerrota + #1112, #3967
  static telaDerrota + #1113, #3967
  static telaDerrota + #1114, #3967
  static telaDerrota + #1115, #3967
  static telaDerrota + #1116, #3967
  static telaDerrota + #1117, #3967
  static telaDerrota + #1118, #3967
  static telaDerrota + #1119, #3967

  ;Linha 28
  static telaDerrota + #1120, #3967
  static telaDerrota + #1121, #3967
  static telaDerrota + #1122, #3967
  static telaDerrota + #1123, #3967
  static telaDerrota + #1124, #3967
  static telaDerrota + #1125, #3967
  static telaDerrota + #1126, #3967
  static telaDerrota + #1127, #3967
  static telaDerrota + #1128, #3967
  static telaDerrota + #1129, #3967
  static telaDerrota + #1130, #3967
  static telaDerrota + #1131, #3967
  static telaDerrota + #1132, #3967
  static telaDerrota + #1133, #3967
  static telaDerrota + #1134, #3967
  static telaDerrota + #1135, #3967
  static telaDerrota + #1136, #3967
  static telaDerrota + #1137, #3967
  static telaDerrota + #1138, #3967
  static telaDerrota + #1139, #3967
  static telaDerrota + #1140, #3967
  static telaDerrota + #1141, #3967
  static telaDerrota + #1142, #3967
  static telaDerrota + #1143, #3967
  static telaDerrota + #1144, #3967
  static telaDerrota + #1145, #3967
  static telaDerrota + #1146, #3967
  static telaDerrota + #1147, #3967
  static telaDerrota + #1148, #3967
  static telaDerrota + #1149, #3967
  static telaDerrota + #1150, #3967
  static telaDerrota + #1151, #3967
  static telaDerrota + #1152, #3967
  static telaDerrota + #1153, #3967
  static telaDerrota + #1154, #3967
  static telaDerrota + #1155, #3967
  static telaDerrota + #1156, #3967
  static telaDerrota + #1157, #3967
  static telaDerrota + #1158, #3967
  static telaDerrota + #1159, #3967

  ;Linha 29
  static telaDerrota + #1160, #3967
  static telaDerrota + #1161, #3967
  static telaDerrota + #1162, #3967
  static telaDerrota + #1163, #3967
  static telaDerrota + #1164, #3967
  static telaDerrota + #1165, #3967
  static telaDerrota + #1166, #3967
  static telaDerrota + #1167, #3967
  static telaDerrota + #1168, #3967
  static telaDerrota + #1169, #3967
  static telaDerrota + #1170, #3967
  static telaDerrota + #1171, #3967
  static telaDerrota + #1172, #3967
  static telaDerrota + #1173, #3967
  static telaDerrota + #1174, #3967
  static telaDerrota + #1175, #3967
  static telaDerrota + #1176, #3967
  static telaDerrota + #1177, #3967
  static telaDerrota + #1178, #3967
  static telaDerrota + #1179, #3967
  static telaDerrota + #1180, #3967
  static telaDerrota + #1181, #3967
  static telaDerrota + #1182, #3967
  static telaDerrota + #1183, #3967
  static telaDerrota + #1184, #3967
  static telaDerrota + #1185, #3967
  static telaDerrota + #1186, #3967
  static telaDerrota + #1187, #3967
  static telaDerrota + #1188, #3967
  static telaDerrota + #1189, #3967
  static telaDerrota + #1190, #3967
  static telaDerrota + #1191, #3967
  static telaDerrota + #1192, #3967
  static telaDerrota + #1193, #3967
  static telaDerrota + #1194, #3967
  static telaDerrota + #1195, #3967
  static telaDerrota + #1196, #3967
  static telaDerrota + #1197, #3967
  static telaDerrota + #1198, #3967
  static telaDerrota + #1199, #3967

printtelaDerrotaScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #telaDerrota
  loadn R1, #0
  loadn R2, #1200

  printtelaDerrotaScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printtelaDerrotaScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts

telaVitoria : var #1200
  ;Linha 0
  static telaVitoria + #0, #3967
  static telaVitoria + #1, #3967
  static telaVitoria + #2, #3967
  static telaVitoria + #3, #3967
  static telaVitoria + #4, #3967
  static telaVitoria + #5, #3967
  static telaVitoria + #6, #3967
  static telaVitoria + #7, #3967
  static telaVitoria + #8, #3967
  static telaVitoria + #9, #3967
  static telaVitoria + #10, #3967
  static telaVitoria + #11, #3967
  static telaVitoria + #12, #3967
  static telaVitoria + #13, #3967
  static telaVitoria + #14, #3967
  static telaVitoria + #15, #3967
  static telaVitoria + #16, #3967
  static telaVitoria + #17, #3967
  static telaVitoria + #18, #3967
  static telaVitoria + #19, #3967
  static telaVitoria + #20, #3967
  static telaVitoria + #21, #3967
  static telaVitoria + #22, #3967
  static telaVitoria + #23, #3967
  static telaVitoria + #24, #3967
  static telaVitoria + #25, #3967
  static telaVitoria + #26, #3967
  static telaVitoria + #27, #3967
  static telaVitoria + #28, #3967
  static telaVitoria + #29, #3967
  static telaVitoria + #30, #3967
  static telaVitoria + #31, #3967
  static telaVitoria + #32, #3967
  static telaVitoria + #33, #3967
  static telaVitoria + #34, #3967
  static telaVitoria + #35, #3967
  static telaVitoria + #36, #3967
  static telaVitoria + #37, #3967
  static telaVitoria + #38, #3967
  static telaVitoria + #39, #3967

  ;Linha 1
  static telaVitoria + #40, #3967
  static telaVitoria + #41, #3967
  static telaVitoria + #42, #3967
  static telaVitoria + #43, #3967
  static telaVitoria + #44, #3967
  static telaVitoria + #45, #3967
  static telaVitoria + #46, #3967
  static telaVitoria + #47, #3967
  static telaVitoria + #48, #3967
  static telaVitoria + #49, #3967
  static telaVitoria + #50, #3967
  static telaVitoria + #51, #3967
  static telaVitoria + #52, #3967
  static telaVitoria + #53, #3967
  static telaVitoria + #54, #3967
  static telaVitoria + #55, #3967
  static telaVitoria + #56, #3967
  static telaVitoria + #57, #3967
  static telaVitoria + #58, #3967
  static telaVitoria + #59, #3967
  static telaVitoria + #60, #3967
  static telaVitoria + #61, #3967
  static telaVitoria + #62, #3967
  static telaVitoria + #63, #3967
  static telaVitoria + #64, #3967
  static telaVitoria + #65, #3967
  static telaVitoria + #66, #3967
  static telaVitoria + #67, #3967
  static telaVitoria + #68, #3967
  static telaVitoria + #69, #3967
  static telaVitoria + #70, #3967
  static telaVitoria + #71, #3967
  static telaVitoria + #72, #3967
  static telaVitoria + #73, #3967
  static telaVitoria + #74, #3967
  static telaVitoria + #75, #3967
  static telaVitoria + #76, #3967
  static telaVitoria + #77, #3967
  static telaVitoria + #78, #3967
  static telaVitoria + #79, #3967

  ;Linha 2
  static telaVitoria + #80, #3967
  static telaVitoria + #81, #3967
  static telaVitoria + #82, #3967
  static telaVitoria + #83, #3967
  static telaVitoria + #84, #3967
  static telaVitoria + #85, #3967
  static telaVitoria + #86, #3967
  static telaVitoria + #87, #3967
  static telaVitoria + #88, #3967
  static telaVitoria + #89, #3967
  static telaVitoria + #90, #3967
  static telaVitoria + #91, #3967
  static telaVitoria + #92, #3967
  static telaVitoria + #93, #3967
  static telaVitoria + #94, #3967
  static telaVitoria + #95, #3967
  static telaVitoria + #96, #3967
  static telaVitoria + #97, #3166
  static telaVitoria + #98, #3967
  static telaVitoria + #99, #3967
  static telaVitoria + #100, #3967
  static telaVitoria + #101, #3967
  static telaVitoria + #102, #3967
  static telaVitoria + #103, #3967
  static telaVitoria + #104, #3967
  static telaVitoria + #105, #3967
  static telaVitoria + #106, #3967
  static telaVitoria + #107, #3967
  static telaVitoria + #108, #3967
  static telaVitoria + #109, #3967
  static telaVitoria + #110, #3967
  static telaVitoria + #111, #3967
  static telaVitoria + #112, #3967
  static telaVitoria + #113, #3967
  static telaVitoria + #114, #3967
  static telaVitoria + #115, #3967
  static telaVitoria + #116, #3967
  static telaVitoria + #117, #3967
  static telaVitoria + #118, #3967
  static telaVitoria + #119, #3967

  ;Linha 3
  static telaVitoria + #120, #3967
  static telaVitoria + #121, #3967
  static telaVitoria + #122, #3967
  static telaVitoria + #123, #3967
  static telaVitoria + #124, #3967
  static telaVitoria + #125, #3967
  static telaVitoria + #126, #3967
  static telaVitoria + #127, #3967
  static telaVitoria + #128, #3967
  static telaVitoria + #129, #3967
  static telaVitoria + #130, #3967
  static telaVitoria + #131, #3967
  static telaVitoria + #132, #3967
  static telaVitoria + #133, #3967
  static telaVitoria + #134, #3158
  static telaVitoria + #135, #3183
  static telaVitoria + #136, #3171
  static telaVitoria + #137, #3173
  static telaVitoria + #138, #3967
  static telaVitoria + #139, #2934
  static telaVitoria + #140, #2917
  static telaVitoria + #141, #2926
  static telaVitoria + #142, #2915
  static telaVitoria + #143, #2917
  static telaVitoria + #144, #2933
  static telaVitoria + #145, #2849
  static telaVitoria + #146, #3967
  static telaVitoria + #147, #3967
  static telaVitoria + #148, #3967
  static telaVitoria + #149, #3967
  static telaVitoria + #150, #3967
  static telaVitoria + #151, #3967
  static telaVitoria + #152, #3967
  static telaVitoria + #153, #3967
  static telaVitoria + #154, #3967
  static telaVitoria + #155, #3967
  static telaVitoria + #156, #3967
  static telaVitoria + #157, #3967
  static telaVitoria + #158, #3967
  static telaVitoria + #159, #3967

  ;Linha 4
  static telaVitoria + #160, #3967
  static telaVitoria + #161, #3967
  static telaVitoria + #162, #3967
  static telaVitoria + #163, #3967
  static telaVitoria + #164, #3967
  static telaVitoria + #165, #3967
  static telaVitoria + #166, #3967
  static telaVitoria + #167, #3967
  static telaVitoria + #168, #3967
  static telaVitoria + #169, #3967
  static telaVitoria + #170, #3967
  static telaVitoria + #171, #3967
  static telaVitoria + #172, #3967
  static telaVitoria + #173, #3967
  static telaVitoria + #174, #3091
  static telaVitoria + #175, #3967
  static telaVitoria + #176, #3967
  static telaVitoria + #177, #3967
  static telaVitoria + #178, #3967
  static telaVitoria + #179, #3967
  static telaVitoria + #180, #3967
  static telaVitoria + #181, #3967
  static telaVitoria + #182, #3967
  static telaVitoria + #183, #3967
  static telaVitoria + #184, #3967
  static telaVitoria + #185, #3967
  static telaVitoria + #186, #3967
  static telaVitoria + #187, #3967
  static telaVitoria + #188, #3967
  static telaVitoria + #189, #3967
  static telaVitoria + #190, #3967
  static telaVitoria + #191, #3967
  static telaVitoria + #192, #3967
  static telaVitoria + #193, #3967
  static telaVitoria + #194, #3967
  static telaVitoria + #195, #3967
  static telaVitoria + #196, #3967
  static telaVitoria + #197, #3967
  static telaVitoria + #198, #3967
  static telaVitoria + #199, #3967

  ;Linha 5
  static telaVitoria + #200, #3967
  static telaVitoria + #201, #3967
  static telaVitoria + #202, #3967
  static telaVitoria + #203, #3967
  static telaVitoria + #204, #3967
  static telaVitoria + #205, #3967
  static telaVitoria + #206, #3967
  static telaVitoria + #207, #3967
  static telaVitoria + #208, #3967
  static telaVitoria + #209, #3967
  static telaVitoria + #210, #3967
  static telaVitoria + #211, #3967
  static telaVitoria + #212, #3967
  static telaVitoria + #213, #3967
  static telaVitoria + #214, #3967
  static telaVitoria + #215, #3967
  static telaVitoria + #216, #3967
  static telaVitoria + #217, #3967
  static telaVitoria + #218, #3967
  static telaVitoria + #219, #3967
  static telaVitoria + #220, #3967
  static telaVitoria + #221, #3967
  static telaVitoria + #222, #3967
  static telaVitoria + #223, #3967
  static telaVitoria + #224, #3967
  static telaVitoria + #225, #3967
  static telaVitoria + #226, #3967
  static telaVitoria + #227, #3967
  static telaVitoria + #228, #3967
  static telaVitoria + #229, #3967
  static telaVitoria + #230, #3967
  static telaVitoria + #231, #3967
  static telaVitoria + #232, #3967
  static telaVitoria + #233, #3967
  static telaVitoria + #234, #3967
  static telaVitoria + #235, #3967
  static telaVitoria + #236, #3967
  static telaVitoria + #237, #3967
  static telaVitoria + #238, #3967
  static telaVitoria + #239, #3967

  ;Linha 6
  static telaVitoria + #240, #3967
  static telaVitoria + #241, #3967
  static telaVitoria + #242, #3967
  static telaVitoria + #243, #3967
  static telaVitoria + #244, #3967
  static telaVitoria + #245, #3967
  static telaVitoria + #246, #3967
  static telaVitoria + #247, #3967
  static telaVitoria + #248, #3967
  static telaVitoria + #249, #3967
  static telaVitoria + #250, #3967
  static telaVitoria + #251, #3967
  static telaVitoria + #252, #3967
  static telaVitoria + #253, #3967
  static telaVitoria + #254, #3967
  static telaVitoria + #255, #3967
  static telaVitoria + #256, #3967
  static telaVitoria + #257, #3967
  static telaVitoria + #258, #3967
  static telaVitoria + #259, #3967
  static telaVitoria + #260, #3967
  static telaVitoria + #261, #3967
  static telaVitoria + #262, #3967
  static telaVitoria + #263, #3967
  static telaVitoria + #264, #3967
  static telaVitoria + #265, #3967
  static telaVitoria + #266, #3967
  static telaVitoria + #267, #3967
  static telaVitoria + #268, #3967
  static telaVitoria + #269, #3967
  static telaVitoria + #270, #3967
  static telaVitoria + #271, #3967
  static telaVitoria + #272, #3967
  static telaVitoria + #273, #3967
  static telaVitoria + #274, #3967
  static telaVitoria + #275, #3967
  static telaVitoria + #276, #3967
  static telaVitoria + #277, #3967
  static telaVitoria + #278, #3967
  static telaVitoria + #279, #3967

  ;Linha 7
  static telaVitoria + #280, #3967
  static telaVitoria + #281, #3967
  static telaVitoria + #282, #3967
  static telaVitoria + #283, #3967
  static telaVitoria + #284, #3967
  static telaVitoria + #285, #3967
  static telaVitoria + #286, #3967
  static telaVitoria + #287, #3967
  static telaVitoria + #288, #3967
  static telaVitoria + #289, #3967
  static telaVitoria + #290, #3967
  static telaVitoria + #291, #3967
  static telaVitoria + #292, #3967
  static telaVitoria + #293, #3967
  static telaVitoria + #294, #3967
  static telaVitoria + #295, #3967
  static telaVitoria + #296, #3967
  static telaVitoria + #297, #3967
  static telaVitoria + #298, #3967
  static telaVitoria + #299, #3967
  static telaVitoria + #300, #3967
  static telaVitoria + #301, #3967
  static telaVitoria + #302, #3967
  static telaVitoria + #303, #3967
  static telaVitoria + #304, #3967
  static telaVitoria + #305, #3967
  static telaVitoria + #306, #3967
  static telaVitoria + #307, #3967
  static telaVitoria + #308, #3967
  static telaVitoria + #309, #3967
  static telaVitoria + #310, #3967
  static telaVitoria + #311, #3967
  static telaVitoria + #312, #3967
  static telaVitoria + #313, #3967
  static telaVitoria + #314, #3967
  static telaVitoria + #315, #3967
  static telaVitoria + #316, #3967
  static telaVitoria + #317, #3967
  static telaVitoria + #318, #3967
  static telaVitoria + #319, #3967

  ;Linha 8
  static telaVitoria + #320, #3967
  static telaVitoria + #321, #3967
  static telaVitoria + #322, #3967
  static telaVitoria + #323, #3967
  static telaVitoria + #324, #3967
  static telaVitoria + #325, #3967
  static telaVitoria + #326, #3967
  static telaVitoria + #327, #3967
  static telaVitoria + #328, #3967
  static telaVitoria + #329, #3967
  static telaVitoria + #330, #3967
  static telaVitoria + #331, #3967
  static telaVitoria + #332, #3967
  static telaVitoria + #333, #3967
  static telaVitoria + #334, #3967
  static telaVitoria + #335, #3967
  static telaVitoria + #336, #3967
  static telaVitoria + #337, #3967
  static telaVitoria + #338, #3967
  static telaVitoria + #339, #3967
  static telaVitoria + #340, #3967
  static telaVitoria + #341, #3967
  static telaVitoria + #342, #3967
  static telaVitoria + #343, #3967
  static telaVitoria + #344, #3967
  static telaVitoria + #345, #3967
  static telaVitoria + #346, #3967
  static telaVitoria + #347, #3967
  static telaVitoria + #348, #3967
  static telaVitoria + #349, #3967
  static telaVitoria + #350, #3967
  static telaVitoria + #351, #3967
  static telaVitoria + #352, #3967
  static telaVitoria + #353, #3967
  static telaVitoria + #354, #3967
  static telaVitoria + #355, #3967
  static telaVitoria + #356, #3967
  static telaVitoria + #357, #3967
  static telaVitoria + #358, #3967
  static telaVitoria + #359, #3967

  ;Linha 9
  static telaVitoria + #360, #3967
  static telaVitoria + #361, #3967
  static telaVitoria + #362, #3967
  static telaVitoria + #363, #3967
  static telaVitoria + #364, #3967
  static telaVitoria + #365, #3967
  static telaVitoria + #366, #3967
  static telaVitoria + #367, #3967
  static telaVitoria + #368, #3967
  static telaVitoria + #369, #3967
  static telaVitoria + #370, #3967
  static telaVitoria + #371, #3967
  static telaVitoria + #372, #3967
  static telaVitoria + #373, #3967
  static telaVitoria + #374, #3967
  static telaVitoria + #375, #3967
  static telaVitoria + #376, #3967
  static telaVitoria + #377, #3967
  static telaVitoria + #378, #3967
  static telaVitoria + #379, #3967
  static telaVitoria + #380, #3967
  static telaVitoria + #381, #3967
  static telaVitoria + #382, #3967
  static telaVitoria + #383, #3967
  static telaVitoria + #384, #3967
  static telaVitoria + #385, #3967
  static telaVitoria + #386, #3967
  static telaVitoria + #387, #3967
  static telaVitoria + #388, #3967
  static telaVitoria + #389, #3967
  static telaVitoria + #390, #3967
  static telaVitoria + #391, #3967
  static telaVitoria + #392, #3967
  static telaVitoria + #393, #3967
  static telaVitoria + #394, #3967
  static telaVitoria + #395, #3967
  static telaVitoria + #396, #3967
  static telaVitoria + #397, #3967
  static telaVitoria + #398, #3967
  static telaVitoria + #399, #3967

  ;Linha 10
  static telaVitoria + #400, #3967
  static telaVitoria + #401, #3967
  static telaVitoria + #402, #3967
  static telaVitoria + #403, #3967
  static telaVitoria + #404, #3967
  static telaVitoria + #405, #3967
  static telaVitoria + #406, #3967
  static telaVitoria + #407, #3967
  static telaVitoria + #408, #3967
  static telaVitoria + #409, #3967
  static telaVitoria + #410, #3967
  static telaVitoria + #411, #3967
  static telaVitoria + #412, #3967
  static telaVitoria + #413, #3967
  static telaVitoria + #414, #3967
  static telaVitoria + #415, #3967
  static telaVitoria + #416, #3967
  static telaVitoria + #417, #3967
  static telaVitoria + #418, #3967
  static telaVitoria + #419, #3967
  static telaVitoria + #420, #3967
  static telaVitoria + #421, #3967
  static telaVitoria + #422, #3967
  static telaVitoria + #423, #3967
  static telaVitoria + #424, #3967
  static telaVitoria + #425, #3967
  static telaVitoria + #426, #3967
  static telaVitoria + #427, #3967
  static telaVitoria + #428, #3967
  static telaVitoria + #429, #3967
  static telaVitoria + #430, #3967
  static telaVitoria + #431, #3967
  static telaVitoria + #432, #3967
  static telaVitoria + #433, #3967
  static telaVitoria + #434, #3967
  static telaVitoria + #435, #3967
  static telaVitoria + #436, #3967
  static telaVitoria + #437, #3967
  static telaVitoria + #438, #3967
  static telaVitoria + #439, #3967

  ;Linha 11
  static telaVitoria + #440, #3967
  static telaVitoria + #441, #3967
  static telaVitoria + #442, #3967
  static telaVitoria + #443, #3967
  static telaVitoria + #444, #3967
  static telaVitoria + #445, #3967
  static telaVitoria + #446, #3967
  static telaVitoria + #447, #3967
  static telaVitoria + #448, #3967
  static telaVitoria + #449, #3967
  static telaVitoria + #450, #3967
  static telaVitoria + #451, #3967
  static telaVitoria + #452, #3967
  static telaVitoria + #453, #3967
  static telaVitoria + #454, #3967
  static telaVitoria + #455, #3967
  static telaVitoria + #456, #3967
  static telaVitoria + #457, #3967
  static telaVitoria + #458, #3967
  static telaVitoria + #459, #3967
  static telaVitoria + #460, #3967
  static telaVitoria + #461, #3967
  static telaVitoria + #462, #3967
  static telaVitoria + #463, #3967
  static telaVitoria + #464, #3967
  static telaVitoria + #465, #3967
  static telaVitoria + #466, #3967
  static telaVitoria + #467, #3967
  static telaVitoria + #468, #3967
  static telaVitoria + #469, #3967
  static telaVitoria + #470, #3967
  static telaVitoria + #471, #3967
  static telaVitoria + #472, #3967
  static telaVitoria + #473, #3967
  static telaVitoria + #474, #3967
  static telaVitoria + #475, #3967
  static telaVitoria + #476, #3967
  static telaVitoria + #477, #3967
  static telaVitoria + #478, #3967
  static telaVitoria + #479, #3967

  ;Linha 12
  static telaVitoria + #480, #3967
  static telaVitoria + #481, #3967
  static telaVitoria + #482, #3967
  static telaVitoria + #483, #3967
  static telaVitoria + #484, #3967
  static telaVitoria + #485, #3967
  static telaVitoria + #486, #3967
  static telaVitoria + #487, #3967
  static telaVitoria + #488, #3967
  static telaVitoria + #489, #3967
  static telaVitoria + #490, #3967
  static telaVitoria + #491, #3967
  static telaVitoria + #492, #3967
  static telaVitoria + #493, #3967
  static telaVitoria + #494, #3967
  static telaVitoria + #495, #3967
  static telaVitoria + #496, #3967
  static telaVitoria + #497, #3967
  static telaVitoria + #498, #3967
  static telaVitoria + #499, #3967
  static telaVitoria + #500, #3967
  static telaVitoria + #501, #3967
  static telaVitoria + #502, #3967
  static telaVitoria + #503, #3967
  static telaVitoria + #504, #3967
  static telaVitoria + #505, #3967
  static telaVitoria + #506, #3967
  static telaVitoria + #507, #3967
  static telaVitoria + #508, #3967
  static telaVitoria + #509, #3967
  static telaVitoria + #510, #3967
  static telaVitoria + #511, #3967
  static telaVitoria + #512, #3967
  static telaVitoria + #513, #3967
  static telaVitoria + #514, #3967
  static telaVitoria + #515, #3967
  static telaVitoria + #516, #3967
  static telaVitoria + #517, #3967
  static telaVitoria + #518, #3967
  static telaVitoria + #519, #3967

  ;Linha 13
  static telaVitoria + #520, #3967
  static telaVitoria + #521, #3967
  static telaVitoria + #522, #3967
  static telaVitoria + #523, #3967
  static telaVitoria + #524, #3967
  static telaVitoria + #525, #3967
  static telaVitoria + #526, #3967
  static telaVitoria + #527, #3967
  static telaVitoria + #528, #3967
  static telaVitoria + #529, #3967
  static telaVitoria + #530, #3967
  static telaVitoria + #531, #3967
  static telaVitoria + #532, #3967
  static telaVitoria + #533, #3967
  static telaVitoria + #534, #3967
  static telaVitoria + #535, #3967
  static telaVitoria + #536, #3967
  static telaVitoria + #537, #3967
  static telaVitoria + #538, #3967
  static telaVitoria + #539, #3967
  static telaVitoria + #540, #3967
  static telaVitoria + #541, #3967
  static telaVitoria + #542, #3967
  static telaVitoria + #543, #3967
  static telaVitoria + #544, #3967
  static telaVitoria + #545, #3967
  static telaVitoria + #546, #3967
  static telaVitoria + #547, #3967
  static telaVitoria + #548, #3967
  static telaVitoria + #549, #3967
  static telaVitoria + #550, #3967
  static telaVitoria + #551, #3967
  static telaVitoria + #552, #3967
  static telaVitoria + #553, #3967
  static telaVitoria + #554, #3967
  static telaVitoria + #555, #3967
  static telaVitoria + #556, #3967
  static telaVitoria + #557, #3967
  static telaVitoria + #558, #3967
  static telaVitoria + #559, #3967

  ;Linha 14
  static telaVitoria + #560, #3967
  static telaVitoria + #561, #3967
  static telaVitoria + #562, #3967
  static telaVitoria + #563, #3967
  static telaVitoria + #564, #3967
  static telaVitoria + #565, #3967
  static telaVitoria + #566, #3967
  static telaVitoria + #567, #3967
  static telaVitoria + #568, #3967
  static telaVitoria + #569, #3967
  static telaVitoria + #570, #3967
  static telaVitoria + #571, #3967
  static telaVitoria + #572, #3967
  static telaVitoria + #573, #3967
  static telaVitoria + #574, #3967
  static telaVitoria + #575, #3967
  static telaVitoria + #576, #3967
  static telaVitoria + #577, #3967
  static telaVitoria + #578, #3967
  static telaVitoria + #579, #3967
  static telaVitoria + #580, #3967
  static telaVitoria + #581, #3967
  static telaVitoria + #582, #3967
  static telaVitoria + #583, #3967
  static telaVitoria + #584, #3967
  static telaVitoria + #585, #3967
  static telaVitoria + #586, #3967
  static telaVitoria + #587, #3967
  static telaVitoria + #588, #3967
  static telaVitoria + #589, #3967
  static telaVitoria + #590, #3967
  static telaVitoria + #591, #3967
  static telaVitoria + #592, #3967
  static telaVitoria + #593, #3967
  static telaVitoria + #594, #3967
  static telaVitoria + #595, #3967
  static telaVitoria + #596, #3967
  static telaVitoria + #597, #3967
  static telaVitoria + #598, #3967
  static telaVitoria + #599, #3967

  ;Linha 15
  static telaVitoria + #600, #3967
  static telaVitoria + #601, #3967
  static telaVitoria + #602, #3967
  static telaVitoria + #603, #3967
  static telaVitoria + #604, #3967
  static telaVitoria + #605, #3967
  static telaVitoria + #606, #3967
  static telaVitoria + #607, #3967
  static telaVitoria + #608, #3967
  static telaVitoria + #609, #3967
  static telaVitoria + #610, #3967
  static telaVitoria + #611, #3967
  static telaVitoria + #612, #3967
  static telaVitoria + #613, #3967
  static telaVitoria + #614, #3967
  static telaVitoria + #615, #3967
  static telaVitoria + #616, #3967
  static telaVitoria + #617, #3967
  static telaVitoria + #618, #3967
  static telaVitoria + #619, #3967
  static telaVitoria + #620, #3967
  static telaVitoria + #621, #3967
  static telaVitoria + #622, #3967
  static telaVitoria + #623, #3967
  static telaVitoria + #624, #3967
  static telaVitoria + #625, #3967
  static telaVitoria + #626, #3967
  static telaVitoria + #627, #3967
  static telaVitoria + #628, #3967
  static telaVitoria + #629, #3967
  static telaVitoria + #630, #3967
  static telaVitoria + #631, #3967
  static telaVitoria + #632, #3967
  static telaVitoria + #633, #3967
  static telaVitoria + #634, #3967
  static telaVitoria + #635, #3967
  static telaVitoria + #636, #3967
  static telaVitoria + #637, #3967
  static telaVitoria + #638, #3967
  static telaVitoria + #639, #3967

  ;Linha 16
  static telaVitoria + #640, #3967
  static telaVitoria + #641, #3967
  static telaVitoria + #642, #3967
  static telaVitoria + #643, #3967
  static telaVitoria + #644, #3967
  static telaVitoria + #645, #3967
  static telaVitoria + #646, #3967
  static telaVitoria + #647, #3967
  static telaVitoria + #648, #3967
  static telaVitoria + #649, #3967
  static telaVitoria + #650, #3967
  static telaVitoria + #651, #3967
  static telaVitoria + #652, #3967
  static telaVitoria + #653, #3967
  static telaVitoria + #654, #3967
  static telaVitoria + #655, #3967
  static telaVitoria + #656, #3967
  static telaVitoria + #657, #3967
  static telaVitoria + #658, #3967
  static telaVitoria + #659, #3967
  static telaVitoria + #660, #3967
  static telaVitoria + #661, #3967
  static telaVitoria + #662, #3967
  static telaVitoria + #663, #3967
  static telaVitoria + #664, #3967
  static telaVitoria + #665, #3967
  static telaVitoria + #666, #3967
  static telaVitoria + #667, #3967
  static telaVitoria + #668, #3967
  static telaVitoria + #669, #3967
  static telaVitoria + #670, #3967
  static telaVitoria + #671, #3967
  static telaVitoria + #672, #3967
  static telaVitoria + #673, #3967
  static telaVitoria + #674, #3967
  static telaVitoria + #675, #3967
  static telaVitoria + #676, #3967
  static telaVitoria + #677, #3967
  static telaVitoria + #678, #3967
  static telaVitoria + #679, #3967

  ;Linha 17
  static telaVitoria + #680, #3967
  static telaVitoria + #681, #3967
  static telaVitoria + #682, #3967
  static telaVitoria + #683, #3967
  static telaVitoria + #684, #3967
  static telaVitoria + #685, #3967
  static telaVitoria + #686, #3967
  static telaVitoria + #687, #3967
  static telaVitoria + #688, #3967
  static telaVitoria + #689, #3967
  static telaVitoria + #690, #3967
  static telaVitoria + #691, #3967
  static telaVitoria + #692, #3967
  static telaVitoria + #693, #3967
  static telaVitoria + #694, #3967
  static telaVitoria + #695, #3967
  static telaVitoria + #696, #3967
  static telaVitoria + #697, #3967
  static telaVitoria + #698, #3967
  static telaVitoria + #699, #3967
  static telaVitoria + #700, #3967
  static telaVitoria + #701, #3967
  static telaVitoria + #702, #3967
  static telaVitoria + #703, #3967
  static telaVitoria + #704, #3967
  static telaVitoria + #705, #3967
  static telaVitoria + #706, #3967
  static telaVitoria + #707, #3967
  static telaVitoria + #708, #3967
  static telaVitoria + #709, #3967
  static telaVitoria + #710, #3967
  static telaVitoria + #711, #3967
  static telaVitoria + #712, #3967
  static telaVitoria + #713, #3967
  static telaVitoria + #714, #3967
  static telaVitoria + #715, #3967
  static telaVitoria + #716, #3967
  static telaVitoria + #717, #3967
  static telaVitoria + #718, #3967
  static telaVitoria + #719, #3967

  ;Linha 18
  static telaVitoria + #720, #3967
  static telaVitoria + #721, #3967
  static telaVitoria + #722, #3967
  static telaVitoria + #723, #3967
  static telaVitoria + #724, #3967
  static telaVitoria + #725, #3967
  static telaVitoria + #726, #3967
  static telaVitoria + #727, #3967
  static telaVitoria + #728, #3967
  static telaVitoria + #729, #3967
  static telaVitoria + #730, #3967
  static telaVitoria + #731, #3967
  static telaVitoria + #732, #3967
  static telaVitoria + #733, #3967
  static telaVitoria + #734, #3967
  static telaVitoria + #735, #3967
  static telaVitoria + #736, #3967
  static telaVitoria + #737, #3967
  static telaVitoria + #738, #3967
  static telaVitoria + #739, #3967
  static telaVitoria + #740, #3967
  static telaVitoria + #741, #3967
  static telaVitoria + #742, #3967
  static telaVitoria + #743, #3967
  static telaVitoria + #744, #3967
  static telaVitoria + #745, #3967
  static telaVitoria + #746, #3967
  static telaVitoria + #747, #3967
  static telaVitoria + #748, #3967
  static telaVitoria + #749, #3967
  static telaVitoria + #750, #3967
  static telaVitoria + #751, #3967
  static telaVitoria + #752, #3967
  static telaVitoria + #753, #3967
  static telaVitoria + #754, #3967
  static telaVitoria + #755, #3967
  static telaVitoria + #756, #3967
  static telaVitoria + #757, #3967
  static telaVitoria + #758, #3967
  static telaVitoria + #759, #3967

  ;Linha 19
  static telaVitoria + #760, #3967
  static telaVitoria + #761, #3967
  static telaVitoria + #762, #3967
  static telaVitoria + #763, #3967
  static telaVitoria + #764, #3967
  static telaVitoria + #765, #3967
  static telaVitoria + #766, #3967
  static telaVitoria + #767, #3967
  static telaVitoria + #768, #3967
  static telaVitoria + #769, #3967
  static telaVitoria + #770, #3967
  static telaVitoria + #771, #3967
  static telaVitoria + #772, #3967
  static telaVitoria + #773, #3967
  static telaVitoria + #774, #3967
  static telaVitoria + #775, #3967
  static telaVitoria + #776, #3967
  static telaVitoria + #777, #3967
  static telaVitoria + #778, #3967
  static telaVitoria + #779, #3967
  static telaVitoria + #780, #3967
  static telaVitoria + #781, #3967
  static telaVitoria + #782, #3967
  static telaVitoria + #783, #3967
  static telaVitoria + #784, #3967
  static telaVitoria + #785, #3967
  static telaVitoria + #786, #3967
  static telaVitoria + #787, #3967
  static telaVitoria + #788, #3967
  static telaVitoria + #789, #3967
  static telaVitoria + #790, #3967
  static telaVitoria + #791, #3967
  static telaVitoria + #792, #3967
  static telaVitoria + #793, #3967
  static telaVitoria + #794, #3967
  static telaVitoria + #795, #3967
  static telaVitoria + #796, #3967
  static telaVitoria + #797, #3967
  static telaVitoria + #798, #3967
  static telaVitoria + #799, #3967

  ;Linha 20
  static telaVitoria + #800, #3967
  static telaVitoria + #801, #3967
  static telaVitoria + #802, #3967
  static telaVitoria + #803, #3967
  static telaVitoria + #804, #3967
  static telaVitoria + #805, #3967
  static telaVitoria + #806, #3967
  static telaVitoria + #807, #3967
  static telaVitoria + #808, #3967
  static telaVitoria + #809, #3967
  static telaVitoria + #810, #3967
  static telaVitoria + #811, #3967
  static telaVitoria + #812, #3967
  static telaVitoria + #813, #3967
  static telaVitoria + #814, #3967
  static telaVitoria + #815, #3967
  static telaVitoria + #816, #3967
  static telaVitoria + #817, #3967
  static telaVitoria + #818, #3967
  static telaVitoria + #819, #3967
  static telaVitoria + #820, #3967
  static telaVitoria + #821, #3967
  static telaVitoria + #822, #3967
  static telaVitoria + #823, #3967
  static telaVitoria + #824, #3967
  static telaVitoria + #825, #3967
  static telaVitoria + #826, #3967
  static telaVitoria + #827, #3967
  static telaVitoria + #828, #3967
  static telaVitoria + #829, #3967
  static telaVitoria + #830, #3967
  static telaVitoria + #831, #3967
  static telaVitoria + #832, #3967
  static telaVitoria + #833, #3967
  static telaVitoria + #834, #3967
  static telaVitoria + #835, #3967
  static telaVitoria + #836, #3967
  static telaVitoria + #837, #3967
  static telaVitoria + #838, #3967
  static telaVitoria + #839, #3967

  ;Linha 21
  static telaVitoria + #840, #3967
  static telaVitoria + #841, #3967
  static telaVitoria + #842, #3967
  static telaVitoria + #843, #3967
  static telaVitoria + #844, #3967
  static telaVitoria + #845, #3967
  static telaVitoria + #846, #3967
  static telaVitoria + #847, #3967
  static telaVitoria + #848, #3967
  static telaVitoria + #849, #3967
  static telaVitoria + #850, #3967
  static telaVitoria + #851, #3967
  static telaVitoria + #852, #3967
  static telaVitoria + #853, #3967
  static telaVitoria + #854, #3967
  static telaVitoria + #855, #3967
  static telaVitoria + #856, #3967
  static telaVitoria + #857, #3967
  static telaVitoria + #858, #3967
  static telaVitoria + #859, #3967
  static telaVitoria + #860, #3967
  static telaVitoria + #861, #3967
  static telaVitoria + #862, #3967
  static telaVitoria + #863, #3967
  static telaVitoria + #864, #3967
  static telaVitoria + #865, #3967
  static telaVitoria + #866, #3967
  static telaVitoria + #867, #3967
  static telaVitoria + #868, #3967
  static telaVitoria + #869, #3967
  static telaVitoria + #870, #3967
  static telaVitoria + #871, #3967
  static telaVitoria + #872, #3967
  static telaVitoria + #873, #3967
  static telaVitoria + #874, #3967
  static telaVitoria + #875, #3967
  static telaVitoria + #876, #3967
  static telaVitoria + #877, #3967
  static telaVitoria + #878, #3967
  static telaVitoria + #879, #3967

  ;Linha 22
  static telaVitoria + #880, #3967
  static telaVitoria + #881, #3967
  static telaVitoria + #882, #3967
  static telaVitoria + #883, #3967
  static telaVitoria + #884, #3967
  static telaVitoria + #885, #3967
  static telaVitoria + #886, #3967
  static telaVitoria + #887, #3967
  static telaVitoria + #888, #3967
  static telaVitoria + #889, #3967
  static telaVitoria + #890, #3967
  static telaVitoria + #891, #3967
  static telaVitoria + #892, #3967
  static telaVitoria + #893, #3967
  static telaVitoria + #894, #3967
  static telaVitoria + #895, #3967
  static telaVitoria + #896, #3967
  static telaVitoria + #897, #3967
  static telaVitoria + #898, #3967
  static telaVitoria + #899, #3967
  static telaVitoria + #900, #3967
  static telaVitoria + #901, #3967
  static telaVitoria + #902, #3967
  static telaVitoria + #903, #3967
  static telaVitoria + #904, #3967
  static telaVitoria + #905, #3967
  static telaVitoria + #906, #3967
  static telaVitoria + #907, #3967
  static telaVitoria + #908, #3967
  static telaVitoria + #909, #3967
  static telaVitoria + #910, #3967
  static telaVitoria + #911, #3967
  static telaVitoria + #912, #3967
  static telaVitoria + #913, #3967
  static telaVitoria + #914, #3967
  static telaVitoria + #915, #3967
  static telaVitoria + #916, #3967
  static telaVitoria + #917, #3967
  static telaVitoria + #918, #3967
  static telaVitoria + #919, #3967

  ;Linha 23
  static telaVitoria + #920, #3967
  static telaVitoria + #921, #3967
  static telaVitoria + #922, #3967
  static telaVitoria + #923, #3967
  static telaVitoria + #924, #3967
  static telaVitoria + #925, #3967
  static telaVitoria + #926, #3967
  static telaVitoria + #927, #3967
  static telaVitoria + #928, #3967
  static telaVitoria + #929, #3967
  static telaVitoria + #930, #3967
  static telaVitoria + #931, #3967
  static telaVitoria + #932, #3967
  static telaVitoria + #933, #3967
  static telaVitoria + #934, #3967
  static telaVitoria + #935, #3967
  static telaVitoria + #936, #3967
  static telaVitoria + #937, #3967
  static telaVitoria + #938, #3967
  static telaVitoria + #939, #3967
  static telaVitoria + #940, #3967
  static telaVitoria + #941, #3967
  static telaVitoria + #942, #3967
  static telaVitoria + #943, #3967
  static telaVitoria + #944, #3967
  static telaVitoria + #945, #3967
  static telaVitoria + #946, #3967
  static telaVitoria + #947, #3967
  static telaVitoria + #948, #3967
  static telaVitoria + #949, #3967
  static telaVitoria + #950, #3967
  static telaVitoria + #951, #3967
  static telaVitoria + #952, #3967
  static telaVitoria + #953, #3967
  static telaVitoria + #954, #3967
  static telaVitoria + #955, #3967
  static telaVitoria + #956, #3967
  static telaVitoria + #957, #3967
  static telaVitoria + #958, #3967
  static telaVitoria + #959, #3967

  ;Linha 24
  static telaVitoria + #960, #3967
  static telaVitoria + #961, #3967
  static telaVitoria + #962, #3967
  static telaVitoria + #963, #3967
  static telaVitoria + #964, #3967
  static telaVitoria + #965, #3967
  static telaVitoria + #966, #3967
  static telaVitoria + #967, #3967
  static telaVitoria + #968, #3967
  static telaVitoria + #969, #3967
  static telaVitoria + #970, #3967
  static telaVitoria + #971, #3967
  static telaVitoria + #972, #3967
  static telaVitoria + #973, #3967
  static telaVitoria + #974, #3967
  static telaVitoria + #975, #3967
  static telaVitoria + #976, #3967
  static telaVitoria + #977, #3967
  static telaVitoria + #978, #3967
  static telaVitoria + #979, #3967
  static telaVitoria + #980, #3967
  static telaVitoria + #981, #3967
  static telaVitoria + #982, #3967
  static telaVitoria + #983, #3967
  static telaVitoria + #984, #3967
  static telaVitoria + #985, #3967
  static telaVitoria + #986, #3967
  static telaVitoria + #987, #3967
  static telaVitoria + #988, #3967
  static telaVitoria + #989, #3967
  static telaVitoria + #990, #3967
  static telaVitoria + #991, #3967
  static telaVitoria + #992, #3967
  static telaVitoria + #993, #3967
  static telaVitoria + #994, #3967
  static telaVitoria + #995, #3967
  static telaVitoria + #996, #3967
  static telaVitoria + #997, #3967
  static telaVitoria + #998, #3967
  static telaVitoria + #999, #3967

  ;Linha 25
  static telaVitoria + #1000, #3967
  static telaVitoria + #1001, #3967
  static telaVitoria + #1002, #3967
  static telaVitoria + #1003, #3967
  static telaVitoria + #1004, #3967
  static telaVitoria + #1005, #3967
  static telaVitoria + #1006, #3967
  static telaVitoria + #1007, #3967
  static telaVitoria + #1008, #3967
  static telaVitoria + #1009, #3967
  static telaVitoria + #1010, #3967
  static telaVitoria + #1011, #3967
  static telaVitoria + #1012, #3967
  static telaVitoria + #1013, #3967
  static telaVitoria + #1014, #3967
  static telaVitoria + #1015, #3967
  static telaVitoria + #1016, #3967
  static telaVitoria + #1017, #3967
  static telaVitoria + #1018, #3967
  static telaVitoria + #1019, #3967
  static telaVitoria + #1020, #3967
  static telaVitoria + #1021, #3967
  static telaVitoria + #1022, #3967
  static telaVitoria + #1023, #3967
  static telaVitoria + #1024, #3967
  static telaVitoria + #1025, #3967
  static telaVitoria + #1026, #3967
  static telaVitoria + #1027, #3967
  static telaVitoria + #1028, #3967
  static telaVitoria + #1029, #3967
  static telaVitoria + #1030, #3967
  static telaVitoria + #1031, #3967
  static telaVitoria + #1032, #3967
  static telaVitoria + #1033, #3967
  static telaVitoria + #1034, #3967
  static telaVitoria + #1035, #3967
  static telaVitoria + #1036, #3967
  static telaVitoria + #1037, #3967
  static telaVitoria + #1038, #3967
  static telaVitoria + #1039, #3967

  ;Linha 26
  static telaVitoria + #1040, #3967
  static telaVitoria + #1041, #3967
  static telaVitoria + #1042, #3967
  static telaVitoria + #1043, #3967
  static telaVitoria + #1044, #3967
  static telaVitoria + #1045, #3967
  static telaVitoria + #1046, #3967
  static telaVitoria + #1047, #3967
  static telaVitoria + #1048, #3967
  static telaVitoria + #1049, #3967
  static telaVitoria + #1050, #3967
  static telaVitoria + #1051, #3967
  static telaVitoria + #1052, #3967
  static telaVitoria + #1053, #3967
  static telaVitoria + #1054, #3967
  static telaVitoria + #1055, #3967
  static telaVitoria + #1056, #3967
  static telaVitoria + #1057, #3967
  static telaVitoria + #1058, #3967
  static telaVitoria + #1059, #3967
  static telaVitoria + #1060, #3967
  static telaVitoria + #1061, #3967
  static telaVitoria + #1062, #3967
  static telaVitoria + #1063, #3967
  static telaVitoria + #1064, #3967
  static telaVitoria + #1065, #3967
  static telaVitoria + #1066, #3967
  static telaVitoria + #1067, #3967
  static telaVitoria + #1068, #3967
  static telaVitoria + #1069, #3967
  static telaVitoria + #1070, #3967
  static telaVitoria + #1071, #3967
  static telaVitoria + #1072, #3967
  static telaVitoria + #1073, #3967
  static telaVitoria + #1074, #3967
  static telaVitoria + #1075, #3967
  static telaVitoria + #1076, #3967
  static telaVitoria + #1077, #3967
  static telaVitoria + #1078, #3967
  static telaVitoria + #1079, #3967

  ;Linha 27
  static telaVitoria + #1080, #3967
  static telaVitoria + #1081, #3967
  static telaVitoria + #1082, #3967
  static telaVitoria + #1083, #3967
  static telaVitoria + #1084, #3967
  static telaVitoria + #1085, #3967
  static telaVitoria + #1086, #3967
  static telaVitoria + #1087, #3967
  static telaVitoria + #1088, #3967
  static telaVitoria + #1089, #3967
  static telaVitoria + #1090, #3967
  static telaVitoria + #1091, #3967
  static telaVitoria + #1092, #3967
  static telaVitoria + #1093, #3967
  static telaVitoria + #1094, #3967
  static telaVitoria + #1095, #3967
  static telaVitoria + #1096, #3967
  static telaVitoria + #1097, #3967
  static telaVitoria + #1098, #3967
  static telaVitoria + #1099, #3967
  static telaVitoria + #1100, #3967
  static telaVitoria + #1101, #3967
  static telaVitoria + #1102, #3967
  static telaVitoria + #1103, #3967
  static telaVitoria + #1104, #3967
  static telaVitoria + #1105, #3967
  static telaVitoria + #1106, #3967
  static telaVitoria + #1107, #3967
  static telaVitoria + #1108, #3967
  static telaVitoria + #1109, #3967
  static telaVitoria + #1110, #3967
  static telaVitoria + #1111, #3967
  static telaVitoria + #1112, #3967
  static telaVitoria + #1113, #3967
  static telaVitoria + #1114, #3967
  static telaVitoria + #1115, #3967
  static telaVitoria + #1116, #3967
  static telaVitoria + #1117, #3967
  static telaVitoria + #1118, #3967
  static telaVitoria + #1119, #3967

  ;Linha 28
  static telaVitoria + #1120, #3967
  static telaVitoria + #1121, #3967
  static telaVitoria + #1122, #3967
  static telaVitoria + #1123, #3967
  static telaVitoria + #1124, #3967
  static telaVitoria + #1125, #3967
  static telaVitoria + #1126, #3967
  static telaVitoria + #1127, #3967
  static telaVitoria + #1128, #3967
  static telaVitoria + #1129, #3967
  static telaVitoria + #1130, #3967
  static telaVitoria + #1131, #3967
  static telaVitoria + #1132, #3967
  static telaVitoria + #1133, #3967
  static telaVitoria + #1134, #3967
  static telaVitoria + #1135, #3967
  static telaVitoria + #1136, #3967
  static telaVitoria + #1137, #3967
  static telaVitoria + #1138, #3967
  static telaVitoria + #1139, #3967
  static telaVitoria + #1140, #3967
  static telaVitoria + #1141, #3967
  static telaVitoria + #1142, #3967
  static telaVitoria + #1143, #3967
  static telaVitoria + #1144, #3967
  static telaVitoria + #1145, #3967
  static telaVitoria + #1146, #3967
  static telaVitoria + #1147, #3967
  static telaVitoria + #1148, #3967
  static telaVitoria + #1149, #3967
  static telaVitoria + #1150, #3967
  static telaVitoria + #1151, #3967
  static telaVitoria + #1152, #3967
  static telaVitoria + #1153, #3967
  static telaVitoria + #1154, #3967
  static telaVitoria + #1155, #3967
  static telaVitoria + #1156, #3967
  static telaVitoria + #1157, #3967
  static telaVitoria + #1158, #3967
  static telaVitoria + #1159, #3967

  ;Linha 29
  static telaVitoria + #1160, #3967
  static telaVitoria + #1161, #3967
  static telaVitoria + #1162, #3967
  static telaVitoria + #1163, #3967
  static telaVitoria + #1164, #3967
  static telaVitoria + #1165, #3967
  static telaVitoria + #1166, #3967
  static telaVitoria + #1167, #3967
  static telaVitoria + #1168, #3967
  static telaVitoria + #1169, #3967
  static telaVitoria + #1170, #3967
  static telaVitoria + #1171, #3967
  static telaVitoria + #1172, #3967
  static telaVitoria + #1173, #3967
  static telaVitoria + #1174, #3967
  static telaVitoria + #1175, #3967
  static telaVitoria + #1176, #3967
  static telaVitoria + #1177, #3967
  static telaVitoria + #1178, #3967
  static telaVitoria + #1179, #3967
  static telaVitoria + #1180, #3967
  static telaVitoria + #1181, #3967
  static telaVitoria + #1182, #3967
  static telaVitoria + #1183, #3967
  static telaVitoria + #1184, #3967
  static telaVitoria + #1185, #3967
  static telaVitoria + #1186, #3967
  static telaVitoria + #1187, #3967
  static telaVitoria + #1188, #3967
  static telaVitoria + #1189, #3967
  static telaVitoria + #1190, #3967
  static telaVitoria + #1191, #3967
  static telaVitoria + #1192, #3967
  static telaVitoria + #1193, #3967
  static telaVitoria + #1194, #3967
  static telaVitoria + #1195, #3967
  static telaVitoria + #1196, #3967
  static telaVitoria + #1197, #3967
  static telaVitoria + #1198, #3967
  static telaVitoria + #1199, #3967

printtelaVitoriaScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #telaVitoria
  loadn R1, #0
  loadn R2, #1200

  printtelaVitoriaScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printtelaVitoriaScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts
