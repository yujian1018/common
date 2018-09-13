/*
 * Copyright (C) 2002-2017 ProcessOne, SARL. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <erl_nif.h>
#include <string.h>
#include <iconv.h>

#define min(x,y)  ( x<y?x:y )
int abs( int num );

int EditDistance(char* src, char* dest){
    if(strlen(src) == 0 || strlen(dest) == 0)
        return abs((int)strlen(src) - (int)strlen(dest));
    if(src[0] == dest[0])
        return EditDistance(src + 1, dest + 1);
    int edIns = EditDistance(src, dest + 1) + 1;
    int edDel = EditDistance(src + 1, dest) + 1;
    int edRep = EditDistance(src + 1, dest + 1) + 1;

    return min(min(edIns,edDel),edRep);
}


static int load(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info)
{
    return 0;
}

static ERL_NIF_TERM edit_distance(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]){
    ErlNifBinary src_bin, dest_bin;
    enif_inspect_binary(env, argv[0], &src_bin);
    enif_inspect_binary(env, argv[1], &dest_bin);

    char *src = enif_alloc(src_bin.size + 1);
    char *dest = enif_alloc(dest_bin.size + 1);

    memcpy(src, src_bin.data, src_bin.size);
    memcpy(dest, dest_bin.data, dest_bin.size);

    src[src_bin.size] = '\0';
    dest[dest_bin.size] = '\0';

    enif_free(src);
    enif_free(dest);
//    printf("%s...%s", src, dest)
    int distance = EditDistance(src, dest);

    return enif_make_int(env, distance);
}

static ErlNifFunc nif_funcs[] =
    {
	{"edit_distance", 2, edit_distance}
    };

ERL_NIF_INIT(erl_func, nif_funcs, load, NULL, NULL, NULL)
