# Enhanced Software Testing Environment for Python and C

This repository updates and modernizes the TrustInn testing platform. It refactors and modularizes the original codebase, replaces the old Tkinter GUI with a more user-friendly interface, enables installing and managing testing tools independently, and improves documentation and workflows for testing software written in Python and C.

Highlights
- Modular architecture so components (UI, test runners, tools) can be developed and deployed independently
- New, more user-friendly interface that replaces the original Tkinter GUI
- Tool installation and management separated from core runtime — install/uninstall testing tools independently
- Documentation and workflows focused on real-world testing for Python and C projects (plus experimental/optional Solidity support)
- Better developer experience and reproducible test environments

Table of contents
- Overview
- Key features
- Architecture
- Requirements
- Quick start
  - Local development
  - Docker (recommended for reproducible environments)
- Installing testing tools (separately)
- Running tests
  - Python
  - C
- Adding a new tool or test runner
- Configuration
- Troubleshooting
- Contributing
- Contact

Overview
This project purposefully separates concerns:
- Core orchestrator — coordinates test runs, tool invocations, reporting and persistence.
- UI layer — a modern, user-friendly interface in place of the previous Tkinter GUI (modular so a CLI or web front-end can be used).
- Tool modules — wrappers and installers for individual testing tools (linters, static analyzers, coverage, sanitizers, fuzzers, etc.).
- Language workflows — pre-built workflows and examples for Python and C test lifecycles (unit tests, static analysis, sanitizers, fuzzing, coverage).

Key features
- Modularized codebase to make maintenance and extension much easier
- UI replaced with a modern interface (decoupled so teams can choose a web UI, CLI, or other front-ends)
- Install and manage testing tools independently of the core system
- Pre-configured workflows and examples for Python and C
- Experimental / optional support for Solidity language artifacts (kept separate from core Python/C flows)
- Clear docs and templates for adding new tools, rules, and workflows

Architecture
- core/ — orchestrator and workflow engine
- ui/ — user interface (decoupled from core; can be swapped for CLI, web UI, etc.)
- tools/ — installers and adapters for third-party testing tools
- workflows/ — language-specific workflows (python/, c/, solidity/)
- docs/ — repository documentation and examples
(Adjust paths above to match this repository's actual layout — these are logical components to guide contribution and usage.)

Requirements
- Linux or macOS recommended for native C tooling; Windows with WSL is supported
- Python 3.8+ (for orchestrator, scripts, and many tool wrappers)
- Common C toolchain: gcc or clang, make, cmake (depending on C project)
- Optional: Docker / Docker Compose for reproducible environments
- Optional: Node.js if the chosen UI implementation requires it

Quick start

Local development (recommended for contributors)
1. Create a Python virtualenv and activate it
   - python -m venv .venv
   - source .venv/bin/activate
2. Install Python dependencies (example)
   - pip install -r requirements.txt
   - If requirements.txt is not present, install dependencies listed in docs or setup files.
3. Configure your environment
   - Copy the example configuration to create a working config:
     - cp config.example.yml config.yml
   - Edit config.yml to set tool locations, Docker image names, ports, and other settings.
4. Start the orchestrator (example)
   - python -m core.main
   - Or run the UI: see ui/README.md for front-end start commands

Docker (recommended for reproducible testing environments)
1. Build the Docker images (if Dockerfiles are included)
   - docker build -t estep-core -f docker/core/Dockerfile .
2. Start the stack
   - docker-compose up --build
3. Access the UI at the configured address (see docker-compose.yml or docs for ports)

Installing testing tools (separately)
This project supports installing tools independently so you can choose which ones to enable.

Common Python testing tools to install:
- pytest: python -m pip install pytest
- coverage: python -m pip install coverage
- flake8, mypy, bandit: python -m pip install flake8 mypy bandit

Common C testing tools to install:
- gcc or clang (via distro packages)
- valgrind: sudo apt install valgrind
- cppcheck: sudo apt install cppcheck
- sanitizer support: use clang/gcc compile flags (-fsanitize=address,undefined,leak) as part of build
- clang-tidy: sudo apt install clang-tidy

Tool installation patterns
- Each tool is expected to have a small wrapper script or module in tools/ that:
  - Ensures the tool is present (offers automatic install where possible)
  - Provides a consistent CLI for the orchestrator to invoke
  - Emits standardized JSON or JUnit-style results so reports are uniform

Running tests

Python
- Run unit tests:
  - pytest tests/
- Collect coverage:
  - coverage run -m pytest && coverage html
- Static analysis:
  - flake8 src/ && mypy src/
- Security scanning (optional):
  - bandit -r src/

C
- Build with debug/sanitizers:
  - mkdir -p build && cd build
  - cmake -DCMAKE_BUILD_TYPE=Debug ..
  - make
- Run tests (example):
  - ./build/tests/unit_tests
- Run with address sanitizer (when built with -fsanitize=address):
  - ASAN_OPTIONS=detect_leaks=1 ./build/tests/unit_tests
- Static analysis:
  - cppcheck --enable=all --inconclusive --std=c11 src/
  - clang-tidy src/*.c -- -Ipath/to/includes

Reports
- The orchestrator can aggregate results (pytest JUnit XML, gcov/lcov data, sanitizer logs, static analyzer reports) into a single report directory.
- Integrations: convert results to HTML dashboards, or export JUnit XML for CI consumption.

Adding a new tool or test runner
1. Add a wrapper module under tools/<tool-name>/:
   - A small CLI to install (optional), run, and output results in a standard format
2. Add a workflow step in workflows/<language>/ that calls the tool’s wrapper
3. Document the tool in docs/tools.md and add any required configuration knobs to config.example.yml
4. Provide unit + integration tests for the wrapper if needed

Configuration
- config.example.yml (create or consult this file in the repo)
- Typical configuration keys:
  - tools:
    - tool_name:
      - enabled: true
      - install_path: /opt/tools/tool_name
  - ui:
    - host: 127.0.0.1
    - port: 8080
  - reports:
    - output_dir: ./reports
    - format: html,junit

Troubleshooting
- Tool not found: enable or install the tool, or point config to its binary
- C runtime issues: build without optimizations and enable debug symbols (-g)
- Valgrind or sanitizer failures: examine logs in reports/ and use the orchestrator-runner to re-run failing tests locally
- Consult docs/ for details and example workflows

Best practices and recommendations
- Use Docker for consistent environments across CI and developer machines
- Keep tool wrappers idempotent — install operations should be safe to re-run
- Emit machine-readable output from tools (JSON or JUnit XML) so the orchestrator can aggregate results
- Keep language-specific workflows in workflows/python/ and workflows/c/ for clarity

Solidity and other languages
- This repository shows a smaller portion of Solidity files. Solidity support is considered optional/experimental here and is intentionally separated from the main Python/C flows. If you want to enable Solidity testing, add a workflow under workflows/solidity/ and the tool wrappers (e.g., solc, mythril) under tools/.

Contributing
We welcome contributions! Suggested workflow:
1. Fork the repo
2. Create a branch for your feature: git checkout -b feat/<short-desc>
3. Add tests and documentation for your change
4. Submit a PR describing the change and how to test it

Please follow the repository's code style and contribution guidelines (see CONTRIBUTING.md if present).

Contact
Maintainer: Vishal-7197
For issues and feature requests, open an issue in this repository.
