


  .ORG $2000
  
  
  
  
  
  
  
  
; DRAW SPRITE 18x16
;
; expects pointer to sprite pattern in spriteSrc
; expects pointer to screen in spriteDest

drawSpriteBig
  ldx #$10
  ldy #$00
  clc
drawSpriteBig2  
  lda (spriteSrc), y              ;or first byte
  ora (spriteDest), y
  sta (spriteDest), y
  iny 
  lda (spriteSrc), y              ;or second byte
  ora (spriteDest), y
  sta (spriteDest), y
  iny 
  lda (spriteSrc), y              ;or third byte
  ora (spriteDest), y
  sta (spriteDest), y
  iny 
  lda spriteDest
  adc #$25                        ;update destination by (40-3)=37
  sta spriteDest
  bcc drawSpriteBig1              ;skip update of msb 
  lda spriteDest+1
  adc #$00
  sta spriteDest+1
drawSpriteBig1
  dex                             ;decrement lopp
  bne drawSpriteBig2
  rts
  
; CLEAR SPRITE 18x16
;
; expects pointer to screen in spriteDest

clearSpriteBig
  ldy #$00
  ldx #$10
clearSpriteBig1
  lda #$00
  sta (spriteDest), y
  iny
  sta (spriteDest), y
  iny
  sta (spriteDest), y
  lda spriteDest
  adc #$26
  sta spriteDest
  bcc clearSpriteBig2
  lda spriteDest+1
  adc #$00
  sta spriteDest+1
clearSpriteBig2
  dex 
  bne clearSpriteBig1
  rts
    
    
; DRAW SPRITE 12x6
;
; expects pointer to sprite pattern in spriteSrc
; expects pointer to screen in spriteDest

drawSpriteSmall
  ldx #$06
  ldy #$00
  clc
drawSpriteSmall1
  lda (spriteSrc), y
  ora (spriteDest), y
  sta (spriteDest), y
  iny
  lda (spriteSrc), y
  ora (spriteDest), y
  sta (spriteDest), y
  iny
  lda spriteDest
  adc #$26
  sta spriteDest
  bcc drawSpriteSmall2
  lda spriteDest+1
  adc #$00
  sta spriteDest+1
drawSpriteSmall2
  dex
  bne drawSpriteSmall1
  rts
  
; CLEAR SPRITE 12x6
;
; expects pointer to screen in spriteDest

clearSpriteSmall
  ldy #$00
  ldx #$06
clearSpriteSmall1
  lda #$00
  sta (spriteDest), y
  iny
  sta (spriteDest), y
  lda spriteDest
  adc #$27
  sta spriteDest
  bcc clearSpriteSmall2
  lda spriteDest+1
  adc #$00
  sta spriteDest+1
clearSpriteSmall2
  dex 
  bne clearSpriteSmall1
  rts
  
; COPY DIRTY AREAS

copyDirtyAreas
  lda dirtyMap+2, y
  
copyDirtyLine

copyDirtyLine2
  clc
  rol
  pha
  php
  bcc copyDirtyLine1   ;skip this rectangle if not dirty
  ldx #$04
copyDirtyLine3
  jsr copyDirtyBlock0  ;6+78
  iny                  ;2
  dex                  ;2
  bne copyDirtyLine3   ;3 = 364
  jmp copyDirtyLine4
copyDirtyLine1
  iny
  iny
  iny
  iny
copyDirtyLine4  
  php
  pha
  bne copyDirtyLine2
  rts
  
  
copyDirtyBlock0
;y .. offset in line
;(4+5)*8+6=78
  lda $8000, y ;0
  sta $a000, y
  lda $8028, y ;1
  sta $a028, y
  lda $8050, y ;2
  sta $a050, y
  lda $8078, y ;3
  sta $a078, y
  lda $80a0, y ;4
  sta $a0a0, y
  lda $80c8, y ;5
  sta $a0c8, y 
  lda $80f0, y ;6
  sta $a0f0, y
  lda $8118, y ;7
  sta $a118, y
  rts

; DIRTY RECTANGLES
;
; dirty map
; 2 bytes of top buffer, 18 bytes of visible area, 2 bytes of bottom buffer
;
;

dirtyMap
  .BYTE 0, 0
  .BYTE 0, 0, 0, 0
  .BYTE 0, 0, 0, 0
  .BYTE 0, 0, 0, 0
  .BYTE 0, 0, 0, 0
  .BYTE 0, 0
  .BYTE 0, 0
  
  

dirtyLineMap
  .BYTE 0, 0, 0 ,0
  .BYTE 1, 1, 1, 1
  
  .BYTE 2, 2, 2, 2 ;first line
  .BYTE 3, 3, 3, 3
  .BYTE 4, 4, 4 ,4
  .BYTE 5, 5, 5, 5
  
  .BYTE 6, 6, 6, 6
  .BYTE 7, 7, 7, 7
  .BYTE 8, 8, 8 ,8
  .BYTE 9, 9, 9, 9
  
  .BYTE 10, 10, 10, 10
  .BYTE 11, 11, 11, 11
  .BYTE 12, 12, 12, 12
  .BYTE 13, 13, 13, 13
  
  .BYTE 14, 14, 14, 14
  .BYTE 15, 15, 15 ,15
  .BYTE 16, 16, 16, 16
  .BYTE 17, 17, 17, 17
  
  .BYTE 18, 18, 18, 18
  .BYTE 19, 19, 19, 19 ;last line
  
  .BYTE 20, 20, 20 ,20
  .BYTE 21, 21, 21, 21 
    
dirtyBigPixel
;000000000011111111112222222222333333333344444444445555555555666666666677
;012345678901234567890123456789012345678901234567890123456789012345678901
;    <------><------><------><------><------><------><------><------>
;000000 eeeeee  eeeeee  eeeeee  eeeeee  
; 222222 000000  000000  000000   
;  444444 222222  222222  222222 
;   666666 444444  444444  444444
;    888888 666666  666666  666666 
;     aaaaaa 888888  888888  888888
;      cccccc aaaaaa  aaaaaa  aaaaaa
;              cccccc  cccccc  cccccc
  .BYTE %10000000, %10000000, %10000000, %10000000  ;0 1 2 3
  .BYTE %10000000, %10000000, %10000000, %10000000  ;4 5 6 7
  .BYTE %10000000, %10000000, %10000000, %10000000  ;8 9 a b
  .BYTE %10000000, %10000000, %11000000, %11000000  ;c d e f
  .BYTE %11000000, %11000000, %11000000, %11000000  ;0 1 2 3
  .BYTE %11000000, %11000000, %11000000, %11000000  ;4 5 6 7
  .BYTE %01000000, %01000000, %01000000, %01000000  ;8 9 a b
  .BYTE %01000000, %01000000, %01100000, %01100000  ;c d e f
  .BYTE %01100000, %01100000, %01100000, %01100000  ;0 1 2 3
  .BYTE %01100000, %01100000, %01100000, %01100000  ;4 5 6 7
  .BYTE %00100000, %00100000, %00100000, %00100000  ;8 9 a b
  .BYTE %00100000, %00100000, %00110000, %00110000  ;c d e f
  .BYTE %00110000, %00110000, %00110000, %00110000  ;0 1 2 3
  
  
