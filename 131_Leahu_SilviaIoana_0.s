.data

	x: .space 4
	n: .space 4
	y: .space 4
	cnt: .space 4
	cnt_apelare_procedura: .space 4
	lungime_drum: .space 4
	nod_sursa: .space 4
	nod_destinatie: .space 4
	sum: .space 4
	m2: .space 40000
	mres: .space 40000
	
	legaturi: .space 4000
	
	m1: .space 40000
	linie: .space 4
	columnIndex: .space 4 
	legatura: .space 4
	formatString: .asciz "%d"
	formatPrintf: .asciz "%d " 
	formatPrintfNoSpaces: .asciz "%d"
	newLine: .asciz "\n"

.text
.global main

matrix_mult:

	#%esp:(adr_de_intoarcere)_(m1)_(m2)_(mres)_(n):
	
	pushl %ebp
	movl %esp,%ebp
	pushl %ebx
	pushl %esi
	pushl %edi
	
	#%esp:(edi)(esi)(ebx) %ebp:(%ebp vechi)(adr de intoarcere)(m1)(m2)(mres)(n)
	
	#loc pentru indice linie
	subl $4,%esp		
	movl $0, -4(%ebp)	
	
	#loc pentru indice coloana
	subl $4,%esp		
	movl $0,-8(%ebp)	
	
	#loc pentru suma
	subl $4,%esp		
	movl $0,-12(%ebp)	
	
	for_linii_matrix_mult:
		movl -4(%ebp), %ecx	
		cmp %ecx,20(%ebp)
		je iesire_procedura

		movl $0, -8(%ebp)
		for_coloane_matrix_mult:
			
			#coloana
			movl -8(%ebp),%ecx	
			cmp %ecx,20(%ebp)
			je cont_linii

			#creem al3lea for
			
			movl $0,-12(%ebp)
			movl $0,%ecx	#deoarece folosim ecx ca un contor normal

			for_inmultiri:
			
				cmp %ecx,20(%ebp)
				je pregatire_for_inmultiri
				
				calculam_primul_indice:

				movl -4(%ebp),%eax	
				movl $0,%edx
				imull 20(%ebp)
				addl %ecx, %eax 
				movl %eax,%edx

				
				movl 8(%ebp),%edi
				movl 12(%ebp),%esi
				movl (%edi,%edx,4),%eax
				
				movl %eax,%ebx
								
				movl %ecx,%eax	
				movl $0,%edx
				imull 20(%ebp)
				addl -8(%ebp),%eax
				movl %eax,%edx

				movl %ebx, %eax

				movl (%esi,%edx,4),%ebx
				movl $0,%edx
				#inmultirea propriu zisa
				imul %ebx	
				
				addl %eax,-12(%ebp)
				
				incl %ecx
				jmp for_inmultiri

				pregatire_for_inmultiri:
			
				#calculam primul indice si adaugam in matricea mres
				movl 16(%ebp),%edi
				movl -4(%ebp),%eax	
				movl $0,%edx
				imull 20(%ebp)
				addl -8(%ebp), %eax 
				movl -12(%ebp),%ebx
				movl %ebx, (%edi,%eax,4)
				
				jmp cont_coloane
			

		cont_coloane:	
			incl -8(%ebp)
			jmp for_coloane_matrix_mult
		 
		
	cont_linii:
		
		incl -4(%ebp)
		jmp for_linii_matrix_mult

	iesire_procedura:
		
		addl $4,%esp
		addl $4,%esp
		addl $4,%esp
		popl %edi
		popl %esi
		popl %ebx
		popl %ebp
		ret
	


main:

citire1:
	
	pusha
	pushl $x
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	popa
	
	
citire2:

	pusha
	pushl $n
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	popa


pregatiri:
	
	movl $0,%ecx
	movl n,%eax
	movl $legaturi, %esi

citire_nr_legaturi:
	
	cmp %ecx,%eax
	je continuare
	
	pusha
	pushl $y
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	popa
	
	movl y, %ebx
	movl %ebx, (%esi, %ecx, 4)
	
	incl %ecx
	jmp citire_nr_legaturi
	
#scot din vector si fac un for pt fiecare nr de legaturi


continuare:
	movl $-1, %ecx

continuare1:
	incl %ecx
	cmp %ecx, n
	je verificam_numar_cerinta					#citire_lungime_drum
	
	movl (%esi, %ecx, 4), %ebx
	movl %ebx, cnt	

urmatorul:
	movl $0, %edx
	
	#fac un for pt legaturile nodului
et_for:
	cmp %edx, cnt
	je continuare1
	
	pusha
	pushl $legatura
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	popa
	
	#creez indexul pt a accesa matricea
	push %edx
	movl %ecx,%eax	
	movl $0,%edx
	mull n 
	
	movl legatura,%ebx
	# %eax=%ecx*n
	addl %ebx,%eax	# %eax=%ecx*n+%ebx
	
	lea m1,%edi
	movl $1,(%edi,%eax,4)
	
	popl %edx
	
	incl %edx
	jmp et_for
	
afisare_matrice:
	movl $0, linie
	for_linii_afisare:
		movl linie, %ecx
		cmp %ecx,n
		je et_exit
		
		movl $0,columnIndex
		for_coloane_afisare:
			movl columnIndex,%ecx
			cmp %ecx,n
			je cont
			
			#afisez matricea
			movl linie,%eax
			movl $0,%edx
			mull n
			addl columnIndex, %eax 
			
			lea m1,%edi
			movl (%edi,%eax,4),%ebx
			
			pushl %ebx
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			
			pushl $0
			call fflush
			popl %ebx
			
			incl columnIndex
			jmp for_coloane_afisare
		 
		
	cont:
		movl $4,%eax
		movl $1,%ebx
		movl $newLine, %ecx
		movl $1,%edx
		int $0x80
		
		incl linie
		jmp for_linii_afisare
		
citire_lungime_drum:

	pusha
	pushl $lungime_drum
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	popa
	
citire_nod_sursa:
	 
	 pusha
	 pushl $nod_sursa
	 pushl $formatString
	 call scanf
	 popl %ebx
	 popl %ebx
	 popa
	 
citire_nod_destinatie:

	pusha
	pushl $nod_destinatie
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	popa
	
copiere_matrice:

	movl $0, linie
	for_linii:
		movl linie, %ecx
		cmp %ecx,n
		je introducere_procedura
		
		movl $0,columnIndex
		for_coloane:
			movl columnIndex,%ecx
			cmp %ecx,n
			je continuare3
			
			#copiez m1 in m2

			movl linie,%eax
			movl $0,%edx
			mull n
			addl columnIndex, %eax 
			
			lea m1,%edi
			lea m2,%esi
			movl (%edi,%eax,4),%ebx
			
			movl %ebx,(%esi,%eax,4)
			
			incl columnIndex
			jmp for_coloane	
		
		continuare3:
		
		incl linie
		jmp for_linii

introducere_procedura:

	movl $1, cnt_apelare_procedura

#for(ecx=1;ecx<k;ecx++)

for_apelare_procedura:
	movl cnt_apelare_procedura, %ecx
	cmp %ecx,lungime_drum
	je accesare_drum
	
	pushl n
	pushl $mres
	pushl $m2
	pushl $m1
	call matrix_mult
	popl %ebx
	popl %ebx
	popl %ebx
	popl %ebx	
	
	movl $0, linie
	copiere_matrice_mres_in_m2:
	movl $0, linie
	for_lines:
		movl linie, %ecx
		cmp %ecx,n
		je cont_apelare_procedura
		
		movl $0,columnIndex
		for_columns:
			movl columnIndex,%ecx
			cmp %ecx,n
			je continuare2
			
			#copiez intotdeauna mres in m2
			movl linie,%eax
			movl $0,%edx
			mull n
			addl columnIndex, %eax 
			
			lea mres,%edi
			lea m2,%esi
			movl (%edi,%eax,4),%ebx
			
			movl %ebx,(%esi,%eax,4)
			
			incl columnIndex
			jmp for_columns
		
		continuare2:
		
		incl linie
		jmp for_lines
	
	cont_apelare_procedura:

	incl cnt_apelare_procedura
	jmp for_apelare_procedura

accesare_drum:
	movl nod_sursa,%eax
	movl $0,%edx
	movl nod_destinatie,%ebx
	imull n
	addl %ebx,%eax	 

	lea mres,%edi
	movl (%edi,%eax,4),%ecx

	afisare:
	pushl %ecx
	pushl $formatPrintfNoSpaces
	call printf
	popl %ebx
	popl %ebx

	pushl $0
	call fflush
	popl %ebx

et_exit:
	movl $1,%eax
	movl $0,%ebx
	int $0x80

verificam_numar_cerinta:
	movl $1,%eax
	cmp x,%eax
	je afisare_matrice
	jne citire_lungime_drum
