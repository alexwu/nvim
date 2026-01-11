# CLAUDE.md - Neovim Configuration Guidelines

## Build Commands

- `just lint` - Run Selene linter on Lua files
- `just fmt` - Format Lua files with StyLua

## Code Style Guidelines

- **Indentation**: 2 spaces (no tabs)
- **Line Endings**: Unix style
- **Naming**: Use snake_case for variables/functions, PascalCase for modules/classes
- **Module Structure**: Return table of plugin specs with configuration in Lua files
- **Error Handling**: Use `pcall` for error-prone operations
- **Imports**: Use `require("module")` for imports, local variables for frequently used modules
- **Keymappings**: Use `set()` utility with mode, key, action, and description format
- **Plugin Config**: Use `opts = {}` for simple configs, `config = function()` for complex ones
- **Formatting**: Files are formatted with StyLua (indent_width = 2)
- **Linting**: Codebase uses Selene with Neovim standards

## Project Organization

- Plugins defined in `lua/plugins/` directory, organized by category
- LSP configurations in `lua/bombeelu/lsp/` and `lua/plugins/lsp/`
- Core utilities in `lua/bombeelu/utils.lua`
- Custom settings in `lua/options.lua`

<command_line_tools>
### ast-grep
AST-based search and rewrite tool for code manipulation.
- `ast-grep run` - Search or rewrite code using AST patterns
- `ast-grep scan` - Scan and rewrite by configuration files
- `ast-grep test` - Test ast-grep rules
- `ast-grep new` - Create new projects, rules, or tests
- `ast-grep lsp` - Start language server
- Config file: `sgconfig.yml`

### fd
Fast file finder (alternative to `find`).
- `fd [pattern] [path]` - Search for files/directories by name
- `fd -H` - Include hidden files
- `fd -I` - Include ignored files (gitignore, etc.)
- `fd -t f` - Only files, `fd -t d` - Only directories
- `fd -e ext` - Filter by file extension
- `fd -x cmd` - Execute command for each result

### rg (ripgrep)
Ultra-fast text search tool (alternative to `grep`).
- `rg pattern [path]` - Search for text patterns
- `rg -i pattern` - Case-insensitive search
- `rg -w pattern` - Match whole words only
- `rg -v pattern` - Invert match (show non-matching lines)
- `rg -n pattern` - Show line numbers
- `rg -l pattern` - Only show filenames with matches
- `rg -c pattern` - Count matches per file
- `rg --json pattern` - Output in JSON format

### just
Command runner for project tasks (alternative to `make`).
- `just` - Run default recipe
- `just -l` - List available recipes
- `just recipe_name` - Run specific recipe
- `just --choose` - Interactive recipe selection
- `just --dry-run recipe` - Show what would be executed
- `just --set VAR value recipe` - Override variables
- Config file: `justfile`

### mise
Development environment manager (runtime versions, env vars, tasks).
- `mise install tool@version` - Install specific tool version
- `mise use tool@version` - Set tool version for project
- `mise ls` - List installed tools
- `mise ls-remote tool` - List available versions
- `mise run task` - Run defined tasks
- `mise set VAR=value` - Set environment variables
- `mise watch task` - Run tasks and watch for changes
- Config file: `mise.toml`
</command_line_tools>
