all:parsebank.fp fpb-lemmatize.data fpb-lemmatize.train \
fpb-lemmatize.model fpb-lemmatize.test.in fpb-lemmatize.test.sys

data:parsebank.fp fpb-lemmatize.data fpb-lemmatize.train \
fpb-lemmatize.test.in

clean:
	rm -f parsebank.fp fpb-lemmatize.data fpb-lemmatize.train \
fpb-lemmatize.model fpb-lemmatize.test.in fpb-lemmatize.test.sys

fpb-lemmatize.data:parsebank.fp
	python3 separate_non_omorfi_words.py $^ omorfi.hfst
	cp $^.omor $@

fpb-lemmatize.train:fpb-lemmatize.data
	tail -n +200000 $^ > fpb-lemmatize.train

fpb-lemmatize.dev:fpb-lemmatize.data
	head -200000 $^ | tail -n +100000 > fpb-lemmatize.dev

fpb-lemmatize.test:fpb-lemmatize.data
	head -100000 $^ > fpb-lemmatize.test

%.fp:%.conllu
	cat $^ | ./conll2finnpos > $@

%.model:%.config %.train %.dev
	time finnpos-train $^ $@

%.in:%
	cat $^ | ./unlemmatize > $@

%.test.sys:%.test.in %.model
	cat $< | finnpos-lemmatize $*.model > $@

%.eval:%.test.sys %.test %.model
	finnpos-eval $*.test.sys $*.test $*.model