PROGRAM DecodeCard
    IMPLICIT NONE
    ! Our card
    INTEGER, DIMENSION(80,12) :: vcard
    INTEGER, DIMENSION(12, 80) :: hcard     
    ! Our code table
    CHARACTER*4, DIMENSION(2,37) :: codetable
    CHARACTER*4, DIMENSION(37,2) :: codes
    INTEGER*2 :: coderow
    CHARACTER*4 :: codekey
    ! For going through the card
    INTEGER*2 :: row, column
    CHARACTER*8 :: key, keypart
    INTEGER :: position ! the spot on the card
    CHARACTER*80 :: text ! The final text

    PRINT *, "*** START PROGRAM GC37XF9***"
    OPEN(UNIT=8, FILE="codes.txt", ACCESS='sequential', STATUS='old', ACTION='read')
    READ(8,*) codetable
    CLOSE(UNIT=8)
    codes = TRANSPOSE(codetable)
    OPEN(UNIT=9, FILE="gc37xf9.card", ACCESS='sequential', STATUS='old', ACTION='read')    
    READ(9,*) vcard
    CLOSE(UNIT=9)
    hcard = TRANSPOSE(vcard)       
    !print *, vcard(43,8)    ! column, row
    !print *, hcard(8, 43)   ! row, colum
    !print *, codes(29,1), codes(29,2)
    
    text = ""

    DO column = 1,80
        key = ""
        DO row = 1,12
            position = vcard(column, row)            
            IF (position .eq. 1.) THEN         
                IF (row .lt. 10.) THEN
                    WRITE(keypart, '(I1)') row
                ELSE
                    WRITE(keypart, '(I2)') row
                END IF                            
                key = trim(key) // trim(keypart)
            END IF
        ENDDO

        IF (LEN(trim(key)) .eq. 0) THEN
            text = trim(text) // trim("_")        
        ELSE
            ! Now find the key in the other array
            DO coderow = 1,37
                codekey = codes(coderow, 1)
                IF (key .eq. codekey) THEN
                    text = trim(text) // trim(codes(coderow,2))
                END IF
            ENDDO
        END IF
    ENDDO
    PRINT *, "==>", text
    PRINT *, "*** END PROGRAM GC37XF9 - NOW GO FIND THE CACHE! ***"
END PROGRAM DecodeCard
