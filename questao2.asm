org 0x7c00
jmp 0x0000:start

data:
palavra: times 100 db 0

getchar:
	mov ah, 0x00
	int 16h
ret

delchar:
	mov al, 0x08
	call putchar
	mov al,' '
	call putchar
	mov al, 0x08
	call putchar
ret

putchar:
	mov ah, 0x0e
	int 10h
ret

endl:
	mov al, 0x0a
	call putchar
	mov al, 0x00d
	call putchar
ret

printString: ;printa a string
.loop:
	lodsb
	cmp al, 0
	je .endloop
	call putchar
	jmp .loop
.endloop:
ret

gets: ; pegar a string
xor cx, cx ;zera cx

.loop1:
	call getchar ;chama a função que pega um caracter
	cmp al, 0x08 ;compara com a tecla backspace
	je .backspace
	cmp al, 0x0d 
	je .done
	cmp cl, 20
	je .loop1 ;só vai parar de fazer loop1 quando cl=0 e isso so acontece quando .backspace deixar cl deslocado.
	
	stosb
	inc cl
	call putchar 
	jmp .loop1

.backspace: ;função que vai alterar o cl e o di e deletar o backspace digitado. 
	cmp cl, 0
	je .loop1
	dec di
	dec cl
	mov byte[di],0
	call delchar
	jmp .loop1
   
.done: ;função que finaliza e pula linha 
	mov al,0
	stosb
	call endl ;chama função que pula linha
ret

reverse: ;inverte a string
	mov di, si
	xor cx, cx
	
 .loop1:
	lodsb
	cmp al, 0
	je .endloop1
	inc cl
	push ax
	jmp .loop1
 .endloop1:

 .loop2:
	cmp cl, 0
	je .endloop2
	dec cl
	pop ax
	stosb
	jmp .loop2
 .endloop2:
ret

start:

mov di, palavra
call gets
mov si, palavra
call reverse
mov si, palavra
Call printString

jmp $
times 510-($-$$) db 0       
dw 0xaa55
