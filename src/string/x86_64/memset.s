.global memset
.type memset,@function
memset:
	vpxor	%xmm0, %xmm0, %xmm0
	vmovd	%esi, %xmm1
	lea	(%rdi, %rdx), %rsi
	mov	%rdi, %rax
	vpshufb	%xmm0, %xmm1, %xmm0
	cmp	$16, %rdx
	jb	less_16bytes
	cmp	$256, %rdx
	jae	_256bytesormore
	cmp	$128, %dl
	jb	less_128bytes
	vmovdqu	%xmm0, (%rdi)
	vmovdqu %xmm0, 0x10(%rdi)
	vmovdqu %xmm0, 0x20(%rdi)
	vmovdqu %xmm0, 0x30(%rdi)
	vmovdqu %xmm0, 0x40(%rdi)
	vmovdqu %xmm0, 0x50(%rdi)
	vmovdqu %xmm0, 0x60(%rdi)
	vmovdqu %xmm0, 0x70(%rdi)
	vmovdqu %xmm0, -0x80(%rsi)
	vmovdqu %xmm0, -0x70(%rsi)
	vmovdqu %xmm0, -0x60(%rsi)
	vmovdqu %xmm0, -0x50(%rsi)
	vmovdqu %xmm0, -0x40(%rsi)
	vmovdqu %xmm0, -0x30(%rsi)
	vmovdqu %xmm0, -0x20(%rsi)
	vmovdqu %xmm0, -0x10(%rsi)
	ret

	.p2align 4
less_128bytes:
	cmp	$64, %dl
	jb	less_64bytes
	vmovdqu %xmm0, (%rdi)
	vmovdqu %xmm0, 0x10(%rdi)
	vmovdqu %xmm0, 0x20(%rdi)
	vmovdqu %xmm0, 0x30(%rdi)
	vmovdqu %xmm0, -0x40(%rsi)
	vmovdqu %xmm0, -0x30(%rsi)
	vmovdqu %xmm0, -0x20(%rsi)
	vmovdqu %xmm0, -0x10(%rsi)
	ret

	.p2align 4
less_64bytes:
	cmp	$32, %dl
	jb	less_32bytes
	vmovdqu %xmm0, (%rdi)
	vmovdqu %xmm0, 0x10(%rdi)
	vmovdqu %xmm0, -0x20(%rsi)
	vmovdqu %xmm0, -0x10(%rsi)
	ret

	.p2align 4
less_32bytes:
	vmovdqu %xmm0, (%rdi)
	vmovdqu %xmm0, -0x10(%rsi)
	ret

	.p2align 4
less_16bytes:
	cmp	$8, %dl
	jb	less_8bytes
	vmovq %xmm0, (%rdi)
	vmovq %xmm0, -0x08(%rsi)
	ret

	.p2align 4
less_8bytes:
	vmovd	%xmm0, %ecx
	cmp	$4, %dl
	jb	less_4bytes
	mov	%ecx, (%rdi)
	mov	%ecx, -0x04(%rsi)
	ret

	.p2align 4
less_4bytes:
	cmp	$2, %dl
	jb	less_2bytes
	mov	%cx, (%rdi)
	mov	%cx, -0x02(%rsi)
	ret

	.p2align 4
less_2bytes:
	cmp	$1, %dl
	jb	less_1bytes
	mov	%cl, (%rdi)
less_1bytes:
	ret

	.p2align 4
_256bytesormore:
	vinserti128 $1, %xmm0, %ymm0, %ymm0
	and	$-0x20, %rdi
	add	$0x20, %rdi
	vmovdqu	%ymm0, (%rax)
	sub	%rdi, %rax
	lea	-0x80(%rax, %rdx), %rcx
	cmp	$4096, %rcx
	ja	gobble_data
gobble_128_loop:
	vmovdqa	%ymm0, (%rdi)
	vmovdqa	%ymm0, 0x20(%rdi)
	vmovdqa	%ymm0, 0x40(%rdi)
	vmovdqa	%ymm0, 0x60(%rdi)
	sub	$-0x80, %rdi
	add	$-0x80, %ecx
	jb	gobble_128_loop
	mov	%rsi, %rax
	vmovdqu	%ymm0, -0x80(%rsi)
	vmovdqu	%ymm0, -0x60(%rsi)
	vmovdqu	%ymm0, -0x40(%rsi)
	vmovdqu	%ymm0, -0x20(%rsi)
	sub	%rdx, %rax
	vzeroupper
	ret

	.p2align 4
gobble_data:
	sub	$-0x80, %rcx
	vmovd	%xmm0, %eax
	rep	stosb
	mov	%rsi, %rax
	sub	%rdx, %rax
	vzeroupper
	ret
