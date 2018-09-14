
#include <erl_nif.h>
#include <string.h>
#include <stdio.h>


#define min(x,y)  (x < y?x:y)

int editDistance(char *src, char  *dest)  
{  
    int i,j;
    int len1 = (int)strlen(src);
    int len2 = (int)strlen(dest);
    // printf("bbb %d  %d\n", len1, len2);
    int d[len1][len2];

    for (i = 0; i < (int)strlen(src); ++i) {
        d[i][0] = i; 
    }
    for (j = 0; j < (int)strlen(dest); ++j) {
        d[0][j] = j; 
    }

    
    for(i=1; i <= (int)strlen(src); i++){
        for(j = 1; j <= (int)strlen(dest); j++){
            if(src[i-1]==dest[j-1]){
                d[i][j] = d[i-1][j-1];
            }else{
                int edIns = d[i][j-1] + 1;
                int edDel = d[i-1][j]+1;
                int edRep = d[i-1][j-1]+1;

                d[i][j] =min(min(edIns,edDel),edRep);
            }
        }
    }
    return d[strlen(src)][strlen(dest)];
}


static ERL_NIF_TERM edit_distance(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{   
    ErlNifBinary src_bin, dest_bin;
    enif_inspect_binary(env, argv[0], &src_bin);
    enif_inspect_binary(env, argv[1], &dest_bin);

    char *src = enif_alloc(src_bin.size + 1);
    char *dest = enif_alloc(dest_bin.size + 1);

    memcpy(src, src_bin.data, src_bin.size);
    memcpy(dest, dest_bin.data, dest_bin.size);

    src[src_bin.size] = '\0';
    dest[dest_bin.size] = '\0';
    
    // printf("aaa %ld  %ld %s  %s\n", src_bin.size, dest_bin.size, src, dest);

    int distance = editDistance(src, dest);

    enif_free(src);
    enif_free(dest);

    return enif_make_int(env, distance);
}

static ErlNifFunc nif_funcs[] =
{
    {"edit_distance", 2, edit_distance}
};


// static int load(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info)
// {
//     return 0;
// }
// static int reload(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info)
// {
//     return 0;
// }
// static int upgrade(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info)
// {
//     return 0;
// }
// static int unload(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info)
// {
//     return 0;
// }

ERL_NIF_INIT(algo_funs, nif_funcs, NULL, NULL, NULL, NULL)