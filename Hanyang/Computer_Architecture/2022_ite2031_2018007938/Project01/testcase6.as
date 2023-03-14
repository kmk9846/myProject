	lw 0 0	hi
	add 4 1 1
	beq 0 1 func
	noop
	lw 3 4 3
	lw 2 2 one
	noop
	add 1 1 1
	jalr 4 6
func	nor 6 4	1
	sw 1 6	6
	add 2 2	2
stopp	beq 2 3	func
stop	halt
zero	.fill	0
	.fill	0 
hi	.fill	32
one	.fill	1
