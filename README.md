# Gemini CLI Auto-Update via launchd

This project provides a simple and robust way to automatically keep the `@google/gemini-cli` npm package updated on macOS using the system's native scheduler, `launchd`.

## Design

The core of this solution is a `launchd` agent, which is a service managed by the operating system. Using `launchd` is the standard and most reliable method for running scheduled tasks on macOS. It is superior to `cron` because it will run missed jobs if the computer was asleep or off at the scheduled time.

The process is orchestrated by a simple shell script that:
1.  Finds the correct path to your `npm` executable.
2.  Updates a template `.plist` configuration file with this path.
3.  Copies the configuration file to the `~/Library/LaunchAgents` directory, where macOS looks for user-specific agents.
4.  Loads and starts the agent using the `launchctl` command.

The agent is configured to run `npm install -g @google/gemini-cli` every Sunday at 2:00 PM.

## Files

-   `com.google.gemini.cli.update.plist`: A template for the `launchd` configuration file. The `__NPM_PATH__` placeholder is replaced by the install script.
-   `install.sh`: The main script to set up and install the `launchd` agent.
-   `uninstall.sh`: A script to stop the service and remove the configuration file.
-   `README.md`: This file.

## Usage

### Installation

To install the auto-updater, simply navigate to this directory in your terminal and run the installation script:

```bash
cd /Users/kevinmhk/workspaces/gemini-cli-update-by-launchd
./install.sh
```

The script will handle everything for you.

### Uninstallation

To remove the auto-updater, run the uninstallation script from this directory:

```bash
./uninstall.sh
```

This will stop the service and remove the configuration file from your system.
