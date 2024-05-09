# Deploy WLM SDAR

This directory contains a deploy and release scripts for WLM SDAR project. All scripts are executable.


## Usage

### Render

First, you may want to just (re)render the book without deploy or release. Then, you need to run the following command (from the `wlm-sdar` folder):

```
deploy/run.sh render
```

This command remove old `_book` directory from the `book` folder and render the whole book. Also it creates a log file in `deploy/logs` named by rendering date and time with `render` prefix.


### Deploy

Second, you may want to deploy a current book version to proofreading, testing and debugging. To do this you need to run the following command (from the `wlm-sdar` folder):

```
deploy/run.sh deploy
```

The results will be saved in `docs/dpl/` and available [here](https://angelgardt.github.io/wlm-sdar/dpl/). You will be able to proofread with [Hypothesis](https://web.hypothes.is/). A previous deployed version will be backed up in `deploy/backup`. Also it creates a log file in `deploy/logs` named by deploying date and time with `deploy` prefix.

At the end of the deploying, the `README.md` will be opened automatically. Use it to document the deploy.

You may repeat deploy as many times as you need.


### Release

Finally, you want to release a current version of a book. To do this, run (again, from the `wlm-sdar` folder):

```
deploy/run.sh release
```

Results will be saved to `docs/cr/` and available [here](https://angelgardt.github.io/wlm-sdar/). Previous release will be moved to `docs/prev` folder. Also it creates a log file in `deploy/logs` named by releasing date and time with `release` prefix.

At the end of the releasing, the `README.md` will be opened automatically. Use it to document the release.


## Structure

* `run.sh` is a main executable files
* `modules` contains part of the deploy program (`_deploy.sh`, `_release.sh` and `_render.sh`) and technical `_set-colors.sh`
* `logs` is a folder for saving logs from deploying processes
* `backup` contains a backup of previous deploy
