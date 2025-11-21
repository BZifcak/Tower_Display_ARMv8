.global _start
.text
_start:
        #open joystick
        sub sp,sp,#16
        str lr,[sp]
        bl openJoystick
        cmp x0,#0
        blt ._start_exit

        #open frame buffer
        bl openfb
        cmp x0,#0
        blt ._start_exit
        mov x8,x0

        #set default color to be red
        mov x0,#31
        mov x1,#0
        mov x2,#0
        bl getColor
        mov x6,x0
        mov x16, #0

        mov x13, #0
        mov x14, #0
        mov x2, x6
        mov x0, x13
        mov x1, x14
        bl .safeDisplay

.main_loop:
        #x is x13
        #y is x14
        #just cuz
        bl getJoystickValue
        mov x4, x0
        cmp x4, #0
        blt ._start_fbclose
        cmp x4, #5
        beq .joyPushIn
        b .joyPush


.drawTower:
        bl .clear
        mov x0, x13
        mov x1, x14
        mov x2, x6
        bl .safeDisplay
        mov x5, #0
.outer_display:
        #loops from i = [0,x] inclusive
        cmp x5, x13
        bgt .main_loop
        #radius of row (x - i) offset
        sub x7, x13, x5
        #lower bound (y - i)
        sub x9, x14, x7
        #upper bound (y + i)
        add x10, x14, x7
.inner_display:
        cmp x9, x10
        bgt .inner_exit
        mov x0, x5
        mov x1, x9
        mov x2, x6
        bl .safeDisplay
        add x9, x9, #1
        b .inner_display
.inner_exit:
        add x5, x5, #1
        b .outer_display

.safeDisplay:
        cmp x0, #8
        bge .exit_display
        cmp x1, #8
        bge .exit_display
        cmp x0, #0
        blt .exit_display
        cmp x1, #0
        blt .exit_display
        mov x15, #7
        #inverts x and y for display
        sub x0, x15, x0
        sub x1, x15, x1
        sub sp, sp, #16
        str lr, [sp]
        bl setPixel
        ldr lr, [sp]
        add sp, sp, #16
.exit_display:
        ret

._start_fbclose:
        bl .clear
        bl closefb
._start_exit:
        #close joystick device
        bl closeJoystick
        cmp x0,#0
        blt ._start_exit
        ldr lr,[sp]
        add sp, sp, #16
        #clean exit
        mov x8,#94
        svc #0
.joyPush:
        cmp x4,#2 //up
        bne .skip1
        cmp x13,#0
        beq .drawTower
        sub x13,x13,#1
        b .drawTower
.skip1:  cmp x4,#1      //left
        bne .skip2
        cmp x14,#7
        beq .drawTower
        add x14,x14,#1
        b .drawTower
.skip2:  cmp x4,#4       //down
        bne .skip3
        cmp x13,#7
        beq .drawTower
        add x13,x13,#1
        b .drawTower
.skip3:  cmp x4,#3       //right
        bne .main_loop
        cmp x14,#0
        beq .drawTower
        sub x14,x14,#1
        b .drawTower
.joyPushIn:
        cmp x16, #6
        bgt ._start_fbclose
        add x16, x16, #1
        cmp x16, #2
        beq .set_blue
        cmp x16, #4
        beq .set_green
        cmp x16, #6
        beq .set_white

.set_blue:
        mov x0,#0
        mov x1,#0
        mov x2,#31
        bl getColor
        mov x6,x0
        b .drawTower


.set_green:
        mov x0,#0
        mov x1,#31
        mov x2,#0
        bl getColor
        mov x6,x0
        b .drawTower

.set_white:
        mov x0,#31
        mov x1,#31
        mov x2,#31
        bl getColor
        mov x6,x0
        b .drawTower


.clear:
        sub sp,sp,#16
        str lr,[sp]
        mov x11,#0
.clear_outer:
        cmp x11, #7
        bgt .clear_outer_exit
        mov x12, #0
.clear_inner:
        cmp x12, #7
        bgt .clear_inner_exit
        mov x0, x11
        mov x1, x12
        mov x2, #0
        bl setPixel
        add x12, x12, #1
        b .clear_inner
.clear_inner_exit:
        add x11, x11, #1
        b .clear_outer
.clear_outer_exit:
        ldr lr, [sp]
        add sp, sp, #16
        ret
