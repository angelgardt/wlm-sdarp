# Deploy WLM SDAR

This directory contains a deploy and release scripts for WLM SDAR project. All scripts are executable.

First, you may want to just (re)render the book without deploy or release. Then, you need to run the following command (from the `wlm-sdar` folder):

```
deploy/run.sh render
```

This command remove old `_book` directory from the `book` folder and render the whole book. Also it creates a log file in `deploy/logs` named by rendering date and time with `render` prefix.

To deploy the book for proofreading:

```
deploy/run.sh deploy
```

Results will be saved to `docs/dpl/`.


To release the book:

```
deploy/run.sh release book
```

Results will be saved to `docs/cr/`. Previous release moved to prev.


```
deploy/run.sh render course
```

```
deploy/run.sh deploy course
```


```
deploy/run.sh release course
```
