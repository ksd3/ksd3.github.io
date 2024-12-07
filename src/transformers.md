# Welcome

Transformers are a type of _sequence to sequence_ model, i.e., given a sequence of characters, which may be split into words, transformers are able to convert that sequence to another sequence in a way that preserves the original sequence's 'meaning' _without using any predefined rules_. An example of a sequence-to-sequence task is text translation, such as converting the English sentence "I ate an apple" into the Italian equivalent: "Ho mangiato una mela." 

Transformers are an example of an _encoder-decoder_ architecture. Encoder-decoder architectures take input data, squeeze it into a kind of secret code (often called 'creating a latent representation'), and sometimes decode the squeezed data to perform useful tasks. An example of an encoder-decoder architecture and a task it may be used on would be using an [autoencoder](https://en.wikipedia.org/wiki/Autoencoder) to denoise images.

This page contains an implementation and demonstration of the transformer architecture **from scratch** using as few predefined libraries as possible in order to give the reader an understanding of what really goes on in each step of the process. We avoid using predefined models or implementations of algorithms as much as possible.


## Introduction

We address the following questions:

1. What is the fundamental principle of a transformer?
2. In very general terms, what does a transformer do?
3. What specific tasks do we need to do in order to implement a transformer?

### 1. What is the fundamental principle of a transformer?

The fundamental principle of a transformer is that one-hot vectors can be used to look up particular rows of a matrix, and you can exploit this to selectively extract, combine, and mask information from your input to produce better outputs[^1]. A lot of readers, especially NLP enthusiasts, may immediately have a problem with this statement. After all, we have not used the most famous term associated with a transformer (attention) while stating this fundamental principle. We also did not say anything about feature embeddings, long-range dependencies, contextual relationships, and encodings - all terms that are used when talking/reading about transformers. This is done for two reasons. First, I believe that it is extremely important to understand what exactly is going on in terms of as many elementary operations as possible. I believe that this necessarily precludes using domain-specific jargon. Second, I am tired of reading innumerable blogs[^2], code comments on GitHub[^3], and slides that fail to give you understanding[^4].

### 2. In very general terms, what does a transformer do?

A transformer takes in a _sequence_ of _elements_ (this sequence is often long), figures out how different elements in that sequence are related, then squeezes that sequence into a list of numbers that capture any inherent 'meaning'[^5]. It then takes that list of numbers and unsqueezes it into a different sequence that tries to preserve the 'meaning' of the original sequence. As shown in the welcome section, transformers can be used for language translation.

### 3. What specific tasks do we need to do in order to implement a transformer?

1. Figure out a way to split individual elements in a sequence (hereafter 'words and punctuation in a sentence') and find a way to feed them to the computer.
2. Make the computer squeeze these words into a list of numbers it can understand.
3. Make the computer unsqueeze the list of numbers into words and form sentences in another language. 

[^1]: If you angrily clicked on the footnote after reading this sentence, are you an NLP enthusiast?
[^2]: This is almost certainly me being lazy/not having any formal training in deep learning, but there _is_ an awful lot of garbage out there, and most of it from full-time machine learning engineers! If I read another variation on 'Transformers have revolutionized the field of natural language processing by leveraging the attention mechanism to embed data and make better predictions'....
[^3]: The better commented implementations of transformers from scratch that I found were created in 2024. Does this say anything about the field of machine learning?
[^4]: Slides are often combined with lectures, so I am willing to give this one a pass. They are also often meant for explaining new things to people who already have experience in the field, so it makes sense that I wouldn't understand them. Unsurprisingly: https://sites.astro.caltech.edu/%7Egeorge/ay141/mermin.pdf
[^5]: As of 2024, anyone claiming that transformers/LLMs can understand and reason like humans is pontificating.

## Preliminaries

Suppose our input language only has four words ('My', 'rabbit', 'likes', 'bananas'), and no punctuation at all. Sentences from our language could be 'rabbit likes bananas' or 'My rabbit likes bananas' or 'likes My bananas' or 'bananas rabbit My'. For the sake of sanity, let's assume that our language only has the sentence 'My rabbit likes bananas'. We want to translate this into Italian: 'Al mio coniglio piacciono le banane'. How do we feed our initial sentence to a computer?

### Tokenization

We first need to split the sentence into individual words. Because our language does not have any sort of punctuation, we can do what is called whitespace tokenization. This is the most natural way of splitting an English sentence - assume that individual words are separated by a blank space, read through the sentence, and store all characters between two whitespaces as a single word [^1].

[^1]: Obviously, this goes wrong the instant you add punctuation, have strings like 'abcdefghijklabcabcdabcdeab' as input, have more words than your input stream can handle, and so on. However, implementing byte-pair encoding would go beyond the scope of the tutorial.


```python
from typing import List #for clean function annotation

def whitespace_tokenizer(sentence: str) -> List[str]:
    """
    Function that reads a string/sentence and outputs a list of strings, where each output string is a word in that sentence. Each word is considered to be delimited by whitespaces.

    Input:
        sentence: str - assumed nonempty for explanation purposes
    Output:
        list of strings
    """
    tokenized_sentence=[] #final output, a list of words
    current_word=[] #list to store the current word

    #The technique to whitespace tokenize the sentence is to iterate through it, and store each non-whitespace character in current_word. 
    #Once a whitespace is encountered, append the contents of current_word to tokenized_sentence and clear current_word
    for i in sentence:
        if i==" ":
            if current_word:
                tokenized_sentence.append(''.join(current_word)) #append to the list of tokens
                current_word=[]#reset current_word
        else:
            current_word.append(i)
    
    #this still leaves the final word in, so add it last
    if current_word:
        tokenized_sentence.append(''.join(current_word))
    
    #delete the current word from memory explicitly (not required)
    del current_word

    return tokenized_sentence

english_sentence="My rabbit likes bananas"
print("Your list of tokens for the English sentence is:", whitespace_tokenizer(english_sentence))
english_tokenized_sentence=whitespace_tokenizer(english_sentence) #save the tokenization in a list

italian_sentence="Al mio coniglio piacciono le banane"
print("Your list of tokens for the Italian sentence is:", whitespace_tokenizer(italian_sentence))
italian_tokenized_sentence=whitespace_tokenizer(italian_sentence)
```

    Your list of tokens for the English sentence is: ['My', 'rabbit', 'likes', 'bananas']
    Your list of tokens for the Italian sentence is: ['Al', 'mio', 'coniglio', 'piacciono', 'le', 'banane']


### Feeding these words to a computer

How do we feed these words into a computer? One way of doing it would be by assigning each individual word to a real number: ['My', 'rabbit', 'likes', 'bananas'] -> ['935.88', '-28124.4483957', '3', '-2']. This is inefficient, as the amount of precision you would need to implement would increase computatational costs and storage requirements. A better way of storing a word would be to store it in a vector. Here is how we can do this. Given a vector, stored as a column matrix with $N$ rows, where $N$ is the number of words in your vocabulary, replace one of the zeros with 1 such that the position of the 1 is unique for that particular word. Then, stack those vectors side by side to form a matrix where each row and column has only one 1 and all other elements are zero. Such vectors are called 'one-hot' vectors and this is a type of encoding called **one-hot encoding**.

This is illustrated below:

'My'=$
\begin{pmatrix}
0\\
0\\
1\\
0
\end{pmatrix}
$, 'rabbit'=$
\begin{pmatrix}
0\\
1\\
0\\
0
\end{pmatrix}
$, 'likes'=$
\begin{pmatrix}
1\\
0\\
0\\
0
\end{pmatrix}
$, 'bananas'=$
\begin{pmatrix}
0\\
0\\
0\\
1
\end{pmatrix}
$, 
'My rabbit likes bananas'=
$
\begin{pmatrix}
0 & 0 & 1 & 0\\
0 & 1 & 0 & 0\\
1 & 0 & 0 & 0\\
0 & 0 & 0 & 1
\end{pmatrix}
$

Let's call the last matrix $W$, for 'word matrix'. Observe that when any one-hot encoded is multiplied with another matrix, by [the rules of matrix multiplication](https://www.dummies.com/article/academics-the-arts/math/pre-calculus/how-to-multiply-matrices-by-each-other-167710/), the column of the second matrix corresponding to the position of the 1 in the column vector is 'pulled out'[^1]. This is illustrated below:

$
\begin{pmatrix}
0 & 0 & 1 & 0
\end{pmatrix}
$
$
\begin{pmatrix}
0.2 & 0.4 & -9 & 1+i \\
29 & 12 & 45.328539 & 0 \\
2i & 32 & 2 & 32 \\
12 & 43 & 0.482 & 0.212 \\
241 & e^{\pi} & TREE(3) & -TREE(3)
\end{pmatrix}
$
$=\begin{pmatrix}
-9 \\
45.328539 \\
2 \\
0.482\\
TREE(3)
\end{pmatrix}$

If you're able to construct this second matrix, then it can potentially lead to something interesting[^2]. There are of course other ways to encode words, and for practical language tasks you take someone else's encoding and use it, but it is important to understand the core principle.

[^1]: I have transposed the column vector to make it a row vector.
[^2]: Foreshadowing



```python
import numpy as np
from typing import List, Dict, Tuple
import random

def create_concatenated_matrix_from_tokens(tokens: List[str]) -> np.ndarray:
    """
    Function that creates a concatenated one-hot encoded matrix from a tokenized sentence.
    
    Input:
        tokens: List containing tokens
    Output:
        tokenized_matrix: A 2-D one-hot encoded np.ndarray of tokens. Each row and column contains only one 1. Always square.
    """

    #The idea is to simply generate a diagonal matrix which will be one-hot encoded by definition
    #Create a dictionary to map each token to a unique index
    token_to_index={token: idx for idx, token in enumerate(tokens)} #get index-token pair from the input list
    #Initialize the matrix with zeros
    tokenized_matrix=np.zeros((len(tokens), len(tokens)), dtype=int)
    #Populate the one-hot encoded matrix
    for token in tokens:
        index=token_to_index[token]
        tokenized_matrix[index][index]=1  #Set the diagonal element to 1

    return tokenized_matrix, token_to_index #this second variable is returned to pull out a random token and corresponding vector later

english_onehot_matrix, english_token_to_index=create_concatenated_matrix_from_tokens(english_tokenized_sentence)
print("The English one-hot encoded matrix is:\n", english_onehot_matrix)

#let's pull out a random token and a one-hot encoded vector to see how it pulls out specific features
def get_random_token_and_vector(token_to_index: Dict[str, int], one_hot_matrix: np.ndarray) -> Tuple[str, np.ndarray]:
    """
    Function that pulls a random token and its corresponding one-hot vector.

    Input:
        token_to_index: Dictionary mapping tokens to their indices
        one_hot_matrix: 2D NumPy array containing one-hot vectors
    Output:
        A tuple containing the random token and its corresponding one-hot vector
    """
    #Randomly select a token
    random_token=random.choice(list(token_to_index.keys()))
    
    #Get the corresponding one-hot vector
    one_hot_vector=one_hot_matrix[token_to_index[random_token]]
    
    return random_token, one_hot_vector

random_token, corresponding_one_hot_vector=get_random_token_and_vector(english_token_to_index, english_onehot_matrix)
print("Let's pick a random token:", random_token, "\nThe corresponding one-hot vector is:", corresponding_one_hot_vector)

#generate a random matrix to demonstrate pulling out certain columns/rows
random_matrix=np.random.rand(len(english_tokenized_sentence), len(english_tokenized_sentence))
print("Multiplying an example random matrix\n", random_matrix, "\nby", random_token+"'s one-hot vector", corresponding_one_hot_vector, "\npulls out the row", np.matmul(corresponding_one_hot_vector, random_matrix), "\nand multiplying by the tranpose of that vector pulls out the column:\n", np.matmul(random_matrix, corresponding_one_hot_vector[:, np.newaxis]))
```

    The English one-hot encoded matrix is:
     [[1 0 0 0]
     [0 1 0 0]
     [0 0 1 0]
     [0 0 0 1]]
    Let's pick a random token: bananas 
    The corresponding one-hot vector is: [0 0 0 1]
    Multiplying an example random matrix
     [[0.48871169 0.52574402 0.78833029 0.7045616 ]
     [0.76188795 0.13720883 0.39406852 0.02774654]
     [0.27090269 0.35964049 0.20715361 0.3064574 ]
     [0.23701048 0.67718606 0.87441259 0.05116356]] 
    by bananas's one-hot vector [0 0 0 1] 
    pulls out the row [0.23701048 0.67718606 0.87441259 0.05116356] 
    and multiplying by the tranpose of that vector pulls out the column:
     [[0.7045616 ]
     [0.02774654]
     [0.3064574 ]
     [0.05116356]]


### Sequence prediction

An immediate application of this specific kind of matrix multiplication is as follows. Suppose we have the following sentence in our four-word language: 'My rabbit'. Our task is to predict the next word that comes after it[^1]. One easy way of doing this is by observing that we only have four options. We can construct the following four sentences:
| Next Word | Potential next (possible incomplete) sentence |
|----|----|
|My|My rabbit My|
|rabbit|My rabbit rabbit|
|likes|My rabbit likes|
|bananas|My rabbit bananas|

How do we decide what word comes next? Well, we can't decide on our own. Perhaps, to an alien whose language consists of only four words that sound exactly like English words, the sentence 'My rabbit My' would translate to English as 'I am in need of two oranges and a deck of playing cards.' The sentence 'My rabbit rabbit' would translate to 'I am on fire'. The sentence 'My rabbit rabbit rabbit rabbit bananas bananas rabbit bananas My likes likes bananas' would translate to 'Yes' (remember, I have not put any limits on the length of the sentences!). The point of these examples is to show you that there is no way for us to predict the next word unless we have some idea of what it is going to be. One way to solve this problem is for a third party (say a talking dog) to step in and say, "I've been around these aliens, and I've observed that whenever they begin a sentence with 'My rabbit', the next word is 'bananas' 10% of the time, 'likes' 85% of the time, 'rabbit' 5% of the time, but 'My' never comes after 'rabbit'. Is there some way for you to use this information? Also, whatever I say is always true."

Since we have no better option, let's trust the talking dog. We can in fact use its information in the following way. We can construct the following vector that shows the probability of predicting the next word after 'rabbit', if spoken by an alien. 

$
\
\begin{aligned}
&\text{bananas}\\
&\text{likes}\\
&\text{rabbit}\\
&\text{My}\\
\end{aligned}
\quad
\begin{bmatrix}
0.1 \\ 0.85 \\ 0.05 \\ 0
\end{bmatrix}
\
$

This is somewhat useful. We know that there is a high chance that the next word in the sentence will be 'likes', so the possible incomplete sentence will now probably be 'My rabbit likes'. But wait a minute. This vector of probabilities is like the column we pulled out of the matrix above. Is it possible to reconstruct this matrix? We can certainly do so - just assume that the dog is always true and start interrogating the dog about the probabilities of the next word _after_ each word in the language, _regardless of the context_. Let's assume the dog is happy to tell us this, so we now have the following matrix:

$
\
\begin{array}{r|cccc}
\text{} & \text{bananas} & \text{likes} & \text{rabbit} & \text{My} \\
\hline
\text{bananas} & 0.1 & 0 & 0 & 0 \\
\text{likes}   & 0.9 & 0 & 0.07 & 0.03  \\
\text{rabbit}  & 0.1 & 0.85 & 0.05 & 0 \\
\text{My}      & 0.2 & 0.01 & 0.79 & 0\\
\end{array}
\
$

The matrix is read row-first, column-second i.e. the probability that the word 'likes' occurs after 'rabbit' is 0.85. 

This tells us something about how the language is constructed. We know that if we hear an alien say 'rabbit', there is a very high chance that it will say 'likes' next. If we hear it say 'likes', there is a very high chance it will say 'bananas' next. There is also a very small chance it will say 'My' after 'likes', but it will never say 'likes' after 'likes'. Therefore, **to a first order**, we can construct this matrix of probabilities that tells us what the next word in the language is going to be. In more formal terms, this is the **stochastic matrix** of a **first-order Markov chain**. It is first-order because the next word in the language only depends on the current word of the language.

But wait. Languages tend to have meaning when several words are used together. For example, in English, the word 'cold' refers to something whose molecules have a lower average kinetic energy than a reference object. However, the phrase 'cold call' means unsolicited phone calls typically made for business purposes. If you only know that the current word in the sentence is 'cold' and your probability matrix says that the word 'call' appears after 'cold' 70% of the time, you may say that the sentence 'The water is cold.' is incomplete and would complete it by saying 'The water is cold call.', which makes no sense[^2]. What do we do?

The natural approach is to say, "I know combinations of words tend to change the meaning of a phrase[^3], but I don't have any idea what constitutes a phrase in my unknown language, nor do I know if the 'meaning' of the sentence itself changes if a two words are present in adjacent positions[^4]. Let me do the same thing I did for my first-order Markov chain. Instead of asking the talking dog the probabilities of the next word after my current word, I will look at the probabilities of the next word after my current word **if another word is present in the sentence**."

Specifically, you can ask the talking dog the questions "If 'rabbit likes' is present in the sentence, what is the probability that the next word is 'bananas'? What about 'rabbit', 'My', and 'likes'? If 'My rabbit' is present, what is are the probabilities for the next word?" and construct the same matrix as we did above. Since we are looking at _every_ pair of words, the number of rows of the matrix quickly grows in size. If there are 5 words in the language, the number of two-word pairs is 20 (obtained from $ 5 \choose 2$) since the order matters. If there are 100 words, there are 4950 pairs. If there are 260,000 words (a quick Google search tells me that this is roughly the number of words in Italian) then there are 33799870000 pairs. And this is just for consecutive word pairings! If we attempt to look even further back i.e. three-word pairs, there will be even more. It is easy to see that the amount of space required to store this prediction matrix grows exponentially[^5].

$
\
\begin{array}{r|cccc}
\text{} & \text{bananas} & \text{likes} & \text{rabbit} & \text{My} \\
\hline
\text{likes bananas} & 0 & \frac{TREE(4)}{TREE(5)} & 0 & 0.02 \\
\text{My rabbit}   & 0 & 0.826 & \frac{TREE(3)}{TREE(4)} & 0.03  \\
\text{rabbit likes}  & 0.024682 & 0.5 & \frac{\pi}{10e} & 0 \\
\text{My bananas}      & 0.004 & 0 & 0.12 & 0.0018256151\\
\text{and so on..}
\end{array}
\
$

Given a sufficiently large prediction matrix containing all possible words and combinations of all possible lengths, we are able to predict the next word. Note that we have not said anything about _actually choosing the next word in this situation_, as this leads to problems. One problem is that we still do not know how to deal with cases where there is an equal chance of two words appearing after our current word. Let's ignore this for now and focus on the biggest one: We want to avoid actually constructing any such matrix. Let's try another trick. Let's say, "The next word in a sentence is easier to predict if another word appears before the current word, **but not necessarily directly before it**. It may happen sometimes, but there is no reason why it should be like this. Here is my hypothesis. I think that it is easier to predict the next word in the sentence given a probability matrix containing all possible combinations of words **where the second word is the current word**." This would look something like: 

$
\
\begin{array}{r|cccc}
\text{} & \text{bananas} & \text{likes} & \text{rabbit} & \text{My} \\
\hline
\text{likes bananas} & 0 & 0 & 0 & 0.01 \\
\text{My bananas}   & 0 & 0 & 0 & 0.03  \\
\text{rabbit bananas}  & 0.1 & 0.00000023 & \frac{e}{\pi} & 0 \\
\text{bananas bananas}      & 0.004 & 0.046826 & 0.12 & 0.5151\\
\text{and so on...}
\end{array}
\
$

This is much better to work with. Note that this is no longer a representation of a Markov chain, as we cannot simply look at the row corresponding to the current word and predict the next one. What can we do instead? We can say: "Okay, let's say that these probabilities represent how much these pairs contribute to the next word in the sequence. We call these probabilities as **votes** and to predict the next word, we can **sum over each column** and compare these sums to determine the next word." This is good, because now we are capturing **long-range/skip dependencies** in the language/sequence. Each row now represents one of many **features** that can describe our sequence at a particular point. 

This is more clearly illustrated when you have, say, only two possible sentences in the language, but the main takeaway from actually doing this task for a set vocabulary and finite amount of sentences in the language is the observation that **many elements in this probability matrix do not matter**. They can either be so small that they are practically zero, or something like 0.5, which means that the next word is equally likely to appear regardless of the sentence, so it may not matter too much. What we are really interested in are elements we can distinguish. For example, suppose that the two sentences that were possible in our language were 'My rabbit likes bananas' and 'My bananas likes rabbit'. If we had the incomplete sentence 'My rabbit likes', then we could ask the talking dog to give us this matrix, and what we would see is that the matrix has a large number of zeros but a 1 for 'bananas', enabling us to do this sum-over-columns technique to accurately predict the next word, even with a deep dependency. To be fair, this example is a bit contrived and longer sentences would illustrate the point much more easily.

This is still pretty bad. Real languages have a large number of words. Our talking dog could have only been around aliens who lived on a certain continent of the alien planet, which led to them developing their own dialect. If you think about it for just a little bit, it is easy to see that this sum-over-columns approach can end up telling us that the next word in the incomplete sentence 'Japan is east of' can be 'China', with a vote total of 2339, and 'Mongolia', with a vote total of 2340. Sure, we can still pick 'Mongolia' as the next word, but such a small difference can naturally be induced by statistical noise, unknowingly biased probability matrices, and other factors (such as us messing up the addition!). Are there ways to overcome this?

One approach is to modify the values in the columns before you sum them up, in a way that allows us to differentiate between them even more. One way to do this is to simply sum all the values and divide each value by the sum, to get a fractional representation. This is not very helpful - it preserves the same relation between the numbers in terms of scaling. Converting a column of [1,2,3] to [0.1666, 0.3334, 0.5] preserves the scaling. To overcome this, we utilize the [independence from irrelevant alternatives](https://en.wikipedia.org/wiki/Independence_of_irrelevant_alternatives) axiom of decision theory, which states that irrelevant choices should not affect the relative probability of choosing between the things you really want to choose between. In mathematical terms, this means that if you have a set of numbers $x \in X$ and you want to decide between $x_1$ and $x_2$ but $x_3...x_n$ are small values that are affecting your confidence, you can suppress $x_3...x_n$ by replacing each variable in the following way:

$x_i\rightarrow\frac{e^{x_i}}{\sum_{i=1}^{i=n}e^{x_i}}$

This is the famous **softmax** function which is more or less used to convert a probability distribution to another probability distribution[^6]. The important thing is that the softmax function suppressed irrelevant values (as $e^k \rightarrow 1$ as $k \rightarrow 0$).

However, the softmax function is also not applicable to our scenario. Suppose we did actually end up converting the votes to a probability distribution and summing them. What would it actually look like? Let's do an example below:


$
\begin{pmatrix}
0 \\ 0.5 \\ 1 \\ 0
\end{pmatrix}
\rightarrow
\begin{pmatrix}
0.15706 \\ 0.258948 \\ 0.426933 \\ 0.15706
\end{pmatrix}
$

The sum of the softmaxed vector elements is 1. This is correct, because we did just convert it to a probability distribution. So this approach, while it did 'suppress' the smaller values, does not actually help us with voting. What can we do?

"Okay," we say. "Let's do something else. Instead of attempting to modify every value, let's just discard the values that aren't important[^7]. First, let's look at how to extract specific features from our matrix. We know one-hot encoded vectors pull relevant rows/columns out of the matrix, so let's make a one-hot encoded vector to pull out the relevant features in the matrix in the following way. We construct a vector initially filled with zeros featuring all possible pairs in sentence where the second word is the current word, and the first word has all other words (possibly including the current word, depending on the dimensions of our matrix). Then, if the first word appears before the current word in the sentence, set that element to 1. This vector allows us to pull out the features of our probability matrix that are 'active' until that current point."

This would look like:

$
\
\begin{aligned}
&\text{My likes}\\
&\text{rabbit likes}\\
&\text{bananas likes}\\
\end{aligned}
\quad
\begin{pmatrix}
1 \\ 1 \\ 0
\end{pmatrix}^\mathrm{T}
\
$
$
\
\begin{array}{r|cccc}
\text{} & \text{bananas} & \text{likes} & \text{rabbit} & \text{My} \\
\hline
\text{My likes} & 1 & 0 & 0 & 0 \\
\text{rabbit likes}   & 1 & 0 & 0 & 0.03  \\
\text{bananas likes}  & 1 & 0.00000023 & \frac{e}{\pi} & 0 \\
\text{and so on...}
\end{array}
\
$

Note the transpose sign. We can see that the matrix multiplication will **suppress** those elements in the pulled out feature vectors where pairs taking into account words appearing after the current word in the sequence will be suppressed i.e. we cannot use knowledge of the entire sentence to predict the next sentence. We have now 'suppressed the future', but we still need to figure out what feature elements in our sequence are important. This is still an unknown, but what we can do is use _another_ one-hot encoded vector to multiply this suppressed vector, to suppress even more. That is: we can compute the **pairwise product** to return a vector after multiplying our two vectors. Where can we get this second one-hot encoded vector? Let's assume that the talking dog gave this to us. The point is that if we manage to suppress information then our voting becomes much stronger, as a lot of elements will be 0. The trick is now to find out how to create this second vector so that we suppress irrelevant information.

Incidentally, the second form of suppression is the idea behind **attention**.


[^1]: In the sense that the next word is 'meaningful'.
[^2]: I am deliberately including punctuation here, as the same technique can be used when punctuations are treated as unique words.
[^3]: This is also partially the reason the appeal to etymology is incorrect.
[^4]: Compare 'hot', 'dog', and 'hot dog'. 
[^5]: See [Stirling's approximation](https://en.wikipedia.org/wiki/Stirling%27s_approximation)
[^6]: Foreshadowing
[^7]: Technically, this is what we have been attempting to do this entire time. 


```python
import numpy as np
from typing import List, Dict, Tuple
import random

#remember that the english sentence is "My rabbit likes bananas"
def generate_biased_probability_matrix(size: int) -> np.ndarray:
    """
    Function to generate a square probability matrix where each row and column 
    has one value significantly higher than the others.

    Input:
        size: The number of rows and columns in the square matrix
    Output:
        biased_matrix: A 2-D np.ndarray where each row and column has one high-probability value
    """
    #the technique is to generate a uniform matrix and randomly assign biased high probability values in each row and column
    biased_matrix=np.random.uniform(0.01, 0.05, (size, size))
    
    #generate high probability values for each row and column
    high_probabilities=np.random.uniform(0.7, 0.9, size=size)
    
    #ghuffle indices to randomly distribute the high probabilities across columns
    indices=np.arange(size)
    np.random.shuffle(indices)
    
    #assign one high probability per row and column
    for i in range(size):
        biased_matrix[i, indices[i]]=high_probabilities[i]
    
    #normalize each row to sum to 1
    biased_matrix=biased_matrix/biased_matrix.sum(axis=1, keepdims=True)
    
    return biased_matrix

size=4
example_probability_matrix=generate_biased_probability_matrix(size)
print("As an example, a second-order probability matrix with skip dependencies given to us by the talking dog can be this:")
print(example_probability_matrix)


def softmax(numbers: List[int])->List[int]:
    """
    Function to softmax a set of numbers
    Input:
        numbers: a list of integers
    Output:
        The list, softmaxed
    """

    exponential_list=np.exp(numbers)
    softmaxed_numbers=[np.exp(number)/sum(exponential_list) for number in numbers]
    return softmaxed_numbers


def digram_one_hot_encoding(sentence: str, tokens: List[str], index_of_word: int) -> Tuple[np.ndarray, np.ndarray]:
    """
    Generate one-hot encoding vectors for digrams based on a user-defined index.

    Input:
        sentence: Original sentence (used for context if needed).
        tokens: List of words (tokens) in the sentence.
        index_of_word: Index of the target word in the tokens list. Zero-indexed

    Output:
        A tuple containing:
            - A NumPy array of digrams (other words paired with the target word).
            - A 1D NumPy array where each element is 1 if the other word appears before the target word, 0 otherwise.
    """
    if index_of_word<0 or index_of_word>=len(tokens):
        raise ValueError("Invalid user-defined index. Must be within the range of the tokens list.")

    #extract the target word. This of course assumes that the tokenization is sequential, but for illustrative purposes, it is fine
    target_word = tokens[index_of_word]

    #generate digrams and the one-hot vector. The idea is that if the word appears before our word then set the index to 1, else 0
    digrams=[f"{token},{target_word}" for idx,token in enumerate(tokens) if idx!=index_of_word]
    one_hot_vector=np.array([1 if idx<index_of_word else 0 for idx in range(len(tokens)) if idx!=index_of_word],dtype=int)

    return np.array(digrams), one_hot_vector

print("Our sentence is:", english_sentence)

#lets take index 2 ('likes' in "My rabbit likes bananas")
index_of_word=2
incomplete_sentence=" ".join([word for index,word in enumerate(english_tokenized_sentence) if index<index_of_word+1])
print("We want an incomplete sentence. Our generation task is to predict the next word in:", incomplete_sentence)
#generate the digrams (word pairs)
digrams,digram_onehot_vector=digram_one_hot_encoding(english_sentence,english_tokenized_sentence,index_of_word)
print("Digrams:")
print(digrams)
print("One-hot vector (without any future dependency):")
print(digram_onehot_vector)

#next, we create the attention mask by hand. specifically, we generate a ones vector equal to the size of the number of words in our sentence
#then we randomly pick 2
attention_mask=np.ones((len(whitespace_tokenizer(incomplete_sentence))), dtype=int)
zero_indices = np.random.choice(len(whitespace_tokenizer(incomplete_sentence)), size=random.randrange(0,len(whitespace_tokenizer(incomplete_sentence))), replace=False)
attention_mask[zero_indices]=0
print("Example attention mask: ", attention_mask.T)

print("Attention applied to the non-future dependency capturing one-hot vector:", attention_mask*digram_onehot_vector)

```

    As an example, a second-order probability matrix with skip dependencies given to us by the talking dog can be this:
    [[0.03888508 0.03133871 0.88147493 0.04830127]
     [0.89819378 0.03108927 0.03605569 0.03466125]
     [0.02927141 0.88815681 0.02795252 0.05461926]
     [0.01763851 0.04167578 0.05967272 0.881013  ]]
    Our sentence is: My rabbit likes bananas
    We want an incomplete sentence. Our generation task is to predict the next word in: My rabbit likes
    Digrams:
    ['My,likes' 'rabbit,likes' 'bananas,likes']
    One-hot vector (without any future dependency):
    [1 1 0]
    Example attention mask:  [0 0 1]
    Attention applied to the non-future dependency capturing one-hot vector: [0 0 0]


### What attention does

We have so far our non-future dependent feature vector. We have used it so far in conjunction with the probability matrix to predict the next step. If we want to suppress the feature vector with attention, does it make sense to use _another matrix_ in the same way? Let's assume that we have a bunch of attention masks/vectors. We can stack them either vertically or horizontally (depending on how exactly we want to implement our lookup) and generate a _matrix of attention masks_. We can then send our feature vector through the attention matrix and then send the result of that product into our probability matrix to predict the next word. 


```python
def send_vector_through_two_matrices(vector: np.ndarray, probability_matrix: np.ndarray) -> np.ndarray:
    """
    Function to send an input vector through an attention matrix and then a probability matrix
    Inputs:
        vector: a 1D NumPy ndarray
    Output:
        a 1D NumPy ndarray of the same length as the input after being sent through two matrices
    """

    #the idea is to generate a 1d array of ones, replace half of the elements with 0, and shuffle and reshape it

    print("Your input vector is:\n", vector)

    total_elements=vector.shape[0]**2
    half=total_elements//2
    flat=np.ones(total_elements, dtype=int)
    flat[:half]=0
    np.random.shuffle(flat)
    example_attention_matrix=flat.reshape((vector.shape[0],vector.shape[0]))

    print("An example attention matrix is:\n", example_attention_matrix)

    result_1=np.matmul(vector, example_attention_matrix)
    print("After multiplying, you get:\n",result_1)

    print("After multiplying the result with the probability matrix, you get", np.matmul(result_1, probability_matrix))

example_probability_matrix=np.random.rand(len(digram_onehot_vector), len(digram_onehot_vector))
print("An example probability matrix is:\n", example_probability_matrix)

send_vector_through_two_matrices(digram_onehot_vector, example_probability_matrix)
```

    An example probability matrix is:
     [[0.6600921  0.31488209 0.01236613]
     [0.51302175 0.04638934 0.92027961]
     [0.38042472 0.01756476 0.29279993]]
    Your input vector is:
     [1 1 0]
    An example attention matrix is:
     [[1 1 0]
     [1 0 1]
     [0 0 1]]
    After multiplying, you get:
     [2 1 1]
    After multiplying the result with the probability matrix, you get [2.21363067 0.69371827 1.2378118 ]


### Reconstructing word pairs from encoded vectors

What do we do with the result of the attention step? Sure, we have a vector that has encoded word pairs (a second-order model), but we don't yet have a way to deconstruct that vector back into a word pair. How do we do this? So far, matrix multiplication has enabled us to encode sentences into vectors and selectively mask the irrelevant word pairs. Can we apply matrix multiplication to _decode_ a word pair? The answer is yes. Matrix multiplications are in fact what **neural networks** do. 

#### Neural Networks

Neural networks are a deep learning architecture based on the neuron-synapse structure of the human brain. Neural networks consist of a series of blocks called artificial neurons (hereafter just 'neuron') stacked vertically in layers. Each neuron has the possibility to receive an input and pass along an output to another neuron. To decide whether it passes along an output, a neuron sums up all of its inputs (which are weighted by the value of the connection along which the output travels) and applies a function, called an _activation function_, to that sum. Depending on the result of the activation function, the neuron sends an output to one or more neurons depending on how many it connects to. Mathematically, passing data through a neuron is equivalent to applying the mathematical function $f(\sum_{i=0}^{i=n} w_i x_i)$, where $f$ is the activation function, $w_i$ is the weight along an input path, and $x_i$ the actual value being sent along that input path.

Neural networks are equivalent to matrix multiplication. Why is this so? Suppose there are two layers in our neural network. The first layer has 3 neurons, and the second layer has two neurons. Let's name the latter two $n_1$ and $n_2$. Also, let's assume that each neuron in the first layer sends is connected to each neuron in the second layer. Therefore, the outputs of the first layer are $x_1,x_2,x_3$ and the weights of the paths along which they are sent are $w_{11}, w_{12}, w_{21}, w_{22}, w_{31}, w_{32}$ for each neuron-neuron path. 

The input to $n_1$ is $w_{11}x_1+w_{21}x_2+w_{31}x_3$, and the input to $n_2$ is $w_{12}x_1+w_{22}x_1+w_{32}x_3$. Writing these out in the form of a system of linear expressions:

$$w_{11}x_1+w_{21}x_2+w_{31}x_3\\w_{12}x_1+w_{22}x_1+w_{32}x_3$$

 it is easy to see that this is in fact a matrix multiplication:$WX$, where $W=\begin{pmatrix}w_{11}&w_{21}&w_{31}\\w_{21}&w_{22}&w_{32}\end{pmatrix}, X=\begin{pmatrix}x_1\\x_2\\x_3\end{pmatrix}$. Each layer also tends to have a **bias** term, so the input to a layer can be represented as the equation $WX+B$, where $B$ is the bias matrix (usually a column vector containing the same value). The activation function is applied to this resultant vector. This means that **the output of a layer of a neural network can be represented by a vector**.

 #### Properties of neural networks

 1. Neural networks are **universal function approximators**. This means that given a large-enough network with nonlinear activation functions, neural networks can model **any** mapping between elements of a domain $X$ and a codomain $Y$. However, this does NOT tell us how many neurons and layers we need or what the activation function is. 
 2. Neural networks can model nonlinear relationships between elements. While the discussion of linear decision boundaries is beyond the scope of this tutorial, it is enough to know that $f$, the activation function, is usually chosen to be something like [ReLU](https://en.wikipedia.org/wiki/Rectifier_(neural_networks)) or the [sigmoid function](https://en.wikipedia.org/wiki/Sigmoid_function).
 3. Since neural networks are just matrix multiplication, they are extremely fast to train on computers[^1]

 #### Activation functions

If the activation function is linear (such as a simple multiplier $f(x)=2x$), the neural network cannot learn linear relationships, no matter how big you make it and how long you train it for. Nonlinear activation functions are necessary to learn nonlinear relationships i.e. relationships between two variables that cannot be explained by a matrix multiplication (attention is linear!). Activation functions like ReLU and the sigmoid function are chosen not only because they are easy to compute, but because of a certain requirement explained below.

#### Training a neural network

Since each layer of a neural network can be expressed as a function $f$, a neural network can be thought of as a large composite function $f_1(W_1f_2(...f_n(W_nX_n+B_N)...+B_1)+B_0)$. Given a training set of ${(x_i,y_i)}$ pairs, the loss of the model is a _cost function_ $C(y_i,g(x_i))$ where $g(x_i)$ is the prediction of the neural network (the large composite function defined above) for the input variable $x_i$. We want to minimize this cost function, as it means our neural network has learned the relationship between the input and output variables. This is done with an algorithm called **backpropagation**. 

Backpropagation is an algorithm that utilizes the technique of gradient descent - given a cost function, we calculate its gradient with respect to the weights and biases of the neural network. According to the learning rate $a$, gradient descent updates the weights and biases of the neural network according to the rule
$$
W/B_{\text{next}}=W/B_{\text{current}}-\alpha\frac{\partial C(X,W/B_{\text{current}})}{\partial W/B}
$$

where $/$ is read as 'OR'. We _subtract_ the gradient because the gradient denotes the direction of maximum increase, so the direction of maximum decrease would be the direction opposite to it. We apply this many times (this is therefore a **greedy** algorithm) to find the local minimum of the function i.e. the values of all $W$ and all $B$ where the cost function is minimized. After each step of updating the gradients, we have to compute the prediction of the network again, in order to prepare for the next step. This is called the **forward pass** or **forward step** through the network, and must be computed repeatedly, making the process a back-and-forth.

#### Calculating backpropagation

Let us consider a neural network set up in the following way. We have **3** input neurons (that is, 3 input variables) and **1** hidden layer with 4 neurons, and **one** output neuron. For the sake of this example, assume that every neuron in one layer is connected to every neuron in the next layer and every neuron in the previous layer. Such a neural network is called a **fully-connected neural network**. 

We have already seen how matrices can represent the input to a layer. Let's represent the output of a layer by a vector after an activation function is applied to each neuron[^2]. We will now define several variables that mathematically represent each layer. For each layer $l$, we have:

$$
n_l \text{, the number of neurons in it} \\

w_l \text{, the weight matrix representing the input to the layer, of size } n_{l} \times n{l-1} \\

b_l \text{, the bias vector of the layer, of size } n_l \\

a_l \text{, the output of the layer. Specifically, this is the vector computed after applying the layer's activation function} \\

z_l \text{, the actual data sent to the next layer. Specifically, this is the vector computed after adding } a_l \text{ and } b_l \\

g_l \text{, a vector representing the actual activation function applied to the neurons of the output}
$$

We can write down some straightforward formluae after these definitions.

$$
z_l=w_la_l+b_l\\

a_l=g_l(z_l)\\
$$

The next question is choosing an appropriate cost function for our task. Let us think about our task for a moment. Since we have been using probabilities all along to predict the next word in our sequence, it is appropriate to use a cost function that tells us how good our probability prediction is. The classical cost function that is used to explain backpropagation is the **squared error function**, $(\text{real value}-\text{predicted value})^2$. This function is natural because it is simply the difference between what we predict and what the truth is, and it is squared for many reasons such as being the variance of the unbiased estimator (if used in its mean-square form) and also being easily differentiable[^3]. But we effectively want to measure the difference between a _predicted probability distribution_ and the _real probability distribution_, as we are predicting the next word in a sentence. This requires having a maximum likelihood estimate of the parameters, and when working with Bernoulli-distributed variables (such as one-hot encoded vectors) the **cross-entropy loss** function $-(yln\hat{y}+(1-y)ln(1-\hat{y}))$ minimizes the maximum likelihood estimate[^4].

Let's see how the derivative is calculated. 

$$
\frac{\partial C}{\partial w_3}=\frac{\partial C}{\partial a_3}\frac{\partial a_3}{\partial z_3}\frac{\partial z_3}{\partial w_3} \\[5pt]


\frac{\partial C}{\partial b_3}=\frac{\partial C}{\partial a_3}\frac{\partial a_3}{\partial z_3}\frac{\partial z_3}{\partial b_3}
$$

by a simple application of the [chain rule](https://en.wikipedia.org/wiki/Chain_rule). This can easily be extended by observing that $z_3$ is a function of $a_2$, which is a function of $z_2$, and $z_2$ is a function of $w_2, b_2, a_1$.

$$
\frac{\partial C}{\partial w_2}=\frac{\partial C}{\partial a_3}\frac{\partial a_3}{\partial z_3}\frac{\partial z_3}{\partial a_2}\frac{\partial a_2}{\partial z_2}\frac{\partial z_2}{\partial w_2} \\[5pt]


\frac{\partial C}{\partial b_2}=\frac{\partial C}{\partial a_3}\frac{\partial a_3}{\partial z_3}\frac{\partial z_3}{\partial a_2}\frac{\partial a_2}{\partial z_2}\frac{\partial z_2}{\partial b_2}
$$

and similarly for the first (input) layer, named layer 0. 

The next task is setting up a way to recursively calculate the derivative of the cost function for any arbitrary layer's weight and bias. The general equation for this is

$$
\frac{\partial C}{\partial w_l}=\frac{\partial C}{\partial z_l}\frac{\partial z_l}{\partial w_l}\\[5pt]
\frac{\partial C}{\partial b_l}=\frac{\partial C}{\partial z_l}\frac{\partial z_l}{\partial b_l}
$$

There are two observations we can make from this. The first is that it is straightfoward to numerically calculate the partial derivative for the last/output layer, and we can store this value in order to avoid repeated computation wherever possible. The second is that you need to calculate the change in the gradient for the last layer, then use that changed gradient for the layer before that one, and so on, 'back-propagating' the errors. 

Let's choose a nice activation function such as the sigmoid function $\sigma(x)=\frac{1}{1+e^{-x}}$ for this. Let us precompute the partial derivative of the output layer, since we'll be needing it. Note that $\odot$ denotes the Hadamard, or element-wise product.

$$
\frac{\partial C}{\partial z_o}=\frac{\partial C}{\partial a_o}\frac{\partial a_o}{\partial z_o}=\frac{\partial C}{\partial a_o} \odot \sigma'(z_o) \\[5pt]

\frac{\partial C}{\partial a_o}=-(\frac{y}{a_o}-\frac{1-y}{1-a_l}) \\[5pt]

\sigma'(z_o)=a_l(1-a_l) \\[5pt]

\text{therefore for }y\text{ being the output vector,} \\[5pt]

\frac{\partial C}{\partial z_o}=a_o-y
$$

This is a very nice result. It is now easy to see that for any inner layer, we can repeatedly apply the chain rule to derive the partial derivatives. If you go about doing this you end up with the following results:

$$
\frac{\partial C}{\partial z_l}=w_{l+1}^T\frac{\partial C}{\partial z_{l+1}} \odot \sigma '(z_l) \\[5pt]

\frac{\partial z_l}{\partial w_l}=a_{l-1} \\[5pt]

\frac{\partial C}{\partial z_l}a_{l-1}^T \\[5pt]

\frac{\partial z_l}{\partial b_l}=1 \\[5pt]

\frac{\partial C_l}{\partial b_l}=\frac{\partial C}{\partial z_l}
$$

A more complete derivation can be found [here](https://towardsdatascience.com/deriving-backpropagation-with-cross-entropy-loss-d24811edeaf9)[^5], but the fundamental idea is the same.

We can now implement this in Python and train the neural network from scratch.


 [^1]: More on this later
 [^2]: For this reason, layers tend to have the same activation function, as it is easy to parallelize the computation
 [^3]: Making automatic differentiation easier led to the invention of many fundamental inventions in empirical learning 
 [^4]: https://sacred-texts.com/hin/m01/m01002.htm, 'I am (continued Sauti)...'


```python
"""
Neural Network Implementation in NumPy
Inputs:
    None
Outputs:
    Fully functional neural network trained on synthetic data
"""

import numpy as np

def sigmoid(x: np.ndarray) -> np.ndarray:
    """
    Apply the sigmoid activation function element-wise
    Inputs:
        x: a NumPy ndarray, the input array
    Outputs:
        a NumPy ndarray with sigmoid applied element-wise
    """
    return 1/(1+np.exp(-x))#sigmoid formula

def sigmoid_prime(x: np.ndarray) -> np.ndarray:
    """
    Compute the derivative of the sigmoid function element-wise
    Inputs:
        x: a NumPy ndarray, the input array
    Outputs:
        a NumPy ndarray with the derivative of sigmoid applied element-wise
    """
    return sigmoid(x)*(1.0-sigmoid(x))#sigmoid derivative formula

class NeuralNetwork:
    """
    Define a simple feedforward neural network
    """

    def __init__(self,architecture: np.ndarray):
        """
        initializer for the neural network class
        Inputs:
            architecture: a NumPy array representing the number of neurons in each layer
        """
        self.L=architecture.size-1#number of layers (excluding input layer)
        self.n=architecture#number of neurons in each layer
        self.parameters={}#dictionary to store weights, biases, and activations

        #initialize weights and biases for each layer
        for i in range(1,self.L+1):
            self.parameters['W'+str(i)]=np.random.randn(self.n[i],self.n[i-1])*0.01#small random weights
            self.parameters['b'+str(i)]=np.ones((self.n[i],1))#biases initialized to 1
            self.parameters['z'+str(i)]=np.ones((self.n[i],1))#pre-activation values initialized to 1
            self.parameters['a'+str(i)]=np.ones((self.n[i],1))#activations initialized to 1
        
        self.parameters['a0']=np.ones((self.n[0],1))#input layer activation
        self.parameters['C']=1#placeholder for cost value
        self.derivatives={}#dictionary to store derivatives

    def forward_propagate(self,X: np.ndarray):
        """
        Perform forward propagation
        Inputs:
            X: a column vector representing one training example
        Outputs:
            None
        """
        self.parameters['a0']=X#set input layer activation
        for l in range(1,self.L+1):
            self.parameters['z'+str(l)]=np.dot(self.parameters['W'+str(l)],self.parameters['a'+str(l-1)])+self.parameters['b'+str(l)]#W*a+b
            self.parameters['a'+str(l)]=sigmoid(self.parameters['z'+str(l)])#apply sigmoid activation

    def compute_cost(self,y: np.ndarray):
        """
        function to compute the cost for one training example
        Inputs:
            y: the true label for the input sample
        Outputs:
            None
        """
        self.parameters['C']=-(y*np.log(self.parameters['a'+str(self.L)])+(1-y)*np.log(1-self.parameters['a'+str(self.L)]))#binary cross-entropy loss

    def compute_derivatives(self,y: np.ndarray):
        """
        function to compute gradients for all parameters
        Inputs:
            y: the true label for the input sample
        Outputs:
            None
        """
        self.derivatives['dz'+str(self.L)]=self.parameters['a'+str(self.L)]-y#last layer gradient
        self.derivatives['dW'+str(self.L)]=np.dot(self.derivatives['dz'+str(self.L)],self.parameters['a'+str(self.L-1)].T)#last layer weights gradient
        self.derivatives['db'+str(self.L)]=self.derivatives['dz'+str(self.L)]#last layer bias gradient

        for l in range(self.L-1,0,-1):
            self.derivatives['dz'+str(l)]=np.dot(self.parameters['W'+str(l+1)].T,self.derivatives['dz'+str(l+1)])*sigmoid_prime(self.parameters['z'+str(l)])#hidden layer gradient
            self.derivatives['dW'+str(l)]=np.dot(self.derivatives['dz'+str(l)],self.parameters['a'+str(l-1)].T)#hidden layer weights gradient
            self.derivatives['db'+str(l)]=self.derivatives['dz'+str(l)]#hidden layer bias gradient

    def update_parameters(self,alpha: float):
        """
        function to update network parameters using gradient descent
        Inputs:
            alpha: learning rate
        Outputs:
            None
        """
        for l in range(1,self.L+1):
            self.parameters['W'+str(l)]-=alpha*self.derivatives['dW'+str(l)]#update weights
            self.parameters['b'+str(l)]-=alpha*self.derivatives['db'+str(l)]#update biases

    def predict(self,x: np.ndarray) -> np.ndarray:
        """
        function to predict the output for a given input
        Inputs:
            x: a column vector representing one input sample
        Outputs:
            a NumPy array representing the predicted output
        """
        self.forward_propagate(x)#perform forward propagation
        return self.parameters['a'+str(self.L)]#return output layer activation

    def fit(self,X: np.ndarray,Y: np.ndarray,num_iter: int,alpha: float=0.01):
        """
        function to train the neural network
        Inputs:
            X: a NumPy array where each row is a training example
            Y: a NumPy array of true labels
            num_iter: number of iterations
            alpha: learning rate
        Outputs:
            None
        """
        for iter in range(num_iter):
            c=0#cumulative cost
            n_c=0#correct predictions count

            for i in range(X.shape[0]):
                x=X[i].reshape((X[i].size,1))#reshape input to column vector
                y=Y[i]#true label
                self.forward_propagate(x)#forward propagation
                self.compute_cost(y)#compute cost
                self.compute_derivatives(y)#compute gradients
                self.update_parameters(alpha)#update parameters
                c+=self.parameters['C']#accumulate cost
                y_pred=self.predict(x)#make prediction
                y_pred=(y_pred>0.5)#convert probability to binary
                if y_pred==y:
                    n_c+=1#correct prediction count

            c=c/X.shape[0]#average cost
            print('Iteration:',iter)
            print("Cost:",c)
            print("Accuracy:",(n_c/X.shape[0])*100)

#generate synthetic data
np.random.seed(42)#reproducibility
X=np.random.rand(200,7)#200 samples, 7 features
y=(np.sum(X,axis=1)>3.5).astype(int).reshape(200,1)#labels based on sum of features

#split data into training and testing sets
split_ratio=0.7#70% training data
split_index=int(X.shape[0]*split_ratio)
indices=np.arange(X.shape[0])
np.random.shuffle(indices)

X_train,X_test=X[indices[:split_index]],X[indices[split_index:]]
y_train,y_test=y[indices[:split_index]],y[indices[split_index:]]

#define architecture
architecture=np.array([7,5,1])#7 input features, 5 hidden neurons, 1 output

#initialize and train the neural network
nn=NeuralNetwork(architecture)
nn.fit(X_train,y_train,num_iter=50,alpha=0.1)

#evaluate the model
correct_predictions=0
for i in range(X_test.shape[0]):
    x=X_test[i].reshape((X_test[i].size,1))#reshape to column vector
    y_true=y_test[i]#true label
    y_pred=nn.predict(x)#prediction
    y_pred=(y_pred>0.5).astype(int)#convert to binary
    if y_pred==y_true:
        correct_predictions+=1#count correct predictions

#calculate test accuracy
test_accuracy=(correct_predictions/X_test.shape[0])*100
print("Test Accuracy:",test_accuracy)
```

    Iteration: 0
    Cost: [[0.72566273]]
    Accuracy: 64.28571428571429
    Iteration: 1
    Cost: [[0.71523798]]
    Accuracy: 66.42857142857143
    Iteration: 2
    Cost: [[0.70509586]]
    Accuracy: 66.42857142857143
    Iteration: 3
    Cost: [[0.6864599]]
    Accuracy: 67.85714285714286
    Iteration: 4
    Cost: [[0.65347682]]
    Accuracy: 75.71428571428571
    Iteration: 5
    Cost: [[0.60664836]]
    Accuracy: 82.14285714285714
    Iteration: 6
    Cost: [[0.55558826]]
    Accuracy: 91.42857142857143
    Iteration: 7
    Cost: [[0.5072171]]
    Accuracy: 93.57142857142857
    Iteration: 8
    Cost: [[0.46296521]]
    Accuracy: 95.0
    Iteration: 9
    Cost: [[0.42292781]]
    Accuracy: 96.42857142857143
    Iteration: 10
    Cost: [[0.38716204]]
    Accuracy: 97.85714285714285
    Iteration: 11
    Cost: [[0.35557885]]
    Accuracy: 97.85714285714285
    Iteration: 12
    Cost: [[0.32788988]]
    Accuracy: 97.85714285714285
    Iteration: 13
    Cost: [[0.30368962]]
    Accuracy: 97.85714285714285
    Iteration: 14
    Cost: [[0.28254309]]
    Accuracy: 97.85714285714285
    Iteration: 15
    Cost: [[0.26403564]]
    Accuracy: 97.85714285714285
    Iteration: 16
    Cost: [[0.24779326]]
    Accuracy: 97.85714285714285
    Iteration: 17
    Cost: [[0.23348834]]
    Accuracy: 98.57142857142858
    Iteration: 18
    Cost: [[0.22083889]]
    Accuracy: 98.57142857142858
    Iteration: 19
    Cost: [[0.20960497]]
    Accuracy: 98.57142857142858
    Iteration: 20
    Cost: [[0.19958386]]
    Accuracy: 98.57142857142858
    Iteration: 21
    Cost: [[0.190605]]
    Accuracy: 98.57142857142858
    Iteration: 22
    Cost: [[0.18252507]]
    Accuracy: 98.57142857142858
    Iteration: 23
    Cost: [[0.17522359]]
    Accuracy: 98.57142857142858
    Iteration: 24
    Cost: [[0.16859908]]
    Accuracy: 98.57142857142858
    Iteration: 25
    Cost: [[0.16256584]]
    Accuracy: 98.57142857142858
    Iteration: 26
    Cost: [[0.15705123]]
    Accuracy: 98.57142857142858
    Iteration: 27
    Cost: [[0.15199344]]
    Accuracy: 98.57142857142858
    Iteration: 28
    Cost: [[0.14733967]]
    Accuracy: 98.57142857142858
    Iteration: 29
    Cost: [[0.14304459]]
    Accuracy: 98.57142857142858
    Iteration: 30
    Cost: [[0.13906911]]
    Accuracy: 98.57142857142858
    Iteration: 31
    Cost: [[0.13537942]]
    Accuracy: 98.57142857142858
    Iteration: 32
    Cost: [[0.1319461]]
    Accuracy: 98.57142857142858
    Iteration: 33
    Cost: [[0.12874349]]
    Accuracy: 98.57142857142858
    Iteration: 34
    Cost: [[0.12574908]]
    Accuracy: 98.57142857142858
    Iteration: 35
    Cost: [[0.12294312]]
    Accuracy: 99.28571428571429
    Iteration: 36
    Cost: [[0.12030816]]
    Accuracy: 99.28571428571429
    Iteration: 37
    Cost: [[0.11782877]]
    Accuracy: 99.28571428571429
    Iteration: 38
    Cost: [[0.11549126]]
    Accuracy: 99.28571428571429
    Iteration: 39
    Cost: [[0.11328345]]
    Accuracy: 100.0
    Iteration: 40
    Cost: [[0.11119447]]
    Accuracy: 100.0
    Iteration: 41
    Cost: [[0.1092146]]
    Accuracy: 100.0
    Iteration: 42
    Cost: [[0.10733513]]
    Accuracy: 100.0
    Iteration: 43
    Cost: [[0.10554823]]
    Accuracy: 100.0
    Iteration: 44
    Cost: [[0.10384686]]
    Accuracy: 100.0
    Iteration: 45
    Cost: [[0.10222465]]
    Accuracy: 100.0
    Iteration: 46
    Cost: [[0.10067586]]
    Accuracy: 100.0
    Iteration: 47
    Cost: [[0.09919528]]
    Accuracy: 100.0
    Iteration: 48
    Cost: [[0.09777818]]
    Accuracy: 100.0
    Iteration: 49
    Cost: [[0.09642027]]
    Accuracy: 100.0
    Test Accuracy: 93.33333333333333


Here's a neat observation. If a neural network is simple a two-layer network with non-linear activation, _it is simply a matrix multiplication to new inputs_. Therefore, we now have a way to **learn** that second-order probability matrix!

Given a neural network which can learn vector-vector relationships, it is easy to see that we can reconstruct our word-pair combinations from a vector that is the result of an attention step. Suppose we have a vector corresponding to the words 'My', 'rabbit', and 'likes', $\begin{pmatrix}1\\1\\1 \end{pmatrix}$, the result of making it non-future-dependent is $\begin{pmatrix}1\\1\\0 \end{pmatrix}$, and our attention step results in $\begin{pmatrix}1\\0\\0 \end{pmatrix}$. We now pass this as _input_ to a neural network and compute the output. The output will simply map our input vector to an output vector. The insight is that you can train the network to accurately map the result of our attention step to word pairs! The next obvious question is how to generate these word pairs. But before that, we need to notice that our neural network gets trained quickly when the input-output training sets have a small number of elements. It quickly becomes unwieldy when you think about practical languages, like the 260,000 Italian words mentioned above. This moves us on to our next topic, **embeddings**.

### Embeddings

To make our neural network work well, we need a large amount of input-output data. This is impractical at the scale of even small, real languages - there are simply too many words. Generating one-hot encoding matrices by vertically stacking the vectors, even with techniques to store sparse matrices, is still impractical once we think about storing word pairs and triplets. We need some way to reduce these one-hot matrices in size so storing them becomes more efficient. This is the same problem we tried to solve with neural networks: converting an input vector into another vector. In our case, we want to convert a large vector to a smaller vector such that enough information is retained. This smaller vector will be called the **embedding** vector.

Based on all that we've seen so far, it is obvious that this conversion will be done with matrix multiplication. The question is how to make this new matrix. We can do the same thing we did before (training a neural network) or we can do something completely different. Here is an example. Suppose we want to embed 'My', 'rabbit', 'likes', and 'bananas' into 2 dimensions. We know that their one-hot encoding is an identity matrix, possibly with its columns shuffled. We can arbitrarily define a $4 \times 2$ matrix that will project this matrix into a smaller matrix. We can then say that column 1 (representing, say, 'rabbit') of the initial matrix is now replaced by column 1 of the new matrix. This is perfectly fine. But is this meaningful?

What do we want from a 'good' embedding? Broadly, a good embedding should be useful for practical tasks. There is no use in embedding words and making the transformer's neural network harder to train. We might want to apply clustering algorithms to word embeddings to find out, for example, how many nouns there are in a large _corpus_ (plural _corpora_) of text. We might also want to know what words are related in an unknown language. For someone trying to embed English, making sure that the embeddings for 'rabbit' and 'hare' are closer(i.e. their difference is closer to $\vec{0}$) than the embeddings for 'rabbit' and 'desk' is important if training a model to explain what it says in pictures of lagomorphs in office environments. Embeddings should probably also capture **context awareness** - 'hot dog' must have a different embedding compared to both 'hot' and 'dog'. They should also not be too low-dimensional; we might lose important information. 

It is beyond the scope of this tutorial to discuss good embedding algorithms. Fortunately, there is a straightforward algorithm we can use to embed our four-word language. Let's map them on the unit circle with a randomly generated matrix, as we have been doing so far.


```python
import numpy as np
import matplotlib.pyplot as plt

#define words
words=['My','rabbit','likes','bananas']

#ensure that the words are sufficiently apart for better visibility-say 30 degrees
angles=np.sort(np.random.choice(np.linspace(0,2*np.pi,360,endpoint=False),len(words),replace=False))

#compute unit circle coordinates
unit_circle_vectors=np.array([[np.cos(angle),np.sin(angle)] for angle in angles])

#define initial one-hot vectors
one_hot_vectors=np.eye(len(words), dtype=int)

#plot embeddings
plt.figure(figsize=(6,6))
for i,word in enumerate(words):
    x,y=unit_circle_vectors[i]
    plt.scatter(x,y,label=word)
    plt.text(x+0.05,y+0.05,word,fontsize=12)
    #draw the arrow
    plt.arrow(0,0,x,y,head_width=0.05,head_length=0.1,fc='blue',ec='red',alpha=0.7)

# Draw the unit circle
theta=np.linspace(0,2*np.pi,100)
circle_x=np.cos(theta)
circle_y=np.sin(theta)
plt.plot(circle_x,circle_y,color='gray',linestyle='--')

plt.title("2D Embedding of a 4-Word Language on Unit Circle")
plt.xlabel("X-axis")
plt.ylabel("Y-axis")
plt.axhline(0,color='gray',linewidth=0.5)
plt.axvline(0,color='gray',linewidth=0.5)
plt.grid(True)
plt.legend()
plt.axis('equal')
plt.show()

# Print initial one-hot vectors and unit circle embeddings
print("Initial One-Hot Vectors:")
for i,word in enumerate(words):
    print(f"{word}:{one_hot_vectors[i]}")

print("\nEmbedded Vectors on Unit Circle:")
for i,word in enumerate(words):
    print(f"{word}:{unit_circle_vectors[i]}")

```


    
![png](images/transformers_13_0.png)
    


    Initial One-Hot Vectors:
    My:[1 0 0 0]
    rabbit:[0 1 0 0]
    likes:[0 0 1 0]
    bananas:[0 0 0 1]
    
    Embedded Vectors on Unit Circle:
    My:[0.9961947  0.08715574]
    rabbit:[-0.54463904 -0.83867057]
    likes:[ 0.60181502 -0.79863551]
    bananas:[ 0.99254615 -0.12186934]


#### Giving important to the position of words in a sentence while embedding text

Let's think a bit about our two-word non-future-dependent vectors. The only condition we have applied so far is that the value in the column matrix row wherever a word appears ahead of our current word should be 0. If a word appeared 1364 places before our current word but its value was deemed 'important' by attention, its corresponding row value would be 1. This is impractical. We know that it is unlikely that a word appearing 1364 places before the current word affects it. How can we quantify this?

The solution is to do it heuristically. Let's figure out what exactly the task is. We have to add some additional information in a word's embedding that denotes the position of the word in a sentence. This additional information is called the **positional encoding**. We want to satisfy a few criteria:

1. The encoding must be unique for each word in the sequence even if that word appears again. The sentence 'My rabbit likes bananas but my friend's rabbit doesn't.' should have different encoding values for the first and second occurrences of 'rabbit'.
2. If we have to add positional encoding to sentences of different lengths, the 'distance' between two pieces of information should remain constant. This means that 'My rabbit likes bananas. My friend's rabbit does not like bananas.' should encode the first and second occurrences of 'rabbit' in a way that the difference between the additional information added should be the same as the difference between 'likes' and 'does'. This ensures that the two sentences are recognized as part of a 'speech'.
3. We should be able to generalize to any sentence length easily with _bounded_ and _deterministic_ values (i.e. do not train a neural network).

Essentially, we need to find a function whose codomain is a vector of the same size of the embedding that is:

1. Easy to compute
2. Periodic
3. Has bounded values.

and iterate through the sentence, computing the function at the index of every word. To add the information to the word embedding, we can literally add the two vectors. This encodes positional information in the embedding.

A function that satisfies these criteria is $f: \mathbb{N} \rightarrow \mathbb{R}^d$

$$
\
f_i(t) = 
\begin{cases} 
\sin(\omega_k \cdot t), & \text{if } i = 2k \\ 
\cos(\omega_k \cdot t), & \text{if } i = 2k + 1 
\end{cases}
\
$$

where $d$ is the number of rows in the column vector representation of the embedding vector, $i$ and $k$ are simply ways to denote even and odd positions (i.e. the first row of the encoding vector is a sine, the second row is a cosine, the third row is a sine, and so on) and $w=\frac{1}{10000^{\frac{2k}{d}}}$. $w$ has been chosen completely by guesswork. $t$ simply denotes the row number. Another good property is that since the encoding are periodic functions, you have also put in some information saying 'the encoding of a word $m$ places away from the current word is so-and-so'. Their periodicity implies that they can be represented as a linear combination of earlier encodings. I want to reiterate that this is a heuristic that works and theoretical justifications for this do not really exist. It works because you have differentiated between sentences such as 'I just computed five times three plus two' and 'I just computed five plus three times two' which have different underlying meanings.

#### Converting embeddings back into words

We finally discuss actually choosing the next word in the sequence. Suppose that have taken a sentence, tokenized it, converted to one-hot encoding, embedded these encodings, added position embeddings, and then trained a neural network to predict an output vector. The final step is to convert this output vector, _which is also an embedding_, back into a vector that represents the target vocabulary. We do not want to convert it back into a one-hot vector. How will you choose the next word? 

Let's do what is straightforward - multiply it with a matrix. This time, we are taking a smaller vector and making it a larger one. This comes with some caveats. We are making a column matrix bigger. If we want to make $\begin{pmatrix}1\\2\\3\end{pmatrix}$ bigger, say to twice its size, how can we do it? Should we do $\begin{pmatrix}1\\0\\2\\0\\3\\0\end{pmatrix}$, $\begin{pmatrix}0\\1\\2\\0\\3\\0\end{pmatrix}$, or $\begin{pmatrix}0\\0\\1\\0\\2\\3\end{pmatrix}$? We can set up a matrix to do any one of these transformations, but we cannot set up a matrix that does this for all possible input vectors. This is because you will be solving an overdetermined system of equations. We have no choice but to accept this, so we have to assume that even if we find a matrix that makes the values as close to zero as possible, they will never all be 0 for any practical case. Going back to our initial task (English to Italian), we will end up with a vector that looks something like this

$
\
\begin{aligned}
&\text{Dios}\\
&\text{mio}\\
&\text{mangiato}\\
&\text{una}\\
&\text{and so on...}
\end{aligned}
\quad
\begin{bmatrix}
0.1 \\ 0.00005 \\ 0.25 \\ 0 \\ \text{...}
\end{bmatrix}
\
$

How do we select the next word? We can certainly pick the one with the largest value, but this is not so good. Fortunately, we have _already_ looked at a way to emphasize the right word - softmaxing! Softmaxing and picking the highest probability allows us to enhance the probability of the right word (and it will be high because we train the neural network in this way - remember that matrix multiplications are just two-layer neural networks) being picked. An added bonus is that the softmax function is differentiable.


```python
import numpy as np

#define words
words=['My','rabbit','likes','bananas']  #ensure vocabulary is 4 words long

print("Tokenized sentence:", words)

#ensure that the words are sufficiently apart for better visibility-say 30 degrees
angles=np.sort(np.random.choice(np.linspace(0,2*np.pi,360,endpoint=False),len(words),replace=False))

#compute unit circle coordinates (2D embeddings)
embedding_dim=2  #set embedding dimension to 2
unit_circle_vectors=np.array([[np.cos(angle),np.sin(angle)] for angle in angles])

#define initial one-hot vectors
one_hot_vectors=np.eye(len(words),dtype=int)

#function for positional encoding as defined in "Attention is all you need"
def positional_encoding(seq_len,d_model):
    #initialize positional encoding matrix
    pos_enc=np.zeros((seq_len,d_model))
    for pos in range(seq_len):
        for i in range(0,d_model,2):
            pos_enc[pos,i]=np.sin(pos/(10000**(2*i/d_model)))
            if i+1<d_model:  #check to prevent index out of range
                pos_enc[pos,i+1]=np.cos(pos/(10000**(2*i/d_model)))
    return pos_enc

#calculate positional encodings for the sentence
seq_len=len(words)
positional_encodings=positional_encoding(seq_len,embedding_dim)

#calculate the sum of position encoding and embedding vectors
combined_vectors=unit_circle_vectors+positional_encodings

#decoder matrix to map combined vectors back to one-hot-like representations
decoder_matrix=np.linalg.pinv(unit_circle_vectors)  #pseudo-inverse to decode

#decode the combined vectors
decoded_vectors=np.dot(combined_vectors,decoder_matrix)

#map decoded vectors to words by finding the closest match
def decode_to_words(decoded_vectors,word_embeddings,word_list):
    result=[]
    for vec in decoded_vectors:
        #project vec back into the original embedding space
        reconstructed_vec=np.dot(vec,word_embeddings)
        #compute distances and find the closest match
        distances=np.linalg.norm(word_embeddings-reconstructed_vec,axis=1)
        closest_word_index=np.argmin(distances)
        result.append(word_list[closest_word_index])
    return result

decoded_words=decode_to_words(decoded_vectors,unit_circle_vectors,words)

#print initial one-hot vectors
print("Initial One-Hot Vectors:")
for i,word in enumerate(words):
    print(f"{word}:{one_hot_vectors[i]}")

#print embedded vectors on unit circle
print("\nEmbedded Vectors on Unit Circle:")
for i,word in enumerate(words):
    print(f"{word}:{unit_circle_vectors[i]}")

#print positional encodings
print("\nPositional Encodings:")
for i,word in enumerate(words):
    print(f"{word}:{positional_encodings[i]}")

#print combined vectors
print("\nCombined Vectors (Embedding+Positional Encoding):")
for i,word in enumerate(words):
    print(f"{word}:{combined_vectors[i]}")

#print decoded words
print("\nDecoded tokenized sentence from Combined Vectors:")
print(decoded_words)


```

    Tokenized sentence: ['My', 'rabbit', 'likes', 'bananas']
    Initial One-Hot Vectors:
    My:[1 0 0 0]
    rabbit:[0 1 0 0]
    likes:[0 0 1 0]
    bananas:[0 0 0 1]
    
    Embedded Vectors on Unit Circle:
    My:[0.1391731  0.99026807]
    rabbit:[-0.5591929  -0.82903757]
    likes:[-0.34202014 -0.93969262]
    bananas:[ 0.89100652 -0.4539905 ]
    
    Positional Encodings:
    My:[0. 1.]
    rabbit:[0.84147098 0.54030231]
    likes:[ 0.90929743 -0.41614684]
    bananas:[ 0.14112001 -0.9899925 ]
    
    Combined Vectors (Embedding+Positional Encoding):
    My:[0.1391731  1.99026807]
    rabbit:[ 0.28227808 -0.28873527]
    likes:[ 0.56727728 -1.35583946]
    bananas:[ 1.03212653 -1.443983  ]
    
    Decoded tokenized sentence from Combined Vectors:
    ['My', 'bananas', 'bananas', 'bananas']


### Attention

We have technically made an encoder-decoder model at this point. As you can see in the code above, even without attention, it is somewhat difficult to get consistent sequence reconstruction. Let's think about attention again. So far, we have simply made an attention matrix and used it to suppress unimportant parts of the code. Our attention matrix was created by stacking one-hot encoded vectors on top of each other. This doesn't make much sense. Some parts of a sentence may be important - maybe not as important as other parts - but important nonetheless. Multiplication with an attention matrix should result in a vector with parts that are suppressed but not necessarily zero. We can give importance to different parts by making our attention matrix elements fractions instead of ones and zeros. 

We have so far not defined precisely what attention does. We have so far said that given a matrix of attention masks, we can pull out specific rows given our one-hot encoded non-future-dependent vectors, and suppress things even more. Now we focus on the big question. How do we generate this attention matrix? We're in a completely different domain now - our words are no longer one-hot encoded, they're embeddings, we're adding positional information to them, and now we want to suppress irrelevant information.

Let's get an intuitive explanation of attention first. We can naturally ask whether the attention in machine learning is the same as attention in human beings. What does this mean? For example, our brain is flooded with many different sensory inputs every second. There's the internal sensory information from the body (such as level of hunger, blood pressure, pain, our balance), and there's external sensory information from the environment (such as me hearing the distant hum of cars outside the window while typing this, but choosing to ignore it). How do we not get overwhelmed? We 'tune out' (suppress) irrelevant information and only focus on the one that matters. Only a small subset of the sensory input data is considered _relevant_ enough to be perceived - this is what we mean when we say we are paying attention to something. 

Simply put, we are assigning importance to items by filtering out the irrelevant ones. We also have a finite amount of attention. For example, watching a group of ants move around is significantly easier than tracking the path of more than a few ants in that group. You can either have a general idea of how the group is moving, or a specific idea of how some finite amount of ants in that group are moving, **but not both**. 

We can specify this mathematically: Given a set of input items $i_1,i_2,...i_n$, we assign nonzero weights to them, $w_1,w_2,...,w_n$ such that $\sum_{k=0}^{n}w_k=1$. Interpreting the weights as importances, they satisfy the two properties of human attention. We can than make a judgment about the items based on this attention. Since our inputs to the attention matrix are a collection of items (embedded word vectors), we can then assign a weight to them. 

Where do these weights come from? This is where the learning in machine learning happens. We want to _learn_ a function $f$ to _compute_ these weights. This function is typically one that **first computes** some 'relevance' score for each word in the sequence **and then** softmaxes the weights in order to make the weights nonzero. We have already computed this relevance score. This is simply the sum of the embedding vector and positional encoding vector. What do we do now?

So far we have talked about second-order models. Throughout the tutorial, we have constructed our one-hot encoded vectors assuming second-order relationships in the past. We briefly said that we could extend the word-pair vector construction to word triplets, but as the discussion so far should show, this is very impractical. We now try to answer the question: **How important is every word to every other word in the sentence, and it is possible to calculate this in one go?** Positional encodings don't really answer this question, as they show how 'relevant' each word is in the overall sentence, but not in relation to the actual other words. We have to figure out three main things:

1. How do you tell a word to 'ask' other words in the sentence the following question: 'How important are you to me?'?
2. If this question is asked for every possible word pair, how do you calculate the response of every other word?
3. If you are able to answer questions 1 and 2, how do you actually construct the vector that will be fed into the neural network?

Let explicitly define what this means. Each word has some sort of **intrinsic value**, which we have said is the sum of its embedding and positional encoding. For each word to ask each other word _how important they are to it_, we have to compare its intrinsic value to the other words' values. But _what_ values? In the compound sentence 'I went out to buy fruit and my sister answered some emails.', 'fruit' and 'emails' are the objects of the subjects 'I' and 'my sister' in the two coordinate clauses. Even though they are very important within their own clauses, they are more or less irrelevant for the other clause. If there was an earlier relation such as 'my sister likes fruit' much earlier (say 1000 words behind 'buy fruit') in the corpus, it would make sense to compare the intrinsic values of the embeddings. But since we practically do not want to look 1000 words behind for all the reasons outlined above, it makes sense to assign each word a **response value** i.e. if asked a question by another word, the word being asked will return a response value _that may be different from its intrinsic value_. Based on what the response value is, the initial word will decide what **information value** it 'passes on' to the neural network so that it can reconstruct this efficiently. Also, it does not make much sense for 'I' and 'emails' to be compared, so you also have to **figure out how much 'I' will pay attention to the other words**. This triplet of _intrinsic value_, _response value_, and _information value_ are what defines the attention process.

How do we make a word get a vector response from every other word? Like we have been doing all along, we define an **attention matrix** that is _not_ one-hot encoded this time around. The attention matrix _prepares each word_ for asking questions. Multiplying a word vector by this attention matrix results in a vector that contains the information 'how much attention should this word pay to other words?'. To make this process fast, you can _stack_ each intrinsic value into a matrix and multiply it with the attention matrix. This results in a matrix (let's call this matrix $A$) that contains information about 'how much should every word pay attention to every other word'? Note that this is not pair-specific; we are _not_ saying that 'I' should pay lesser attention to 'emails' than to 'went'. This is the behavior that is _learned_ by the transformer. 

Next, we multiply $A$ with a matrix that contains a matrix of responses of the other words. Like before, we are not explicitly telling 'I' to provide a worse response if asked 'How important are you to me?' by 'emails', but we are _learning_ this behavior. Let's call the result of this matrix multiplication $B$. You can now _normalize_ the weights and _softmax_ them in order for the matrix to have stable values. We then finally multiply this matrix by the matrix of information values to get $C$ **the result of the attention step**. _This_ is the idea behind attention. $B$ contains information about _how much weight_ each word should give to every other word, and $C$ contains information that makes our two-layer neural network make a judgment. These matrices are _learned_ by the transformer by backpropagation.

#### Multi-head attention 

Since we are now no longer dealing with nonnegative zero-one matrices, the question of how to do this calculation efficiently for large corpora still remains. Unfortunately we cannot. We can only rely on specialized and accelerated hardware. We are also still not sure whether the attention process actually captures meanings in a way that is human-understandable. The solution is straightforward: instead of having _one_ set of matrices to perform attention, have _more than one set_. Apply each matrix set's attention independently, and for every newly returned information vector, combine them together in a specified way (usually, just concatenate, then use a neural network to predict outputs). The hope is that each set of matrices will learn something different about the text - sentence structure, word meanings, subject-object relationships. Each such set of matrices is called an **attention head**. To make this process somewhat computationally palatable, the matrices in multihead attention have smaller output dimensions (usually what the size would be for a single head for the whole corpus divided by the number of heads). _In practice_, this does work. 

The final thing is dealing with practical languages. We still have to **stack** these attention blocks and two-layer neural networks many times in order to actually encode and decode things. This is the main reason it takes so long to train transformers on real text items. There is still of course the problem of getting correct datasets, but this is fine.


```python
import numpy as np


tokenized_sentence=['My','rabbit','likes','bananas']

#combined_vectors is a np.ndarray of shape (4,2) that has been initialized in a different cell

intrinsic_value_matrix=combined_vectors.T

print("The intrinsic value matrix is:\n", intrinsic_value_matrix)

l=len(tokenized_sentence) #this is completely arbitrary - i want a machine learning model whose final dimension is 4

attention_matrix=np.random.rand(l,l)

print("The initial attention matrix is:\n", attention_matrix)

A=np.matmul(intrinsic_value_matrix, attention_matrix)
print("Preparing the words for attention, we get:\n", A)

response_matrix=np.random.rand(l,l)

print("The initial response matrix is:\n", response_matrix)

B=np.matmul(A,response_matrix.T)

print("The responses given by each word to each other word is:\n", B, "\n and after normalizing, we get:\n", B/np.sqrt(l))
B=B/np.sqrt(l) #explicitly rewrite the matrix

print("We will softmax the attention matrix in order to boost closer words. The result of doing this is:\n", np.exp(B)/np.sum(np.exp(B),axis=1,keepdims=True))
B=np.exp(B)/np.sum(np.exp(B),axis=1,keepdims=True) #store it again

information_matrix=np.random.rand(l,l)

print("The information matrix is:\n", information_matrix)

C=np.matmul(B, information_matrix)

print("The actual information passed on to the two-layer neural network for decoding is:\n", C)
```

    The intrinsic value matrix is:
     [[ 0.1391731   0.28227808  0.56727728  1.03212653]
     [ 1.99026807 -0.28873527 -1.35583946 -1.443983  ]]
    The initial attention matrix is:
     [[0.96775588 0.85687394 0.11764399 0.73973033]
     [0.31966683 0.98841599 0.48535898 0.1224339 ]
     [0.72518555 0.3230112  0.99707816 0.97978246]
     [0.65613402 0.12982645 0.686861   0.09303049]]
    Preparing the words for attention, we get:
     [[ 1.31351514  0.71549621  1.42792633  0.78933853]
     [-0.09688701  0.79459977 -2.24969069 -0.02585148]]
    The initial response matrix is:
     [[0.02936416 0.82295845 0.20975295 0.37902713]
     [0.97345739 0.3368405  0.29648978 0.918208  ]
     [0.11074845 0.75958241 0.98806557 0.90129601]
     [0.65166792 0.31406079 0.25432198 0.8192551 ]]
    The responses given by each word to each other word is:
     [[ 1.22608639  2.66780165  2.81126061  2.09050766]
     [ 0.16939992 -0.51740933 -1.65330782 -0.40691028]] 
     and after normalizing, we get:
     [[ 0.61304319  1.33390082  1.4056303   1.04525383]
     [ 0.08469996 -0.25870467 -0.82665391 -0.20345514]]
    We will softmax the attention matrix in order to boost closer words. The result of doing this is:
     [[0.14693005 0.30211697 0.32458379 0.22636919]
     [0.34953106 0.24794025 0.14050437 0.26202432]]
    The information matrix is:
     [[0.87982191 0.52543491 0.24433994 0.11294321]
     [0.08717947 0.71907745 0.42011873 0.90535987]
     [0.7396713  0.19126042 0.61377742 0.43550545]
     [0.57724973 0.73806912 0.80619588 0.84373733]]
    The actual information passed on to the two-layer neural network for decoding is:
     [[0.52636754 0.52360382 0.54454599 0.62247348]
     [0.5843209  0.58220905 0.48705008 0.54622243]]



```python
print("This is a demonstration of multihead attention.\n")


print("Let's have two attention heads. The idea is to make our single-head attention model smaller.")

intrinsic_value_matrix=combined_vectors

l2=int(l/2) #two heads
matrix_sets=[]
l3=int(l2/2) #two heads, so the underlying projection dimesion will be smaller
for i in range(l2):
    matrix_sets.append([np.random.rand(l2,l3),np.random.rand(l2,l3),np.random.rand(l2,l3)])

print("The multihead attention matrices are now:")
print([i for i in matrix_sets])


passed_on=[]
print("The attention process is now applied to the intrinsic value matrix for each head.")
for i in range(l2):
    A=np.matmul(intrinsic_value_matrix,matrix_sets[i][0])
    B=np.matmul(A,matrix_sets[i][1].T)/np.sqrt(l2)
    B=np.exp(B)/np.sum(np.exp(B),axis=1,keepdims=True)
    C=np.matmul(B,matrix_sets[i][2])
    print("For head",i+1,"the information passed on is:\n", C)
    passed_on.append(C)

print("Therefore, the total information passed on is:\n",np.hstack((passed_on[0],passed_on[1])))
```

    This is a demonstration of multihead attention.
    
    Let's have two attention heads. The idea is to make our single-head attention model smaller.
    The multihead attention matrices are now:
    [[array([[0.25397487],
           [0.0311156 ]]), array([[0.73929474],
           [0.10634373]]), array([[0.31491959],
           [0.00381713]])], [array([[0.68166948],
           [0.16713201]]), array([[0.65528241],
           [0.99174262]]), array([[0.07267087],
           [0.07707801]])]]
    The attention process is now applied to the intrinsic value matrix for each head.
    For head 1 the information passed on is:
     [[0.16275392]
     [0.16155103]
     [0.16291437]
     [0.16692318]]
    For head 2 the information passed on is:
     [[0.07498641]
     [0.07491223]
     [0.0749164 ]
     [0.07499548]]
    Therefore, the total information passed on is:
     [[0.16275392 0.07498641]
     [0.16155103 0.07491223]
     [0.16291437 0.0749164 ]
     [0.16692318 0.07499548]]


#### Masked attention

We have not exactly implemented future-proofing here. Masked attention is simply a term that makes $B$ an upper triangular matrix, as we can easily now see why it is a future proofed matrix. 

#### Skip connections, Layer Normalization, and Xavier Initializations

Sometimes the result of the total information being passed on is small, so you can always add a **skip connection** to make it so that your vector is a result of embedding+position encoding AND attention. This is all empirical stuff that 'just works'. Skip connections also serve the dual purpose of being good for gradient descent. One thing we have not spoken about is gradient descent in practice. It is easy to see that gradient descent may be bad in practice while sound in theory, when the error function's plot in parameter space is just too hilly. Skip connections, things like _layer normalization_, and _Xavier initialization_ for all parameters make 'the gradients flow smoother' in backpropagation. In practice, this means that the gradient calculation actually updates the values fairly frequently, instead of the gradient being calculated as 0 (because of a loss of numerical precision in computers - they have finite precision!). 

For backpropagation through layer normalization, this is the mathematics:
$$
\text{Layer Normalization means applying the mathematical function }x_{\text{norm}}=f_{\text{layer}} \text{ such that}\\[5pt]
f_{\text{layer}}=\frac{x - \mu}{\sqrt{\sigma^2 + \epsilon}}\text{, where}\\[5pt]

\mu = \frac{1}{N} \sum_{i=1}^N x_i \quad \text{(mean)}\\[5pt]

\sigma^2 = \frac{1}{N} \sum_{i=1}^N (x_i - \mu)^2 \quad \text{(variance)}\\[5pt]

\text{And to backpropagate through it,}\\[5pt]

\text{Define } d_{out}=\frac{\partial \mathcal{L}}{\partial x_{\text{norm}}}\\[5pt]

\frac{\partial \mathcal{L}}{\partial \sigma^2} = \sum_{i=1}^N d_{out_{i}} \cdot (x_i - \mu) \cdot \left(-\frac{1}{2} (\sigma^2 + \epsilon)^{-3/2}\right)\\[5pt]

\frac{\partial \mathcal{L}}{\partial \mu} = \sum_{i=1}^N d_{out_{i}} \cdot \left(-\frac{1}{\sqrt{\sigma^2 + \epsilon}}\right) + \frac{\partial \mathcal{L}}{\partial \sigma^2} \cdot \sum_{i=1}^N \left(-2 (x_i - \mu) / N \right)\\[5pt]

\frac{\partial \mathcal{L}}{\partial x_i} = \frac{d_{out_{i}}}{\sqrt{\sigma^2 + \epsilon}} + \frac{\partial \mathcal{L}}{\partial \sigma^2} \cdot \frac{2 (x_i - \mu)}{N} + \frac{\partial \mathcal{L}}{\partial \mu} \cdot \frac{1}{N}
$$


#### Cross-attention

So far we have described attention as a standalone procedure. The idea is now to encode text with attention (for example, our neural network converts to a lower dimensional space) and pass the result of that into a decoder matrix. What does that mean? It means that we have converted text into an arbitrary dimension space _after_ performing all of these procedures. But wait. These can simply be interpreted as the results of a separate instance of attention results! While _generating_ text, we can simply pull those results in and feed them into the decoder's decoding stage, providing the attention we need.

#### Text generation

Now we do our actual task. How do we actually choose the next word? The idea is to predict the next word and generate a probability distribution with softmaxing, and greedily picking the one with the highest probability. Then, _take the text that has been generated so far along with the output_ and use it as an _input_ to the decoder, apply attention, then use multihead to combine things with the encoded transformer. Transformers generate text one word at a time. The way you put the text in as input is by inserting a special word that translates to 'SEQUENCE STARTS HERE'. This allows the decoder to train and learn to predict the next word.

### A transformer from scratch in pure numpy

After all of this, we can finally implement a transformer in numpy. Note that when you backpropagate errors through the model, the updates are applied to all matrices as single neurons as well. Let us lay out what the overall task is:

1. Give an input sentence, tokenize it, embed the words, add positional encoding. Keep a copy of the output.
2. Initialize _random_ attention, response, and value matrices, and run the matrix of inputs through the multi-head attention step. 
3. Add the output copy and attention step results, and use that as input to a 2 layer neural network (whose neurons are randomly initialized) to convert the data into some weird representation that only the machine understands.
4. Put this weird or _latent_ representation into another neural network to decode it, then project it to the target space vocabulary size, then softmax. Select the word with the largest probability as the output and compare which word in the other vocabulary's embeddings is the closest. Once the next word is found, use that as the input to the model (that is, put it through its own set of attention steps, but this time they're masked) and use that to predict the next token. Once the entire sequence has been predicted, compute the cross-entropy loss and apply backpropagation, updating each matrix. 


```python
import numpy as np
from typing import List, Tuple, Optional, Dict

###############################################################################
# Utilities
###############################################################################

def whitespace_tokenizer(sentence: str) -> List[str]:
    """
        Splits a latin-character sentence into individual words assuming that each word is separated by a whitespace, and there's no punctuation
    
        Input:
            sentence: a string 
        Output:
            List of strings containing each individual words
    """

    #we now start using python's inbuilt functions in order to make the code look more impressive
    return sentence.strip().split()

def build_vocab(list_of_tokenized_sentences: List[List[str]]) -> Tuple[dict, dict]:
    """
        Builds a vocabulary of all words in the a given corpus of languages.
        This means that if you have more than one sentence, it creates a list of words.
        Input:
            list_of_tokenized_sentences: a list of list of strings, AKA a whitespace tokenized sentence
        Output:
            A tuple of Python dictionaries, containing all words and their index. This index is random, because of the use of set()
    """
    #the idea is to store the vocabulary in a Python set() object, which randomly stores elements for faster access (there's more to it but oh well)
    vocabulary=set()
    for tokenized_sentence in list_of_tokenized_sentences: 
        vocabulary.update(tokenized_sentence) #when you update a python set with a list, the elements of the list are added to the vocabulary
    vocabulary=list(vocabulary) #convert the vocabulary set() into a list, so you can enumerate through it
    word_index_pairs={w:i for i,w in enumerate(vocabulary)} #create a word:index pairing dictionary
    index_word_pairs={i:w for i,w in enumerate(vocabulary)} #create an index:word pairing dictionary
    return word_index_pairs,index_word_pairs

def pad_sequences(sequences: List[List[int]], max_length: Optional[int]=None, pad_value: int=0) -> np.ndarray:
    """
        Pads sequences. This is done because it is easier to process sequences with the same length, so we artifically add numbers to smaller ones.
        Inputs:
            sequences: a list of list of integers
            max_length: Optional. Allows you to set the maximum length for a sequence instead of computing it dynamically.
                     For example, in a corpus of sentences each under 20 words long, you can set the max length as 294
            pad_value: What number you want to use to 
        Output:
            A numpy.ndarray of a padded sequence

    """
    #dynamically figure out the max length, as you have to pad to this
    if max_length is None:
        max_length=max(len(sequence) for sequence in sequences)
    padded=[]
    for sequence in sequences:
        padded_sequence=sequence+[pad_value]*(max_length-len(sequence)) #simply append a list containing pad_value
        padded.append(padded_sequence)
    return np.array(padded, dtype=np.int32) #return an ndarray

def create_mask_for_removing_future_dependency(sequence: np.ndarray) -> np.ndarray:
    """
        Creates a non-future-dependent mask for the decoder, so that the decoder doesn't use the future for generation. This is also called autoregressive behavior.
        Inputs:
            sequence: An input ndarray whose shape is (batch_size, batch_size) - note that this assumes you are feeding it into the decoder at scale
        Outputs:
            An ndarray of the same shape as the input sequence which is upper triangular. The data type is Bool for faster processing. The upper triangular part has 'True'.
    """
    sequence_length=sequence.shape[1]
    autoregressive_mask=np.triu(np.ones((sequence_length,sequence_length)),k=1).astype(bool) #again, using the inbuilt functions
    return autoregressive_mask

def one_hot(indices: np.ndarray, vocabulary_size: int) -> np.ndarray:
    """
        Converts input sequences into one-hot encoding in one go. 
        Since we are feeding sequences in one go to the encoder in batches, we need a 3D ndarray. 
        Inputs:
            indices: An input ndarray whose shape is (batch_size, sequence_length), where each element has an integer index. This is why we created indices above
            vocabulary_size: The number of words in the vocabulary of the language
    """
    batched_tokens=np.zeros((indices.shape[0], indices.shape[1], vocabulary_size)) #create your zero ndarray, and populate it
    #use a nested loop to set one-hot encodings
    for batch_index in range(indices.shape[0]):
        for token_index in range(indices.shape[1]):
            batched_tokens[b,t,indices[batch_index,token_index]]=1
    return batched_tokens

###############################################################################
# Normalization, activation, and loss
###############################################################################

def layer_norm(x: np.ndarray, eps=1e-6) -> Tuple[np.ndarray,np.ndarray,np.ndarray]:
    """
        Normalizes the input ndarray. This is done to make backpropagation not run into numerical errors.
        Inputs:
            x: ndarray of inputs. usually just a vector
            eps: this is done to prevent division by zero during normalization
        Outputs:
            Tuple of ndarrays containing the normalized input ndarray, the mean, and the variance
    """
    mean=np.mean(x, axis=-1, keepdims=True)
    var=np.var(x, axis=-1, keepdims=True)
    x_norm=(x-mean)/np.sqrt(var+eps)
    return x_norm,mean,var

def layer_norm_backprop(dout: np.ndarray, x: np.ndarray, mean: np.ndarray, var: np.ndarray, eps: float=1e-6) ->np.ndarray:

    """
        Compute the gradient of the loss with respect to the input x of a layer normalization operation, implementing backpropagation as defined in the tutorial
        Inputs: 
            dout: an ndarray containing the gradient with respect to the normalized input
            x: an ndarray containing the original input
            mean: mean of the input ndarray x along the last axis, as computed above
            var: exactly like the mean
            eps: an optional value for numerical stabillity
        Outputs:
            an ndarray containing the gradient with respect to the layer normalization procedure
    """

    #numerically backpropagate by calculating the derivatives. unfortunately, this just requires knowing the formula as shown above
    N=x.shape[-1]
    dx_norm=dout/np.sqrt(var+eps)
    dvar=np.sum(dout*(x-mean)*-0.5*(var+eps)**(-1.5), axis=-1, keepdims=True)
    dmean=(np.sum(dout*-1/np.sqrt(var+eps), axis=-1, keepdims=True)+dvar*np.sum(-2*(x-mean), axis=-1, keepdims=True)/N)
    dx=dx_norm+dvar*2*(x-mean)/N+dmean/N
    return dx

def softmax(x: np.ndarray) -> np.ndarray:
    """
        Compute the softmax of an input ndarray and generate a probability distribution
        Inputs:
            x: an ndarray that you want to softmax
        Outputs:
            an ndarray containing the softmaxed version along the last axis
    """
    x_shifted=x-np.max(x, axis=-1, keepdims=True) #this is done to improve numerical stability. softmaxing is invariant to shifts by a constant value
    exp_x=np.exp(x_shifted)
    return exp_x/np.sum(exp_x, axis=-1, keepdims=True)

def cross_entropy_loss(predictions: np.ndarray, targets: np.ndarray) -> float:
    """
        Compute the cross-entropy loss as defined above, measuring the difference between two probability predicted distributions
        Inputs:
            predictions: an ndarray containing whatever you have predicted
            targets: an ndarray containing whatever the real targets are
        Outputs:
            a float of computed cross-entropy loss, averaged over all elements in the batch
    """
    epsilon=1e-12 #more numerical precision constants
    predictions=np.clip(predictions, epsilon, 1-epsilon) #values smaller than epsilon become epsilon, values larger than 1-epsilon become 1-epsilon
    flat_targets=targets.flatten() #maybe the arrays are not 1d, but the cross-entropy loss needs the 1d
    flat_preds=predictions.reshape(-1, predictions.shape[-1]) #same reason here for flattening
    loss=-np.mean(np.log(flat_preds[np.arange(flat_targets.shape[0]), flat_targets])) #compute the crossentropy loss
    return loss

def cross_entropy_derivative(predictions: np.ndarray, targets: np.ndarray) -> np.ndarray:
    """
        Compute the backpropagation for cross-entropy loss
        Inputs:
            predictions: an ndarray containing whatever you have predicted
            targets: an ndarray containing whatever the real targets are
        Outputs:
            an ndarray of the gradient of the cross-entropy derivative required for backpropagation
    """
    #the gradient was also defined above so this is just a way to get batches of data in and publish it
    batch,length,vocab_size=predictions.shape
    grad=predictions.copy()
    for b in range(batch):
        for t in range(length):
            grad[b, t, targets[b,t]]-=1
    grad/=(batch*length)
    return grad

###############################################################################
# Multi-Head Attention
###############################################################################

def split_heads(x: np.ndarray, num_heads: int) -> np.ndarray:
    """
        Attention heads attend to different parts of the data, so this is a function to simply split the data 
        Inputs:
            x: an ndarray of input data
            num_heads: the number of attention instances you want
        Outputs:
            a reshaped x split into the number of heads
    """
    #at this point it should be familiar, split the data into batches and make it work
    batch,length,d_model=x.shape
    head_dim=d_model//num_heads #the heads attend to different parts of the model
    return x.reshape(batch, length, num_heads, head_dim).transpose(0,2,1,3) #reshape x so that every ndarray is for heads

def merge_heads(x: np.ndarray) -> np.ndarray:
    """
        After the result of multihead attention, you need to recombine them, so this function does it
        Inputs:
            x: an ndarray containing information of shape (batch, num_heads, length, head_dim)
        Outputs:
            a combined x after (presumably) multihead attention has been done
    """
    batch,num_heads,length,head_dim=x.shape
    return x.transpose(0, 2, 1, 3).reshape(batch, length, num_heads*head_dim)

def scaled_dot_product_attention(attention_matrix: np.ndarray, response_matrix: np.ndarray, information_matrix: np.ndarray, mask: Optional[np.ndarray]=None) -> Tuple[np.ndarray, np.ndarray]:
    """
        This is the official formula of the attention. As we have seen, we use an attention matrix to make each word ask each other word a question.
        The response of each other word is the response matrix and the information passed on is the information matrix. 
        inputs:
            attention_matrix: An ndarray of attention values
            response_matrix: An ndarray of response values
            information_matrix: An ndarray of information values that is passed on
            mask: An ndarray of masks, but with Bool values
        Outputs:
            a tuple of the information passed on and the attention weights
    """ 
    normalization_factor=attention_matrix.shape[-1]
    scores=np.matmul(attention_matrix, response_matrix.transpose(0,1,3,2))/np.sqrt(normalization_factor) #we are now using 'official' terminology
    if mask is not None:
        scores=np.where(mask[np.newaxis, np.newaxis,:,:], -1e9, scores) #mask if required
    attn_weights=softmax(scores) #softmax the product
    output=np.matmul(attn_weights, information_matrix) #send information on
    return output, attn_weights

def multi_head_attention(batched_input_intrinsic_value_matrix: np.ndarray, batched_input_response_matrix: np.ndarray, batched_input_information_matrix: np.ndarray, batched_input_intrinsic_value_projection_matrix: np.ndarray, batched_input_response_projection_matrix: np.ndarray, batched_input_information_projection_matrix: np.ndarray, final_reshaper_matrix: np.ndarray, num_heads: int, mask: Optional[np.ndarray]=None) -> Tuple[np.ndarray, np.ndarray]:
    """
        Implementation of multihead attention. Simply put, apply attention on smaller parts of the sequence, and then recombine them by concatenation.
        Because we are splitting the sequence, we need to generate different attention, response, and information matrices for each attention instance.
        This means we have to project the input into different matrices every time, and the matrix that does this projection is also learned.
        This is the trick behind multihead attention.
        Inputs:
            batched_input_intrinsic_value_matrix: an ndarray of your batched input
            batched_input_response_matrix: an ndarray that is essentially the same as batched_input_intrinsic_value
            batched_input_information_matrix: same as above. you have to declare that these matrices exist 
            batched_input_intrinsic_value_projection_matrix: an ndarray that projects the intrinsic value to the size for multihead attention
            batched_input_response_projection_matrix: same thing for response_matrix
            batched_input_information_projection_matrix: same thing as above
        Returns:
            A tuple of ndarrays that have the concatenated result of multihead attention and also the attention weights respectively. 
    """
    attention_matrix=batched_input_intrinsic_value_matrix @ batched_input_intrinsic_value_projection_matrix #we now use the inbuilt @ operator to do matrix multiplication quickly
    response_matrix=batched_input_response_matrix @ batched_input_intrinsic_value_projection_matrix
    information_matrix=batched_input_information_matrix @ batched_input_information_projection_matrix

    #extract dimensions from the attention matrix (query tensor)
    #attention_matrix` is the query tensor with shape (batch_size, seq_len_q, d_model)
    batch, lq, d_model=attention_matrix.shape

    #extract the length of the key tensor from the response matrix
    #response_matrix is the key tensor with shape (batch_size, seq_len_k, d_model)
    #lk represents seq_len_k (sequence length of the response_matrix), which may differ from lq (seq_len_q)
    lk=response_matrix.shape[1]

    #we don't explicitly compute `lv` (seq_len_v, length of values) because information_matrix is expected to have the same sequence length as response_matrix

    #reshape and transpose attention_matrix to prepare for multi-head attention
    #step 1: reshape attention_matrix from (batch_size, seq_len_q, d_model) to (batch_size, seq_len_q, num_heads, head_dim), where head_dim = d_model//num_heads
    #step 2: transpose to (batch_size, num_heads, seq_len_q, head_dim) for easier computation per head
    A=attention_matrix.reshape(batch, lq, num_heads, d_model//num_heads).transpose(0,2,1,3)

    #reshape and transpose response_matrix similarly
    B=response_matrix.reshape(batch, lk, num_heads, d_model//num_heads).transpose(0,2,1,3)

    #reshape and transpose information_matrix similarly
    C=information_matrix.reshape(batch, lk, num_heads, d_model//num_heads).transpose(0,2,1,3)

    #compute the attention each head
    #input ndarrays (A, B, B) are now split into individual heads for parallel processing
    #'mask` is optional and is used to block certain positions (e.g., future positions in autoregressive decoding)
    out_heads, attn_weights=scaled_dot_product_attention(A, B, C, mask)

    #concatenate the output
    out=(merge_heads(out_heads))@final_reshaper_matrix  # Apply a linear projection to combine the head outputs into `d_model` dimensions.

    return out, attn_weights


def mha_backprop(
        dout: np.ndarray,
        batched_input_intrinsic_value_matrix: np.ndarray,
        batched_input_response_matrix: np.ndarray,
        batched_input_information_matrix: np.ndarray, 
        batched_input_intrinsic_value_projection_matrix: np.ndarray,
        batched_input_response_projection_matrix: np.ndarray, 
        batched_input_information_projection_matrix: np.ndarray, 
        final_projection_matrix: np.ndarray,
        attention_weights: np.ndarray, 
        num_heads: int, 
        mask: Optional[np.ndarray]=None
    ) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """
        This is the big one. This is the function that backpropagates through multihead attention. 
        It computes the gradients of the loss with respect to the sequence matrices and the weight matrices used in the multi-head attention mechanism.
        Like before, we are in fact feeding it the loss.
        Inputs:
            dout: an ndarray of the gradient of the loss with respect to the output of multihead attention
            batched_input_intrinsic_value_matrix: an ndarray as defined in the multihead attention function above,
            batched_input_response_matrix: an ndarray as defined in the multihead attention function above ,
            batched_input_information_matrix: an ndarray as defined in the multihead attention function above,   
            batched_input_intrinsic_value_projection_matrix: an ndarray as defined in the multihead attention function above,
            batched_input_response_projection_matrix: an ndarray as defined in the multihead attention function above, 
            batched_input_information_projection_matrix: an ndarray as defined in the multihead attention function above, 
            final_projection_matrix: an ndarray as defined in the multihead attention function above,
            attention_weights: an ndarray that is the output of multihead attention function, required for backpropagation
            mask: an optional ndarray of masks (Bool data type)
        Outputs:
            the following tuple: Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
            - differential_intrinsic_value_matrix (np.ndarray): Gradient w.r.t. the query input `batched_input_intrinsic_value_matrix`, shape (batch_size, seq_len_q, d_model).
            - differential_response_matrix (np.ndarray): Gradient w.r.t. the key input `batched_input_response_matrix`, shape (batch_size, seq_len_k, d_model).
            - differential_information_matrix (np.ndarray): Gradient w.r.t. the value input `batched_input_information_matrix`, shape (batch_size, seq_len_k, d_model).
            - original_shape_intrinsic_value_differential (np.ndarray): Gradient w.r.t. the query weight matrix `batched_input_intrinsic_value_projection_matrix`, shape (d_model, d_model).
            - original_shape_response_differential (np.ndarray): Gradient w.r.t. the key weight matrix `batched_input_response_projection_matrix`, shape (d_model, d_model).
            - original_shape_information_differential (np.ndarray): Gradient w.r.t. the value weight batched_input_information_projection_matrix `W_v`, shape (d_model, d_model).
            - original_shape_attention_differential (np.ndarray): Gradient w.r.t. the output weight matrix `final_projection_matrix`, shape (d_model, d_model).
    """
    #throughout the code, a variable starting with 'd' denotes a derivative/gradient, aside from d_model, which is the model dimension (user-defined really)
    batch, attention_sequence_length, d_model=batched_input_intrinsic_value_matrix.shape #compute the gradient matrix
    sequence_length=batched_input_response_matrix.shape[1] #length of the sequence, obtained from really any matrix
    head_dim=d_model//num_heads #just the model head size

    #recompute the forward step
    attention_matrix=batched_input_intrinsic_value_matrix @ batched_input_intrinsic_value_projection_matrix #standard stuff
    response_matrix=batched_input_response_matrix @ batched_input_response_projection_matrix
    information_matrix=batched_input_information_matrix @ batched_input_information_projection_matrix

    #similarly reshaping stuff as done before
    head_attention_matrix=attention_matrix.reshape(batch, attention_sequence_length, num_heads, head_dim).transpose(0,2,1,3)
    head_response_matrix=response_matrix.reshape(batch, sequence_length, num_heads, head_dim).transpose(0,2,1,3)
    head_information_matrix=information_matrix.reshape(batch, sequence_length, num_heads, head_dim).transpose(0,2,1,3)

    d_merged_heads=dout.reshape(batch, attention_sequence_length, d_model) #reshape dout into the correct shape
    d_out_heads=d_merged_heads.reshape(batch, attention_sequence_length, num_heads, head_dim).transpose(0,2,1,3)

    #check shape consistency, because it makes for easier debugging
    assert d_out_heads.shape==(batch, num_heads, attention_sequence_length, head_dim), f"Shape mismatch in d_out_heads: {d_out_heads.shape}" #first time we've used 'assert'

    #attention weights and value gradients
    d_attention_weights=np.matmul(d_out_heads, head_information_matrix.transpose(0,1,3,2)) #this is pretty standard fare, start getting the stuff out from backprop
    d_vh=np.matmul(attention_weights.transpose(0,1,3,2), d_out_heads) #this is also the same thing

    #calculate the differential element of the attention scores, for backpropagation
    sum_over_j=np.sum(attention_weights*d_attention_weights, axis=-1, keepdims=True)
    d_scores=attention_weights*(d_attention_weights-sum_over_j)

    #calculate the differential elements for the attention and response matrices, per head
    d_attention_head=np.matmul(d_scores, head_response_matrix)/np.sqrt(head_dim)
    d_response_head=np.matmul(d_scores.transpose(0,1,3,2), head_attention_matrix)/np.sqrt(head_dim)

    #combine the elements back for concatenation
    total_attention_differential=d_attention_head.transpose(0,2,1,3).reshape(batch, attention_sequence_length, d_model)
    total_response_differential=d_response_head.transpose(0,2,1,3).reshape(batch, sequence_length, d_model)
    total_information_differential=d_vh.transpose(0,2,1,3).reshape(batch, sequence_length, d_model)

    #now calculate the total gradients for all elements
    original_shape_intrinsic_value_differential=np.matmul(batched_input_intrinsic_value_matrix.reshape(-1, d_model).T, total_attention_differential.reshape(-1, d_model))
    original_shape_response_differential=np.matmul(batched_input_response_matrix.reshape(-1, d_model).T, total_response_differential.reshape(-1, d_model))
    original_shape_information_differential=np.matmul(batched_input_information_matrix.reshape(-1, d_model).T, total_information_differential.reshape(-1, d_model))
    #original_shape_attention_differential=np.matmul(merge_heads(attention_weights @ information_matrix).reshape(batch*attention_sequence_length, d_model).T, dout.reshape(batch*attention_sequence_length, d_model))
    C = information_matrix.reshape(batch, sequence_length, num_heads, head_dim).transpose(0, 2, 1, 3)

    original_shape_attention_differential = np.matmul(
    merge_heads(np.matmul(attention_weights, C)).reshape(batch * attention_sequence_length, d_model).T,
    dout.reshape(batch * attention_sequence_length, d_model)
        )
    differential_intrinsic_value_matrix = total_attention_differential @ batched_input_intrinsic_value_projection_matrix.T
    differential_response_matrix = total_response_differential @ batched_input_response_projection_matrix.T
    differential_information_matrix = total_information_differential @ batched_input_information_projection_matrix.T

    return differential_intrinsic_value_matrix, differential_response_matrix, differential_information_matrix, original_shape_intrinsic_value_differential, original_shape_response_differential, original_shape_information_differential, original_shape_attention_differential


###############################################################################
# Feed Forward Network
###############################################################################

#now we define the feedforward neural network (2 layers) with backprop. we use the ReLU activation function for easy differentials
#note the different output in the definition of the feedforward network
def feed_forward(x: np.ndarray, W1: np.ndarray, b1: np.ndarray, W2: np.ndarray, b2: np.ndarray) -> Tuple[np.ndarray, Tuple[np.ndarray, np.ndarray]]:
    """ 
        This is a simple two layer feedforward neural network. The reason a cache is returned at all is because it is immensely helpful in backpropagation
        Inputs:
            x: input ndarray of data
            W1: weight matrix for the first linear transformation
            b1: bias vector for first layer
            W2, b2: same as above for second layer
        Outputs:
            Tuple[np.ndarray, Tuple[np.ndarray, np.ndarray]]:
            - z2 (np.ndarray): the output tensor after the feed-forward computation of shape (batch_size, seq_len, d_model).
            - cache (Tuple[np.ndarray, np.ndarray]): a tuple containing:
                - z1 (np.ndarray): the output of the first linear transformation before the ReLU activation, of shape (batch_size, seq_len, d_ff).
                - relu (np.ndarray): The output of the ReLU activation, of shape (batch_size, seq_len, d_ff).
    """
    #this is just straighforward - two matrix multiplications with a ReLU in between
    z1=x@W1+b1
    relu=np.maximum(0, z1)
    z2=relu@W2+b2
    return z2, (z1, relu)

def feed_forward_backprop(dz2: np.ndarray, x: np.ndarray, W1: np.ndarray, b1: np.ndarray, W2: np.ndarray, b2: np.ndarray, cache: Tuple[np.ndarray, np.ndarray]) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """
        The backpropagation for a feedforward layer. Note that we are working backwards, so the input variables are defined that way
        Inputs:
            dz2: ndarray containing gradient of the loss function with respect to output of the second layer
            x: input ndarray of data
            W1-cache: same as above
        Outputs:
            Tuple of losses (ndarrays) with respect to x,W1,b1,W2,b2 respectively
    """
    #backpropagation, step by step, is the exact formula outlines in the tutorial
    (z1, relu)=cache #now you see why we utilized the cache at all
    batch, length, d_model=x.shape
    dW2=np.matmul(relu.reshape(-1, d_model).T, dz2.reshape(-1, d_model))
    db2=dz2.sum(axis=(0,1))
    d_relu=dz2@W2.T
    d_z1=d_relu*(z1>0)
    dW1=np.matmul(x.reshape(-1, d_model).T, d_z1.reshape(-1, d_model))
    db1=d_z1.sum(axis=(0,1))
    dX=d_z1@W1.T
    return dX, dW1, db1, dW2, db2

###############################################################################
# Encoder and Decoder Blocks
###############################################################################

#we now build the actual encoder-decoder layer.

def encoder_layer(x: np.ndarray, intrinsic_value_projector: np.ndarray, response_projector: np.ndarray, information_projector: np.ndarray, attention_projector: np.ndarray, W1: np.ndarray, b1: np.ndarray, W2: np.ndarray, b2: np.ndarray, num_heads: int=2) -> Tuple[np.ndarray, Tuple]:
    """
        Now we build the transformer in earnest from all of our classes. This implements the encoder layer using the structure outlined in the tutorial
        Inputs:
            x: ndarray of input data
            intrinsic_value_projector, response_projector, information_projector, attention_projector: ndarrays containing projection matrices for input data
            W1, b1, W2, b2: ndarrays of the two-layer neural network
            num_heads: number of attention heads
        Outputs:
            out: output ndarray of the entire encoder
            cache: a Tuple of all cached values for backpropagation

    """
    #at this point i start using smaller variable names because the program becomes tedious to read. anyway, this code is self-explanatory 
    x_norm, mean1, var1=layer_norm(x)
    attn_out, attn_w=multi_head_attention(x_norm, x_norm, x_norm, intrinsic_value_projector, response_projector, information_projector, attention_projector, num_heads=num_heads)
    x2=x+attn_out

    x2_norm, mean2, var2=layer_norm(x2)
    ff_out, ff_cache=feed_forward(x2_norm,W1,b1,W2,b2)
    out=x2+ff_out
    cache=(x, x2, x_norm, x2_norm, mean1, var1, mean2, var2, attn_w, ff_cache)
    return out, cache

def decoder_layer(x, encoder_out,
                  intrinsic_weight_masked, response_weight_masked, information_weight_masked, attention_weight_masked,
                  intrinsic_crossattention_weight, response_crossattention_weight, information_crossattention_weight, attention_crossattention_weight, W1, b1, W2, b2, mask, num_heads=2):
    """
        We implement the decoder layer with masked attention.
        Inputs: 
            x: ndarray of input data
            intrinsic_weight_masked: projection matrix for masked self-attention for the intrinsic value weight
            response_weight_masked: projection matrix for masked self-attention for the response weight
            information_weight_masked: projection matrix for masked self-attention for the information weight
            attention_weight_masked: projection matrix for masked self-attention for the attention weights
            intrinsic_crossattention_weight: projection matrix for the intrinsic value weight during cross-attention
            response_crossattention_weight: projection matrix for the response weight during cross-attention
            information_crossattention_weight: projection matrix for the information weight during cross-attention
            attention_crossattention_weight: projection matrix for the attention weights during cross-attention
            W1,b1,W2,b2, mask: all defined above
            num_heads: number of attention instances
        Outputs:
            Tuple[np.ndarray, Tuple]:
            - out: output ndarray of the decoder layer, shape (batch_size, seq_len, d_model)
            - cache (Tuple): cached values for backpropagation, including:
                - x, x2, x3 : intermediate ndarrays at various stages
                - x_norm_dec1, x2_norm, x3_norm : layer-normalized ndarrays
                - mean_dec1, var_dec1, mean_dec2, var_dec2, mean_dec3, var_dec3: Means and variances (in ndarrays) from layer normalization
                - masked_attn_w, cross_attn_w: attention weight ndarrays from masked self-attention and cross-attention
                - ff_cache_dec (Tuple): cached values from the feed-forward network
    """
    #this just implements the decoder layer

    #first, apply layer normalization, then compute multihead attention
    x_norm_dec1,mean_dec1,var_dec1=layer_norm(x)
    masked_attn_out, masked_attn_w=multi_head_attention(x_norm_dec1, x_norm_dec1, x_norm_dec1,
                                                          intrinsic_weight_masked, response_weight_masked, information_weight_masked, attention_weight_masked, 
                                                          num_heads=num_heads, mask=mask)
    x2=x+masked_attn_out
    #then layernorm again
    x2_norm, mean_dec2, var_dec2=layer_norm(x2)
    cross_attn_out, cross_attn_w=multi_head_attention(x2_norm, encoder_out, encoder_out,
                                                        intrinsic_crossattention_weight, response_crossattention_weight, information_crossattention_weight, attention_crossattention_weight,
                                                        num_heads=num_heads, mask=None)
    x3=x2+cross_attn_out
    #layer norm thrice
    x3_norm, mean_dec3, var_dec3=layer_norm(x3)
    ff_out, ff_cache_dec=feed_forward(x3_norm, W1, b1, W2, b2)
    out=x3+ff_out
    #prepare the cache for backprop
    cache=(x, x2, x3, x_norm_dec1, x2_norm, x3_norm, mean_dec1, var_dec1, mean_dec2, var_dec2, mean_dec3, var_dec3, masked_attn_w, cross_attn_w, ff_cache_dec)
    return out, cache

###############################################################################
# Forward and Backprop Through Model (Single Layer Encoder-Decoder)
###############################################################################

#at this point 

def forward_transformer(enc_in: np.ndarray, dec_in: np.ndarray,
                        intrinsic_value_weight_enc: np.ndarray, response_weight_enc: np.ndarray, information_weight_enc: np.ndarray, attention_weight_enc: np.ndarray, W1_enc: np.ndarray, b1_enc: np.ndarray, W2_enc: np.ndarray, b2_enc: np.ndarray,
                        intrinsic_value_weight_dec_masked: np.ndarray, response_weight_dec_masked: np.ndarray, information_weight_dec_masked: np.ndarray, attention_weight_dec_masked: np.ndarray,
                        intrinsic_value_weight_dec_cross: np.ndarray, response_weight_dec_cross: np.ndarray, information_weight_dec_cross: np.ndarray, attention_weight_dec_cross: np.ndarray,
                        W1_dec: np.ndarray, b1_dec: np.ndarray, W2_dec: np.ndarray, b2_dec: np.ndarray,
                        W_embed_out: np.ndarray, b_embed_out: np.ndarray,
                        src_mask: np.ndarray, tgt_mask: np.ndarray) -> Tuple[np.ndarray, Tuple]:
    """
        We implement the forward pass for the transformer model. This is fairly straightforward and how we've defined it

        Inputs:
            enc_in: ndarray of input data to the encoder, shape (batch_size, src_len, d_model)
            dec_in: ndarray of input data to the decoder, shape (batch_size, tgt_len, d_model)
            intrinsic_value_weight_enc: projection matrix for the query in the encoder's self-attention
            response_value_weight_enc: projection matrix for the key in the encoder's self-attention
            information_value_weight_enc: projection matrix for the value in the encoder's self-attention
            attention_value_weight_enc: projection matrix for the output in the encoder's self-attention
            W1_enc, b1_enc, W2_enc, b2_enc: feed-forward network weights and biases for the encoder
            intrinsic_value_weight_dec_masked: projection matrix for the query in the decoder's masked self-attention
            response_value_weight_dec_masked: projection matrix for the key in the decoder's masked self-attention
            information_value_weight_dec_masked: projection matrix for the value in the decoder's masked self-attention
            attention_value_weight_dec_masked: projection matrix for the output in the decoder's masked self-attention
            intrinsic_value_weight_dec_cross: projection matrix for the query in the decoder's cross-attention
            response_value_weight_dec_cross: projection matrix for the key in the decoder's cross-attention
            information_value_weight_dec_cross: projection matrix for the value in the decoder's cross-attention
            attention_value_weight_dec_cross: projection matrix for the output in the decoder's cross-attention
            W1_dec, b1_dec, W2_dec, b2_dec: feed-forward network weights and biases for the decoder
            W_embed_out: projection matrix for mapping decoder output to the vocabulary space, shape (d_model, vocab_size)
            b_embed_out: bias vector for mapping decoder output to the vocabulary space, shape (vocab_size,)
            src_mask: ndarray mask for the encoder, shape (src_len, src_len)
            tgt_mask: ndarray mask for the decoder, shape (tgt_len, tgt_len)

        Outputs:
            Tuple[np.ndarray, Tuple]:
            - probs: output probabilities over the vocabulary, shape (batch_size, tgt_len, vocab_size)
            - cache (Tuple): cached values for backpropagation, including:
                - enc_out: ndarray of the encoder output, shape (batch_size, src_len, d_model)
                - enc_cache: cached intermediate values from the encoder
                - dec_out: ndarray of the decoder output, shape (batch_size, tgt_len, d_model)
                - dec_cache: cached intermediate values from the decoder
    """

    #this should be fairly straighforward by now, how it's implemented. just feed your weights in and go through the entire layer
    enc_out, enc_cache=encoder_layer(enc_in, intrinsic_value_weight_enc, response_weight_enc, information_weight_enc, attention_weight_enc, W1_enc, b1_enc, W2_enc, b2_enc)
    dec_out, dec_cache=decoder_layer(dec_in, enc_out, intrinsic_value_weight_dec_masked, response_weight_dec_masked, information_weight_dec_masked, attention_weight_dec_masked,
                                       intrinsic_value_weight_dec_cross, response_weight_dec_cross, information_weight_dec_cross, attention_weight_dec_cross,
                                       W1_dec, b1_dec, W2_dec, b2_dec,
                                       mask=tgt_mask)
    logits=dec_out@W_embed_out+b_embed_out
    probs=softmax(logits)
    return probs, (enc_out, enc_cache, dec_out, dec_cache)

def backward_transformer(dprobs: np.ndarray,
    enc_in: np.ndarray,
    dec_in: np.ndarray,
    enc_out: np.ndarray,
    enc_cache: Tuple,
    dec_out: np.ndarray,
    dec_cache: Tuple,
    intrinsic_value_weight_enc: np.ndarray,
    response_weight_enc: np.ndarray,
    information_weight_enc: np.ndarray,
    attention_weight_enc: np.ndarray,
    W1_enc: np.ndarray,
    b1_enc: np.ndarray,
    W2_enc: np.ndarray,
    b2_enc: np.ndarray,
    intrinsic_value_weight_dec_masked: np.ndarray,
    response_weight_dec_masked: np.ndarray,
    information_weight_dec_masked: np.ndarray,
    attention_weight_dec_masked: np.ndarray,
    intrinsic_value_weight_dec_cross: np.ndarray,
    response_weight_dec_cross: np.ndarray,
    information_weight_dec_cross: np.ndarray,
    attention_weight_dec_cross: np.ndarray,
    W1_dec: np.ndarray,
    b1_dec: np.ndarray,
    W2_dec: np.ndarray,
    b2_dec: np.ndarray,
    W_embed_out: np.ndarray,
    b_embed_out: np.ndarray,
    src_mask: np.ndarray,
    tgt_mask: np.ndarray) -> Tuple[Dict[str, np.ndarray], np.ndarray]:
    """
        This is possibly the hardest part in the code. This is complete backpropagation for the transformer, through all layers.

        Inputs:
            dprobs: ndarray of gradients with respect to output probabilities, shape (batch_size, tgt_len, vocab_size)
            enc_in: ndarray of input data to the encoder, shape (batch_size, src_len, d_model)
            dec_in: ndarray of input data to the decoder, shape (batch_size, tgt_len, d_model)
            enc_out: ndarray of encoder outputs, shape (batch_size, src_len, d_model)
            enc_cache: cached values from the encoder forward pass
            dec_out: ndarray of decoder outputs, shape (batch_size, tgt_len, d_model)
            dec_cache: cached values from the decoder forward pass
            intrinsic_value_weight_enc: projection matrix for the query in the encoder's self-attention
            response_weight_enc: projection matrix for the key in the encoder's self-attention
            information_weight_enc: projection matrix for the value in the encoder's self-attention
            attention_weight_enc: projection matrix for the output in the encoder's self-attention
            W1_enc, b1_enc, W2_enc, b2_enc: feed-forward network weights and biases for the encoder
            intrinsic_value_weight_dec_masked: projection matrix for the query in the decoder's masked self-attention
            response_weight_dec_masked: projection matrix for the key in the decoder's masked self-attention
            information_weight_dec_masked: projection matrix for the value in the decoder's masked self-attention
            attention_weight_dec_masked: projection matrix for the output in the decoder's masked self-attention
            intrinsic_value_weight_dec_cross: projection matrix for the query in the decoder's cross-attention
            response_weight_dec_cross: projection matrix for the key in the decoder's cross-attention
            information_weight_dec_cross: projection matrix for the value in the decoder's cross-attention
            attention_weight_dec_cross: projection matrix for the output in the decoder's cross-attention
            W1_dec, b1_dec, W2_dec, b2_dec: feed-forward network weights and biases for the decoder
            W_embed_out: projection matrix for mapping decoder outputs to the vocabulary, shape (d_model, vocab_size)
            b_embed_out: bias vector for mapping decoder outputs to the vocabulary, shape (vocab_size,)
            src_mask: mask for the source sequence, shape (src_len, src_len)
            tgt_mask: mask for the target sequence, shape (tgt_len, tgt_len)

        Outputs:
            Tuple[Dict[str, np.ndarray], np.ndarray]:
            - grads: dictionary containing gradients for all trainable weights and biases, including:
                - intrinsic_value_weight_enc, response_weight_enc, information_weight_enc, attention_weight_enc: gradients for encoder self-attention weights
                - W1_enc, b1_enc, W2_enc, b2_enc: gradients for encoder feed-forward network
                - intrinsic_value_weight_dec_masked, response_weight_dec_masked, information_weight_dec_masked, attention_weight_dec_masked: gradients for decoder masked self-attention weights
                - intrinsic_value_weight_dec_cross, response_weight_dec_cross, information_weight_dec_cross, attention_weight_dec_cross: gradients for decoder cross-attention weights
                - W1_dec, b1_dec, W2_dec, b2_dec: gradients for decoder feed-forward network
                - W_embed_out, b_embed_out: gradients for output projection layer
            - dx_enc1: gradient with respect to the encoder input, shape (batch_size, src_len, d_model)
    """

    #this is how backprop is implemented
    batch, length, d_model=dec_out.shape  #first, extract the output of the decoder. what we are really interested in is the model dimension
    vocab_size=W_embed_out.shape[1]  #and get the vocabulary size

    #start: backprop through the final layer
    
    dW_embed_out=dec_out.reshape(-1, d_model).T@dprobs.reshape(-1, vocab_size)  # Shape: (d_model, vocab_size)
    db_embed_out=dprobs.sum(axis=(0,1))  # Shape: (vocab_size,)
    d_dec_out=dprobs @ W_embed_out.T  # Gradient w.r.t decoder output, shape (batch, tgt_len, d_model)

    #get all values from the decoder - this is called 'unpacking'
    (x, x2, x3,
     x_norm_dec1, x2_norm_dec, x3_norm_dec,
     mean_dec1, var_dec1, mean_dec2, var_dec2, mean_dec3, var_dec3,
     masked_attn_w, cross_attn_w, ff_cache_dec)=dec_cache

    #backprop through the feedforward neural network for the decoder
    d_x3_ff=d_dec_out
    d_x3_ff, dW1_dec, db1_dec, dW2_dec, db2_dec=feed_forward_backprop(d_x3_ff, x3_norm_dec, W1_dec, b1_dec, W2_dec, b2_dec, ff_cache_dec)
    dx3_norm=d_x3_ff
    dx3=layer_norm_backprop(dx3_norm, x3_norm_dec, mean_dec3, var_dec3)
    d_x3_skip=dx3

    #backprop through crossattention
    d_x2_cross=d_x3_skip
    dx_cross_Q, dx_cross_K, dx_cross_V, dintrinsic_value_weight_dec_cross_, dresponse_weight_dec_cross_, dinformation_weight_dec_cross_, dattention_weight_dec_cross_ = mha_backprop(
        d_x2_cross, x2_norm_dec, enc_out, enc_out,
        intrinsic_value_weight_dec_cross, response_weight_dec_cross, information_weight_dec_cross, attention_weight_dec_cross,
        cross_attn_w, num_heads=2
    )
    d_x2_skip=dx_cross_Q
    d_enc_out=dx_cross_K+dx_cross_V

    #backprop through masked selfattention
    d_x2_masked=d_x2_skip
    dx_masked_Q, dx_masked_K, dx_masked_V, dintrinsic_value_weight_dec_masked_, dresponse_weight_dec_masked_, dinformation_weight_dec_masked_, dattention_weight_dec_masked_ = mha_backprop(
        d_x2_masked, x_norm_dec1, x_norm_dec1, x_norm_dec1,
        intrinsic_value_weight_dec_masked, response_weight_dec_masked, information_weight_dec_masked, attention_weight_dec_masked,
        masked_attn_w, num_heads=2, mask=tgt_mask
    )
    dx_norm_dec1=dx_masked_Q+dx_masked_K+dx_masked_V
    dx_dec1=layer_norm_backprop(dx_norm_dec1, x_norm_dec1, mean_dec1, var_dec1)

    dx2_norm=d_x2_cross
    dx2=layer_norm_backprop(dx2_norm, x2_norm_dec, mean_dec2, var_dec2)

    #combine different layers' gradients
    dx=dx_dec1+dx2

    #unpack encoder values
    (enc_x, enc_x2, enc_x_norm, enc_x2_norm, enc_mean1, enc_var1, enc_mean2, enc_var2, enc_attn_w, enc_ff_cache)=enc_cache

    #backprop through the encoder
    d_enc=d_enc_out
    d_enc_ff, dW1_enc, db1_enc, dW2_enc, db2_enc=feed_forward_backprop(d_enc, enc_x2_norm, W1_enc, b1_enc, W2_enc, b2_enc, enc_ff_cache)
    d_enc2_norm=d_enc_ff
    d_enc2=layer_norm_backprop(d_enc2_norm, enc_x2_norm, enc_mean2, enc_var2)

    #backprop through encoder's attention
    dx_enc_Q, dx_enc_K, dx_enc_V, dintrinsic_value_weight_enc_, dresponse_weight_enc_, dinformation_weight_enc_, dattention_weight_enc_=mha_backprop(
        d_enc2, enc_x_norm, enc_x_norm, enc_x_norm,
        intrinsic_value_weight_enc, response_weight_enc, information_weight_enc, attention_weight_enc,
        enc_attn_w, num_heads=2
    )
    d_enc_norm1=dx_enc_Q+dx_enc_K+dx_enc_V
    dx_enc1=layer_norm_backprop(d_enc_norm1, enc_x_norm, enc_mean1, enc_var1)

    #combine all gradients in a dictionary 
    grads = {
        'intrinsic_value_weight_enc': dintrinsic_value_weight_enc_, 'response_weight_enc': dresponse_weight_enc_, 'information_weight_enc': dinformation_weight_enc_, 'attention_weight_enc': dattention_weight_enc_,
        'W1_enc': dW1_enc, 'b1_enc': db1_enc, 'W2_enc': dW2_enc, 'b2_enc': db2_enc,
        'intrinsic_value_weight_dec_masked': dintrinsic_value_weight_dec_masked_, 'response_weight_dec_masked': dresponse_weight_dec_masked_, 'information_weight_dec_masked': dinformation_weight_dec_masked_, 'attention_weight_dec_masked': dattention_weight_dec_masked_,
        'intrinsic_value_weight_dec_cross': dintrinsic_value_weight_dec_cross_, 'response_weight_dec_cross': dresponse_weight_dec_cross_, 'information_weight_dec_cross': dinformation_weight_dec_cross_, 'attention_weight_dec_cross': dattention_weight_dec_cross_,
        'W1_dec': dW1_dec, 'b1_dec': db1_dec, 'W2_dec': dW2_dec, 'b2_dec': db2_dec,
        'W_embed_out': dW_embed_out, 'b_embed_out': db_embed_out
    }

    return grads, dx_enc1

###############################################################################
# Main Training Setup
###############################################################################


#we are finally done. let's now train the actual transformer
english_sentences=[
    "My rabbit likes bananas"
]

italian_sentences=[
    "Al mio coniglio piacciono le banane",
]

eng_tokens=[whitespace_tokenizer(s) for s in english_sentences]
for_tokens=[whitespace_tokenizer(s) for s in italian_sentences]

eng_word2idx, eng_idx2word=build_vocab(eng_tokens)
for_word2idx, for_idx2word=build_vocab(for_tokens)

def encode(tokens, w2i):
    return [w2i[t] for t in tokens]

eng_encoded=[encode(t, eng_word2idx) for t in eng_tokens]
for_encoded=[encode(t, for_word2idx) for t in for_tokens]

max_eng_len=max(len(x) for x in eng_encoded)
max_for_len=max(len(x) for x in for_encoded)

# Add start/end tokens
start_token=len(for_word2idx)
end_token=len(for_word2idx)+1
for_word2idx["<start>"]=start_token
for_word2idx["<end>"]=end_token
for_idx2word[start_token]="<start>"
for_idx2word[end_token]="<end>"

for_idx2word={idx: token for token, idx in for_word2idx.items()}

for_encoded_input=[[start_token]+seq for seq in for_encoded]
for_encoded_target=[seq+[end_token] for seq in for_encoded]

max_for_len_inp=max(len(s) for s in for_encoded_input)
max_for_len_tgt=max(len(s) for s in for_encoded_target)

eng_padded=pad_sequences(eng_encoded, max_length=max_eng_len, pad_value=0)
for_inp_padded=pad_sequences(for_encoded_input, max_length=max_for_len_inp, pad_value=0)
for_tgt_padded=pad_sequences(for_encoded_target, max_length=max_for_len_tgt, pad_value=0)

batch_size=len(eng_padded)
src_len=eng_padded.shape[1]
tgt_len=for_inp_padded.shape[1]
vocab_size_src=len(eng_word2idx)
vocab_size_tgt=len(for_word2idx)
d_model=16 #this is arbitrary. many AI companies sell access to their embeddings and dimensions

src_embeddings=np.random.randn(vocab_size_src, d_model)*0.01 #i chose 0.01 for a balance between numerical stability and demonstrating the power of transformers
tgt_embeddings=np.random.randn(vocab_size_tgt, d_model)*0.01

#we haven't actually defined the embedding function- let's embed our vocabulary
def embed(x, emb):
    return emb[x] 

#this next section is just defining random matrices

W_embed_out=np.random.randn(d_model, vocab_size_tgt)*0.01 #define this random matrix for embedding
b_embed_out=np.zeros(vocab_size_tgt) #and the bias of the weights as well

intrinsic_value_weight_enc=np.random.randn(d_model, d_model)*0.01 
response_weight_enc=np.random.randn(d_model, d_model)*0.01
information_weight_enc=np.random.randn(d_model, d_model)*0.01
attention_weight_enc=np.random.randn(d_model, d_model)*0.01
W1_enc=np.random.randn(d_model, d_model)*0.01
b1_enc=np.zeros(d_model)
W2_enc=np.random.randn(d_model, d_model)*0.01
b2_enc=np.zeros(d_model)

intrinsic_value_weight_dec_masked=np.random.randn(d_model, d_model)*0.01
response_weight_dec_masked=np.random.randn(d_model, d_model)*0.01
information_weight_dec_masked=np.random.randn(d_model, d_model)*0.01
attention_weight_dec_masked=np.random.randn(d_model, d_model)*0.01

intrinsic_value_weight_dec_cross=np.random.randn(d_model, d_model)*0.01
response_weight_dec_cross=np.random.randn(d_model, d_model)*0.01
information_weight_dec_cross=np.random.randn(d_model, d_model)*0.01
attention_weight_dec_cross=np.random.randn(d_model, d_model)*0.01

W1_dec=np.random.randn(d_model, d_model)*0.01
b1_dec=np.zeros(d_model)
W2_dec=np.random.randn(d_model, d_model)*0.01
b2_dec=np.zeros(d_model)

#here we define the learning rate and epochs
learning_rate=0.01
epochs=20

src_mask=None
tgt_mask=create_mask_for_removing_future_dependency(for_inp_padded)

#and implement the generic neural network training

for epoch in range(epochs):
    enc_inp=embed(eng_padded, src_embeddings)
    dec_inp=embed(for_inp_padded, tgt_embeddings)

    #this is the forward pass
    probs, cache=forward_transformer(enc_inp, dec_inp,
                                       intrinsic_value_weight_enc, response_weight_enc, information_weight_enc, attention_weight_enc, W1_enc, b1_enc, W2_enc, b2_enc,
                                       intrinsic_value_weight_dec_masked, response_weight_dec_masked, information_weight_dec_masked, attention_weight_dec_masked,
                                       intrinsic_value_weight_dec_cross, response_weight_dec_cross, information_weight_dec_cross, attention_weight_dec_cross,
                                       W1_dec, b1_dec, W2_dec, b2_dec,
                                       W_embed_out, b_embed_out,
                                       src_mask, tgt_mask)

    loss=cross_entropy_loss(probs, for_tgt_padded)
    print(f"Epoch {epoch+1}, Loss: {loss}")

    pred_indices=np.argmax(probs, axis=-1)
    for b in range(batch_size):
        predicted_tokens=[for_idx2word[idx] for idx in pred_indices[b]]
        print("Predicted:", " ".join(predicted_tokens))
    
    dprobs=cross_entropy_derivative(probs, for_tgt_padded)

    #this is the backward pass
    grads, dx_enc=backward_transformer(dprobs, enc_inp, dec_inp, *cache,
                                         intrinsic_value_weight_enc, response_weight_enc, information_weight_enc, attention_weight_enc, W1_enc, b1_enc, W2_enc, b2_enc,
                                         intrinsic_value_weight_dec_masked, response_weight_dec_masked, information_weight_dec_masked, attention_weight_dec_masked,
                                         intrinsic_value_weight_dec_cross, response_weight_dec_cross, information_weight_dec_cross, attention_weight_dec_cross,
                                         W1_dec, b1_dec, W2_dec, b2_dec,
                                         W_embed_out, b_embed_out,
                                         src_mask, tgt_mask)

    #update all parameters after backprop
    intrinsic_value_weight_enc-=learning_rate*grads['intrinsic_value_weight_enc']
    response_weight_enc-=learning_rate*grads['response_weight_enc']
    information_weight_enc-=learning_rate*grads['information_weight_enc']
    attention_weight_enc-=learning_rate*grads['attention_weight_enc']
    W1_enc-=learning_rate*grads['W1_enc']
    b1_enc-=learning_rate*grads['b1_enc']
    W2_enc-=learning_rate*grads['W2_enc']
    b2_enc-=learning_rate*grads['b2_enc']

    intrinsic_value_weight_dec_masked-=learning_rate*grads['intrinsic_value_weight_dec_masked']
    response_weight_dec_masked-=learning_rate*grads['response_weight_dec_masked']
    information_weight_dec_masked-=learning_rate*grads['information_weight_dec_masked']
    attention_weight_dec_masked-=learning_rate*grads['attention_weight_dec_masked']

    intrinsic_value_weight_dec_cross-=learning_rate*grads['intrinsic_value_weight_dec_cross']
    response_weight_dec_cross-=learning_rate*grads['response_weight_dec_cross']
    information_weight_dec_cross-=learning_rate*grads['information_weight_dec_cross']
    attention_weight_dec_cross-=learning_rate*grads['attention_weight_dec_cross']

    W1_dec-=learning_rate*grads['W1_dec']
    b1_dec-=learning_rate*grads['b1_dec']
    W2_dec-=learning_rate*grads['W2_dec']
    b2_dec-=learning_rate*grads['b2_dec']

    W_embed_out-=learning_rate*grads['W_embed_out']
    b_embed_out-=learning_rate*grads['b_embed_out']

# After training, you can use the decoder in inference mode by feeding
# previously generated tokens (shifted) as input to the decoder and applying
# the masked multi-head attention to predict the next token

```

    Epoch 1, Loss: 2.0795187664172397
    Predicted: banane coniglio banane banane <start> piacciono <end>
    Epoch 2, Loss: 2.0793373726502367
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 3, Loss: 2.0791564355830636
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 4, Loss: 2.078974718625546
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 5, Loss: 2.0787933552602227
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 6, Loss: 2.0786123118403346
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 7, Loss: 2.078431551323341
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 8, Loss: 2.078251032354273
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 9, Loss: 2.0780707083355354
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 10, Loss: 2.0778905181441116
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 11, Loss: 2.077710390742451
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 12, Loss: 2.077530273264538
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 13, Loss: 2.0773500940542484
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 14, Loss: 2.0771697955319044
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 15, Loss: 2.0769892772510743
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 16, Loss: 2.07680845041442
    Predicted: banane coniglio banane banane mio piacciono <end>
    Epoch 17, Loss: 2.0766272061537157
    Predicted: banane coniglio banane banane coniglio piacciono <end>
    Epoch 18, Loss: 2.0764454984062057
    Predicted: banane coniglio banane banane coniglio piacciono <end>
    Epoch 19, Loss: 2.076263321722837
    Predicted: banane coniglio banane banane coniglio piacciono <end>
    Epoch 20, Loss: 2.0760807185682095
    Predicted: banane coniglio banane banane coniglio piacciono <end>


### Observations

Well, after all of that, this poor of a performance is what we got? This is true. We were translating only one sequence, after all. Where transformers really excel is at scale, because of the differentiable attention matrix which can be parallelized. But you can see how it gets stuck depending on different learning rates and initialization. One of the difficulties is initialization to make gradient descent helpful. Xavier initialization could have worked, but it is much better to do it with numpy to get real understanding.

### Conclusion

This aims to be an implementation of transformers that works, end-to-end, in numpy. No pointing to paper that blew up - Attention is All You Need (no, not it isn't). No awkward discussions of 'keys', 'values', 'queries' (replaced with _fundamental_ names instead). No list of mathematical formulas for different attention mechanisms with 'choose what you want'. No describing the transformer architecture in a way that is essentially 'just look at the figure'. No code snippets without explanation for the basics. For the last point, the final implementation is, in fact, annoying. The assumption is that you read this point from start to end. However there is something I have not mentioned at all. That something is **automatic differentiation**.

#### Automatic Differentiation

You may have noticed just how obnoxious implementing backpropagation was. Every single function had to be done manually. Was there a way we could have done it recursively? The answer is yes. This is called _automatic differentiation_. Automatic differentiation relies on the technique that all mathematical operations done by a computer are at the end pulled from basic arithmetic functions, since that's what's implemented on their circuit boards. Therefore, all computations of functions are inherently limited by this. Even though multiplication is not repeated addition, to a computer it is. Libraries exist entirely to implement backpropagation and automatic differentiation for user-defined functions. One such library is **PyTorch**. It implements automatic differentiation and abstracts it away, allowing users to define new functions and not worry about how backpropagation deals with that object. How would the transformer from scratch look like in PyTorch? [:)](https://github.com/IParraMartin/An-Explanation-Is-All-You-Need/blob/main/model.py)
