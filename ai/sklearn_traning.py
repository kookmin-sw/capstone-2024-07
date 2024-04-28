import pandas as pd
import re
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
import random
import nltk
from nltk.corpus import wordnet

nltk.download('wordnet')
nltk.download('omw-1.4')

def augment_text(text, num_augment=2):
    words = text.split()
    augmented_texts = [text]  # 원본 텍스트도 포함

    for _ in range(num_augment):
        operation = random.choice(['synonym', 'insert', 'swap', 'delete'])
        if operation == 'synonym' and len(words) > 1:
            # 랜덤한 단어를 동의어로 교체
            word_to_replace = random.choice(words)
            synonyms = [syn.lemmas()[0].name() for syn in wordnet.synsets(word_to_replace) if syn.lemmas()]
            if synonyms:
                new_word = random.choice(synonyms)
                new_text = text.replace(word_to_replace, new_word, 1)
                augmented_texts.append(new_text)
        elif operation == 'insert' and len(words) > 1:
            # 랜덤한 위치에 랜덤 단어의 동의어 삽입
            word_to_insert = random.choice(words)
            synonyms = [syn.lemmas()[0].name() for syn in wordnet.synsets(word_to_insert) if syn.lemmas()]
            if synonyms:
                new_word = random.choice(synonyms)
                insert_position = random.randint(0, len(words))
                words.insert(insert_position, new_word)
                augmented_texts.append(' '.join(words))
        elif operation == 'swap' and len(words) > 1:
            # 두 단어의 위치를 서로 바꿈
            idx1, idx2 = random.sample(range(len(words)), 2)
            words[idx1], words[idx2] = words[idx2], words[idx1]
            augmented_texts.append(' '.join(words))
        elif operation == 'delete' and len(words) > 1:
            # 랜덤하게 한 단어를 삭제
            words.pop(random.randint(0, len(words)-1))
            augmented_texts.append(' '.join(words))

    return augmented_texts

def normalize_text(text):
    text = re.sub(r"[^\w\s]", "", text)
    text = re.sub(r"\s+", " ", text).strip().lower()
    return text

def load_and_preprocess_data(filepath):
    data = []
    with open(filepath, 'r', encoding='utf-8') as file:
        for line in file:
            text, label = line.strip().split('|', maxsplit=1)
            normalized_text = normalize_text(text)
            label = int(label)
            if label == 1:
                augmented_texts = augment_text(normalized_text)
                data.extend((aug_text, label) for aug_text in augmented_texts)
            else:
                data.append((normalized_text, label))
    return pd.DataFrame(data, columns=['text', 'label'])

df = load_and_preprocess_data('dataset.txt')

tfidf_vectorizer = TfidfVectorizer(analyzer='char', ngram_range=(1,3), max_features=1000)
X = tfidf_vectorizer.fit_transform(df['text']).toarray()
y = df['label']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

param_grid = {
    'C': [0.01, 0.1, 1, 10, 100],
    'max_iter': [100, 500, 1000]
}

grid_search = GridSearchCV(LogisticRegression(), param_grid, cv=5, scoring='accuracy')
grid_search.fit(X_train, y_train)

print("Best Parameters: {}".format(grid_search.best_params_))
y_pred = grid_search.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f'Test Accuracy: {accuracy:.2f}') 

from joblib import dump
model_bundle = {
    "vectorizer": tfidf_vectorizer,
    "model": grid_search
}
dump(model_bundle, 'model.joblib')
