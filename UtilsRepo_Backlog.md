# UtilsRepo Backlog

## Version: v1.3.1+

### 🛠️ Automation Enhancements
- [ ] Fully automate `copype.cmd` execution with detection of correct architecture and error handling
- [ ] Create helper script to:
  - Detect PE install location
  - Copy required bootloaders (e.g., etfsboot.com)
  - Regenerate ISO automatically with Rufus integration fallback
- [ ] Rufus automation script enhancement with verification of launch and ISO burn status

### 🧪 Testing & Validation
- [ ] Add verbose testing feedback across all scripts
- [ ] Display real-time PowerShell success indicators (e.g., ✅ symbols or success text)
- [ ] Integrate post-deployment validation (e.g., check ISO mountability, drive content, etc.)

### 🧾 Documentation & Git Best Practices
- [ ] Always update README.md with each significant feature or directive change
- [ ] Maintain semantic versioning, e.g., v1.3.1, v1.3.2, etc.
- [ ] Maintain and update `CHANGELOG.md` automatically per commit
- [ ] Maintain `Directives_History.md` with timestamps and versions
- [ ] Create a GitHub Actions workflow (or optional PowerShell script) for automated tests

### 📎 Directives & Workflow
- [ ] Script everything to MVP-first. Avoid unnecessary visuals or polish unless requested.
- [ ] Always apply patches as soon as they are identified.
- [ ] Maintain directive compliance enforcement logic in all script generators.
- [ ] Provide downloadable outputs for all code, backlog, or version-tracking files.

---
_Last updated: v1.3.1_