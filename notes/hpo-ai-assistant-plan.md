# HPO AI Assistant - Draft Plan

## Overview

Build a GitHub workflow that triggers when someone @mentions a bot (e.g., `@hpo-helper`), runs Claude Code to analyze the HPO ontology + PubMed + other sources, and responds with helpful information.

## Target Use Cases

1. **Creating new ontology terms** - Generate properly formatted HPO terms with definitions, synonyms, parent terms, and cross-references
2. **Editing existing ontology terms** - Modify definitions, add synonyms, update hierarchy
3. **Answering questions about HPO** - Explain term relationships, find related terms, clarify usage

---

## Implementation Options

### Option A: Mondo-style (Simpler)

**Source:** `/Users/jtr4v/PythonProject/mondo_old/.github/`

| Component | Implementation |
|-----------|---------------|
| Detection | `dragon-ai-agent/github-mention-detector@v1.0.0` |
| Execution | `dragon-ai-agent/run-goose-obo@v1.0.4` |
| Instructions | `.goosehints` + `CLAUDE.md` |
| Controllers | `.github/ai-controllers.json` |

**Pros:**
- Simpler setup, fewer moving parts
- Proven on production ontology (Mondo)
- Good OBO-specific tooling (obo-grep.pl, obo-checkout.pl)

**Cons:**
- Goose-based (not Claude-native)
- No manual trigger support
- Less explicit tool control

---

### Option B: Data-Sheets-Schema-style (More Sophisticated)

**Source:** `/Users/jtr4v/PythonProject/data-sheets-schema/.github/`

| Component | Implementation |
|-----------|---------------|
| Detection | Custom JavaScript in workflow (`actions/github-script@v7`) |
| Execution | `dragon-ai-agent/run-claude-obo@v1.0.2` |
| Instructions | `.goosehints` + detailed markdown workflow guides |
| Controllers | `.github/ai-controllers.json` |
| MCP Servers | `.mcp.json` (GitHub MCP, ARTL for literature) |
| Settings | `.claude/settings.json` |

**Pros:**
- Claude-native execution
- Manual `workflow_dispatch` trigger
- Explicit tool allowlists
- MCP server integration (literature search)
- More documentation (~1,600 lines vs ~400)
- Budget monitoring

**Cons:**
- More complex setup
- More files to maintain

---

## Recommended Approach: Hybrid

Combine strengths of both:

1. **Use Claude-native execution** (`dragon-ai-agent/run-claude-obo`) - better for our use case
2. **Keep Mondo's OBO tooling** (obo-grep.pl, obo-checkout.pl patterns) - proven for ontology work
3. **Add manual trigger** (`workflow_dispatch`) - useful for testing and direct invocation
4. **Add MCP for literature** - PubMed integration essential for HPO definitions
5. **Explicit tool control** - security and predictability
6. **Detailed HPO-specific instructions** - term format, hierarchy rules, citation requirements

---

## Files to Create

```
.github/
├── workflows/
│   └── hpo-assistant.yml          # Main workflow
├── ai-controllers.json            # Authorized users
├── ISSUE_TEMPLATE/                # Already exists, may need updates
│   └── a_adding_term.md           # Already exists
└── copilot-instructions.md        # Symlink to CLAUDE.md (optional)

.goosehints                        # AI instructions for HPO editing
.mcp.json                          # MCP server config (GitHub, literature)
.claude/
└── settings.json                  # Claude Code settings

CLAUDE.md                          # Main AI instructions (update existing or create)
```

---

## Key Components to Implement

### 1. Workflow File (`hpo-assistant.yml`)

```yaml
name: HPO Assistant
on:
  issues:
    types: [opened, edited]
  issue_comment:
    types: [created, edited]
  pull_request:
    types: [opened, edited]
  pull_request_review_comment:
    types: [created, edited]
  workflow_dispatch:
    inputs:
      item-type:
        description: 'Issue or PR'
        required: true
        type: choice
        options: [issue, pr]
      item-number:
        description: 'Issue/PR number'
        required: true
        type: string

jobs:
  check-mention:
    # Detect @hpo-helper mentions
    # Check if user is in ai-controllers.json
    # Extract prompt, context, item info

  respond-to-mention:
    # Run dragon-ai-agent/run-claude-obo
    # Pass HPO-specific instructions
    # Create PR or comment with response
```

### 2. AI Controllers (`ai-controllers.json`)

```json
["pnrobinson", "other-authorized-users"]
```

### 3. Instructions (`.goosehints` or `CLAUDE.md`)

Must cover:
- **HPO term format** (OBO stanza structure)
- **ID allocation** (HP:6001459+ range, or coordinate with maintainers)
- **Required fields** (id, name, def with PMID, is_a parents)
- **Synonym types** (EXACT, BROAD, NARROW, RELATED, layperson)
- **Cross-references** (UMLS, SNOMED, Orphanet, ICD-10)
- **Hierarchy rules** (True-Path Rule, Pie Rule, 5 o'clock Rule)
- **File locations** (`hp.obo`, `src/ontology/hp-edit.owl`)
- **Search commands** (grep patterns for finding terms)
- **Literature fetching** (aurelian or ARTL MCP for PubMed)
- **Validation** (ROBOT commands)

### 4. MCP Configuration (`.mcp.json`)

```json
{
  "mcpServers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "artl": {
      "command": "uvx",
      "args": ["--from", "aurelian", "artl"]
    }
  }
}
```

---

## HPO-Specific Considerations

### Term Format Example

```obo
[Term]
id: HP:6001459
name: Straddling tricuspid valve
def: "A congenital cardiac malformation in which the tricuspid subvalvar apparatus has attachments within both ventricles." [PMID:10577451, IPCCC:06.01.09]
comment: Associated with malalignment of atrial and ventricular septa.
synonym: "Tricuspid valve straddling" EXACT []
xref: Orphanet:95461
xref: SNOMEDCT_US:1234910007
xref: UMLS:C5761644
is_a: HP:0001702 ! Abnormal tricuspid valve morphology
is_a: HP:0011562 ! Straddling atrioventricular valve
```

### Key Hierarchy Branches for Cardiac Terms

```
HP:0001627 Abnormal cardiac structure
├── HP:0001654 Abnormal heart valve morphology
│   └── HP:0006705 Abnormal atrioventricular valve morphology
│       ├── HP:0001633 Abnormal mitral valve morphology
│       └── HP:0001702 Abnormal tricuspid valve morphology
└── HP:0011545 Abnormal cardiac connection
    └── HP:0011546 Abnormal atrioventricular connection
        ├── HP:0011561 Overriding atrioventricular valve
        └── HP:0011562 Straddling atrioventricular valve
```

### External Resources to Integrate

| Resource | Purpose | Access Method |
|----------|---------|---------------|
| PubMed | Definitions, citations | aurelian/ARTL MCP |
| Orphanet | Rare disease cross-refs | Web fetch |
| OMIM | Genetic disease links | Web fetch |
| SNOMED CT | Clinical terminology xrefs | Manual lookup |
| UMLS | Unified medical language | Manual lookup |
| IPCCC | Cardiac phenotype codes | Web fetch |

---

## Open Questions

1. **Bot name:** `@hpo-helper`, `@hpo-assistant`, or something else?
2. **ID allocation:** How to get new HP IDs? Coordinate with maintainers or use a reserved range?
3. **Which users to authorize initially?** Start with core HPO team?
4. **PR vs comment:** Should bot create PRs directly or just comment with suggestions?
5. **Validation:** Run ROBOT validation before creating PR?
6. **Testing:** How to test the workflow before deploying to main repo?

---

## Next Steps

1. [ ] Decide on implementation approach (A, B, or Hybrid)
2. [ ] Get list of authorized users for `ai-controllers.json`
3. [ ] Write `.goosehints` / `CLAUDE.md` with HPO-specific instructions
4. [ ] Create workflow file
5. [ ] Set up MCP servers (if using Option B)
6. [ ] Configure secrets (ANTHROPIC_API_KEY, PAT_FOR_PR)
7. [ ] Test on a fork before deploying to main repo
8. [ ] Create user documentation

---

## Reference Implementations

- **Mondo:** `/Users/jtr4v/PythonProject/mondo_old/.github/`
- **Data-Sheets-Schema:** `/Users/jtr4v/PythonProject/data-sheets-schema/.github/`
- **HPO Issue Templates:** `/Users/jtr4v/PythonProject/human-phenotype-ontology/.github/ISSUE_TEMPLATE/`
