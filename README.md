# Reading time

Medium-esque reading stats in elm.

```shell
elm package install chrisbuttery/reading-time
```

If article stats are your thing, you may also like [elm-scroll-progress](https://github.com/chrisbuttery/elm-scroll-progress).

## Usage

```elm
import ReadingTime

str = "I can't believe I ate the whole thing."

ReadingTime.stats str Nothing

{-|
 - { text = "1 min read", minutes = 0.04, time = 2400, words = 8 }
 -}
```

## API

#### stats : String -> Maybe Float

Pass in a string to count and an optional float value to calculate  `word per minute`.

## Example

Try the [example](http://chrisbuttery.github.io/reading-time/example/dist/index.html)


## Building example

Install [Create Elm App](https://github.com/halfzebra/create-elm-app) and run `elm-app build` or `elm-app start` inside of `/example`.


## Tests

```bash
% npm install -g elm-test
% elm-test
```
