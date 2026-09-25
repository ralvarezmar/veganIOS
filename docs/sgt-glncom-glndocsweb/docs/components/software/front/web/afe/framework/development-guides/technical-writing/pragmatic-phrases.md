# Pragmatic phrases

As devs, we like to write shorter code for a number of reasons. These reasons also apply to more objective documentation, such as faster reading and ease of maintenance. Short sentences (sentences) communicate more powerfully than long sentences.

## Each sentence should communicate only one idea or context (sole responsibility)

Here's an example of a long sentence that communicates a lot of ideas:

❌ > **Long sentence with lots of ideas**
>
> *The late 1950s were a pivotal era for programming languages because IBM introduced Fortran in 1957 and John McCarthy introduced Lisp the following year, which gave programmers an iterative or recursive way to solve problems.*

Now here's an example of the same sentence, broken down into smaller sentences:

✅ > **Short sentences, only one topic per sentence**
>
> *The late 1950s were a key era for programming languages. IBM introduced Fortran in 1957. John McCarthy invented the Lisp the following year. As a result, by the late 1950s, programmers could solve problems iteratively or recursively.*

Now, it's easy to identify the topics in the paragraph, since each sentence communicates only one idea.

## Convert Very Long Sentences to Lists

Behind a long technical phrase, there's a list wanting to break free. Here's an example:

❌ > **Sentence too long**
>
> To change the normal flow of a loop, you can use a break statement (which takes it out of the current loop) or a continue statement (which skips the rest of the current iteration of the current loop).

Faced with a long sentence, consider refactoring that sentence into a bulleted list. The preceding example contains the conjunction **or**, which we'll convert to a bulleted list:

✅ > **Long sentence, converted to list**
>
> To change the normal flow of a loop, call one of the following statements:
>
> - break, which takes you out of the current loop
> - continue, which skips the remainder of the current iteration of the current loop

## Eliminate "filler" words

It is common to find sentences with words that are in the sentence just to make volume, without adding to the meaning. Take a look at this sentence and see if you identify the "filler words":

❌ > **Sentence with filler words**
>
> Input value greater than 100 causes the log to fire.

Replacing **causes triggering** with the verb **triggers** produces a shorter sentence:

✅ > **Sentence with no filler words**
>
> Input values greater than 100 trigger logging. Here are some common substitutions:

|Long-winded |Concise |
| ---------- | ----------------- |
|right now | Now |
|determine the location of| Find |
|is able | can|
