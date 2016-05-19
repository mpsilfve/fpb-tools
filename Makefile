all:parsebank.fp fpb-lemmatize.data

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
	finnpos-train $^ $@

%.fp.in:%.fp
	cat $^ | ./unlemmatize > $@

%.test.sys:%.test %.lemmatizer
	cat $< | ./unlemmatize | finnpos-lemmatize $*.lemmatizer > $@