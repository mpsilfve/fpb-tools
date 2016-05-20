#! /usr/bin/env python3

from sys import argv, stdin

import libhfst

if __name__=='__main__':
    
    oprefix = argv[1]
    omorfi_out = open(oprefix + '.omor', 'w')
    non_omorfi_out = open(oprefix + '.non.omor', 'w')

    omorfi = libhfst.HfstInputStream(argv[2]).read()

    for line in map(lambda x: x.strip(), open(argv[1])):
        if line == '':
            omorfi_out.write('\n')
            non_omorfi_out.write('\n')
        else:
            wf, feats, lemma, label, ann = line.split('\t')
            
            if len(wf) > 30 or len(omorfi.lookup(wf)) == 0:
                non_omorfi_out.write(line + '\n')
            else:
                omorfi_out.write(line + '\n')
