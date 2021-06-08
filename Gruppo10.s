.section .rodata
//stringhe per load e save dati file
filename: .asciz "progetto_grp_10.dat"
read_mode: .asciz "r"   //modalità lettura - load
write_mode: .asciz "w"  //modalità scrittura - save

//Layout intestazione
fmt_menu_titolo:
    .ascii "\n╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
    .ascii "║                                                                                              ║\n"
    .ascii "║ _    _ ___  ____ ____ ___ ___ ____    _  _ _  _ _ _  _ ____ ____ ____ _ ___ ____ ____ _ ____ ║\n"
    .ascii "║ |    | |__] |__/ |___  |   |  |  |    |  | |\\ | | |  | |___ |__/ [__  |  |  |__| |__/ | |  | ║\n"
    .ascii "║ |___ | |__] |  \\ |___  |   |  |__|    |__| | \\| |  \\/  |___ |  \\ ___] |  |  |  | |  \\ | |__| ║\n"
    .ascii "║                                                                                              ║\n"
    .ascii "║                            sviluppato dal Gruppo 10 - Corso di Architettura degli Elaboratori║\n"
    .asciz "╚══════════════════════════════════════════════════════════════════════════════════════════════╝\n"
    
fmt_separatore:
    .asciz "─────────────────────────────────────────────────────────────────────────────────────────────────\n"
fmt_menu_intestazione:
    .asciz "\n ID CORSO                           CFU   ESAME SUP.   VOTO   LODE  \n"
fmt_voto_da_stampare: //questa stringa viene stampata solo in mod filtro
    .asciz "*Si stanno visualizzando i corsi con voto di almeno %d:             \n"
//fine fmt intestazione

//fmt string per la stampa dei singoli record su linea
fmt_menu_entry:
    .asciz "%3d %-30s %4d %7s %9d %8s \n" //da rivedere

//fmt string per il menù    
fmt_menu_options:
    .ascii "Menù di scelta:\n"
    .ascii "    1: Aggiungi Corso\n"
    .ascii "    2: Elimina Corso\n"
    .ascii "    3: Filtra le materie per voto ottenuto\n"
    .ascii "    4: Stampa l'intero libretto\n"
    .ascii "    5: Modifica i valori di un corso inserito\n"
    .ascii "    9: Crediti\n"
    .asciz "    0: Esci\n"

 //fmt string per le statistiche
fmt_statistiche:    .asciz "Le tue statistiche:\n"   
fmt_media_voto:     .asciz "    Media voto ponderata: %.2f\n"
fmt_base_di_laurea: .asciz "    Base di Laurea: %.2f\n"
fmt_cfu_ottenuti:   .asciz "    Hai ottenuto n° %d cfu.\n"
fmt_esami_superati: .asciz "    Hai superato n° %d esami.\n"

//fmt per gli scan da input
fmt_scan_int:       .asciz "%d"
fmt_scan_str:       .asciz "%127s"

//fmt per specificare cosa si richiede durante gli scan
fmt_richiesta_menu:    .asciz "\nInserire il numero corrispondente all'azione da effettuare: "
fmt_richiesta_index: .asciz "# (fuori range per annullare): "
fmt_richiesta_index_filtro: .asciz "# Inserisci il valore di voto minimo da visualizzare (fuori range 18-30 per annullare): "
fmt_richiesta_corso:   .asciz "Corso (separare parole con underscore, non utilizzare lo spazio): "
fmt_richiesta_cfu:     .asciz "Cfu: "
fmt_richiesta_esame:   .asciz "Esame sostenuto (0 no, 1 sì): "
fmt_richiesta_voto:  .asciz "Voto: "
fmt_richiesta_lode: .asciz "Hai ottenuto la lode (0 per no, 1 per si): "


//fmt string da usare con gli interruttori 0-1 durante la fase di stampa
fmt_esame_no: .asciz "No"
fmt_esame_si: .asciz "Si"
fmt_lode_si: .asciz "Si"
fmt_lode_no: .asciz "No"

//fmt string per la visualizzazione dei crediti
fmt_crediti: 
    .ascii "\nEccoci! Questi siamo noi, gli sviluppatori del Gruppo 10, in rigoroso ordine alfabetico:\n\n"
    .ascii "ALESSANDRO MONETTI\n"
    .ascii "ANDREA TOCCI\n"
    .ascii "ANTONIO DE SETA\n"
    .ascii "CHRISTIAN ROSATI\n"
    .ascii "ERNESTO RAPISARDA\n"
    .ascii "MATTIA ANTONIO GUARINO\n"
    .ascii "SIMONE ROTUNDO\n"
    .asciz "VINCENZO CALABRO'\n"

//fmt string per gli error e fail
fmt_fail_save_data: .asciz "\nImpossibile salvare i dati.\n\n"
fmt_fail_aggiungi_corso: .asciz "\nMemoria insufficiente. Eliminare un corso, quindi riprovare.\n\n"
fmt_fail_filtra_esame_sostenuto: .asciz "\nNessun corso presente o che risponde ai requisiti del filtro.\n\n"
fmt_fail_calcolo_voto_medio_error: .asciz "\nNessun voto presente.\n\n"
fmt_fail_calcolo_esami_superati: .asciz "\nNessun esame superato.\n\n"
fmt_fail_calcolo_cfu_ottenuti_error: .asciz "\nNessun cfu conseguito.\n\n"
.align 2

.data
n_corsi: .word 0     //ad inizio load dati, i primi 4 bytes del nostro file, sono il numero di corsi, e lo carichiamo qui
somma_voto: .double 0.0
somma_cfu: .double 0.0
valore_lode: .double 0.5    //usiamo questa costante per determinare il valore di una lode (che dovrebbe essere 0.5 nel nostro corso)

.equ max_corsi, 25          //numero massimo di corsi inseribili

//Costanti size
.equ size_nome, 31                                      //dimensione nome corso
.equ size_cfu, 4                                        //dimensione cfu
.equ size_sostenuto, 4                                  //dimensione esame superato
.equ size_voto, 4                                       //dimensione voto ottenuto
.equ size_lode, 4                                       //dimensione lode

//Costanti offset
.equ offset_nome, 0                                     //punto di partenza dell'array NOME
.equ offset_cfu, offset_nome + size_nome                //posizione array cfu
.equ offset_sostenuto, offset_cfu + size_cfu           //posizione array sostenuto-esame superato
.equ offset_voto, offset_sostenuto + size_sostenuto     //posizione array voto
.equ offset_lode, offset_voto + size_voto               //posizione array lode
.equ corso_size_aligned, 56                            //dimensione totale di una riga/record

.bss
tmp_str: .skip 128                                      //inizializiamo tmp_str con 128bytes "vuoti" - usata per scan stringhe
tmp_int: .skip 8                                        //inizializiamo tmp_int con 8 bytes "vuoti" - usata per scan interi
corso: .skip corso_size_aligned * max_corsi             //riserviamo in memoria lo spazio necessario per caricare fino a 25 "corsi"


.macro read_int richiesta //scansione interi
    adr x0, \richiesta    //qui si specifica cosa stampare per guidare l'utente nell'input  
    bl printf

    adr x0, fmt_scan_int    //indichiamo il formato di cosa stiamo acquisendo in input (intero in questo caso)
    adr x1, tmp_int         //destinazione dove caricare il valore in input
    bl scanf    

    ldr x0, tmp_int         //mettiamo il valore appena salvato in tmp_int in x0 in modo da poterlo utilizzare fin da subito appena finita la macro
.endm

.macro read_str richiesta //scansione stringhe
    adr x0, \richiesta      //qui si specifica cosa stampare per guidare l'utente nell'input
    bl printf

    adr x0, fmt_scan_str    //indichiamo il formato di cosa stiamo acquisendo in input (stringa in questo caso)
    adr x1, tmp_str         //destinazione dove caricare la stringa in input
    bl scanf
.endm


/* Macro di salvataggio dati in memoria
Per essere sicuri che la nostra memoria fosse sempre ben allineata con i dati in input, abbiamo deciso 
di usare due macro: una per i numeri interi e un'altra per le stringhe, usando rispettivamente memcpy e 
strncpy, in questo modo si può controllare in modo efficiente la quantità di bytes da salvare in memoria 
e dove salvarli esattamente. */
.macro save_to_int numero, offset, size //macro per salvare n(size) bytes come numeri interi
    add x0, \numero, \offset        //destinazione
    ldr x1, =tmp_int                //sorgente
    mov x2, \size                   //numero di bytes da salvare
    bl memcpy 
.endm


.macro save_to item, offset, size //macro per salvare n(size) bytes come stringhe
    add x0, \item, \offset          //destinazione
    ldr x1, =tmp_str                //sorgente
    mov x2, \size                   //numero di bytes da salvare
    bl strncpy

    add x0, \item, \offset + \size - 1
    strb wzr, [x0]
.endm


.text
.type main, %function
.global main
/*Il nostro main ospita il ciclo principale del programma, dalla quale è possibile uscire inserendo in input 0, altri-
menti il loop continua.
Prima di entrare nel nostro ciclo, carichiamo i dati tramite la funzione load_save (prima e unica invocazione della fun-
zione), e setta il valore di w23 a 0 (registro usato come booleana per decidere il comportamento della funzione print_menu).
Una volta dentro al ciclo principale, il programma farà la prima stampa completa di tutti i dati appena caricati in 
memoria, compreso il menu di selezione per le azioni.
Nella riga successiva, si chiede all'utente di inserire in input il numero dell'azione che vuole eseguire, e il nostro
programma tramite una serie di compare, va a selezionare la funzione associata, la invoca, la esegue, e al termine 
riparte il loop con una stampa, in questo modo le modifiche apportate saranno subito visibili.
In caso di inserimento del num 3, ovvero modalità filtro, il programma setta w23 a 1 (booleana ==True) e riparte da
inizio loop entrando nella funzione print_menu ma comportandosi come un filtro grazie al nostro 1 in w23.
In caso di inserimento di 4, il programma ristampa tutti i record....abbiamo inserito questa funzione, perchè
un'utente che si trova in modalità filtro, potrebbe voler visualizzare tutti i record nuovamente. */
main:                         //inizio del main  
    stp x29, x30, [sp, #-16]!

    bl load_data              //invochiamo la funzione load_data che carica i dati del nostro file nella memoria  
    mov w23, #0               //booleana per far funzionare la funz print menu in modalità filtrata True=1 e False=0
    main_loop:
        bl print_menu                   //funzione di stampa e funzione di filtraggio (tramite booleana in w23 0-1)
        prendi_input:                   //
        read_int fmt_richiesta_menu     //prendiamo in input la scelta di menu
        
        cmp x0, #0
        beq end_main_loop               //se la scelta fosse 0, termina il programma saltata all'end_main_loop
        
        cmp x0, #1                      //se la scelta fosse 1
        bne no_aggiungi_corso           //
        bl aggiungi_corso               //invochiamo la funzione per inserire un nuovo corso
        no_aggiungi_corso:

        cmp x0, #2                      //se la scelta fosse 2
        bne no_elimina_corso            //
        bl elimina_corso                //invochiamo la funziona per eliminare un corso già esistente
        no_elimina_corso:

        cmp x0, #3                      //se la scelta fosse 3
        bne no_filtra_esami             //
        mov w23, #1                     //settiamo il valore della booleana in w23 a 1, e
        b main_loop                     //ritorniamo all'inizio del loop, dove entremeo nella funzione di stampa in mod filtro
        no_filtra_esami:

        cmp x0, #4                      //se la scelta fosse 4
        bne no_ristampa                 //
        b main_loop                     //funzione creata principalmente per uscire da mod. filtro e ristampare
        no_ristampa:

        cmp x0, #5                      //se la scelta fosse 5
        bne no_modifiche                //
        bl modifica_corso               //entra nella funzione creata per modificare i parametri di un esame già inserito 
        no_modifiche:

        cmp x0, #9
        bne no_crediti
        adr x0, fmt_crediti
        bl printf
        b prendi_input
        no_crediti:
   

        b main_loop                     //ritorno ad inizio ciclo
    end_main_loop:

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)


.type load_data, %function
/*funzione che sfrutta le librerie di C, tramite fopen, fclose e fread, per caricare in memoria i nostri dati salvati
su file. La funzione viene invocata solo una volta, ad inizio del main. */
load_data:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!
    /*Salviamo nello stack x19 in quanto lo utilizzeremo per caricare il nome del nostro file */
    
    adr x0, filename            //carichiamo il nome del nostro file
    adr x1, read_mode           //scegliamo la modalità r (lettura) 
    bl fopen                    //e lanciamo fopen per aprire il file
                                //se il file non esiste o non è stato creato, fopen restituisce 0, altrimenti restituisce l'indirizzo
    cmp x0, #0                  //
    beq end_load_data           //dopo il compare se il file non esiste (ovvero fopen restituisce 0), si chiude la funzione

    mov x19, x0                 //carichiamo l'indirizzo del nostro file in x19 per non perderlo nelle varie letture

    //in questa prima lettura, prendiamo i primi 4 bytes del file, che rappresentano il num di corsi salvati,e li mettiamo nella costante n_corsi
    ldr x0, =n_corsi            //destinazione
    mov x1, #4                  //quanti bytes leggere
    mov x2, #1                  //quante volte leggere
    mov x3, x19                 //sorgente
    bl fread    

    //in questa seconda lettura, leggiamo i nostri record salvati    
    ldr x0, =corso              //destinazione
    mov x1, corso_size_aligned  //quanti bytes leggere
    mov x2, max_corsi           //quante volte leggere ...in pratica gli abbiamo detto di salvare "corso_size_aligned x max_corsi" bytes
    mov x3, x19                 //sorgente
    bl fread

    mov x0, x19                 //spostiamo l'indirizzo del nostro file in x0
    bl fclose                   //chiude il programma

    end_load_data:

    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size load_data, (. - load_data)


.type save_data, %function
/*Funzione che sfrutta le librerie di C, tramite fopen, fclose e fwrite, per salvare i dati, che sono stati inseriti o 
modificati nella memoria, all'interno del nostro file. Se il file non esiste, lo crea, e se ci sono errori nella 
procedura di save, stampa una stringa di error. La funzione viene invocata al termine delle seguenti funzioni:
-aggiungi_corso
-elimina_corso
-modifica_corso*/
save_data:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!
    /*Salviamo nello stack x19 in quanto lo useremo per il nome del file e l'indirizzo */

    adr x0, filename            //carichiamo il nome del nostro file
    adr x1, write_mode          //scegliamo la modalità w (scrittura)
    bl fopen                    //e lanciamo fopen per aprire il file
    /*se il file non esiste, verrà creato, altrimenti se già esistente, verrà aperto e fopen restituisce l'indirizzo
    ...in caso di errori di apertura del file , fopen restituisce 0  */

    cmp x0, #0                  //in caso di errori di caricamento
    beq fail_save_data          //e saltiamo al messaggio di errore

        mov x19, x0             //carichiamo in x19 indirizzo del file

        //in questa prima fwrite salviamo nei primi 4 bytes, il numero di corsi presente nella nostra struttura    
        ldr x0, =n_corsi        //sorgente
        mov x1, #4              //quanti bytes salvare
        mov x2, #1              //quante volte salvarli
        mov x3, x19             //destinazione
        bl fwrite

        //in questa seconda fwrite, salviamo tutti i dati dei nostri corsi inseriti   
        ldr x0, =corso              //sorgente
        mov x1, corso_size_aligned  //quanti bytes salvare
        mov x2, max_corsi           //quante volte ....in queste due righe abbiamo detto di salvare "corso_size_aligned x max_corsi" bytes
        mov x3, x19                 //destinazione
        bl fwrite

        mov x0, x19                 //chiudiamo il file
        bl fclose

        b end_save_data             //fine salvataggio corretto

    fail_save_data:                 //fmt string usata per errori di save
        adr x0, fmt_fail_save_data
        bl printf

    end_save_data:

    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size save_data, (. - save_data)

.type print_menu, %function
/*Abbiamo scelto di sfruttare la funzione print_menu sia per stampare tutti gli elementi della struttura, che 
per la modalità filtro ...sostanzialmente cambia il modo in cui si comporta se al momento dell'invocazione della 
funzione, il registro w23 è settato a 0 o 1 (la nostra "booleana").
Se la booleana è settata a 0, salterà tutte le funzioni di controllo per il filtro e stamperà tutti i "record".
Se la booleana è settata a 1, all'inizio della funzione, chiederà il voto minimo da usare come parametro per il
filtro, e successivamente effettua il controllo ad ogni record, per vedere se il vote soddisfa il parametro in input
, nel caso lo rispettasse, la funzione stampa il record associato, altrimenti salta direttamente alla label in cui
si aumenta il nostro "offset iniziale" e riprende a scansionare.
Sempre all'interno della funzione, se siamo in modalità stampa completa di tutti i record, stampa anche le statistiche,
che vengono invocate proprio all'interno di questa funzione....abbiamo scelto di farlo qui, perchè dopo 
l'aggiunta/eliminazione di un corso, il programma invoca questa funzione di stampa, in questo modo le statistiche saranno
aggiornate.
Abbiamo scelto di non mostrare le statistiche durante la modalità filtro, perchè si sviluppano su tutti gli esami superati
presenti, e non avrebbe senso mostrare la media magari solo su 2 record filtrati.
In entrambe le modalità il menu delle opzioni sarà stampato. */
print_menu:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    str x24, [sp,#-8]!
    
    /*Uso dei registri Callee-Saved
        x19 usato per il calcolo dell'ID
        x20 usato per il numero complessivo di corsi caricati
        x21 usato per l'offset di corso
        x22 usato per l'annualità da stampare in mod filtro 
        w23 usato come interruttore mod filtro e mod stampa semplice
        w24 usato come contatore dei risultati filtrati*/

    //nelle prossime 3 righe carichiamo nei registri contatore ID, num. di corsi e offset corso
    mov w19, #0                             // ID
    ldr w20, n_corsi                        // numero di corsi
    ldr x21, =corso                         // offset iniziale di corso (la nostra i==0)


    //stiamo verificando se siamo in mod filtro tramite la booleana in w23:
    verifica_mod_filtro: 
    cmp w23, #1                             //booleana True=1 e False=0
    bne stampa_semplice                     //se è false salta a stampa_semplice
    read_int fmt_richiesta_index_filtro     //se è True prende da input il voto minimo da filtrare
    mov w22, w0                             //spostiamo in w22 il nostro voto minimo da filtrare
    mov w24, #0                             //settiamo a 0 il contatore dei corsi che matchano il filtro
    cmp w22, #18                            //nelle successive 5 righe controlliamo che il voto del filtro sia in range
    blt resetta_filtro                  
    cmp w22, #30
    bgt resetta_filtro
    b stampa_semplice
    resetta_filtro:
        mov w23, #0
    //nelle successive 10 righe stampiamo la prima parte di layout che è sempre presente ...ovvero intestazione
    stampa_semplice:                        
    adr x0, fmt_menu_titolo                 // Titolo
    bl printf

    //adr x0, fmt_separatore                  //linea tratteggiata
    //bl printf
    adr x0, fmt_menu_intestazione           //nomi colonne
    bl printf
    adr x0, fmt_separatore                  //linea tratteggiata
    bl printf

    //qui finisce la parte di layout sempre presente

    //verifichiamo se siamo in modalità filtro, per stampare eventualmente il voto minimo da visualizzare
    cmp w23, #1                             //booleana True=1 e False=0
    bne print_entries_loop                  //se è settata su false, va direttamente al ciclo di stampa normale    

    adr x0, fmt_voto_da_stampare            //se è true, format string che introduce la modalità filtro
    mov w1, w22                             //e indichiamo nella stampa quale è il voto minimo
    bl printf
    //fine intestazione filtro

    adr x0, fmt_separatore
    bl printf



    //inizio ciclo di stampa
    print_entries_loop:
        add w19, w19, #1        //aumentiamo l'ID in questo punto, in quanto ci torna utile farlo ora anche per la mod filtro
        cmp w19, w20            //verifichiamo tramite ID e N.corsi se siamo arrivati alla fine
        bgt end_print_entries_loop //salta a fine loop
        
        //se siamo in modalità filtro, nelle prossime 8 righe, verifichiamo se un ID è da stampare                  
        cmp w23, #1                         //booleana
        bne stampa_predefinita              //se è False salta tutta la parte del filtro e stampa tutti gli ID
        ldr w4, [x21, offset_sostenuto]     //carica booleana esame effettuato 0-1 
        cmp w4, #1                          //confronta con 1 la booleana esame, e se uguale prosegue a riga 395
        bne aumentoindici                   //se false, salta ad aumentoindici, dove aumentiamo il valore di x21 in modo da posizionarsi all'Id successivo
        ldr w5, [x21, offset_voto]          //carichiamo su w5 il voto
        cmp w5, w22                         //lo confrontiamo con il valore minimo da stampare, e se corrisponde iniziamo la stampa del record 
        blt aumentoindici                   //se non corrisponde, come su, andiamo direttamente ad aumentoindici
        add w24, w24, #1                    //aumentiamo il contatore delle materie che rispondo ai requisiti di filtro


    stampa_predefinita:    
        adr x0, fmt_menu_entry              //format string
        mov w1, w19                         //ID
        add x2, x21, offset_nome            //Nome Corso
        ldr w3, [x21, offset_cfu]           //Cfu
        /* anche se caricati in precedenza, ricarichiamo nuovamente sostenuto e voto, perchè 
        in caso di stampa senza filtro, le righe di prima sarebbero saltate e i valori vanno caricati*/
        
        ldr w4, [x21, offset_sostenuto]     //carichiamo la booleana 0-1 relativa ad esame superato
        cmp w4, #0                          //nelle prossime 6 righe, verifichiamo la booleana 
        beq non_passato                     //se settata su 0, saltiamo alla riga 440 e carichiamo la fmt "no" 
        adr x4, fmt_esame_si                //se settata su 1, settiamo la fmt "si" e saltiamo a carica voto            
        b carica_voto                       //brach che viene eseguito per evitare di sovrascrivere il si con il no
        non_passato:
        adr x4, fmt_esame_no

        carica_voto:
        ldr w5, [x21, offset_voto]          //voto
        
        ldr w6, [x21, offset_lode]          //carichiamo la boolean 0-1 relativa a Lode
        cmp w6, #0                          //nelle prossime 6 righe, verifichiamo la booleana
        beq no_lode                         //se settata su 0, saltiamo alla riga 452 e carichiamo la fmt "no"
        adr x6, fmt_lode_si                 //se settata su 1, settiamo la fmt "si" e saltiamo al printf a riga 419
        b stampa                            //branch che viene eseguito per evitare di sovrascrivere il si con il no
        no_lode:
        adr x6, fmt_lode_no
    
        stampa:
        bl printf                           //stampa l'intera fmt appena caricata valore per valore


        aumentoindici:
        add x21, x21, corso_size_aligned    //salviamo in x21 la somma tra il precedente registro iniziale di corso e la size di un intera riga
        b print_entries_loop                //ristarta il ciclo

    
    end_print_entries_loop:                 
    cmp w23,#0                              //le prossime 7 righe, servono per la stampa di error in caso di
    beq stampa_statistiche                  //tentativo di filtraggio, in assenza di corsi o di corsi che matchano il voto inserito in input
    cmp w24,#0                              
    bgt stampa_statistiche
    adr x0, fmt_fail_filtra_esame_sostenuto
    bl printf
    b skip_statistiche


    stampa_statistiche:
    cmp w23, #0                             //verifichiamo se siamo in modalità filtro
    bne skip_statistiche                    //se si, evitiamo di stampare le statistiche
    
    //statistiche
    adr x0, fmt_separatore                  //linea di separazione
    bl printf 

    adr x0, fmt_statistiche
    bl printf
    bl calcola_esami_superati               //invochiamo la funzione per conteggiare i num. di esami superati
    bl calcola_cfu_ottenuti                 //invochiamo la funzione per conteggiare i cfu appena ottenuti
    bl calcola_voto_medio                   //invochiamo la funzione per media ponderata e base di laurea

    skip_statistiche:
    adr x0, fmt_separatore                  //linea di separazione
    bl printf

    adr x0, fmt_menu_options                //stampa il menu delle opzioni di scelta
    bl printf

    mov w23, #0                             //prima di uscire, risettiamo il valore della boleana del filtro a 0
    ldr x24, [sp], #8
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size print_menu, (. - print_menu)

.type aggiungi_corso, %function
/*La funzione aggiungi_corso, viene sfruttata per inserire un'intero corso da 0. 
La funzione si erege su 4 macro:
-macro scansione numeri interi
-macro scansione stringhe
-macro memorizzazione interi
-macro memorizzazione stringhe
All'interno della funzione, a seconda della tipologia di dato che dobbiamo acquisire, verranno invocate nel modo 
più opportuno, e in caso di esame non superato (ovvero valore 0), la funzione tramite una serie di compare, inserisci
direttamente lui i valori 0 nei campi successivi, senza richiedere l'inserimento manuale.
Prima di uscire dalla funzione, il programma aggiorna il valore di n_corsi , importantissimo per il load e il save dei
dati. */
aggiungi_corso:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    str x21, [sp, #-8]!
    /* Uso dei registri Calle-Saved:
            -x19 usato per il numero di corsi
            -x20 usato per acquisire l'indirizzo iniziale di corso
            -w21 usato per caricare i valori presi in scan ed evitare di perderli durante invocazione di altre macro*/

    ldr x19, n_corsi            //carichiamo n_corsi
    ldr x20, =corso             //carichiamo indirizzo iniziale di corso
    
    //tramite alcuni calcoli, facciamo in modo che x20 punti alla fine dei dati già presenti in modo da non sovrascrivere nulla 
    mov x0, corso_size_aligned  //la dimensione di ogni corso/record 
    mul x0, x19, x0             //n_corsi x corso_size_aligned= numero di bytes già occupati e aggiungengoli
    add x20, x20, x0            //all'indirizzo di corso in x20, il mio "puntatore" si sposta esattamente a fine array
    

    cmp x19, max_corsi          //se abbiamo già raggiunto il numero massimo di corsi inseribili, allora il programma salta
    bge fail_aggiungi_corso     //a fine funzione e stampa un messaggio di error
    
        read_str fmt_richiesta_corso            //acquisiamo in input il nome del corso
        save_to x20, offset_nome, size_nome     //e salviamo tramite la macro 

        read_int fmt_richiesta_cfu              //acquisiamo in input i cfu
        save_to_int x20, offset_cfu, size_cfu   //e salviamo tramite macro
        prendi_input_esame_sostenuto_aggiungi:
        read_int fmt_richiesta_esame            //acquisiamo in input l'esito dell'esame (0=non passato e 1=promosso)
        mov w21, w0                             //facciamo backup del suo valore prima di invocare le macro
        cmp w21, #0
        blt prendi_input_esame_sostenuto_aggiungi
        cmp w21, #1
        bgt prendi_input_esame_sostenuto_aggiungi
        save_to_int x20, offset_sostenuto, size_sostenuto //e salviamo tramite la macro
        cmp w21, #1                             //confrontiamo il valore backuppato in precedenza con 1
        beq inserisci_voto_manualmente          //se uguale saltiamo all'inserimento manuale dei voti
        save_to_int x20, offset_voto, size_voto //altimenti significa che il valore è ==0 ed attualmente si trova
        save_to_int x20, offset_lode, size_lode //in tmp_int, così ci basta invocare nel modo giusto le due macro e inseriamo
        b fine                                  //a 0 voto e lode, per poi saltare a fine

        

    inserisci_voto_manualmente:
        read_int fmt_richiesta_voto                 //input del voto
        mov w21, w0                                 //backup del voto
        save_to_int x20, offset_voto, size_voto     //salviamo il voto tramite la macro
        cmp w21, #30                                //compariamo il voto con 30, e se non uguale
        bne continua_inserimento                    //saltiamo a continua_inserimento 
        read_int fmt_richiesta_lode                 //altrimenti chiediamo se ha preso la lode (0=no, e 1=si)
        save_to_int x20, offset_lode, size_lode     //salviamo il record
        b fine                                      //saltiamo a fine solo se abbiamo dovuto inserire lode si/no    


    continua_inserimento:                           
        ldr x21, =tmp_int                           //label per inserire a 0 la lode in modo automatico in caso di voto
        mov w22, #0                                 // inferiore al 30, il tutto tramite macro per essere sicuri dell'alli- 
        str w22, [x21]                              //neamento dei bytes
        save_to_int x20, offset_lode, size_lode

    fine:
        add x19, x19, #1                            //prima di uscire aumentiamo il valore di n_corsi
        ldr x20, =n_corsi
        str x19, [x20]

        bl save_data         //invochiamo la funzione save_date, per salvare il record anche nel file

        b end_aggiungi_corso //salto a fine funzione
    
    fail_aggiungi_corso:
        adr x0, fmt_fail_aggiungi_corso  //fmt string che viene stampata in caso di error
        bl printf
    
    end_aggiungi_corso:
    ldr x21, [sp], #8
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size aggiungi_corso, (. - aggiungi_corso)


.type elimina_corso, %function
/*La funzione elimina_corso, viene sfruttata per rimuovere un'intero corso esistente. 
La funzione fa uso della libreria di C, in particolare usiamo memcpy.
In sostanza, si chiede all'utente quale ID si vuole eliminare, e se in range, con il numero inserito
facciamo dei calcoli per capire esattamente quanti record succesivi a quello indicato in input
dobbiamo spostare, in quanto la funzione andrà semplicemente a copiare questi bytes a partire dal punto 
iniziale dell'id indicato in iput, che non sarà proprio eliminato, ma sarà semplicemente sovrascritto.
Prima di uscire dalla funzione, il programma aggiorna il valore di n_corsi , importantissimo per il 
load e il save dei dati. 
Ritornati nel loop del main, il programma stamperà l'intero libretto aggiornato.*/
elimina_corso:
    stp x29, x30, [sp, #-16]!
    /*non essendoci la necessità di conservare dati per molto tempo, nessun registro Callee-saved viene utilizzato */
    
    read_int fmt_richiesta_index    //chiediamo in input l'ID che si vuole eliminare

    //controlliamo se il valore inserito in input è nel range dei n_corsi esistenti
    cmp x0, 1
    blt end_elimina_corso

    ldr x1, n_corsi
    cmp x0, x1
    bgt end_elimina_corso
    //fine validazione input

    sub x5, x0, 1   // sottraiamo 1 all'ID inserito in input, in quanto a differenza da quanto stampato nel print, i nostri Id partono da 0
    ldr x6, n_corsi // carichiamo il numero di corsi presenti
    sub x6, x6, x0  // qui acquisiamo il num di corsi, successivi all'ID che dobbiamo spostare
    mov x7, corso_size_aligned  //dimensione di un singolo corso
    ldr x0, =corso  //offser iniziale di corso
    mul x1, x5, x7  // offset to dest (bytes presenti da punto iniziale di corso fino a ID input-1)
    
    add x0, x0, x1  // destinazione 
    add x1, x0, x7  // sorgente
    mul x2, x6, x7  // quantità di bytes da copiare
    bl memcpy

    //nelle prossime 4 righe aggiorniamo il valore di n_corsi in memoria
    ldr x0, =n_corsi
    ldr x1, [x0]
    sub x1, x1, #1
    str x1, [x0]

    bl save_data    //salviamo su file

    end_elimina_corso:
    
    ldp x29, x30, [sp], #16
    ret
    .size elimina_corso, (. - elimina_corso)


.type calcola_voto_medio, %function
/*La funzione calcola_voto_medio viene utilizzata per calcolare due statistiche float: la media ponderata e
la base di laurea.
Abbiamo usato una unica funzione, in quanto, anche se la Base di Laurea esprime una cosa differente dalla
media ponderata, quest'ultima risulta necessaria per il calcolo della prima.
Al fine dell'espletamento del calcolo, abbiamo utilizzato fin da subito registri neon per i nostri calcoli.
La funzione si basa su un loop, che scandisce corso per corso, e di fronte ad un esame superato, somma in 
un registro il risultato tra (voto x cfu), mentre in un secondo registro somma i cfu (n.b. in caso di lode
prima di fare la moltiplicazione, somma 0.5 al voto)...al termine della scansione dei corsi effettua la 
divisione tra il primo registro e il secondo, per ottenere la media ponderata.
Prima di stamparlo, effettuiamo il backup  del valore, in quanto per il calcolo della base di Laurea, effettueremo 
il seguente calcolo: MediaPonderata x 30 / 110 .  Al termine manda in stampa anche questo risultato. 
Inizializziamo i registri d1 e d2 a 0.0 mediante una variabile, in quanto abbiamo notato che nonostante
questo sia l'unica funzione dove usiamo registri neon, se non la inizializzavamo a 0, la nostra funzione 
dava risultati sbagliati in quanto in d1 vi era già un valore.*/
calcola_voto_medio:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    /*Uso dei registri Callee-saved:
            -w19 viene utilizzato per caricare il numero dei corsi presenti
            -w20 viene utilizzato come contatore per uscire dal loop
            -x21 viene utilizzato per il calcolo progressivo degli offset 
            -w22 viene usato per una booleana 0-1 per almeno un esame superato*/

    //controlliamo che siano presenti dei corsi, altrimenti stampiamo stringa di error    
    ldr w19, n_corsi
    cmp w19, #0
    beq calcola_voto_medio_error


        ldr x1, =somma_voto             //carichiamo in x1 l'indirizzo della variabile somma_voto e
        ldr d1, [x1]                    //la carichiamo in d1 (che ora vale 0.0)
        ldr x1, =somma_cfu              //carichiamo in x1 l'indirizzo della variabile somma_cfu e
        ldr d2, [x1]                    //la carichiamo in d2 (che ora vale 0.0)
        ldr x1, =valore_lode            //carichiamo in x1 l'indirizzo della variabile valore_lode e
        ldr d5, [x1]                    //la carichiamo in d5 (che ora vale 0.5)
        
        mov w20, #0                     //inizializiamo il nostro contatore a 0
        ldr x21, =corso                 //acquisiamo l'offset iniziale di corso
        mov w22, #0                     //booleana per almeno un esame superato
        //inizio loop
        calcola_voto_medio_loop: 
            ldr w0, [x21, offset_sostenuto] //nelle seguenti 3 righe verifichiamo se è un'esame superato
            cmp w0,#0                       //se non lo è, saltiamo alla label salto1 nella quale
            beq salto1                      //si aumenta offset per passare al corso successivo, mentre se è
            mov w22, #1                     //settiamo la booleana di esame sup a 1 (==True)
            ldr w0, [x21,offset_voto]       //superato, carichiamo in w0 il voto dell'esame del corso
            scvtf d3, w0                    //lo convertiamo in float
            ldr w0, [x21, offset_cfu]       //carichiamo i cfu del corso in w0 
            scvtf d4, w0                    //lo convertiamo in float
            ldr w0, [x21, offset_lode]      //nelle prossime 4 righe verifichiamo se abbiamo preso la lode
            cmp w0, #0                      //se si, aggiungiamo il valore della lode (0.5) che è in d5
            beq no_lode_calcolo             // al nostro voto appena acquisito
            fadd d3, d3, d5                 //se non abbiamo preso lode si salta direttamente al calcolo

        no_lode_calcolo:    
            fmadd d1, d3, d4, d1            //salviamo in d1=(voto x cfu)+somma_voto
            fadd d2, d2,d4                  //sommiamo in d2=cfu+somma_cfu
        salto1:
            add x21, x21, corso_size_aligned    //nelle prossime 4 righe controlliamo se siamo a fine loop
            add w20, w20, #1                    //e aumentiamo l'offset per spostarci al corso successivo
            cmp w20, w19
            blt calcola_voto_medio_loop
        //fine loop

        cmp w22, #0                         //prima di procedere con i conti, verifichiamo che ci sia almeno
        beq calcola_voto_medio_error        //un voto presente, altrimenti salta al mess di error

        adr x0, fmt_media_voto              //carichiamo la fmt per la media ponderata
        fdiv d0, d1, d2                     //salviamo in d0= sommatoria(voto x cfu)/somma_cfu ...media ponderata
        fmov d19, d0                        //facciamo un backup della media ponderata appena calcolata in d19

        bl printf                           //la stampiamo

        b end_calcola_voto_medio            //branch per evitare di stampare la fmt di error in caso di assenza di corsi

    calcola_voto_medio_error:
        adr x0, fmt_fail_calcolo_voto_medio_error //fmt di error
        bl printf
        b end_calcola_voto_medio_definitivo

    end_calcola_voto_medio:
    fmov d0, d19                            //ripristiniamo la media ponderata in d0
    mov w1, #30                             //carichiamo 30 in w1
    scvtf d1, w1                            //e lo convertiamo in float in d1
    mov w1, #110                            //carichiamo 110 in w1
    scvtf d2, w1                            //e lo convertiamo in float in d2
    fdiv d0, d0, d1                         //dividiamo la media per 30.0
    fmul d0, d0, d2                         //e moltiplichiamo per 110.0 , ottenendo la nostra base di laurea

    adr x0, fmt_base_di_laurea              //carichiamo la fmt per la base di laurea
    bl printf                               //e la stampiamo



    end_calcola_voto_medio_definitivo:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size calcola_voto_medio, (. - calcola_voto_medio)

.type calcola_cfu_ottenuti, %function
/*Funzione dedicata al calcolo dei cfu ottenuti negli esami superati.
In un loop facciamo scandire in tutti i record presenti il valore di "Esame_superato/offset_sostenuto",
e se settato su 0 salta al record successivo, se settato su 1 andrà a leggere il valore di cfu e lo 
somma in un registro, che alla fine stamperemo. */
calcola_cfu_ottenuti:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    /*Uso dei registri Callee-saved:
            -w19 usato per il numero di corsi presenti
            -x20 usato per l'offset di corso e altri puntatori */


    //nelle prossime 3 righe controlliamo che siano presenti effettivamente dei corsi
    ldr w19, n_corsi
    cmp w19, #0
    beq calcola_cfu_ottenuti_error

        
        mov w1, #0                          //inizializiamo in w1=0 il registro che useremo per conservare la somma fino a fine calcolo
        mov w3, #0                          //w3 viene usato come contatore , in modo da poter uscire dal loop
        ldr x20, =corso                     //offset iniziale del corso
       
        //inizio loop       
        calcola_cfu_ottenuti_loop:
            ldr w2, [x20, offset_sostenuto] //carichiamo in w2 il valore di "esame superato"
            cmp w2, #0                       //lo confrontiamo con 0, e
            beq non_calcolare               //nel caso sia 0, salta al record successivo perchè l'esame non è stato superato
            ldr w2, [x20, offset_cfu]       //se invece in w2, il valore era 1, ora in w2 ci carichiamo il numero dei cfu associati
            add w1, w1, w2                  //e li sommiamo a w1 per tenerne conto

        non_calcolare:                      
            add x20, x20, corso_size_aligned    //modifichiamo l'offest per spostarci al corso successivo
            add w3, w3, #1                      //aumentiamo il nostro contatore di 1
            cmp w3, w19                         //confrontiamo con il numero di corsi, ed usciamo quando sarà uguale, evitando di andare "out of index"
            blt calcola_cfu_ottenuti_loop
        //fine loop

        
        cmp w1,#0                               //verifichiamo di aver ottenuto almeno 1 cfu e in questo caso saltiamo
        bgt almeno_un_cfu                 //alla label almeno_uno_superato 
        adr x0, fmt_fail_calcolo_cfu_ottenuti_error     //altrimenti carichiamo la label di error
        b stampa_cfu                                    //e in questo caso saltiamo alla stampa del messagio di error
        almeno_un_cfu:
        adr x0, fmt_cfu_ottenuti                //carichiamo la fmt per stampare il numero di cfu ottenuti
        stampa_cfu:
        bl printf                               //stampiamo

        b end_calcola_cfu_ottenuti              //branch all'end

    calcola_cfu_ottenuti_error:
        adr x0, fmt_fail_calcolo_cfu_ottenuti_error     //messaggio di error in caso di assenza di corsi o di assenza di corsi super
        bl printf
    
    end_calcola_cfu_ottenuti:

    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size calcola_cfu_ottenuti, (. - calcola_cfu_ottenuti)

.type calcola_esami_superati, %function
/*Funzione dedicata al calcolo del numero di esami superati.
In un loop facciamo scandire in tutti i record presenti il valore di "voto", così da poter contare tutti i voti >=18, ma si 
sarebbe potuto utilizzare anche il valore registrato in "esame_superato/offset_sostenuto" ottenendo il medesimo risultato. 
Usiamo un doppio contatore, uno per poter uscire dal loop a fine scansione e uno per contare il numero di esami superati, e
alla fine stamperemo questo valore.*/
calcola_esami_superati:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    /*Uso dei registri Callee-saved:
            -w19 usato per il numero di corsi presenti
            -x20 usato per l'offset di corso e altri puntatori */

    //nelle prossime 3 righe controlliamo che siano presenti effettivamente dei corsi
    ldr w19, n_corsi
    cmp w19, #0
    beq calcola_esami_superati_error


        mov w1, #0                          //inizializziamo la nostra sommatoria a 0
        mov w3, #0                          //inizializziamo il nostro contatore a 0
        ldr x20, =corso                     //offset iniziale di corso
        
        //inizio loop
        calcola_esami_superati_loop:
            ldr w2, [x20, offset_voto]      //carichiamo il valore di voto
            cmp w2,#18                      //lo confrontiamo con il voto minimo di 18
            blt non_calcolare_esami         //se inferiore a 18, saltiamo al record succesivo 
            add w1, w1, #1                  //se l'esame è stato superato

        non_calcolare_esami:                    
            add x20, x20, corso_size_aligned    //modifichiamo l'offset per spostarci al corso successivo
            add w3, w3, #1                      //aggiungiamo 1 al nostro contatore di uscita
            cmp w3, w19                         // controlliamo se siamo a fine loop
            blt calcola_esami_superati_loop     //b ad inizio loop se non abbiamo finito la scansione dei corsi
        //fine loop


        cmp w1,#0                               //verifichiamo di aver superato almeno 1 esame e in questo caso saltiamo
        bgt almeno_uno_superato                 //alla label almeno_uno_superato 
        adr x0, fmt_fail_calcolo_esami_superati     //altrimenti carichiamo la label di error
        b stampa_n_esami_superati                      //e saltiamo alla stampa
        almeno_uno_superato:
        adr x0, fmt_esami_superati              //carichiamo la fmt string per stampare il numero di esami superati    
        stampa_n_esami_superati:
        bl printf                               //stampa

        b end_calcola_esami_superati            //salto a fine funzione

    calcola_esami_superati_error:
        adr x0, fmt_fail_calcolo_esami_superati //format di errore
        bl printf
    
    end_calcola_esami_superati:

    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size calcola_esami_superati, (. - calcola_esami_superati)

.type modifica_corso, %function
/*Abbiamo deciso di implementare questa funzione per un senso di completezza del programma, perchè oltre a voler inserire
o eliminare dati, l'utente potrebbe voler modificare un record già inserito, aggiornando l'esito degli esami.
La funzione è un mix tra elimina_corso e aggiungi_corso:
        -a inizio funzione chiediamo un'input (in range) che è l'ID che vogliamo modificare
        -tramite un calcolo, all'inizio determiniamo il valore del nostro offset
        -chiediamo all'utente di inserire i dati modificati tramite le medesime macro di aggiungi_corso
La differenza principale tra questa funzione e aggiungi_corso, sta nell'offset/puntatore ...in questa funzione, stiamo 
puntando ai bytes esatti che vogliamo modificare, mentre in aggiungi_corso l'offset punta direttamente alla fine di tutti 
i corsi già presenti, aggiungendo in coda i dati inseriti.  */
modifica_corso:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    //carichiamo i tre valori necessari per calcolare il nostro offset
    ldr x19, n_corsi                
    ldr x20, =corso
    mov x21, corso_size_aligned

    read_int fmt_richiesta_index        //chiediamo in input quale ID si vuole modificare

    //nelle seguenti 5 righe verifichiamo che il valore in input sia in range
    cmp x0,#1
    blt end_modifica_corso
    cmp x0, x19
    bgt end_modifica_corso

    //
    sub x0, x0, #1
    mul x0, x0, x21
    add x20, x20, x0 
    //ldr x25, =tmp_int
        prendi_input_esame_sostenuto_modifica:
        read_int fmt_richiesta_esame                        //chiediamo in input l'esisto dell'esame 0-1
        mov x19, x0                                         //lo salviamo in x19 prima di invocare la
        cmp x19, #0
        blt prendi_input_esame_sostenuto_modifica
        cmp x19, #1
        bgt prendi_input_esame_sostenuto_modifica
        save_to_int x20, offset_sostenuto, size_sostenuto   //macro per salvare il nuovo valore
        cmp x19, #1                                         //confrontiamo il nuovo valore con 1, e se uguale saltiamo all'inserimento successivo
        beq inserisci_voto_manualmente_modifica 
        save_to_int x20, offset_voto, size_voto             //altrimenti carica in automatico 0 in voto e
        save_to_int x20, offset_lode, size_lode             //carica in automatico 0 a lode
        b fine_modifica                                     //salto a fine_modifica

        

    inserisci_voto_manualmente_modifica:                    
        read_int fmt_richiesta_voto                 //input del voto
        mov x19, x0                                 //backup del voto
        save_to_int x20, offset_voto, size_voto     //salviamo il voto tramite la macro
        cmp x19, #30                                //compariamo il voto con 30, e se non uguale
        bne no_lode_modifica                        //saltiamo a no_lode_modifica
        read_int fmt_richiesta_lode                 //altrimenti chiediamo se ha preso la lode (0=no, e 1=si)
        b invoca_save_lode                          //se abbiamo inserito la lode manualmente, salta alla macro di salvataggio
        no_lode_modifica:               
        ldr x0, =tmp_int                            //nel caso di voto inferiore a 30, in queste 3 righe
        mov x1, #0                                  //mettiamo il valore 0 in tmp_int,
        str x1, [x0]                                //prima di invocare la macro di salvataggio
        invoca_save_lode:
        save_to_int x20, offset_lode, size_lode

    
    fine_modifica:
        bl save_data                                //salviamo tutte le modifiche

        b end_modifica_corso                        //salto all'uscita della funzione
    
    fail_modifica_corso:                            
        adr x0, fmt_fail_aggiungi_corso             //fmt per error
        bl printf
    end_modifica_corso:
    
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size modifica_corso, (. - modifica_corso)

