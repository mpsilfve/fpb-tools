#! /usr/bin/env python3 

from sys import stdin

if __name__=='__main__':
    for line in map(lambda x: x.strip(), stdin):
        if line == '':
            print()
        else:
            wf, feats, lemma, label, ann = line.split('\t')

            # In cases like "keski#ikä", the lemma should be
            # "keski-ikä", otherwise, "#" symbols are simply deleted.
            if '-' in wf:
                lemma = lemma.replace('#','-')
            else:
                lemma = lemma.replace('#','')
        
            # If the word-form is '#' then the lemma is now empty :/
            if lemma == '' or lemma == '_':
                lemma = '#'

            # Labels can be empty some times as well.
            if label == '' or label == '_':
                label = '#'

            print('\t'.join((wf, feats, lemma, label, ann)))
