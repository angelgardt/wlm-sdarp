#!/usr/bin/env Rscript
# ==============================================================================
# WLM SDARP — GitHub Pages Deployment Script
# ==============================================================================
# Usage:
#   ## to see script version
#     Rscript scripts/deploy.R -v
#   ## to see help
#     Rscript scripts/deploy.R -h
#     Rscript scripts/deploy.R --help
#   ## to run deploy
#     Rscript scripts/deploy.R --project book --profile ru
#   ## to run test deploy without pushing to GitHub
#     Rscript scripts/deploy.R --project book --profile ru --dry-run
# ==============================================================================

# --- Load dependencies --------------------------------------------------------
suppressPackageStartupMessages({
  library(docopt)
  library(fs)
  library(processx)
  library(yaml)
})


# --- Documentation for docopt --------------------------------------------------
doc <- "
Deploy projects of WLM SDARP to GitHub Pages.
Run the command
    to see script version
      Rscript scripts/deploy.R -v
    to see help
      Rscript scripts/deploy.R -h
      Rscript scripts/deploy.R --help
    to run deploy
      Rscript scripts/deploy.R --project book --profile ru
    to run test deploy without pushing to GitHub
      Rscript scripts/deploy.R --project book --profile ru --dry-run

Usage:
  deploy.R [options]

Options:
  -h --help            Show this message
  -v                   Show script version
  --profile=<prof>     Language profile
  --project=<proj>     Quarto project to deploy
  --dry-run            Test run without git push
"


# --- Helpers --------------------------------------------------

log_info <- function(..., to_file = TRUE) {
  cat(sprintf("[INFO] %s\n", paste0(...)), file = stderr())
  if (to_file)
  {
    cat(sprintf("[INFO] %s\n", paste0(...)), file = LOGFILE, append = TRUE)
  }
}

log_success <- function(..., to_file = TRUE) {
  cat(sprintf("[OK] %s\n", paste0(...)), file = stderr())
  if (to_file) {
    cat(sprintf("[OK] %s\n", paste0(...)), file = LOGFILE, append = TRUE)
  }
}

log_error <- function(..., to_file = TRUE) {
  cat(sprintf("[ERROR] %s\n", paste0(...)), file = stderr())
  if (to_file) {
    cat(sprintf("[ERROR] %s\n", paste0(...)), file = LOGFILE, append = TRUE)
  }
}

stop_with_error <- function(..., to_file = TRUE) {
  log_error(..., to_file = to_file)
  quit(status = 1)
}

run_cmd <- function(cmd, args, echo = TRUE, error_on_status = TRUE, to_file = TRUE) {
  if (echo) log_info(sprintf("Running: %s %s", cmd, paste(args, collapse = " ")), to_file = to_file)
  result <- processx::run(cmd, args, echo = echo, error_on_status = error_on_status)
  if (error_on_status && result$status != 0) {
    stop_with_error(sprintf("Command failed: %s %s", cmd, paste(args, collapse = " ")), to_file = to_file)
  }
  return(result)
}

get_current_branch <- function() {
  result <- run_cmd("git", c("rev-parse", "--abbrev-ref", "HEAD"),
                    echo = FALSE, error_on_status = TRUE)
  trimws(result$stdout)
}

get_current_commit_hash <- function() {
  result <- run_cmd("git", c("rev-parse", "--short", "HEAD"),
                    echo = FALSE, error_on_status = TRUE)
  trimws(result$stdout)
}

get_repo_url <- function() {
  result <- run_cmd("git", c("config", "--get", "remote.origin.url"),
                    echo = FALSE, error_on_status = TRUE)
  trimws(result$stdout)
}

# --- Set logging ----------------------------------------------------------
LOGDIR <- "scripts/logs/deploy"
if (!fs::dir_exists(LOGDIR)) {
  fs::dir_create(LOGDIR, recurse = TRUE)
}

LOGFILE <- fs::path(LOGDIR, Sys.time(), ext = "log")
fs::file_create(LOGFILE)


# --- Read config & meta -----------------------------------------------
CONFIG_PATH <- "scripts/.config-deploy.yml"
META_PATH <- "book/_metadata.yml"

if (fs::file_exists(CONFIG_PATH)) {
  CONFIG <- read_yaml("scripts/.config-deploy.yml")
} else {
  log_error("No config file")
  quit(status = 1)
}

if (fs::file_exists(META_PATH)) {
  META <- read_yaml("book/_metadata.yml")
} else {
  log_error("No meta file")
  quit(status = 1)
}


# --- Parse args -------------------------------------------------------
opts <- docopt(doc)

# Handle -v flag (script version)
if (isTRUE(opts$`-v`)) {
  cat(sprintf("deploy.R version %s\n", CONFIG$script$version))
  quit(status = 0)
}


# --- Step 0: Validation -------------------------------------------------

# --- Validate version & stage ----------------------------------------------------------
cat("\n=== Version Validation ===\n")
cat(sprintf("  Version found in metadata: %s\n", META$version))

VERSION_PATTERN <- "^[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"
STAGES <- Map(\(x) x$name,
              CONFIG$valid$version$stage) |>
  unlist()
STAGE_PATTERN <- paste0("-?(", paste0(STAGES, collapse = "|"), ")")

if (grepl(paste0(VERSION_PATTERN, STAGE_PATTERN), META$version)) {
  log_success("Version validated successfully")
} else {
  msg <- "Unknown version format.
  Only these are available:
    [MAJOR].[MINOR].[PATCH]-alpha
    [MAJOR].[MINOR].[PATCH]-beta
    [MAJOR].[MINOR].[PATCH]-stable
  "
  log_error(msg)
}

VERSION <- sub(pattern = STAGE_PATTERN, replacement = "", x = META$version)
STAGE <- sub(pattern = VERSION_PATTERN, replacement = "", x = META$version) |>
  sub(pattern = "-", replacement = "", x = _)


# --- Validate inputs -------------------------------------------------
cat("\n=== Input Validation ===\n")

DRY_RUN <- isTRUE(opts$`--dry-run`)

PROFILE <- opts$`--profile`
if (!PROFILE %in% CONFIG$valid$profiles) {
  stop_with_error(sprintf("Invalid --profile. Allowed: %s",
                          paste(CONFIG$valid$profiles, collapse = ", ")))
}

PROJECT <- opts$`--project`
if (!PROJECT %in% CONFIG$valid$projects) {
  stop_with_error(sprintf("Invalid --project. Allowed: %s",
                          paste(CONFIG$valid$projects, collapse = ", ")))
}

if (STAGE == "stable") {
  TAG <- paste0(CONFIG$archive$`tag-prefix`, VERSION)
} else {
  TAG <- NULL
}

log_success("Inputs validated successfully!")


# --- Summary presentation ------------------------------------------
cat("\n=== Deployment Summary ===\n")
cat(sprintf("  Project: %s\n", PROJECT))
cat(sprintf("  Profile: %s\n", PROFILE))
cat(sprintf("  Version: %s\n", VERSION))
cat(sprintf("  Stage: %s\n", STAGE))
if (!is.null(TAG)) cat(sprintf("  Tag: %s\n", TAG))
cat(sprintf("  Dry run: %s\n", ifelse(DRY_RUN, "YES (no push)", "NO")))


# --- Validate branch ----------------------------------------------------------
cat("\n=== Branch Validation ===\n")
BRANCHES <- Map(\(x) x$branch, CONFIG$valid$version$stage) |> unlist()

CURRENT_BRANCH <- get_current_branch()
log_info(sprintf("Current branch: %s", CURRENT_BRANCH))

if (!CURRENT_BRANCH %in% BRANCHES) {
  stop_with_error(sprintf(
    "Deployment from the %s branch is prohibited!\n
    Switch to %s to deploy %s respectively.",
    CURRENT_BRANCH,
    paste(BRANCHES, collapse = ", "),
    paste(STAGES, collapse = ", ")
    )
  )
} else if (CURRENT_BRANCH != BRANCHES[which(STAGES == STAGE)]) {
  stop_with_error(sprintf(
    "Only %s versions can be deployed from %s branch.\n For %s, switch to %s",
    STAGES[which(BRANCHES == CURRENT_BRANCH)],
    CURRENT_BRANCH,
    STAGE,
    BRANCHES[which(STAGES == STAGE)]
    )
  )
} else {
  log_info(sprintf("%s deploy from %s branch — allowed",
                   STAGE,
                   CURRENT_BRANCH))
  log_success("Branch validated successfully!")
}


# --- Check project exists -------------------------------------------------
cat("\n=== Check project folder exists ===\n")

PROJECT_PATH <- fs::path(PROJECT)
if (!fs::dir_exists(PROJECT_PATH)) {
  stop_with_error(sprintf("Project folder not found: %s", PROJECT_PATH))
}
log_success("All good!")


# --- Check profile config exists -------------------------------------------------
cat("\n=== Check profile config exists ===\n")

PROFILE_CONFIG <- fs::path(PROJECT, sprintf("_quarto-%s.yml", PROFILE))
if (!fs::file_exists(PROFILE_CONFIG)) {
  stop_with_error(sprintf("Profile config not found: %s", PROFILE_CONFIG))
}
log_success("All good!")


# --- Step 1: Render project -------------------------------------------------

log_info(sprintf("=== STEP 1: Rendering project %s (profile: %s) ===", PROJECT, PROFILE))

render_result <- run_cmd(
  "quarto",
  c("render", PROJECT, "--profile", PROFILE),
  echo = TRUE
)

# Verify _site/<profile> was created
SITE_PATH <- fs::path(PROJECT, "_site", PROFILE)
if (!fs::dir_exists(SITE_PATH)) {
  stop_with_error(sprintf("_site folder not created after render: %s", SITE_PATH))
}

log_success("Rendering completed")


# --- Step 2: Prepare temp folder for gh-pages ---------------------------------

log_info("=== STEP 2: Preparing temp folder ===")

DEPLOY_TEMP <- fs::path(CONFIG$temp, sprintf("gh-pages-deploy-%s", Sys.getpid()))

if (fs::dir_exists(DEPLOY_TEMP)) {
  fs::dir_delete(DEPLOY_TEMP)
}

REPO_URL <- get_repo_url()
if (REPO_URL == "") {
  stop_with_error("Could not get repository URL. Check git remote")
}

# Clone gh-pages with depth 1 for speed
run_cmd(
  "git",
  c("clone", "--depth", "1", "--branch", CONFIG$`gh-pages`$branch,
    REPO_URL, DEPLOY_TEMP),
  echo = TRUE
)

log_success(sprintf("gh-pages cloned to: %s", DEPLOY_TEMP))


# --- Step 3: Copy artifacts ---------------------------------------------------

log_info("=== STEP 3: Copying artifacts ===")

# Determine subpath inside version/
TARGET_SUBPATH <- fs::path(PROJECT, PROFILE)
TARGET_PATH <- fs::path(DEPLOY_TEMP, STAGE, TARGET_SUBPATH)

# Create target folder
fs::dir_create(TARGET_PATH, recurse = TRUE)

# Remove old content (full replacement)
if (fs::dir_exists(TARGET_PATH)) {
  fs::dir_delete(TARGET_PATH)
}

# Copy _site to target folder
fs::dir_copy(SITE_PATH, TARGET_PATH)

log_success(sprintf("Artifacts copied to: %s", fs::path_rel(TARGET_PATH, DEPLOY_TEMP)))

# --- Step 4: Archive to prev/ (stable with tag only) --------------------------

if (STAGE == "stable" && !is.null(TAG)) {

  version_separated <- as.integer(strsplit(VERSION, "\\.")[[1]])
  should_archive <- (length(version_separated >= 3) && version_separated[3] == 0)

  if (should_archive) {
    log_info(sprintf("=== STEP 4: Archiving stable version %s to prev/ ===", TAG))
    archive_subpath <- fs::path(PROJECT, PROFILE)
    archive_path <- fs::path(DEPLOY_TEMP, "prev", TAG, archive_subpath)

    fs::dir_create(archive_path, recursive = TRUE)

    if (fs::dir_exists(archive_path) &&
        length(fs::dir_ls(archive_path)) > 0) {
      stop_with_error(sprintf("Archive for %s already exists. Check version or stage", TAG), to_file = FALSE)
      } else {
        fs::dir_copy(SITE_PATH, archive_path)
        log_success(sprintf("Archive created: %s", fs::path_rel(archive_path, DEPLOY_TEMP)))
      }
  } else {
      log_info(sprintf("Version %s is a patch release, skipping archive", TAG), to_file = FALSE)
  }
}


# --- Step 5: Git commit и push -------------------------------------------------

log_info("=== STEP 5: Commit and push to gh-pages ===")

setwd(DEPLOY_TEMP)

# Configure git user (if not set globally)
run_cmd("git", c("config", "user.name", "Deploy Script"),
        echo = FALSE, error_on_status = FALSE, to_file = FALSE)
run_cmd("git", c("config", "user.email", "deploy@wlm-sdarp.local"),
        echo = FALSE, error_on_status = FALSE, to_file = FALSE)

# Add all changes
run_cmd("git", c("add", "-A"), echo = TRUE, to_file = FALSE)

# Check if there are changes to commit
STATUS_RESULT <- run_cmd("git", c("status", "--porcelain"), echo = FALSE, error_on_status = FALSE, to_file = FALSE)

if (trimws(STATUS_RESULT$stdout) == "") {
  log_info("No changes. Skipping commit.", to_file = FALSE)
} else {
  COMMIT_HASH <- get_current_commit_hash()
  COMMIT_MSG <- sprintf(
    "deploy: %s-%s/%s (%s) from %s@%s",
    VERSION, STAGE, PROJECT, PROFILE, CURRENT_BRANCH, COMMIT_HASH
  )

  if (!is.null(TAG)) {
    COMMIT_MSG <- sprintf("%s [tag: %s]", COMMIT_MSG, TAG)
  }

  run_cmd("git", c("commit", "-m", COMMIT_MSG), echo = TRUE, to_file = FALSE)

  if (DRY_RUN) {
    log_info("DRY RUN: skipping git push", to_file = FALSE)
  } else {
    run_cmd("git", c("push", "origin", CONFIG$`gh-pages`$branch), echo = TRUE, to_file = FALSE)
    log_success(sprintf("Changes pushed to %s", CONFIG$`gh-pages`$branch), to_file = FALSE)
  }
}

setwd("../..")


# --- Step 6: Cleanup ----------------------------------------------------------

log_info("=== STEP 6: Cleanup ===")

fs::dir_delete(DEPLOY_TEMP)
log_success(sprintf("Temp folder deleted: %s", DEPLOY_TEMP))


# --- Final summary ------------------------------------------------------------

cat("\n")
log_success("=== DEPLOYMENT COMPLETED ===\n")

# Build URL for viewing
PAGE_PATH <- fs::path(STAGE, PROJECT, PROFILE, "")

PAGES_URL <- sprintf("https://angelgardt.github.io/%s/%s", CONFIG$`repo-name`, PAGE_PATH)

cat(sprintf("\nProject: %s\n", PROJECT))
cat(sprintf("Profile: %s\n", PROFILE))
cat(sprintf("Version: %s\n", VERSION))
cat(sprintf("Stage: %s\n", STAGE))
if (!is.null(TAG)) {
  cat(sprintf("Tag: %s\n", TAG))
}
cat(sprintf("URL: %s\n", PAGES_URL))

if (DRY_RUN) {
  cat("\nThis was a dry run (--dry-run). Changes were NOT pushed to repository.\n")
}

cat("\n")
