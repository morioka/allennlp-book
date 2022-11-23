# AllenNLP入門

本リポジトリはAnnanAIによる「AllenNLP入門」のソースコード置き場です。[Amazon](https://www.amazon.co.jp/dp/B08GLG39DF/ref=cm_sw_em_r_mt_dp_2pGsFbYJDFYJT)または[BOOTH](https://annan-ai.booth.pm/items/1881126)にて販売中です。

<p align="center">
  <img src="./allennlp-book-r-and-d.jpg" width="300" />
</p>

<p align="center">
  <img src="./allennlp-book.jpeg" width="300" />
</p>

## 目次

- [第1章 AllenNLPチュートリアル](./ner-model)
- [第2章 文書分類](./classifier-model)
- [第3章 Seq2Seq](./seq2seq)
- [第4章 Natural Language Inference](./nli)
- [第5章 事前学習済みBERT](./ner-model)
- [第6章 AllenNLP で日本語を扱おう](./jp-classifier-model)
- [第7章 MLflow との連携](./mlflow)

## 著者

[@altescy](https://github.com/altescy), [@kajyuuen](https://github.com/kajyuuen)

## 修正

python-3.9.7 + allennlp-2.10.0 で動作するよう修正(2022-11-23現在)

注意：とにかく動作するよう場当たり的に修正した。動作の妥当性は未確認。

```
allennlp==2.10.0
awscli==1.25.77
boto3==1.24.76
Janome==0.4.2
mlflow==1.29.0
pytest==7.1.3
```

主な変更点

- overridesアノテーションを除去する。allennlp 0.9.0ではoverridesが多用されていたが、2.10.0 では全くない
- いくつかの非互換性
  - config: word_embeddings -> word_embedeings.token_embedder
  - config: Iterator -> data_loader
  - DataReader._read() の戻り値が Iterator -> Iterable 
  - batch_samplerのsorting_keysが List[Tuple[str, str]] から List[str] に変更されている
    - https://github.com/linqian66/allennlp-0.9.0/blob/master/allennlp/data/iterators/bucket_iterator.py
- ComposedSeq2Seqでdecoer.pyを使わない。allennlp-0.9.0時点でAutoRegressiveSeqDecoderに問題があるとして自己修正されていたもの
- そのほかクラス定義が相当変更されており、設定ファイルも影響を受ける。


実行手順

```bash
pyenv install 3.9.7
pyenv virtualenv 3.9.7 allennlp-book2
pyenv shell allennlp-book2
pip isntall -r requirements.txt
```

- 第1章 AllenNLPチュートリアル
```bash
cd ner_model
cd datasets; ./download.sh; cd ..

# 学習
allennlp train -f --include-package src -s ./tmp configs/experiment.jsonnet

# 評価
allennlp predict --output-file output.json \
                 --include-package src \
                 --predictor conll_2003_predictor \
                 --use-dataset-reader \
                 --silent \
                 tmp datasets/eng.testa
```
- 第2章 文書分類
```bash
cd classifier-model
allennlp train -f --include-package src -s ./tmp configs/experiment.jsonnet
```
- 第3章 Seq2Seq
```bash
cd seq2seq
# SimpleSeq2Seq
allennlp train -s tmp configs/simple_seq2seq.jsonnet
allennlp predict --use-dataset-reader \
                 --predictor seq2seq \
                 tmp/model.tar.gz data/valid.tsv
# ComposedSeq2Seq
allennlp train --include-package decoder -s tmp configs/composed_seq2seq.jsonnet
allennlp predict --include-package decoder \
                 --use-dataset-reader \
                 --predictor seq2seq \
                 tmp/model.tar.gz data/valid.tsv
```
- 第4章 Natural Language Inference
```bash
cd nli
allennlp train -s tmp --include-package src configs/san.jsonnet
```
- 第5章 事前学習済みBERT
```bash
cd ner_model
ipython
[1]: from transformers import *
...: BERT_PATH = "./pretrain_bert"
...:
...: # 学習済みBERTのダウンロード
...: pretrained_weights = "bert-base-cased"
...: tokenizer = BertTokenizer.from_pretrained(pretrained_weights)
...: model = BertModel.from_pretrained(pretrained_weights)
...:
...: # モデルとトークナイザの保存
...: tokenizer.save_pretrained(BERT_PATH)
...: model.save_pretrained(BERT_PATH)
^Z
allennlp train -f --include-package src -s ./tmp configs/bert-experiment.jsonnet
```
- 第6章 AllenNLP で日本語を扱おう
```bash
cd jp-lassifier-model
allennlp train -f --include-package src -s ./tmp configs/experiment.jsonnet
```
- 第7章 MLflow との連携

※未確認
