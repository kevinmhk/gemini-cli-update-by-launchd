# Project Overview

This directory contains a set of scripts to create, manage, and remove a `launchd` agent on macOS. The agent's purpose is to automatically update the `@google/gemini-cli` npm package once a week (every Sunday at 2:00 PM).

This approach uses standard macOS tooling (`launchd`, `launchctl`) to provide a reliable, scheduled task that can run even if the computer was asleep at the scheduled time.

## Key Files

*   `install.sh`: This is the main installation script. It performs the following steps:
    1.  Finds the absolute path to the user's `npm` executable.
    2.  Replaces a placeholder in the `com.google.gemini.cli.update.plist` template with the correct `npm` path.
    3.  Copies the updated `.plist` file to `~/Library/LaunchAgents/`.
    4.  Loads the agent into `launchd` using `launchctl`, activating the weekly update schedule.

*   `uninstall.sh`: This script safely removes the auto-update service. It performs the following steps:
    1.  Stops and unloads the `launchd` agent using `launchctl`.
    2.  Deletes the `.plist` file from `~/Library/LaunchAgents/`.

*   `com.google.gemini.cli.update.plist`: This is an XML-based property list file used to configure the `launchd` agent. It defines:
    *   The `Label` (a unique identifier for the agent).
    *   The `ProgramArguments` (the command to run: `npm install -g @google/gemini-cli`).
    *   The `StartCalendarInterval` (the schedule for the task).
    *   Paths for `StandardOutPath` and `StandardErrorPath` for logging.

*   `README.md`: The primary documentation file for a human reader, explaining the project's design and usage.

*   `prompts.md`: Contains the original prompt used to instruct the Gemini CLI to generate this project.

## Usage

The primary interaction with this project is through the `install.sh` and `uninstall.sh` scripts.

*   **To install the auto-updater:**
    ```bash
    ./install.sh
    ```

*   **To uninstall the auto-updater:**
    ```bash
    ./uninstall.sh
    ```
