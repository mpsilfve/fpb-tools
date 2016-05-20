#! /usr/bin/env python3

from sys import argv, stdin

import libhfst

if __name__=='__main__':
    
    for line in map(lambda x: x.strip(), stdin):
        if line == '':
            print()
        else:
            wf, feats, lemma, label, ann = line.split('\t')
            
            if 'PROP' in label:
                lemma = lemma[0].upper() + lemma[1:]
            
            print ('\t'.join((wf,feats,lemma,label,ann)))
