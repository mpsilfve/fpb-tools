# fpb-tools

Training a lemmatizer
---------------------

1. Install [FinnPos](https://github.com/mpsilfve/FinnPos) and [hfst](https://github.com/hfst/hfst) (you need the hfst python interface), 
2. clone this repository and 
3. place a suitable amount (e.g 5000K first lines) of Finnish Parsebank data in a file `parsebank.conllu` directly under the main directory `fpb-tools`.

The file `parsebank.conllu` should contain > 200K lines. The first 100K line in `parsebank.conllu` will be used for testing, the next 100K lines for development and the remaining lines for training. 

When `parsebank.conllu` is in place, 

`make all` 

should build the FinnPos lemmatization model `fpb-lemmatize.model` (Using a 5000K `parsebank.conllu` file and a 1.90 GHz processor, the build took a bit over an hour and required approximately 6GB of RAM). If you only want to make the data sets, then run

`make data`

Check the file `fpb-lemmatize.test.in` to see the input format for `finnpos-lemmatize`. To lemmatize a file `foo.test.in` you can

`make foo.test.sys`

To see accuracy, you then can

`make foo.eval`

Caveats
-------

Before dividing the data in `parsebank.conllu` into train, dev and test data, all words not recognized by OMorFi are filtered out. This is done because, in the current Finnish Parsebank, there is no lemmatization for words that were not recognized by OMorFi.

Lemmas for compound words in Finnish Parsebank contain `#` characters which separate the parts of the compound. For example, the lemma of `teholuokkan` is `teho#luokka`. FinnPos does not produce these separators. The lemma of `teholuokan` given by the FinnPos lemmatizer will therefore be `teholuokka`.

For all words except proper nouns, the lemma will be in lower case. This also applies to abbreviations, acronyms and such.

Lemmatization is usually not succesful when a word has an incorrect morphological label.

Evaluation
----------

After you have built `fpb-lemmatize.model`, you can test the model on the test data file `fpb-lemmatize.test`. To do this, run `make fpb-lemmatize.test.sys`.

Then run `make fpb-lemmatize.eval` to evaluate the result.

Using a 5000K `parsebank.conllu` file, the result of the evaluation was

    finnpos-eval fpb-lemmatize.test.sys fpb-lemmatize.test fpb-lemmatize.model
    Comparing fpb-lemmatize.test.sys and fpb-lemmatize.test (gold standard).
    Label accuracy for all words: 1
    Label accuracy for IV words:  1
    Label accuracy for OOV words: 1
    Lemma accuracy for all words: 0.978966
    Lemma accuracy for IV words:  0.993677
    Lemma accuracy for OOV words: 0.785943

The label accuracy is meaningless in this case because the model only performs lemmatization. The lemmatization accuracy for words that were seen during training (IV words) is basically 100% because there's nearly a 1-to-1 mapping from labeled word forms to lemmas in the training material. For OOV words, that is word forms not seen during training, the lemmatization accuracy is substantially less, around 79%.

It should be noted that `fpb-lemmatize.test` only contains words from Finnish Parsebank which are known to OMorFi. Results on words not known to OMorFi may differ so lemmatization accuracy might be worse than 74%.

Lemmatization speed using a 1.90 GHz processor was around 35K tokens/second. Additionally, model loading took 4.92 seconds (with a 180MB lemmatization model).
