local embedding_dim = 768;
local hidden_dim = 2;
local num_epochs = 1;
local batch_size = 2;
local learning_rate = 0.1;
local bert_path = "./pretrain_bert";

{
    dataset_reader: {
        type: "conll_2003_reader",
        token_indexers: {
            bert: {
                type: "pretrained_transformer",
                //pretrained_model: bert_path,
                //do_lowercase: false,
                model_name: bert_path,
            },
        },
    },
    train_data_path: "datasets/eng.train",
    validation_data_path: "datasets/eng.testa",
    model: {
        type: "ner_tagger",
        word_embeddings: {
            token_embedders: {
                //allow_unmatched_keys: true,
                bert: {
                    type: "pretrained_transformer",
                    //pretrained_model: bert_path,
                    model_name: bert_path,
                }
            }
        },
        encoder: {
            type: "lstm",
            input_size: embedding_dim,
            hidden_size: hidden_dim
        }
    },
    data_loader: {
        batch_sampler: {
            type: "bucket",
            batch_size: batch_size,
            sorting_keys: ['sentence'],
            // sorting_keys: [['sentence', 'num_tokens']],
        }
    },
    trainer: {
        num_epochs: num_epochs,
        optimizer: {
            type: "sgd",
            lr: learning_rate
        }
    }
}