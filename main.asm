


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
  
  
