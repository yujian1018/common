#include <Magick++.h>

#include <iostream>
#include <stdio.h>
#include <ctime>
#include <sys/time.h>
#include <sstream>

using namespace std;
using namespace Magick;

const int IMG_RESIZES[3][2]={{80, 80}, {320, 320}, {640, 640}};
//const int IMG_RESIZES[1][2]={{80, 80}};
const int array_len = sizeof(IMG_RESIZES)/sizeof(int)/2;

int write(Image image)
{
    string img_jpeg_quality;
    stringstream ss;
    int img_quality_num, width, height;
    Blob blob;

    Image image_file = image;
    img_jpeg_quality = image.attribute("JPEG-Quality");
    ss << img_jpeg_quality;
    ss >> img_quality_num;
    for(int i=0; i<array_len; i++)
    {
        width = IMG_RESIZES[i][0];
        height = (int)(image.baseRows()*width/image.baseColumns()+0.5);

        image.quality(img_quality_num);
        image.thumbnail( Geometry(width, height) );
        image.write( &blob );

        image = image_file;

    }
    ss.clear();
    return 0;
}

int main(int argc,char **argv)
{
    struct timeval start, end;
    gettimeofday( &start, NULL );

    InitializeMagick(*argv);

    Image image("../img/1.jpg");

    for(int m = 0; m < 1000; m++){
        write(image);
    }

    gettimeofday( &end, NULL );
    int timeuse = 1000000 * ( end.tv_sec - start.tv_sec ) + end.tv_usec - start.tv_usec;
    printf("time: %d us\n", timeuse);
    return 0;
}


//c++ -o demo cpp_demo.cpp -O `GraphicsMagick++-config --cppflags --cxxflags --ldflags --libs`