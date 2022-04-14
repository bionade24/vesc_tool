
; This is a simple driver for a SSD1306 128x64-pixel OLED-display using i2c. 

(def font [
0x00 0x00 0x00 0x00 0x00  0x00 0x00 0x5F 0x00 0x00  0x00 0x07 0x00 0x07 0x00  0x14 0x7F 0x14 0x7F 0x14
0x24 0x2A 0x7F 0x2A 0x12  0x23 0x13 0x08 0x64 0x62  0x36 0x49 0x56 0x20 0x50  0x00 0x08 0x07 0x03 0x00
0x00 0x1C 0x22 0x41 0x00  0x00 0x41 0x22 0x1C 0x00  0x2A 0x1C 0x7F 0x1C 0x2A  0x08 0x08 0x3E 0x08 0x08
0x00 0x80 0x70 0x30 0x00  0x08 0x08 0x08 0x08 0x08  0x00 0x00 0x60 0x60 0x00  0x20 0x10 0x08 0x04 0x02
0x3E 0x51 0x49 0x45 0x3E  0x00 0x42 0x7F 0x40 0x00  0x72 0x49 0x49 0x49 0x46  0x21 0x41 0x49 0x4D 0x33
0x18 0x14 0x12 0x7F 0x10  0x27 0x45 0x45 0x45 0x39  0x3C 0x4A 0x49 0x49 0x31  0x41 0x21 0x11 0x09 0x07
0x36 0x49 0x49 0x49 0x36  0x46 0x49 0x49 0x29 0x1E  0x00 0x00 0x14 0x00 0x00  0x00 0x40 0x34 0x00 0x00
0x00 0x08 0x14 0x22 0x41  0x14 0x14 0x14 0x14 0x14  0x00 0x41 0x22 0x14 0x08  0x02 0x01 0x59 0x09 0x06
0x3E 0x41 0x5D 0x59 0x4E  0x7C 0x12 0x11 0x12 0x7C  0x7F 0x49 0x49 0x49 0x36  0x3E 0x41 0x41 0x41 0x22
0x7F 0x41 0x41 0x41 0x3E  0x7F 0x49 0x49 0x49 0x41  0x7F 0x09 0x09 0x09 0x01  0x3E 0x41 0x41 0x51 0x73
0x7F 0x08 0x08 0x08 0x7F  0x00 0x41 0x7F 0x41 0x00  0x20 0x40 0x41 0x3F 0x01  0x7F 0x08 0x14 0x22 0x41
0x7F 0x40 0x40 0x40 0x40  0x7F 0x02 0x1C 0x02 0x7F  0x7F 0x04 0x08 0x10 0x7F  0x3E 0x41 0x41 0x41 0x3E
0x7F 0x09 0x09 0x09 0x06  0x3E 0x41 0x51 0x21 0x5E  0x7F 0x09 0x19 0x29 0x46  0x26 0x49 0x49 0x49 0x32
0x03 0x01 0x7F 0x01 0x03  0x3F 0x40 0x40 0x40 0x3F  0x1F 0x20 0x40 0x20 0x1F  0x3F 0x40 0x38 0x40 0x3F
0x63 0x14 0x08 0x14 0x63  0x03 0x04 0x78 0x04 0x03  0x61 0x59 0x49 0x4D 0x43  0x00 0x7F 0x41 0x41 0x41
0x02 0x04 0x08 0x10 0x20  0x00 0x41 0x41 0x41 0x7F  0x04 0x02 0x01 0x02 0x04  0x40 0x40 0x40 0x40 0x40
0x00 0x03 0x07 0x08 0x00  0x20 0x54 0x54 0x78 0x40  0x7F 0x28 0x44 0x44 0x38  0x38 0x44 0x44 0x44 0x28
0x38 0x44 0x44 0x28 0x7F  0x38 0x54 0x54 0x54 0x18  0x00 0x08 0x7E 0x09 0x02  0x18 0xA4 0xA4 0x9C 0x78
0x7F 0x08 0x04 0x04 0x78  0x00 0x44 0x7D 0x40 0x00  0x20 0x40 0x40 0x3D 0x00  0x7F 0x10 0x28 0x44 0x00
0x00 0x41 0x7F 0x40 0x00  0x7C 0x04 0x78 0x04 0x78  0x7C 0x08 0x04 0x04 0x78  0x38 0x44 0x44 0x44 0x38
0xFC 0x18 0x24 0x24 0x18  0x18 0x24 0x24 0x18 0xFC  0x7C 0x08 0x04 0x04 0x08  0x48 0x54 0x54 0x54 0x24
0x04 0x04 0x3F 0x44 0x24  0x3C 0x40 0x40 0x20 0x7C  0x1C 0x20 0x40 0x20 0x1C  0x3C 0x40 0x30 0x40 0x3C
0x44 0x28 0x10 0x28 0x44  0x4C 0x90 0x90 0x90 0x7C  0x44 0x64 0x54 0x4C 0x44  0x00 0x08 0x36 0x41 0x00
0x00 0x00 0x77 0x00 0x00  0x00 0x41 0x36 0x08 0x00  0x02 0x01 0x02 0x04 0x02])

(def #SSD-ADDRESS 0x3c)

(def cmds-init '(
    (0xAE)      ; Display off
    (0xD5 0x80) ; Osc freq
    (0xA8 0x3F) ; Mux ratio
    (0xD3 0x00) ; Display offset
    (0x8D 0x14) ; Char reg
    (0x81 0xCF) ; Set contrast
    (0x20 0x00) ; Memory addr mode
    (0x21 0 127) ; Column addr
    (0x22 0 7) ; Page addr
    (0x40) ; Start line
    (0xA1) ; Seg remap op
    (0xC8) ; Com scan dir op
    (0xDA 0x12) ; Com pin conf
    (0xD9 0xF1) ; Precharge
    (0xDB 0x40) ; Vcom deselect
    (0xA4) ; Dis ent disp on
    (0xA6) ; Dis normal
    (0x2E) ; Deactivate scroll
    (0xAF) ; Disaply on
))

(i2c-start)

(loopforeach c cmds-init
    (i2c-tx-rx #SSD-ADDRESS `(0x00 ,@c))
)

(def pixbuf (array-create type-byte 1025))
(bufset-u8 pixbuf 0 0x40) ; First byte tells the SSD1306 that this is data
(bufclear pixbuf 0 1)

; Note that the functions below assume int for x, y and row, so a type conversion
; using (to-i x) has to be made if they are called with e.g. floats.

(defun pix-set (x y)
    (let ((addr (+ x 1 (* (/ y 8) 128))))
    (if (and (< addr 1025) (>= addr 0))
        (bufset-u8 pixbuf
            addr
            (bitwise-or
                (bufget-u8 pixbuf addr)
                (shl 1 (bitwise-and y 7)))
))))

(defun circle (x0 y0 r)
    (let (
        (f (- 1 r))
        (ddF-x 1)
        (ddF-y (* -2 r))
        (x 0)
        (y r)
    )
    (progn
        (pix-set x0 (+ y0 r))
        (pix-set x0 (- y0 r))
        (pix-set (+ x0 r) y0)
        (pix-set (- x0 r) y0)

        (loopwhile (< x y)
            (progn
                (if (>= f 0)
                    (progn
                        (set! 'y (- y 1))
                        (set! 'ddF-y (+ ddF-y 2))
                        (set! 'f (+ f ddF-y))
                ))
                (set! 'x (+ x 1))
                (set! 'ddF-x (+ ddF-x 2))
                (set! 'f (+ f ddF-x))
                
                (pix-set (+ x0 x) (+ y0 y))
                (pix-set (- x0 x) (+ y0 y))
                (pix-set (+ x0 x) (- y0 y))
                (pix-set (- x0 x) (- y0 y))
                (pix-set (+ x0 y) (+ y0 x))
                (pix-set (- x0 y) (+ y0 x))
                (pix-set (+ x0 y) (- y0 x))
                (pix-set (- x0 y) (- y0 x))
)))))

(defun line (xs ys xe ye)
    (let (
        (x0 (if (> xe xs) xs xe))
        (x1 (if (> xe xs) xe xs))
        (y0 (if (> ye ys) ys ye))
        (y1 (if (> ye ys) ye ys))
        (steep (> x0 x1))
        (dx (- x1 x0))
        (dy (abs (- y1 y0)))
        (err (/ dx 2))
        (ystep (if (< y0 y1) 1 -1))
    )
    (loopwhile (<= x0 x1)
        (progn
            (if steep
                (pix-set y0 x0)
                (pix-set x0 y0)
            )
            (set! 'err (- err dy))
            (if (< err 0)
                (progn
                    (set! 'y0 (+ y0 ystep))
                    (set! 'err (+ err dx))
            ))
            (set! 'x0 (+ x0 1))
))))

(defun putc (x row c) 
    (let (
        (y (* row 128))
        (co (* 5 (- c 32)))
    )(progn
        (bufset-u32 pixbuf (+ x 1 y) (bufget-u32 font co))
        (bufset-u8 pixbuf (+ x 5 y) (bufget-u8 font (+ 4 co)))
)))

(defun putstr (x row str)
    (looprange i 0 (str-len str)
        (putc (+ x (* i 6)) row (bufget-u8 str i))
))

; Draw static things
(line 0 11 127 11)

(def fps 0)

(loopwhile t
    (progn
        (def t-start (systime))
        (putstr 0 0 (str-from-n (get-vin)      "V In : %.1f "))
        (putstr 0 2 (str-from-n (get-temp-fet) "T Fet: %.1f "))
        (putstr 0 7 (str-from-n fps "FPS %.1f "))
        (circle 90 50 (to-i (- (get-vin) 10))) ; Circle that changes size based in v_in
        (i2c-tx-rx #SSD-ADDRESS pixbuf)
        (bufclear pixbuf 0 385) ; Clear lower screen section
        (def fps (/ 1 (secs-since t-start))) ; Calculate framerate excluding sleep
        (sleep 0.1)
))
