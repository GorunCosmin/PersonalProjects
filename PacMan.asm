.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "PacMan",0
area_width EQU (matrix_wight*cel_size)+margin_left+margin_right;
area_height EQU (matrix_height*cel_size)+margin_down+margin_top;
area DD 0

cel_size equ 20;

matrix_wight equ 17;
matrix_height equ 21;

margin_top equ 40;
margin_right equ 25;
margin_down equ 50;
margin_left equ 25;




counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc
include componente_PacMan.inc
include component_harta.inc
include fantome.inc


up dd 0;
right dd 0;
down dd 0;
left dd 0;
;          0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  
matrix DB 11, 25, 25, 25, 25, 25, 23, 25, 25, 25, 23, 25, 25, 25, 25, 25, 12     ;0
       DB 15,  2,  2,  2,  2,  2, 15,  2,  3,  2, 15,  2,  2,  2,  2,  2, 15    ;1
       DB 15,  2, 34, 25, 32,  2, 33,  2, 31,  2, 33,  2, 34, 25, 32,  2, 15    ;2
       DB 15,  2,  2,  2,  2,  2,  2,  2, 15,  2,  2,  2,  2,  2,  2,  2, 15    ;3
       DB 15,  2, 31,  2, 11, 25, 32,  2, 15,  2, 34, 25, 12,  2, 31,  2, 15    ;4
       DB 15,  2, 15,  2, 15,  2,  2,  2, 33,  2,  2,  2, 15,  2, 15,  2, 15    ;5
       DB 15,  2, 15,  2, 33,  2, 31,  2,  2,  2, 31,  2, 33,  2, 15,  2, 15   ;6
       DB 15,  2, 15,  2,  2,  2, 22, 32, 16, 34, 24,  2,  2,  2, 15,  2, 15    ;7
       DB 15,  2, 33,  2, 31,  2, 15,  0,  0,  0, 15,  2, 31,  2, 33,  2, 15    ;8
       DB 15,  2,  2,  2, 33,  2, 15,  0,  0,  0, 15,  2, 33,  2,  2,  2, 15    ;9
       DB 22, 25, 32,  2,  2,  2, 14, 25, 25, 25, 13,  2,  2,  2, 34, 25, 24    ;10
       DB 15,  2,  2,  2, 31,  2,  2,  2,  0,  2,  2,  2, 31,  2,  2,  2, 15    ;11
       DB 22, 32,  2, 34, 21, 32,  2, 11, 25, 12,  2, 34, 21, 32,  2, 34, 24    ;12
       DB 15,  2,  2,  2,  2,  2,  2, 33,  3, 33,  2,  2,  2,  2,  2,  2, 15    ;13
       DB 15,  2, 34, 25, 12,  2,  2,  2,  2,  2,  2,  2, 11, 25, 32,  2, 15    ;14
       DB 15,  2,  2,  3, 15,  2, 34, 25, 25, 25, 32,  2, 15,  3,  2,  2, 15    ;15
       DB 15,  2, 34, 25, 13,  2,  2,  2,  2,  2,  2,  2, 14, 25, 32,  2, 15    ;16
       DB 15,  2,  2,  2,  2,  2, 34, 25, 23, 25, 32,  2,  2,  2,  2,  2, 15    ;17
       DB 15,  2, 17,  2, 17,  2,  2,  2, 33,  2,  2,  2, 17,  2, 17,  2, 15    ;18
       DB 15,  2,  2,  2,  2,  2, 31,  2,  2,  2, 31,  2,  2,  2,  2,  2, 15    ;19
       DB 14, 25, 25, 25, 25, 25, 21, 25, 25, 25, 21, 25, 25, 25, 25, 25, 13    ;20

var1dd dd 0;
var2dd dd 0;
var3dd dd 0;
var4dd dd 0;

poz_fructe dd 0;
timer_poz_fructe dd 0;

new_pozition dd 0;
pozition dd 0;
last_pozition dd 0;
poz_int dd 0;

PMan_timer dd 0;
PMan_form1 dd 0;

PMan_matrixX_start equ 8;
PMan_matrixY_start equ 11;
PMan_areaX_start equ margin_left+(PMan_matrixX_start*cel_size);
PMan_areaY_start equ margin_top+(PMan_matrixY_start*cel_size);

PMan_pozitionX dd PMan_areaX_start;
PMan_pozitionY dd PMan_areaY_start;

PMan_matriX dd PMan_matrixX_start
PMan_matriY dd PMan_matrixY_start

NextPozX dd 0;
NextPozY dd 0;

NextX dd 0;
NextY dd 0;

nr_dep equ 5;
nr_depAngry equ 4;
nr_depGH1 dd nr_dep;
nr_depGH2 dd nr_dep;

deplasare equ cel_size/nr_dep;
deplasare_angry equ deplasare+1;

deplasareGH1 dd deplasare;
deplasareGH2 dd deplasare;

timer_deplasare_PM dd 0;

FructFull equ 4;
FructRemain dd FructFull;
FructActualiz dd 0;

AfisY equ 470;
AfisLifeStart equ 20;
AfisFructStart equ 350

LifeFull equ 3;
LifeRemain dd LifeFull;
LifeActualiz dd 0;

EndGame dd 0;
Score_points dd 0;
AfisScoreY equ 10;
AfisScoreX equ 320;

Super_PMan dd 0;
Super_PMan_Timer dd 0;
Super_Time equ 100;

EndScoreX equ 170;
EndScoreY equ 240;

endGdep equ 10;

Ghost1xStart equ 7;
Ghost1yStart equ 8;

Ghost2xStart equ 9;
Ghost2yStart equ 8;

Ghost1X dd Ghost1xStart;
Ghost1Y dd Ghost1yStart;

Ghost2X dd Ghost2xStart;
Ghost2Y dd Ghost2yStart;

GhostArea1X dd (Ghost1xStart*cel_size)+margin_left;
GhostArea1Y dd (Ghost1yStart*cel_size)+margin_top;

GhostArea1XST equ (Ghost1xStart*cel_size)+margin_left;
GhostArea1YST equ (Ghost1yStart*cel_size)+margin_top;

GhostArea2X dd (Ghost2xStart*cel_size)+margin_left;
GhostArea2Y dd (Ghost2yStart*cel_size)+margin_top;

GhostArea2XST equ (Ghost2xStart*cel_size)+margin_left;
GhostArea2YST equ (Ghost2yStart*cel_size)+margin_top;

ghost_timer dd 0;
ghost_animation dd 0;

timer_deplasare_fant dd 0;

Ghost1Move DD 2,1,4,1,4,3,2,3,  2,3,4,1
elfinGH1 dd 48;
elbuclaGH1 dd 32;
new_depGH1 DD 0;
depGH1 dd 0;

depGhost1_timer dd 0;
elementGH1 dd 0;

Ghost2Move DD 4,1, 2,1,4,3
elfinGH2 dd 24;
elbuclaGH2 dd 8;
new_depGH2 DD 0;
depGH2 dd 0;

depGhost2_timer dd 0;
elementGH2 dd 0;

GH1angry dd 0;
GH2angry dd 0;

simtGh equ 60;
.code

Ver_endgame macro 
local skip;
  cmp LifeRemain,0;
  jne skip;
  mov EndGame,1
skip:
endm;
Print_time macro
;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
endm;
Print_text macro 
    make_text_macro 'S',area,AfisScoreX-55,AfisScoreY
    make_text_macro 'C',area,AfisScoreX-45,AfisScoreY
    make_text_macro 'O',area,AfisScoreX-35,AfisScoreY
    make_text_macro 'R',area,AfisScoreX-25,AfisScoreY
    make_text_macro 'E',area,AfisScoreX-15,AfisScoreY

endm;
Print_score macro x,y
    mov EBX,10;
	mov EAX,Score_points;
	
	mov EDX,0;
	div EBX;
	add EDX,'0'
	make_text_macro edx, area, x+40, y
	
	mov EDX,0;
	div EBX;
	add EDX,'0'
	make_text_macro edx, area, x+30, y
	
	mov EDX,0;
	div EBX;
	add EDX,'0'
	make_text_macro edx, area, x+20, y
	
	mov EDX,0;
	div EBX;
	add EDX,'0'
	make_text_macro edx, area, x+10, y
	
	mov EDX,0;
	div EBX;
	add EDX,'0'
	make_text_macro edx, area, x, y

endm;

Incrementare_time macro
local skip1,skip2,skip3,skip4;
    inc counter;
	inc timer_poz_fructe;
	inc PMan_timer;
	inc timer_deplasare_PM;
	inc timer_deplasare_fant;
	inc Super_PMan_Timer;
	inc depGhost1_timer;
	inc depGhost2_timer;
	
	inc ghost_timer;
	
	cmp ghost_timer,1
	jne skip2;
	cmp ghost_animation,0
	jne skip3;
	mov ghost_animation,1;
	jmp skip4;
skip3: 
    mov ghost_animation,0
skip4:
   mov ghost_timer,0;
skip2:


	cmp Super_PMan,1
	jne skip1;
	cmp Super_PMan_Timer,Super_Time
	jl skip1;
	    mov Super_PMan,0
skip1:
endm;

Actualizare_PacMan_form macro 
local end_m,skip1
   cmp PMan_timer,2
   jne end_m;
   mov PMan_timer,0
   cmp PMan_form1,0
   jne skip1;
   mov PMan_form1,1
   jmp end_m;
  skip1:
  mov PMan_form1,0
end_m:
endm;

Print_ecran macro 
    mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 0
	push area
	call memset
	add esp, 12
endm;

Print_ghost1 macro 
local skip,end_m,calm;
  
   cmp ghost_animation,0
   jne skip;
   Print_image_caracter GhostArea1X,GhostArea1Y,Ghost1_1_0
   jmp end_m;
skip:
   Print_image_caracter GhostArea1X,GhostArea1Y,Ghost1_2_0
end_m:
   cmp GH1angry,0
   je calm
   Print_image_caracter GhostArea1X,GhostArea1Y,angry_0
   calm:
endm;

Print_ghost2 macro 
   local skip,end_m,calm;
   cmp ghost_animation,0
   jne skip;
   Print_image_caracter GhostArea2X,GhostArea2Y,Ghost2_1_0
   jmp end_m;
skip:
   Print_image_caracter GhostArea2X,GhostArea2Y,Ghost2_2_0
end_m:
   cmp GH2angry,0
   je calm
   Print_image_caracter GhostArea2X,GhostArea2Y,angry_0
   calm:
endm;

Print_ghost macro 
    Print_ghost1;
	Print_ghost2;
endm;




;macro pozitie
;macro afis img
;replace
Calc_pozition macro x,y ;4*((y*wight)+x)
    push EBX;
	mov EAX,y;
	mov EBX,area_width
	mul EBX;
	
	mov EBX,x;
	add EAX,EBX;
	
	mov EBX,4;
	mul EBX;
	
	add EAX,area;
	pop EBX;
endm;

Print_image macro x,y,image
local loop_print,skip,new_rand;
   push ECX;
   push EAX;
   push EBX;
   push EDI;
   push ESI;
   push var1dd;
   Calc_pozition x,y;
   mov ECX,cel_size*cel_size
   mov ESI,EAX;
   lea EDI,image;
   mov var1dd,0
loop_print:
   mov EAX,[EDI]
   shl eax,4
   
   mov [ESI],eax
   
   inc var1dd;
   cmp var1dd,cel_size;
   je new_rand;
   add ESI,4;
   jmp skip;
 new_rand:  
   add ESI,(area_width-cel_size+1)*4;
   mov var1dd,0
skip:
   
   add EDI,4;
   dec ECX;
   cmp ECX,0
   jg loop_print;
   pop var1dd;
   pop ESI;
   pop EDI;
   pop EBX;
   pop EAX;
   pop ECX;
endm;

Print_image_caracter macro x,y,image
local loop_print,skip,new_rand,background;
   push ECX;
   push EAX;
   push EBX;
   push EDI;
   push ESI;
   push var1dd;
   Calc_pozition x,y;
   mov ECX,cel_size*cel_size
   mov ESI,EAX;
   lea EDI,image;
   mov var1dd,0
loop_print:
   mov EAX,[EDI]
   cmp EAX,0
   je background;
   
   shl eax,4
   
   
   mov [ESI],eax
background:
   inc var1dd;
   cmp var1dd,cel_size;
   je new_rand;
   add ESI,4;
   jmp skip;
 new_rand:  
   add ESI,(area_width-cel_size+1)*4;
   mov var1dd,0
skip:
   
   add EDI,4;
   dec ECX;
   cmp ECX,0
   jg loop_print;
   pop var1dd;
   pop ESI;
   pop EDI;
   pop EBX;
   pop EAX;
   pop ECX;
endm;

Animati macro 
local skip_1,skip_2,end_p;
  cmp timer_poz_fructe,3
  jne skip_1
  mov timer_poz_fructe,0
    cmp poz_fructe,0
	jne skip_2;
	mov poz_fructe,1;
	jmp skip_1;
skip_2:
  mov poz_fructe,0;
skip_1:
endm;

PMan_dead macro 
mov PMan_matriX,PMan_matrixX_start;
mov PMan_matriY,PMan_matrixY_start;
mov PMan_pozitionX,PMan_areaX_start
mov PMan_pozitionY,PMan_areaY_start
mov pozition,0
mov Super_PMan,0;
mov new_pozition,0
dec LifeRemain;
endm;

Print_fructe macro x,y
local p_sus,end_p;
   cmp poz_fructe,0;
   jne p_sus;
   Print_image x,y,Fruct_jos_0
   jmp end_p;
 p_sus:
   Print_image x,y,Fruct_sus_0
end_p:
endm;

Print_matrix macro 
local print_loop,skip1,no_wall,next,Score_p,Fruct;
	lea ESI,matrix;
    mov ECX,matrix_wight*matrix_height
	mov var1dd,margin_left;
	mov var2dd,margin_top
	mov var3dd,0;
print_loop:
	mov EAX,[ESI];
	mov EDX,EAX;In DL am elementul din matrix
   
   cmp DL,10
   jle no_wall
   Print_wall var1dd,var2dd,DL;
   jmp next;
no_wall:
   cmp DL,2
   je Score_p;
   cmp DL,3
   je Fruct;
   Print_image var1dd,var2dd,Background_0;
   jmp next;
Score_p:
   Print_image var1dd,var2dd,Score_point_0
   jmp next;
Fruct:
   Print_fructe var1dd,var2dd
   jmp next;   
   
next:   
   add var1dd,cel_size
   inc var3dd;
   cmp var3dd,matrix_wight
   jne skip1;
   mov var3dd,0;
   mov var1dd,margin_left;
   add var2dd,cel_size
skip1:
   inc ESI;
   dec ECX;
   cmp ECX,0
   jg print_loop;

endm;

Print_PacMan macro x,y
local gura_inc,gura_desc,end_p,skip0,skip01,skip02,skip03,skip1,skip2,skip3,skip4,super1,super2,super3,super4,super5,super6,super7,super8;
   
   ;mov EBX,new_pozition;
   ;mov pozition,EBX;
   ;mov last_pozition,EBX;
   
   
   cmp pozition,0 
   jne skip0;
   cmp last_pozition,1
   jne skip01;
   jmp gura_inc_sus;
skip01:
   cmp last_pozition,2;
   jne skip02;
   jmp gura_inc_dreapta;
skip02:
   cmp last_pozition,3;
   jne skip03;
   jmp gura_inc_jos;
skip03:
   cmp last_pozition,4;
   jne skip04;
   jmp gura_inc_stanga;
skip04:
   cmp last_pozition,0
   jne skip0; 

   
skip0:
   cmp pozition,1;
   jne skip1;
   
   cmp PMan_form1,0
   je gura_inc_sus;
   cmp PMan_form1,1
   je gura_desc_sus;
   
   
   jmp end_p;
skip1:
   cmp pozition,2;
   jne skip2;
      
   cmp PMan_form1,0
   je gura_inc_dreapta;
   cmp PMan_form1,1
   je gura_desc_dreapta;
   
   jmp end_p;
skip2:
   cmp pozition,3;
   jne skip3;
      
   cmp PMan_form1,0
   je gura_inc_jos;
   cmp PMan_form1,1
   je gura_desc_jos;
   
   jmp end_p;
skip3:
   cmp pozition,4;
   jne skip4;
      
   cmp PMan_form1,0
   je gura_inc_stanga;
   cmp PMan_form1,1
   je gura_desc_stanga;
   
   jmp end_p;
skip4:
   
   jmp gura_inc_dreapta; 
  
  
   
gura_inc_dreapta:
   cmp Super_PMan,1;
   je super2;
   Print_image_caracter x,y,PM_drepata_0
   jmp end_p;
super2:
   Print_image_caracter x,y,SuperPM_dreapta_0
   jmp end_p;
   
gura_inc_sus:
   cmp Super_PMan,1;
   je super1;
   Print_image_caracter x,y,PM_sus_0
   jmp end_p;
super1:
   Print_image_caracter x,y,SuperPM_sus_0
   jmp end_p;
   
gura_inc_jos:
   cmp Super_PMan,1;
   je super3;
   Print_image_caracter x,y,PM_jos_0
   jmp end_p;
super3:
   Print_image_caracter x,y,SuperPM_jos_0
   jmp end_p; 
   
gura_inc_stanga:
   cmp Super_PMan,1;
   je super4;
   Print_image_caracter x,y,PM_stanga_0
   jmp end_p;
super4:
   Print_image_caracter x,y,SuperPM_stanga_0
   jmp end_p;  
   
gura_desc_dreapta:
   cmp Super_PMan,1;
   je super5;
   Print_image_caracter x,y,PM_drepata_desc_0
   jmp end_p;
super5:
   Print_image_caracter x,y,SuperPM_dreapta_desc_0
   jmp end_p;  
   
gura_desc_sus:
   cmp Super_PMan,1;
   je super6;
   Print_image_caracter x,y,PM_sus_desc_0
   jmp end_p;
super6:
   Print_image_caracter x,y,SuperPM_sus_desc_0
   jmp end_p;  
   
 gura_desc_jos:
   cmp Super_PMan,1;
   je super7;
   Print_image_caracter x,y,PM_jos_desc_0
   jmp end_p;
super7:
   Print_image_caracter x,y,SuperPM_jos_desc_0
   jmp end_p;  
   
gura_desc_stanga:
   cmp Super_PMan,1;
   je super8;
   Print_image_caracter x,y,PM_stanga_desc_0
   jmp end_p;
super8:
   Print_image_caracter x,y,SuperPM_stanga_desc_0
   jmp end_p;  
   
end_p:
endm; 

muta macro a,b
  push EBX;
  mov EBX,b;
  mov a,EBX;
  pop EBX;
endm;

Next_poz macro x,y,NextX,NextY,directie,deplasare
local end_m,d_sus,d_dreapta,d_jos,d_stanga;
   push EBX;
   muta NextX,x
   muta NextY,y
   mov EBX,deplasare
   cmp directie,0;
   je end_m;
   cmp directie,1;
   je d_sus;
   cmp directie,2;
   je d_dreapta;
   cmp directie,3;
   je d_jos;
   cmp directie,4;
   je d_stanga;
   jmp end_m;   
d_sus:
   sub NextY,EBX;
   jmp end_m;
d_dreapta:
   add NextX,EBX
   jmp end_m;
d_jos:
   add NextY,EBX;
   jmp end_m;
d_stanga:
   sub NextX,EBX;
   jmp end_m;

end_m:
   pop EBX;
endm;

PacMan macro 
   Print_PacMan PMan_pozitionX,PMan_pozitionY
endm;




Print_wall macro x,y,tip
local wall_vert,wall_oriz,corner1,corner2,corner3,corner4,T1,T2,T3,T4,End1,End2,End3,End4,Poarta,square,end_p;
    cmp tip,15
	je wall_vert;
    cmp tip,25
	je wall_oriz;
    cmp tip,11
	je corner1;
    cmp tip,12
	je corner2
    cmp tip,13
	je corner3
    cmp tip,14
	je corner4
    cmp tip,21
	je T1;
    cmp tip,22
	je T2;
	 
    cmp tip,23
	je T3;
	
    cmp tip,24
	je T4;
	
	cmp tip,31
	je End1
		
	cmp tip,32
	je End2;
		
	cmp tip,33
	je End3;
		
	cmp tip,34
	je End4;
		
	cmp tip,16
	je Poarta;
			
	cmp tip,17
	je square
			

	Print_image x,y,Background_0
	jmp end_p;
wall_vert:
   Print_image x,y,WallVert_0
   jmp end_p;
wall_oriz:
   Print_image x,y,WallOriz_0
   jmp end_p;
corner1:
   Print_image x,y,Corner1_0
   jmp end_p;
corner2:
   Print_image x,y,Corner2_0
   jmp end_p;
corner3:
    Print_image x,y,Corner3_0
   jmp end_p;
corner4:
   Print_image x,y,Corner4_0
   jmp end_p;
T1:
   Print_image x,y,T1_0
   jmp end_p;
T2:
   Print_image x,y,T2_0
   jmp end_p;
T3:
   Print_image x,y,T3_0
   jmp end_p;
T4:
   Print_image x,y,T4_0
   jmp end_p;
End1:
   Print_image x,y,End1_0
   jmp end_p;
End2:
   Print_image x,y,End2_0
   jmp end_p;
End3:
   Print_image x,y,End3_0
   jmp end_p;
End4:
   Print_image x,y,End4_0
   jmp end_p;
Poarta:
   Print_image x,y,Poarta_0
   jmp end_p;
square:
   Print_image x,y,Square_0
end_p:
endm;

Actualizare_new_directie macro 
local sus,dreapta,jos,stanga,end_p;
   mov EAX,[EBP+arg2];
   cmp EAX,026h;
   je sus;
   cmp EAX,027h;
   je dreapta;
   cmp EAX,028h;
   je jos;
   cmp EAX,025h;
   je stanga;
   mov new_pozition,0
   jmp end_p;
sus:
    mov new_pozition,1
    jmp end_p;   
dreapta:
    mov new_pozition,2
    jmp end_p;
jos:
    mov new_pozition,3
    jmp end_p;  
stanga:
    mov new_pozition,4
    jmp end_p;  
end_p:	
endm; 

PacMan_move macro
local skip,liber,next2;
   Next_poz PMan_pozitionX,PMan_pozitionY,PMan_pozitionX,PMan_pozitionY,pozition,deplasare
   cmp timer_deplasare_PM,nr_dep
   jne skip;
   mov timer_deplasare_PM,0
   muta poz_int,pozition
   
   
   Next_poz PMan_matriX,PMan_matriY,PMan_matriX,PMan_matriY,pozition,1
   Element_matrix PMan_matriX,PMan_matriY,pozition
   cmp DL,10
   jle next2;
   mov pozition,0
   ;jmp liber;
 next2:  
   Element_matrix PMan_matriX,PMan_matriY,new_pozition
   cmp DL,10
   jg liber;
   muta pozition,new_pozition
liber:
   Replace_matrix;
   mov EAX,poz_int;
   mov EBX,pozition;
   cmp EAX,EBX;
   je skip;
   muta last_pozition,poz_int;
skip:
endm;

Replace_matrix macro 
local SCORE,FRUCT;
   mov var4dd,0 
   Element_matrix PMan_matriX,PMan_matriY,var4dd
   cmp DL,2
   je SCORE;
   cmp DL,3
   je FRUCT;
   jmp skip;
SCORE:
   Replace PMan_matriX,PMan_matriY,var4dd
   inc Score_points
   jmp skip;
FRUCT: 
   Replace PMan_matriX,PMan_matriY,var4dd
   dec FructRemain;
   add Score_points,100
   mov Super_PMan,1
   mov Super_PMan_Timer,0;
   
   ;dec LifeRemain;
   ;PMan_dead
   jmp skip;
   
   
skip:

endm;



Element_matrix macro x,y,directie
   push ESI;
   push EAX;
   push EBX;
   Next_poz x,y,NextX,NextY,directie,1
   lea ESI,matrix;
   mov EAX,NextX;
   add ESI,NextX
   mov EAX,NextY
   mov EBX,matrix_wight
   mul ebx;
   add ESI,EAX;
   mov EDX,[ESI]
   pop EBX;
   pop EAX;
   pop ESI;
endm;

Replace macro x,y,rep_val
  push ESI
  push EAX;
  push EBX;

  mov ESI,offset matrix
  mov EAX,x;
  add ESI,EAX;
  mov EAX,y;
  mov EBX,matrix_wight
  mul EBX;
  add ESI,EAX;
  
  mov EAX,rep_val
  mov [ESI],AL
  
  pop EBX;
  pop EAX;
  pop ESI;
endm;

Print_vieti macro x,y 
local aici,end_m;
    cmp PMan_form1,0
	je aici;
	Print_image x,y,PM_drepata_0
	jmp end_m;
aici:
   Print_image x,y,PM_drepata_desc_0
end_m:
endm;

Print_Lifes macro 
local et_loop;
    ;Print_vieti AfisLifeStart,AfisY
	push var1dd;
	push EBX;
	
	mov EBX,AfisLifeStart;
	mov var1dd,EBX;
	mov ECX,LifeRemain
et_loop:
	Print_vieti var1dd,AfisY
	add var1dd,20
	dec ECX;
	cmp ECX,0
	jg et_loop
	
	pop EBX;
	pop var1dd;
endm;

Print_endGame macro 
  make_text_macro 'E',area,EndScoreX- endGdep,EndScoreY-20
  make_text_macro 'N',area,EndScoreX+10- endGdep,EndScoreY-20
  make_text_macro 'D',area,EndScoreX+20- endGdep,EndScoreY-20
  make_text_macro 'G',area,EndScoreX+35-endGdep,EndScoreY-20
  make_text_macro 'A',area,EndScoreX+45-endGdep,EndScoreY-20
  make_text_macro 'M',area,EndScoreX+55-endGdep,EndScoreY-20
  make_text_macro 'E',area,EndScoreX+65-endGdep,EndScoreY-20
endm;


Print_Fructs macro 
    ;Print_Fructe AfisFructStart,AfisY
endm;

Interactiuni macro 
local end_m,Ghost2,reset,interactiuneGH1,skip2,sus,jos,dreapta,stanga,compY,Interactiune;
;
   
   
   ;Ghost1
   mov EAX,GhostArea1X
   mov EBX,PMan_pozitionX
   
   cmp EAX,EBX
   jg dreapta;
   jmp stanga;
dreapta:
   sub EAX,EBX;
   cmp EAX,5
   jle compY;
   jmp Ghost2;
stanga:
   sub EBX,EAX;
   cmp EBX,5
   jle compY
   jmp Ghost2;
compY:   
   mov EAX,GhostArea1Y
   mov EBX,PMan_pozitionY
   cmp EAX,EBX;
   jg sus;
   jmp jos;
   
sus:
   sub EAX,EBX;
   cmp EAX,5
   jl Interactiune
   jmp Ghost2;

jos:   
   sub EBX,EAX;
   ;sub EBX,20;
   cmp EBX,5
   jl Interactiune;
   jmp Ghost2;
   
   
  
   
;interactiune 
Interactiune:
   cmp Super_PMan,0
   jne InteractiuneGH1;
   PMan_dead;
   jmp Ghost2;
   
InteractiuneGH1:
   add Score_points,200;
   mov Ghost1X,Ghost1xStart;
   mov Ghost1Y,Ghost1yStart;
   mov GhostArea1X,GhostArea1XST; 
   mov GhostArea1Y,GhostArea1YST; 
   mov elementGH1,0
   mov depGH1,0
   mov new_depGH1,0
   mov GH1angry,0
	
	
	
	
	
Ghost2:
   ;Ghost2
  mov EAX,GhostArea2X
   mov EBX,PMan_pozitionX
   
   cmp EAX,EBX
   jg dreapta2;
   jmp stanga2;
dreapta2:
   sub EAX,EBX;
   cmp EAX,5
   jle compY2;
   jmp reset;
stanga2:
   sub EBX,EAX;
   cmp EBX,5
   jle compY2
   jmp reset;
compY2:   
   mov EAX,GhostArea2Y
   mov EBX,PMan_pozitionY
   cmp EAX,EBX;
   jg sus2;
   jmp jos2;
   
sus2:
   sub EAX,EBX;
   cmp EAX,5
   jl Interactiune2
   jmp reset;

jos2:   
   sub EBX,EAX;
   ;sub EBX,20;
   cmp EBX,5
   jl Interactiune2;
   jmp reset;

   jne reset;
;interactiune
Interactiune2:
   cmp Super_PMan,0
   jne InteractiuneGH2;
   PMan_dead;
   jmp reset;
InteractiuneGH2:
   add Score_points,200;
   mov Ghost2X,Ghost2xStart;
   mov Ghost2Y,Ghost2yStart;
   mov GhostArea2X,GhostArea2XST; 
   mov GhostArea2Y,GhostArea2YST; 
   mov elementGH2,0
   mov depGH2,0
   mov new_depGH2,0
   mov GH2angry,0
reset:  
   mov timer_deplasare_fant,0;
end_m:   
endm;

Ghost1_Move macro 
local skip1,end_m,reset,poarta,cont;
     lea ESI,Ghost1Move;
     cmp new_depGH1,0
	 jne skip1;
	 add ESI,elementGH1;
     mov EBX,[ESI];
	 add elementGH1,4;
	 mov new_depGH1,EBX;
	 mov EBX,elementGH1;
	 mov EAX,elfinGH1;
	 cmp EAX,EBX
	 jne cont;
	 muta elementGH1,elbuclaGH1
cont:
skip1:
    Next_poz GhostArea1X,GhostArea1Y,GhostArea1X,GhostArea1Y,depGH1,deplasareGH1;
	mov EAX,depGhost1_timer
	mov ebx,nr_depGH1
    cmp EAX,EBX
	jl end_m;
	Element_matrix Ghost1X,Ghost1Y,new_depGH1
	cmp DL,16
	je poarta;
	cmp DL,10
	jg reset;
poarta:
	muta depGH1,new_depGH1;
	mov new_depGH1,0;
reset:
    Next_poz Ghost1X,Ghost1Y,Ghost1X,Ghost1Y,depGH1,1 
    mov depGhost1_timer,0
end_m:
endm;

Ghost2_Move macro 
local skip1,end_m,reset,poarta,cont;
     lea ESI,Ghost2Move;
     cmp new_depGH2,0
	 jne skip1;
	 add ESI,elementGH2;
     mov EBX,[ESI];
	 add elementGH2,4;
	 mov new_depGH2,EBX;
	 
	 mov EBX,elementGH2;
	 mov EAX,elfinGH2;
	 cmp EAX,EBX
	 jne cont;
	 muta elementGH2,elbuclaGH2
cont:
skip1:
    Next_poz GhostArea2X,GhostArea2Y,GhostArea2X,GhostArea2Y,depGH2,deplasareGH2;
	mov EAX,depGhost2_timer;
	mov EBX,nr_depGH2
    cmp EAX,EBX
	jl end_m;
	Element_matrix Ghost2X,Ghost2Y,new_depGH2
	cmp DL,16
	je poarta;
	cmp DL,10
	jg reset;
poarta:
	muta depGH2,new_depGH2;
	mov new_depGH2,0;
reset:
    Next_poz Ghost2X,Ghost2Y,Ghost2X,Ghost2Y,depGH2,1 
    mov depGhost2_timer,0
end_m:
endm;

Detectare1 macro
local angry,skip1,verY,g1,g2,g3,g12,g22,g32,safe;
   mov EAX,depGhost1_timer;
   mov EBX,nr_depGH2
   cmp EAX,EBX
   jne end_m;

   mov EAX,GhostArea1X;
   mov EBX,PMan_pozitionX;

   cmp EAX,EBX;
   jl g1;
   jmp g2 
g1:
   sub EBX,EAX
   jmp g3
g2:
   sub EAX,EBX;
   mov EBX,EAX;
 g3:  
   cmp EBX,simtGh;
   jg safe;
   
   mov EAX,GhostArea1Y;
   mov EBX,PMan_pozitionY; 
   
   cmp EAX,EBX;
   jl g12;
   jmp g22 
g12:
   sub EBX,EAX
   jmp g32
g22:
   sub EAX,EBX;
   mov EBX,EAX;
 g32:  
   cmp EBX,simtGh;
   jl angry;
  	
   
safe:
   mov GH1angry,0;
   mov deplasareGH1,deplasare
   mov nr_depGH1,nr_dep
   jmp skip1;
angry:
   mov GH1angry,1
   mov deplasareGH1,deplasare_angry
   mov nr_depGH1,nr_depAngry
skip1:
   end_m:
endm;

Detectare2 macro
local angry,skip1,verY,g1,g2,g3,g12,g22,g32,safe,end_m;
   mov EAX,depGhost2_timer;
   mov EBX,nr_depGH2
   cmp EAX,EBX
   jne end_m;
   
   
   mov EAX,GhostArea2X;
   mov EBX,PMan_pozitionX;

   cmp EAX,EBX;
   jl g1;
   jmp g2 
g1:
   sub EBX,EAX
   jmp g3
g2:
   sub EAX,EBX;
   mov EBX,EAX;
 g3:  
   cmp EBX,simtGh;
   jg safe;
   
   mov EAX,GhostArea2Y;
   mov EBX,PMan_pozitionY; 
   
   cmp EAX,EBX;
   jl g12;
   jmp g22 
g12:
   sub EBX,EAX
   jmp g32
g22:
   sub EAX,EBX;
   mov EBX,EAX;
 g32:  
   cmp EBX,simtGh;
   jl angry;
  	
   
safe:
   mov GH2angry,0;
   mov deplasareGH2,deplasare
   mov nr_depGH2,nr_dep
   jmp skip1;
angry:
   mov GH2angry,1
   mov deplasareGH2,deplasare_angry
   mov nr_depGH2,nr_depAngry
skip1:
   end_m:
endm;


Print_nume macro 
    make_text_macro 'G',area,0,10
    make_text_macro 'O',area,10,10
    make_text_macro 'R',area,20,10
    make_text_macro 'U',area,30,10
    make_text_macro 'N',area,40,10
    make_text_macro 'C',area,55,10
    make_text_macro 'O',area,65,10
    make_text_macro 'S',area,75,10
    make_text_macro 'M',area,85,10
    make_text_macro 'I',area,95,10
    make_text_macro 'N',area,105,10

endm;







; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0FFFFFFh
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click, 3 - s-a apasat o tasta)
; arg2 - x (in cazul apasarii unei taste, x contine codul ascii al tastei care a fost apasata)
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	Print_ecran;
Tasta:
	Actualizare_new_directie
	jmp afisare_litere
	
evt_click:
	
	
	
	
	jmp afisare_litere
evt_timer:

    Incrementare_time
	Detectare1;
	Detectare2;
    Animati;
	Actualizare_PacMan_form
	PacMan_move
	Ghost1_Move;
	Ghost2_Move;
	Interactiuni
	
	
afisare_litere:
    Ver_endgame;
    cmp EndGame,1
	je endGam;
    Print_matrix
	Print_ghost
    PacMan
    ;Print_time
	Print_Lifes
	Print_Fructs
	Print_score AfisScoreX, AfisScoreY
	
	Print_text
	Print_nume
	jmp final_draw;
endGam:
   Print_ecran
   Print_score EndScoreX,EndScoreY
   Print_endGame
	;scriem un mesaj
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start