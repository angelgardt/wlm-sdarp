#!/usr/bin/env Rscript
# ==============================================================================
# WLM SDARP — GitHub Pages Deployment Script
# ==============================================================================
# Usage:
#   Rscript scripts/deploy.R -v               ## to see script version
#   Rscript scripts/deploy.R -h               ## to see help
#   Rscript scripts/deploy.R --help           ## to see help
#   Rscript scripts/deploy.R --dry-run        ## to run test deploy without pushing to GitHub
#   Rscript scripts/deploy.R                  ## to run deploy
# ==============================================================================

# --- Load dependencies --------------------------------------------------------
suppressPackageStartupMessages({
  library(docopt)
  library(fs)
  library(processx)
  library(yaml)
})

# --- Read config & meta -----------------------------------------------
config <- read_yaml("scripts/.config-deploy.yml")
meta <- read_yaml("book/_metadata.yml")

# SCRIPT_VERSION <- config$script$version
# REPO_NAME <- config$`repo-name`
# GH_PAGES_BRANCH <- config$`gh-pages`$branch
# VALID_VERSIONS <- config$valid$versions
# VALID_PROJECTS <- config$valid$projects
# VALID_PROFILES <- config$valid$profiles
# TEMP_DIR <- config$temp

# --- Documentation for docopt --------------------------------------------------
doc <- "
Deploy projects of WLM SDARP to GitHub Pages.
Just run the command
    Rscript scripts/deploy.R
and follow the instructions.

Usage:
  deploy.R [options]

Options:
  -h --help            Show this message
  -v                   Show script version
  --dry-run            Test run without git push
"

# --- Parse args -------------------------------------------------------
opts <- docopt(doc)

# Handle -v flag (script version)
if (isTRUE(opts$`-v`)) {
  cat(sprintf("deploy.R version %s\n", config$script$version))
  quit(status = 0)
}

### ____TESTING____
# if (isTRUE(opts$`--dry-run`)) {
#   cat("dry-run\n")
#   quit(status = 0)
# }
# 
# cat("go\n")
# quit(status = 0)

# --- Helpers --------------------------------------------------

log_info <- function(...) {
  cat(sprintf("[INFO] %s\n", paste0(...)), file = stderr())
  cat(sprintf("[INFO] %s\n", paste0(...)), file = LOGFILE, append = TRUE)
}

log_success <- function(...) {
  cat(sprintf("[OK] %s\n", paste0(...)), file = stderr())
  cat(sprintf("[OK] %s\n", paste0(...)), file = LOGFILE, append = TRUE)
}

log_error <- function(...) {
  cat(sprintf("[ERROR] %s\n", paste0(...)), file = stderr())
  cat(sprintf("[ERROR] %s\n", paste0(...)), file = LOGFILE, append = TRUE)
}

stop_with_error <- function(...) {
  log_error(...)
  quit(status = 1)
}

run_cmd <- function(cmd, args, echo = TRUE, error_on_status = TRUE) {
  if (echo) log_info(sprintf("Running: %s %s", cmd, paste(args, collapse = " ")))
  result <- processx::run(cmd, args, echo = echo, error_on_status = error_on_status)
  if (error_on_status && result$status != 0) {
    stop_with_error(sprintf("Command failed: %s %s", cmd, paste(args, collapse = " ")))
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

# --- Validate version & stage ----------------------------------------------------------

VERSION_PATTERN <- "^[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]+"
STAGE_PATTERN <- "-?(alpha|beta|stable)$"

if (grepl(paste0(VERSION_PATTERN, STAGE_PATTERN), meta$version)) {
  log_success("Version successfully validated!")
} else {
  msg <- "Unknown version format.
  Only these are available:
    [MAJOR].[MINOR].[PATCH]-alpha
    [MAJOR].[MINOR].[PATCH]-beta
    [MAJOR].[MINOR].[PATCH]-stable
  "
  log_error(msg)
}


# --- Get arguments for deploy ----------------------------------------------------------

DRY_RUN <- isTRUE(opts$`--dry-run`)
VERSION <- sub(pattern = STAGE_PATTERN, 
               replacement = "", 
               x = meta$version)
STAGE <- sub(pattern = VERSION_PATTERN, 
             replacement = "", 
             x = meta$version) |> 
  sub(pattern = "^-", 
      replacement = "", 
      x = _)

cat("Select project:\n")
cat(paste(1:length(config$valid$projects), config$valid$projects, sep = ". "), sep = "\n")
PROJECT <- config$valid$projects[as.numeric(readline())]

cat("Select profile:\n")
cat(paste(1:length(config$valid$profiles), config$valid$profiles, sep = ". "), sep = "\n")
PROFILE <- config$valid$profiles[as.numeric(readline())]

cat("Project:", PROJECT)
cat("Profile:", PROJECT)

quit(status = 0)

# --- Validate branch ----------------------------------------------------------


current_branch <- get_current_branch()
log_info(sprintf("Current branch: %s", current_branch))

if (current_branch == "dev") {
  if (version != "alpha") {
    stop_with_error(sprintf(
      "Only alpha versions can be deployed from %s.\n For %s, switch to master: git checkout master",
      current_branch, version
    ))
  }
  log_info("Alpha deploy from dev branch — allowed")
} else if (current_branch == "master") {
  if (version == "alpha") {
    log_info("Warning: alpha deploy from master. Usually alpha is deployed from */dev.")
  }
  log_info(sprintf("%s deploy from master — allowed", version))
} else {
  stop_with_error(
    "Deploy is only allowed from '*/dev' or 'master'.\n",
    sprintf("Current branch: %s\n", current_branch),
    "Switch to: git checkout dev  or  git checkout master",
  )
}

# --- Check project exists -------------------------------------------------

project_path <- fs::path(project)
if (!fs::dir_exists(project_path)) {
  stop_with_error(sprintf("Project folder not found: %s", project_path))
}

# --- Check profile config exists -------------------------------------------------

profile_config <- fs::path(project, sprintf("_quarto-%s.yml", profile))
if (!fs::file_exists(profile_config)) {
  stop_with_error(sprintf("Profile config not found: %s", profile_config))
}

# --- Step 1: Render project -------------------------------------------------

log_info(sprintf("=== STEP 1: Rendering project %s (profile: %s) ===", project, profile))

render_result <- run_cmd(
  "quarto",
  c("render", project, "--profile", profile),
  echo = TRUE
)

# Verify _site/<profile> was created
site_path <- fs::path(project, "_site", profile)
if (!fs::dir_exists(site_path)) {
  stop_with_error(sprintf("_site folder not created after render: %s", site_path))
}

log_success("Rendering completed")

# --- Step 2: Prepare temp folder for gh-pages ---------------------------------

log_info("=== STEP 2: Preparing temp folder ===")

deploy_temp <- fs::path(TEMP_DIR, sprintf("gh-pages-deploy-%s", Sys.getpid()))

if (fs::dir_exists(deploy_temp)) {
  fs::dir_delete(deploy_temp)
}

repo_url <- get_repo_url()
if (repo_url == "") {
  stop_with_error("Could not get repository URL. Check git remote")
}

# Clone gh-pages with depth 1 for speed
run_cmd(
  "git",
  c("clone", "--depth", "1", "--branch", GH_PAGES_BRANCH, repo_url, deploy_temp),
  echo = TRUE
)

log_success(sprintf("gh-pages cloned to: %s", deploy_temp))

# --- Step 3: Copy artifacts ---------------------------------------------------

log_info("=== STEP 3: Copying artifacts ===")

# Determine subpath inside version/
target_subpath <- fs::path(project, profile)
target_path <- fs::path(deploy_temp, version, target_subpath)

# Create target folder
fs::dir_create(target_path, recursive = TRUE)

# Remove old content (full replacement)
if (fs::dir_exists(target_path)) {
  fs::dir_delete(target_path)
}

# Copy _site to target folder
fs::dir_copy(site_path, target_path)

log_success(sprintf("Artifacts copied to: %s", fs::path_rel(target_path, deploy_temp)))

# --- Step 4: Archive to prev/ (stable with tag only) --------------------------

if (version == "stable" && !is.null(tag)) { ## ADD CHECK FOR MINOR!!! - smth like str_detect(tag, "\.0$")
  log_info(sprintf("=== STEP 4: Archiving to prev/%s ===", tag))
  
  if (project == "book") {
    prev_subpath <- fs::path("book", profile)
  } else {
    prev_subpath <- "assessment"
  }
  
  prev_path <- fs::path(deploy_temp, "prev", tag, prev_subpath)
  fs::dir_create(prev_path, recursive = TRUE)
  fs::dir_copy(site_path, prev_path)
  
  log_success(sprintf("Archive created: %s", fs::path_rel(prev_path, deploy_temp)))
}

# --- Step 5: Git commit и push -------------------------------------------------

log_info("=== STEP 5: Commit and push to gh-pages ===")

setwd(deploy_temp)

# Configure git user (if not set globally)
run_cmd("git", c("config", "user.name", "Deploy Script"), 
        echo = FALSE, error_on_status = FALSE)
run_cmd("git", c("config", "user.email", "deploy@wlm-sdarp.local"), 
        echo = FALSE, error_on_status = FALSE)

# Add all changes
run_cmd("git", c("add", "-A"), echo = TRUE)

# Check if there are changes to commit
status_result <- run_cmd("git", c("status", "--porcelain"), echo = FALSE, error_on_status = FALSE)

if (trimws(status_result$stdout) == "") {
  log_info("No changes. Skipping commit.")
} else {
  commit_hash <- get_current_commit_hash()
  commit_msg <- sprintf(
    "deploy: %s/%s (%s) from %s@%s",
    version, project, profile, current_branch, commit_hash
  )
  
  if (!is.null(tag)) {
    commit_msg <- sprintf("%s [tag: %s]", commit_msg, tag)
  }
  
  run_cmd("git", c("commit", "-m", commit_msg), echo = TRUE)
  
  if (dry_run) {
    log_info("DRY RUN: skipping git push")
  } else {
    run_cmd("git", c("push", "origin", GH_PAGES_BRANCH), echo = TRUE)
    log_success("Changes pushed to gh-pages")
  }
}

setwd("../..")

# --- Step 6: Cleanup ----------------------------------------------------------

log_info("=== STEP 6: Cleanup ===")

fs::dir_delete(TEMP_DIR)
log_success(sprintf("Temp folder deleted: %s", deploy_temp))

# --- Final summary ------------------------------------------------------------

cat("\n")
log_success("=== DEPLOYMENT COMPLETED ===\n")

# Build URL for viewing
page_path <- fs::path(version, project, profile, "")

pages_url <- sprintf("https://angelgardt.github.io/%s/%s", REPO_NAME, page_path)

cat(sprintf("\nProject: %s\n", project))
cat(sprintf("Profile: %s\n", profile))
cat(sprintf("Version: %s\n", version))
if (!is.null(tag)) {
  cat(sprintf("Tag: %s\n", tag))
}
cat(sprintf("URL: %s\n", pages_url))

if (dry_run) {
  cat("\nThis was a dry run (--dry-run). Changes were NOT pushed to repository.\n")
}

cat("\n")
