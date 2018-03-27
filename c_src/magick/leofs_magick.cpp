#include <Magick++.h>
#include <erl_nif.h>
#include <list>
#include <string>
#include <cstring>
#include <sstream>
#include <iostream>

using namespace std;
using namespace Magick;

const int IMG_RESIZES[3][2]={{80, 80}, {320, 320}, {640, 640}};
const int array_len = sizeof(IMG_RESIZES)/sizeof(int)/2;

extern "C"{

static ERL_NIF_TERM convert(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    int width, height, img_quality_num;
    string img_jpeg_quality;
    stringstream ss;
    ERL_NIF_TERM r = enif_make_list(env, 0);
    ErlNifBinary bin, h;

    enif_inspect_binary(env, argv[0], &bin);

    InitializeMagick(NULL);

    Blob blob(bin.data, bin.size);

    Image image(blob);

    Image image_file = image;

    img_jpeg_quality = image.attribute("JPEG-Quality");
    ss << img_jpeg_quality;
    ss >> img_quality_num;
    if( img_quality_num > 75)
    {
        img_quality_num = 75;
    }else if(img_quality_num == 0)
    {
        return enif_make_int(env, 2);
    }
//    cout << "aaa:"  << image.attribute("*") << "...bbb:" << image.type() << "...ccc:" << img_quality_num << "...ddd:" << image.imageInfo() << endl;
    try {
        for(int i=0; i<array_len; i++)
        {
            width = IMG_RESIZES[i][0];
            height = (int)(image.baseRows()*width/image.baseColumns()+0.5);

            image.quality(img_quality_num);
            image.thumbnail( Geometry(width, height) );
            image.write( &blob );
            enif_alloc_binary(blob.length(), &h);
            memcpy(h.data, blob.data(), blob.length());
            r = enif_make_list_cell(env, enif_make_binary(env, &h), r);

            image = image_file;

        }
    }
    catch( Exception &error_ )
    {
        return enif_make_int(env, 1);
    }

    ERL_NIF_TERM result;
    enif_make_reverse_list(env, r, &result);

    ss.clear();

    return result;

}


//使用脏调度器，异步执行nif
static ErlNifFunc nif_funcs[] =
{
    {"convert", 1, convert, ERL_NIF_DIRTY_JOB_CPU_BOUND}
};
}

ERL_NIF_INIT(leofs_magick,nif_funcs,NULL,NULL,NULL,NULL)