#include <stdio.h>
#include <stdlib.h>
#include "lodepng.h"

struct Pixel32 {
    unsigned char R;
    unsigned char G;
    unsigned char B;
    unsigned char A;
};

unsigned char* LoadPNG(const char* filename, unsigned* W, unsigned* H) {
    unsigned char* Res = NULL;
    unsigned ErrorCode = lodepng_decode32_file(&Res, W, H, filename);

    if(ErrorCode != 0) {
        printf("Lodepng error %u\n", ErrorCode);
        printf("%s\n", lodepng_error_text(ErrorCode));
    }

    return Res;
}

void SavePNG(const char* filename, const unsigned char* Bitmap, unsigned W, unsigned H) {
    unsigned char* buffer;
    size_t bufsize;

    unsigned ErrorCode = lodepng_encode32(&buffer, &bufsize, Bitmap, W, H);

    if (ErrorCode == 0)
        lodepng_save_file(buffer, bufsize, filename);
    else {
        printf("Lodepng error %u\n", ErrorCode);
        printf("%s\n", lodepng_error_text(ErrorCode));
    }

    free(buffer);
}

void InitBaseColors2(struct Pixel32* BaseColors) {
    for(int i=0; i<16; i++){
        BaseColors[i].A = 255;
    }

    BaseColors[0].R = 0;
    BaseColors[0].G = 0;
    BaseColors[0].B = 0;

    for(int i=1; i<=6; i++) {
        BaseColors[i].R = 0;
        BaseColors[i].G = 51*(i-1);
        BaseColors[i].B = 255 - 51*(i-1);
    }

    for(int i=6; i<=11; i++) {
        BaseColors[i].R = 51*(i-6);
        BaseColors[i].G = 255 - 51*(i-6);
        BaseColors[i].B = 0;
    }

    for(int i=11; i<=15; i++) {
        BaseColors[i].R = 255 - 51*(i-11);
        BaseColors[i].G = 0;
        BaseColors[i].B = 51*(i-11);
    }
}

int main() {
    const char* filename1 = "skull.png";
    const char* filename2 = "ans.png";

    unsigned W, H;
    unsigned char t;
    unsigned char* Bitmap = LoadPNG(filename1, &W, &H);
    struct Pixel32* Pixels = Bitmap;

    printf("«агружено изображение %u x %u\n", W, H);

    struct Pixel32 BaseColors[16];
    InitBaseColors2(BaseColors);

    for(int k=0; k<W*H; k++) {
        t = Pixels[k].G / 16;
        Pixels[k] = BaseColors[t];
    }

    printf("изображение раскрашено\n");

    SavePNG(filename2, Bitmap, W, H);
    printf("»тоговое изображение сохранено в %s\n", filename2);

    free(Bitmap);
    return 0;
}
