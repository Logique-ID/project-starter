# Template Sync Scripts

Automated synchronization system for updating Mason brick templates from reference projects while preserving all Mason/Mustache variable conditions.

## Overview

The sync system updates the Mason brick template (`src/__brick__/{{project_name}}/`) from the reference project (`ref/ref_app/`) while intelligently preserving all existing Mason variable blocks like `{{#use_firebase}}...{{/use_firebase}}`.

## Usage

### Basic Sync

Run the sync script from the project root:

```bash
dart run scripts/sync-template.dart
```

### Dry Run

Preview changes without modifying files:

```bash
dart run scripts/sync-template.dart --dry-run
```

or

```bash
dart run scripts/sync-template.dart -n
```

### Verbose Output

See detailed information about each file processed:

```bash
dart run scripts/sync-template.dart --verbose
```

or

```bash
dart run scripts/sync-template.dart -v
```

### Sync Specific Directory

Sync only a specific directory or file:

```bash
dart run scripts/sync-template.dart --path lib/src/routing
```

### Combined Options

```bash
dart run scripts/sync-template.dart --dry-run --verbose --path lib/src
```

### Interactive File Selection

Choose which files to sync interactively:

```bash
dart run scripts/sync-template.dart --interactive
```

or

```bash
dart run scripts/sync-template.dart -i
```

This will:
1. Analyze files using the same detection logic as `--impact` (only shows files that will be changed)
2. Display files that will be changed (numbered list)
3. Prompt you to select files to sync
4. Show a preview of what will be synced vs skipped
5. Ask for confirmation before proceeding

**Note:** Only files that will actually be changed (new files, updated files, binary files) are shown in the selection list. Files that won't change are automatically excluded, just like in impact analysis.

**Selection options:**
- Enter numbers separated by commas: `1,3,5` (syncs files 1, 3, and 5)
- Enter ranges: `1-5` (syncs files 1 through 5)
- Enter `all` to sync all files
- Enter `none` or press Enter to cancel
- Enter `q` to quit

**Example:**
```
Available files:
────────────────────────────────────────────────────────────
  [1] lib/src/routing/app_router.dart
  [2] lib/src/routing/app_startup.dart
  [3] lib/src/routing/go_router_refresh_stream.dart

Select files to SYNC:
  - Enter numbers separated by commas (e.g., 1,3,5)
  - Enter ranges (e.g., 1-5)
  - Enter "all" to sync all files
  - Enter "none" or press Enter to cancel
  - Enter "q" to quit

Your selection: 1,3
```

You can combine with other flags:
```bash
dart run scripts/sync-template.dart --interactive --path lib/src/routing
dart run scripts/sync-template.dart --interactive --dry-run
```

### Impact Analysis

Preview which files will be impacted before syncing:

```bash
dart run scripts/sync-template.dart --show-impact
```

or

```bash
dart run scripts/sync-template.dart --impact
```

This will show:
- **Direct Changes**: Files that will be updated or created
- **Indirect Impacts**: Files that depend on changed files (via imports)
- **Warnings**: Potential issues detected during analysis

You can combine with `--path` to analyze a specific directory:

```bash
dart run scripts/sync-template.dart --impact --path lib/src/routing
```

The impact analysis:
- Analyzes all Dart files to build a dependency graph
- Identifies files that import changed files
- Shows which files will be directly modified
- Highlights potential breaking changes
- Provides a summary of total impact

## How It Works

### Smart Merge Algorithm

1. **Parses Mason Blocks**: Extracts all `{{#var}}...{{/var}}`, `{{^var}}...{{/var}}`, and `{{variable}}` patterns from template files
2. **Content Mapping**: Maps reference content to template structure while preserving variable wrappers
3. **Block Preservation**: When reference content changes, maintains the variable conditions that wrap it
4. **Path Normalization**: Handles transformations like `ref_app` → `{{project_name}}` and `id.logique.trial` → `{{app_id}}`

### File Handling Strategy

- **Existing Files**: Smart merge preserving all Mason variables
- **New Files**: Copied as-is from reference (with path/content mapping, no variables added)
- **Deleted Files**: Kept in template (template-specific files are preserved)
- **Binary Files**: Direct copy (images, fonts, etc.)

### Path Transformations

The script automatically transforms:
- Directory names: `ref_app` → `{{project_name}}`
- Package names: `id.logique.trial` → `{{app_id}}`
- App names: `"Trial"` → `"{{app_name}}"`
- Project names: `ref_app` → `{{project_name}}`

## Architecture

### Components

1. **sync-template.dart** - Main orchestration script with CLI
2. **sync-template_merger.dart** - Smart merge logic for preserving Mason variables
3. **sync-template_parser.dart** - Extracts and parses Mason variable blocks
4. **sync-template_mapper.dart** - Handles path and content transformations
5. **sync-template_config.dart** - Configuration and patterns
6. **sync-template_impact.dart** - Impact analysis for identifying affected files
7. **sync-template_interactive.dart** - Interactive file selection for choosing files to ignore

## Examples

### Example 1: Syncing pubspec.yaml

**Reference (ref/ref_app/pubspec.yaml):**
```yaml
name: ref_app
dependencies:
  firebase_core: 4.2.1
```

**Template (src/__brick__/{{project_name}}/pubspec.yaml):**
```yaml
name: {{project_name}}
{{#use_firebase}}
dependencies:
  firebase_core: 4.2.1
{{/use_firebase}}
```

**After Sync:**
```yaml
name: {{project_name}}
{{#use_firebase}}
dependencies:
  firebase_core: 4.2.1
{{/use_firebase}}
```

The `{{#use_firebase}}` block is preserved even though the reference doesn't have it.

### Example 2: New File

If a new file `lib/src/new_feature.dart` is added to the reference, it will be:
1. Copied to the template
2. Path-mapped (`ref_app` → `{{project_name}}`)
3. Content-mapped (package names, app IDs, etc.)
4. No Mason variables added (copied as-is)

## Ignored Files

### Hardcoded Whitelist (Exact Name Match)

Specific files and folders can be hardcoded in `SyncConfig.whitelistIgnore` to always be ignored during sync. This uses exact name matching (case-sensitive) and is checked before pattern-based ignores.

**To add files/folders to the whitelist:**

Edit `scripts/sync-template_config.dart`:

```dart
static const List<String> whitelistIgnore = [
  'template_config.yaml',  // Specific file by exact name
  'custom_folder/',        // Specific folder (trailing slash)
  '.cursor/',              // Folder by name
  'special_file.dart',     // File by exact name
];
```

**How it works:**
- Files: Matches exact filename anywhere in the path
- Folders: Matches folder name (with or without trailing slash) anywhere in the path
- Case-sensitive matching
- Checked first before pattern-based ignores

### Pattern-Based Ignores

The following patterns are automatically ignored:
- `build/` directories
- `.dart_tool/`
- `.idea/`, `.vscode/`
- `.gradle/`, `ios/Pods/`
- `pubspec.lock`
- Binary files are copied directly (not merged)

## Warnings

The script may generate warnings when:
- A Mason block in the template cannot be matched to content in the reference
- Content structure differs significantly between reference and template

These warnings don't prevent syncing - the template version is preserved in such cases.

## How File Comparison Works

The sync script uses whitespace-aware comparison to detect real content changes:

- **Normalizes line endings**: Converts `\r\n` and `\r` to `\n`
- **Trims trailing whitespace**: Removes trailing spaces and tabs from each line
- **Preserves meaningful whitespace**: Leading indentation and spaces between words are preserved
- **Ignores whitespace-only changes**: Files that differ only in whitespace are considered unchanged

This means files won't be marked as changed if the only differences are:
- Trailing spaces on lines
- Different line endings (CRLF vs LF)
- Extra blank lines (if they're the only difference)

## Troubleshooting

### Script Fails to Find Reference Directory

Ensure you're running from the project root and that `ref/ref_app/` exists.

### Mason Variables Not Preserved

Check that the template file has the correct Mason syntax. The parser looks for:
- `{{#variable}}...{{/variable}}` (conditional blocks)
- `{{^variable}}...{{/variable}}` (inverted blocks)
- `{{variable}}` (simple variables)

### Path Transformations Not Working

Verify the patterns in `sync-template_config.dart` match your reference project structure.

### Files Not Detected as Changed

The comparison ignores whitespace-only differences. If you need to sync whitespace changes, you may need to manually update the template file.

## Development

To modify the sync behavior:

1. **Change ignored patterns**: Edit `SyncConfig.ignorePatterns` in `sync-template_config.dart`
2. **Add path mappings**: Update `SyncConfig.variableMappings` in `sync-template_config.dart`
3. **Modify merge logic**: Edit `SmartMerger` class in `sync-template_merger.dart`
4. **Add transformations**: Update `PathMapper.mapContent()` in `sync-template_mapper.dart`
