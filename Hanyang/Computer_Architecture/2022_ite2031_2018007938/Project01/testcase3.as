	lw  0   2   mcand
	lw	0	3	mplier	
	lw	0	4	one	
	lw	0	5	max	
loop	nor	3	3	6
	nor	4	4	7
	nor	6	7	6
	beq	6	4	add
back	add	4	4	4
	add	2	2	2
	beq	4	5	EXIT
	beq	0	0	loop
add	add	1	2	1
	beq	0	0	back
EXIT	halt
mcend 	.fill	3
mplier 	.fill	2
one	.fill	1	
max	.fill	131072	
