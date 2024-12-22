;
; Programme CHOIX.ASM
;
; Cr‚‚ le 31-01-1991 par Pr‚martin Patrick.
;
; Ce programme a pour but d'attendre l'appuit sur une touche, il la met
; en majuscule si c'est une lettre minuscule, puis il renvoie le r‚sultat
; dans le registre AL avant de rendre la main au programme appelant.
; Celui ci peut tester AL (par ERRORLEVEL pour les fichiers Batch) pour
; savoir quelle touche a ‚t‚ appuy‚e.
;
; Ce programme est destin‚ … devenir CHOIX.COM, il ne contient donc pas de
; segment de pile, ni de segment de donn‚es.
;
;
;          D‚finitions des ‚quivalences:
;
dos             equ 21h
retour          equ 4ch
clavier         equ 16h
lecture         equ 00h
;
;          Programme:
;
code          segment
              assume cs : code
              assume ss : nothing
              assume ds : nothing
              assume es : nothing

start:
              mov ah, lecture     ; Lecture d'un caractŠre dans le tampon.
              int clavier         ; Attente s'il n'y en a pas.
              ; Maintenant, AL contient le code ASCII du caractŠre frapp‚.
; On met le caractŠre en majuscule.
              cmp al, 'a'
              jb  suite
              cmp al, 'z'
              ja  suite
              sub al, 20h         ; force le bit 5 … 0.
suite:
              ; AL contient le caractŠre en majuscule.
              mov ah, retour      ; Rend la main au programme appelant en
              int dos             ; laissant le code de AL inchang‚.

              db 'Copyright Pr‚martin Patrick 1991.'

code          ends
              end start
