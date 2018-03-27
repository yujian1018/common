#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <magick/api.h>

#include <erl_nif.h>

const int IMG_RESIZES[3][2]={{80, 80}, {320, 320}, {640, 640}};
int array_len = sizeof(IMG_RESIZES)/sizeof(int)/2;
unsigned long img_size, img_quality_num;

static ERL_NIF_TERM convert(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    ExceptionInfo
        exception;

    Image
        *image,
        *resize_image;

    ImageInfo
        *image_info;

    int i,width, height;

    ErlNifBinary bin;
    enif_inspect_binary(env, argv[0], &bin);

    /*
    Initialize the image info structure and read the list of files
    provided by the user as a image sequence
    */
    InitializeMagick(NULL);

    GetExceptionInfo(&exception);

    image_info=CloneImageInfo((ImageInfo *) NULL);

    image = BlobToImage(image_info,bin.data,bin.size,&exception);

    /*
    Create a thumbnail image sequence
    */
    ERL_NIF_TERM r = enif_make_list(env, 0);
    ErlNifBinary h;

    const ImageAttribute *attribute;
    attribute = GetImageAttribute(image, "JPEG-Quality");

    img_quality_num = atoi(attribute->value);
//    printf("quality:%s...image_info qua::%ld...img_quality_num:%ld...\n", attribute->value, image_info->quality, img_quality_num);
    if( img_quality_num > 75)
    {
      img_quality_num = 75;
    }
    for (i=0; i< array_len; i++)
    {

//        printf("ima size:%ld...\n", GetBlobSize(image));
    width = IMG_RESIZES[i][0];
    height = image->rows * width / image->columns + 1;
    resize_image=ResizeImage(image,width,height,LanczosFilter,1.0,&exception);

    if (resize_image == (Image *) NULL)
    {
        CatchException(&exception);
        return enif_make_int(env, 1);
    }

    unsigned char *blob;
    image_info->quality=img_quality_num;
    blob = ImageToBlob(image_info, resize_image, &img_size, &exception);
    if(blob ==(void *) NULL)
    {
        printf("Failed to ImageToBlob!\n");
        return enif_make_int(env, 2);
    }

//        printf("111:%ld\n", GetBlobSize(resize_image));

    if (resize_image == (Image *) NULL)
    {
        CatchException(&exception);
        continue;
    }
        enif_alloc_binary(img_size, &h);
        memcpy(h.data, blob, img_size);
        r = enif_make_list_cell(env, enif_make_binary(env, &h), r);
        DestroyImage(resize_image);
        free(blob);
    }

    /*
    Release resources
    */

    DestroyImage(image);
    DestroyImageInfo(image_info);
    DestroyExceptionInfo(&exception);
    DestroyMagick();
    ERL_NIF_TERM result;
    enif_make_reverse_list(env, r, &result);
    return result;
}


static ErlNifFunc nif_funcs[] =
{
    {"convert", 1, convert}
};

ERL_NIF_INIT(leofs_magick,nif_funcs,NULL,NULL,NULL,NULL)