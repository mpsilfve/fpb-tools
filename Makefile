all:parsebank.fp fpb-lemmatize.data fpb-lemmatize.train fpb-lemmatize.model fpb-lemmatize.test.sys

fpb-lemmatize.data:parsebank.fp
	python3 separate_non_omorfi_words.py $^ omorfi.hfst
	cp $^.omor $@

fpb-lemmatize.train:fpb-lemmatize.data
	head -100000 $^ > fpb-lemmatize.test
	head -200000 $^ | tail -n +100000 > fpb-lemmatize.dev
	tail -n +200000 $^ > fpb-lemmatize.train

%.fp:%.conllu
	cat $^ | ./conll2finnpos > $@

%.model:%.config %.train %.dev
	time finnpos-train $^ $@

%.fp.in:%.fp
	cat $^ | ./unlemmatize > $@

%.test.sys:%.test %.model
	cat $< | ./unlemmatize | finnpos-lemmatize $*.model > $@

%.eval:%.test.sys %.test %.model
	finnpos-eval $*.test.sys $*.test $*.model