# Task logger

Command line tool for logging your daily tasks.

Tasks belongs to a project and can be categorized.

This tool can integrate with external services such us [minutedock](https://minutedock.com/).

## Installation

You will need ruby and bundler installed.
```bash
git clone git@github.com:delbetu/task_logger.git
cd task_logger
bundle install
```

## Runnig test

```bash
bundle exec rspec
```

## Running and usage

### Configure categories and projects

When logging a task you will be prompted to select a category and a project.
Those lists are loaded from the `proyects.yml` and `categories.yml`.

Copy samples and edit them in the way that better fits your job.
```bash
cp config/projects.yml.example config/projects.yml
cp config/categories.yml.example config/task_categories.yml
```

### Configure external services

If you have a [minutedock](https://minutedock.com) account you can send
the tasks you have logged to this service.

Get your api keys from minutedock.
```bash
cp config/minutedock_credentials.yml.example config/minutedock_credentials.yml
```
Edit this file and paste your credentials.

### Usage

Run
```bash
ruby ui
```
and fill up the questions.

## Code sample

Since this code is meant to be a show case I encourage reader to follow the commits in order.

This project was developed using TDD. Every commit is a baby step easy to understand.

The pieces of code are divided on **UI**, **Interactor** and **IO-Objects**.

**UI**
  - Manage user data flowing in and out of the system.
  - Sends message to Interactors

**Interactor**
  - Recieves petitions from the UI
  - Implements bussiness logic by Interacting with IO-Objects

**IO-Objects**
  - Interact with one IO-device (storage or network) by wrapping a third-party library.

### Development process

This was build using TDD.
First thinking of how UI would interact with user and then deciding what functions the Interactor object should provide.
Then start proggramming the outer TDD loop over the interactor stubbing out IO-objects.
After that the interface for the IO-object was revealed so the inner TDD loop starts.

## Feel free to comment
