jmp main

;---- Declaracao de Variaveis Globais -----
; Sao todas aquelas que precisam ser vistas por mais de uma funcao: Evita a passagem de parametros!!!
; As variaveis locais de cada funcao serao alocadas nos Registradores internos = r0 - r7
RNG: var #1
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
static PONTOS + #0, #50

Palavra: var #41	; Vetor para Armazenar as letras da Palavra
PalavraSize: var #1	; Tamanho da Palavra
Letra: var #1		; Contem a letra que foi digitada
TryList: var #60	; Lista com as letras ja' digitadas
TryListSize: var #1	; Tamanho da Lista com as letras ja' digitadas
Acerto: var #1		; Contador de Acertos
Erro: var #1			; Contador de Erros

; Mensagens que serao impressas na tela
Msn1: string "Pressione Enter para Iniciar o Jogo"

; Recebe a mensagem em r0 e a posição em r1
imprime_mensagem:
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
	rts

;---- Inicio do Programa Principal -----
main:
	
	loadn r0, #Msn1
	loadn r1, #563
	call imprime_mensagem
	
	loadn r0, #0
	loadn r2, #13
	loadn r5, #255
	
loop_inicio:
	inchar r1
	
	cmp r1, r2
	jeq fim_loop_inicio
	inc r0
		
	jmp loop_inicio

fim_loop_inicio:
	store RNG, r0
	load r7, RNG
	
    call printDefineStatusScreen
    call mostraStatus
    jmp loop_status

loop_status:
    inchar r1

    cmp r1,r2
    jeq fim_loop_status

    loadn r4, #JMP_TABLE_STATUS
    add r4, r4, r1
    loadi r1, r4

    loadn r4, #0

    cmp r1, r4
    jeq loop_status

    jid r1

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


fim_loop_status:
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

    rts

; Printa o número em r0 com dois digitos começando na posição r1
printNum:
    push r2
    push r3
    push r4

    loadn r2, #48
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
    loadn r2, #48
    add r2, r2, r4
    outchar r2, r1
    dec r1

    pop r4
    pop r3
    pop r2

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
  static DefineStatus + #121, #65
  static DefineStatus + #122, #84
  static DefineStatus + #123, #75
  static DefineStatus + #124, #58
  static DefineStatus + #125, #3967
  static DefineStatus + #126, #3967
  static DefineStatus + #127, #3967
  static DefineStatus + #128, #3967
  static DefineStatus + #129, #3967
  static DefineStatus + #130, #45
  static DefineStatus + #131, #3967
  static DefineStatus + #132, #43
  static DefineStatus + #133, #3967
  static DefineStatus + #134, #91
  static DefineStatus + #135, #49
  static DefineStatus + #136, #3967
  static DefineStatus + #137, #50
  static DefineStatus + #138, #93
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
  static DefineStatus + #201, #68
  static DefineStatus + #202, #69
  static DefineStatus + #203, #70
  static DefineStatus + #204, #58
  static DefineStatus + #205, #3967
  static DefineStatus + #206, #3967
  static DefineStatus + #207, #3967
  static DefineStatus + #208, #3967
  static DefineStatus + #209, #3967
  static DefineStatus + #210, #45
  static DefineStatus + #211, #3967
  static DefineStatus + #212, #43
  static DefineStatus + #213, #3967
  static DefineStatus + #214, #91
  static DefineStatus + #215, #51
  static DefineStatus + #216, #3967
  static DefineStatus + #217, #52
  static DefineStatus + #218, #93
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
  static DefineStatus + #290, #45
  static DefineStatus + #291, #3967
  static DefineStatus + #292, #43
  static DefineStatus + #293, #3967
  static DefineStatus + #294, #91
  static DefineStatus + #295, #53
  static DefineStatus + #296, #3967
  static DefineStatus + #297, #54
  static DefineStatus + #298, #93
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
  static DefineStatus + #361, #83
  static DefineStatus + #362, #80
  static DefineStatus + #363, #68
  static DefineStatus + #364, #58
  static DefineStatus + #365, #3967
  static DefineStatus + #366, #3967
  static DefineStatus + #367, #3967
  static DefineStatus + #368, #3967
  static DefineStatus + #369, #3967
  static DefineStatus + #370, #45
  static DefineStatus + #371, #3967
  static DefineStatus + #372, #43
  static DefineStatus + #373, #3967
  static DefineStatus + #374, #91
  static DefineStatus + #375, #55
  static DefineStatus + #376, #3967
  static DefineStatus + #377, #56
  static DefineStatus + #378, #93
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
  static DefineStatus + #441, #83
  static DefineStatus + #442, #80
  static DefineStatus + #443, #69
  static DefineStatus + #444, #58
  static DefineStatus + #445, #3967
  static DefineStatus + #446, #3967
  static DefineStatus + #447, #3967
  static DefineStatus + #448, #3967
  static DefineStatus + #449, #3967
  static DefineStatus + #450, #45
  static DefineStatus + #451, #3967
  static DefineStatus + #452, #43
  static DefineStatus + #453, #3967
  static DefineStatus + #454, #91
  static DefineStatus + #455, #57
  static DefineStatus + #456, #3967
  static DefineStatus + #457, #48
  static DefineStatus + #458, #93
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
  static DefineStatus + #522, #72
  static DefineStatus + #523, #80
  static DefineStatus + #524, #58
  static DefineStatus + #525, #3967
  static DefineStatus + #526, #3967
  static DefineStatus + #527, #3967
  static DefineStatus + #528, #3967
  static DefineStatus + #529, #3967
  static DefineStatus + #530, #45
  static DefineStatus + #531, #3967
  static DefineStatus + #532, #43
  static DefineStatus + #533, #3967
  static DefineStatus + #534, #91
  static DefineStatus + #535, #65
  static DefineStatus + #536, #127
  static DefineStatus + #537, #66
  static DefineStatus + #538, #93
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
  static DefineStatus + #688, #0
  static DefineStatus + #689, #3967
  static DefineStatus + #690, #3967
  static DefineStatus + #691, #0
  static DefineStatus + #692, #0
  static DefineStatus + #693, #0
  static DefineStatus + #694, #0
  static DefineStatus + #695, #0
  static DefineStatus + #696, #0
  static DefineStatus + #697, #0
  static DefineStatus + #698, #0
  static DefineStatus + #699, #0
  static DefineStatus + #700, #0
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
  static DefineStatus + #730, #0
  static DefineStatus + #731, #0
  static DefineStatus + #732, #0
  static DefineStatus + #733, #0
  static DefineStatus + #734, #0
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
  static DefineStatus + #761, #80
  static DefineStatus + #762, #79
  static DefineStatus + #763, #67
  static DefineStatus + #764, #65
  static DefineStatus + #765, #79
  static DefineStatus + #766, #58
  static DefineStatus + #767, #3967
  static DefineStatus + #768, #3967
  static DefineStatus + #769, #3967
  static DefineStatus + #770, #3967
  static DefineStatus + #771, #3967
  static DefineStatus + #772, #45
  static DefineStatus + #773, #3967
  static DefineStatus + #774, #43
  static DefineStatus + #775, #3967
  static DefineStatus + #776, #91
  static DefineStatus + #777, #67
  static DefineStatus + #778, #3967
  static DefineStatus + #779, #68
  static DefineStatus + #780, #93
  static DefineStatus + #781, #3967
  static DefineStatus + #782, #3967
  static DefineStatus + #783, #3967
  static DefineStatus + #784, #3967
  static DefineStatus + #785, #3967
  static DefineStatus + #786, #69
  static DefineStatus + #787, #78
  static DefineStatus + #788, #84
  static DefineStatus + #789, #69
  static DefineStatus + #790, #82
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
  static DefineStatus + #841, #65
  static DefineStatus + #842, #84
  static DefineStatus + #843, #75
  static DefineStatus + #844, #85
  static DefineStatus + #845, #80
  static DefineStatus + #846, #58
  static DefineStatus + #847, #3967
  static DefineStatus + #848, #3967
  static DefineStatus + #849, #3967
  static DefineStatus + #850, #3967
  static DefineStatus + #851, #3967
  static DefineStatus + #852, #45
  static DefineStatus + #853, #3967
  static DefineStatus + #854, #43
  static DefineStatus + #855, #3967
  static DefineStatus + #856, #91
  static DefineStatus + #857, #69
  static DefineStatus + #858, #3967
  static DefineStatus + #859, #70
  static DefineStatus + #860, #93
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
  static DefineStatus + #921, #68
  static DefineStatus + #922, #69
  static DefineStatus + #923, #70
  static DefineStatus + #924, #85
  static DefineStatus + #925, #80
  static DefineStatus + #926, #58
  static DefineStatus + #927, #3967
  static DefineStatus + #928, #3967
  static DefineStatus + #929, #3967
  static DefineStatus + #930, #3967
  static DefineStatus + #931, #3967
  static DefineStatus + #932, #45
  static DefineStatus + #933, #3967
  static DefineStatus + #934, #43
  static DefineStatus + #935, #3967
  static DefineStatus + #936, #91
  static DefineStatus + #937, #71
  static DefineStatus + #938, #3967
  static DefineStatus + #939, #72
  static DefineStatus + #940, #93
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
static JMP_TABLE_STATUS + #99, #0
static JMP_TABLE_STATUS + #100, #0
static JMP_TABLE_STATUS + #101, #0
static JMP_TABLE_STATUS + #102, #0
static JMP_TABLE_STATUS + #103, #0
static JMP_TABLE_STATUS + #104, #0
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
