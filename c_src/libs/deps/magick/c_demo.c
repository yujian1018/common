#include <stdio.h>
#include <string.h>
//#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <magick/api.h>

//const int IMG_RESIZES[3][2]={{80, 80}, {320, 320}, {640, 640}};
const int IMG_RESIZES[1][2]={{80, 80}};
int array_len = sizeof(IMG_RESIZES)/sizeof(int)/2;
unsigned long img_size, img_quality_num;

static int resize_image(const Image *image, ExceptionInfo exception, ImageInfo *image_info)
{
    int
        i,width, height;

    const ImageAttribute
        *attribute;

    Image
          *resize_image;

    attribute = GetImageAttribute(image, "JPEG-Quality");

    img_quality_num = atoi(attribute->value);
    if( img_quality_num > 75)
    {
        img_quality_num = 75;
    }
    for (i=0; i< array_len; i++)
    {

        width = IMG_RESIZES[i][0];
        height = (int)(image->rows * width / image->columns+0.5);

        resize_image = ResizeImage(image,width,height,LanczosFilter,1.0,&exception);

        if (resize_image == (Image *) NULL)
        {
            CatchException(&exception);
            return 1;
        }

        unsigned char *blob;
        image_info->quality=img_quality_num;
        blob = ImageToBlob(image_info, resize_image, &img_size, &exception);
        if(blob ==(void *) NULL)
        {
            printf("Failed to ImageToBlob!\n");
            return 2;
        }

//        printf("111:%ld\n", GetBlobSize(resize_image));

        if (resize_image == (Image *) NULL)
        {
            CatchException(&exception);
            continue;
        }

        DestroyImage(resize_image);
        free(blob);

    }
    return 0;

}

int main(int argc,char **argv)
{
    struct timeval start, end;
    gettimeofday( &start, NULL );

    InitializeMagick(NULL);

    ExceptionInfo
      exception;

    Image
      *image;

    ImageInfo
      *image_info;

    /*
    Initialize the image info structure and read the list of files
    provided by the user as a image sequence
    */
    GetExceptionInfo(&exception);

    image_info = CloneImageInfo((ImageInfo *) NULL);
    (void) strcpy(image_info -> filename, "../img/1.jpg");
    image = ReadImage(image_info, &exception);

    for(int i=0; i<10000; i++)
    {
        resize_image(image, exception, image_info);
    }



    /*
    Release resources
    */
    DestroyImage(image);
    DestroyImageInfo(image_info);
    DestroyExceptionInfo(&exception);
    DestroyMagick();

    gettimeofday( &end, NULL );
    int timeuse = 1000000 * ( end.tv_sec - start.tv_sec ) + end.tv_usec - start.tv_usec;
    printf("time: %d us\n", timeuse);
    return(0);
}

//gcc -o demo c_demo.c -O `GraphicsMagick-config --cppflags --ldflags --libs`
//#gcc -fPIC -shared -I /usr/local/lib/erlang/usr/include/ -o priv/leofs_magick.so c_src/magick/leofs_magick.c -O  `GraphicsMagickWand-config --cppflags --ldflags --libs`
//#g++ -fPIC -shared -I /usr/local/lib/erlang/usr/include/ -o priv/leofs_magick.so c_src/magick/leofs_magick.cpp -O  `GraphicsMagick++-config --cppflags --ldflags --libs`
//#gcc -fPIC -shared -I /usr/local/lib/erlang/usr/include/ -o priv/leofs_magick.so c_src/magick/leofs_magick_1.c -O  `GraphicsMagick-config --cppflags --ldflags --libs`
