.data
	nrCerinta: .space 4
	nrNoduri: .space 4
	legaturi: .space 420
	legatura: .space 4
	nrLegaturi: .space 4
	matriceAd: .space 44100
	formatScanld: .asciz "%ld"
	formatPrintld: .asciz "%ld "
	newLine: .asciz "\n"
	linie: .space 4
	coloana: .space 4
	
	#variabile pentru cerinta 2:
	lungimeDrum: .space 4
	nodSursa: .space 4
	nodDestinatie: .space 4
	rezultat: .space 4
	matrice: .space 44100
	aux: .space 44100
	formatPrintld2: .asciz "%ld"
.text
matrix_mult:
	pushl %ebp
	movl %esp, %ebp
	
	pushl %edi
	pushl %esi
	pushl %ebx
	subl $16, %esp
	
	
	movl $0, -16(%ebp)
	for_1:
		movl -16(%ebp), %ecx
		movl 20(%ebp), %eax
		cmp %ecx, %eax
		movl $0, -20(%ebp)
		je endFor_1
		for_2:
			movl -20(%ebp), %ecx
			movl 20(%ebp), %eax
			cmp %ecx, %eax
			je endFor_2
			
			movl $0, -24(%ebp)
			movl $0, %ebx
			for_3:
				movl -24(%ebp), %ecx
				movl 20(%ebp), %eax
				cmp %ecx, %eax
				je endFor_3
				
				movl 8(%ebp), %esi
				xor %eax, %eax
				addl -16(%ebp), %eax
				mull 20(%ebp)
				addl -24(%ebp), %eax
				movl (%esi, %eax, 4), %edi
				 
				 
				movl 12(%ebp), %esi
				xor %eax, %eax
				addl -24(%ebp), %eax
				mull 20(%ebp)
				addl -20(%ebp), %eax
				movl (%esi, %eax, 4), %ecx
				
				xor %eax, %eax
				movl %ecx, %eax
				mull %edi
				
				addl %eax, %ebx
				addl $1, -24(%ebp)
				jmp for_3
			endFor_3:
			
			movl 16(%ebp), %esi
			xor %eax, %eax
			addl -16(%ebp), %eax
			mull 20(%ebp)
			addl -20(%ebp), %eax
			movl %ebx, (%esi, %eax, 4)
			addl $1, -20(%ebp)
			jmp for_2
		endFor_2:
		addl $1, -16(%ebp)
		jmp for_1
	endFor_1:
	
	addl $16, %esp
	popl %ebx
	popl %esi
	popl %edi
	
	popl %ebp
	ret

.globl main
main:
	#citire cerinta:
	pushl $nrCerinta
	pushl $formatScanld
	call scanf
	popl %edx
	popl %edx
	
	#citire nr de noduri:
	pushl $nrNoduri
	pushl $formatScanld
	call scanf
	popl %edx
	popl %edx
	
#citire numar de legaturi:
	xor %ecx, %ecx
	
	movl $0, linie
citireNrLegaturi:
	movl linie, %ecx
	cmp %ecx, nrNoduri
	je endCitireNrLegaturi
	
	#citire nr de legaturi:
	pushl $legatura
	pushl $formatScanld
	call scanf
	popl %edx
	popl %edx
	lea legaturi, %edi
	movl legatura, %ebx
	movl linie, %ecx
	movl %ebx, (%edi, %ecx, 4)
	incl linie
	jmp citireNrLegaturi
	

endCitireNrLegaturi:
movl $0, linie
citireLegaturi:
	movl linie, %ecx
	cmp %ecx, nrNoduri
	je sfarsitCitire
	
	lea legaturi, %edi
	movl (%edi, %ecx, 4), %edx
	movl %edx, nrLegaturi
	movl $0, coloana
	
	citireLegaturiPtUnNod:
		movl coloana, %ebx
		cmp %ebx, nrLegaturi
		je endCitireLegaturiPtUnNod
		#citire legatura: 
		pushl $legatura
		pushl $formatScanld
		call scanf
		popl %eax
		popl %eax
		
		#actualizare matrice de adiacenta:
		xor %eax, %eax
		addl linie, %eax
		mull nrNoduri
		addl legatura, %eax
		lea matriceAd, %esi
		movl $1, (%esi, %eax, 4)
		
		incl coloana
		jmp citireLegaturiPtUnNod
	
	endCitireLegaturiPtUnNod:
		incl linie
		jmp citireLegaturi

sfarsitCitire:
movl nrCerinta, %eax
cmp $1, %eax
jne cerinta2

afisareMatrice:
	movl $0, linie
	linii:
		movl linie, %ecx
		cmp %ecx, nrNoduri
		je etexit
		
		movl $0, coloana
		coloane:
			movl coloana, %ebx
			cmp %ebx, nrNoduri
			je linieNoua
			xor %eax, %eax
			addl linie, %eax
			mull nrNoduri
			addl coloana, %eax
			lea matriceAd, %esi
			movl (%esi, %eax, 4), %edx
			#afisare element:
			pushl %edx
			pushl $formatPrintld
			call printf
			popl %edx
			popl %edx
			
			pushl $0
			call fflush
			popl %edx
			incl coloana
			jmp coloane
			
			linieNoua:
				incl linie
				pushl $newLine
				call printf
				popl %edx
				
				pushl $0
				call fflush
				popl %edx
				jmp linii
			
cerinta2:
	#citire lungime:
	pushl $lungimeDrum
	pushl $formatScanld
	call scanf
	popl %edx
	popl %edx
	
	#citire nod sursa:
	pushl $nodSursa
	pushl $formatScanld
	call scanf
	popl %edx
	popl %edx

	#citire nod destinatie:
	pushl $nodDestinatie
	pushl $formatScanld
	call scanf
	popl %edx
	popl %edx
	
	#creare matrice identica
	xor %eax, %eax
	addl nrNoduri, %eax
	movl %eax, linie
	lea matrice, %esi
	xor %ecx, %ecx
	matrIdentica:
		cmp %ecx, linie
		je endMatrIdentica
		xor %eax, %eax
		addl %ecx, %eax
		mull nrNoduri
		addl %ecx, %eax
		movl $1, (%esi, %eax, 4)
		incl %ecx
		jmp matrIdentica
		
	endMatrIdentica:
	movl $0, linie
	inmultireMatr:
		movl linie, %ecx
		cmp %ecx, lungimeDrum
		je endInmultireMatr
		
		pushl nrNoduri
		pushl $aux
		pushl $matrice
		pushl $matriceAd
		call matrix_mult
		popl %edx
		popl %edx
		popl %edx
		popl %edx
		
		#copiere aux in matrice:
		xor %eax, %eax
		addl nrNoduri, %eax
		mull nrNoduri
		lea aux, %edi
		lea matrice, %esi
		xor %ecx, %ecx
		copiereAux:
			cmp %ecx, %eax
			je endCopiereAux
			movl (%edi, %ecx, 4), %ebx
			movl %ebx, (%esi, %ecx, 4)
			incl %ecx
			jmp copiereAux
		
		endCopiereAux:
			incl linie
			jmp inmultireMatr
		
	
	endInmultireMatr:
	#afisare rezultat:
	lea matrice, %esi
	xor %eax, %eax
	addl nodSursa, %eax
	mull nrNoduri
	addl nodDestinatie, %eax
	
	movl (%esi, %eax, 4), %ebx
	movl %ebx, rezultat
	
	pusha
	pushl rezultat
	pushl $formatPrintld2
	call printf
	popl %edx
	popl %edx
	popa
			
	pusha
	pushl $0
	call fflush
	popl %edx
	popa
	
	pusha
	pushl $newLine
	call printf
	popl %edx
	popa
				
	pusha
	pushl $0
	call fflush
	popl %edx
	popa
	
etexit:
	mov $1, %eax
	xor %ebx, %ebx
	int $0x80

