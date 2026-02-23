# Sprint Tracking

## Files

- `.sprint/current.json` — Machine-readable sprint state
- `.sprint/progress.md` — Human-readable session log

## Sprint Init

```bash
mkdir -p .sprint

cat > .sprint/current.json << EOF
{
  "sprint_id": "sprint-$(date +%Y-%m-%d)",
  "created": "$(date -Iseconds)",
  "goal": "SPRINT_GOAL_HERE",
  "tasks": [],
  "stats": { "completed": 0, "total": 0, "progress_pct": 0 }
}
EOF
```

## Progress Log Format

```markdown
# Sprint Progress

**Goal:** [Sprint Goal]
**Started:** [Date]

---

- [timestamp] [teammate-role] Completed [task-id]: [description]
```
