# Windows Setup Guide

## ⚠️ Important: Folder Naming

**CORRECT:** `C:\api-security` (with hyphen, no spaces)  
**INCORRECT:** `C:\API Security` (space causes issues)

Windows has issues with spaces in folder names when using command-line tools, Git, and scripts. Always use kebab-case (hyphens) or snake_case (underscores).

---

## 📁 Recommended Folder Structure

```
C:\api-security\           ← Main project folder (no spaces!)
├── cf-worker\             ← Cloudflare Workers
├── cf-dashboard\          ← React Dashboard
├── devops-persona\        ← DevOps resources
└── ...
```

---

## 🚀 Quick Start (Windows PowerShell)

### 1. Open PowerShell

Press `Win + X`, then select **"Windows PowerShell"** or **"Terminal"**

### 2. Navigate to Project

```powershell
cd C:\api-security
```

**NOT:**
```powershell
cd C:\API Security   ← ❌ Space causes issues
cd "C:\API Security"  ← ⚠️ Quotes required but problematic
```

### 3. Verify Setup

```powershell
# Check current directory
Get-Location

# Should output: C:\api-security
```

---

## ⚡ Common Windows Commands

### Deploy Worker
```powershell
cd C:\api-security\cf-worker
wrangler deploy
```

### Run Dashboard Locally
```powershell
cd C:\api-security\cf-dashboard
npm run dev
```

### Git Operations
```powershell
cd C:\api-security
git status
git add .
git commit -m "Your message"
git push
```

### Database Operations
```powershell
cd C:\api-security\cf-worker
wrangler d1 execute llm-fw-db --command "SELECT * FROM users"
```

---

## 🐛 Troubleshooting Windows Issues

### Issue: "Command not found" or path errors

**Cause:** Space in folder name breaks command parsing

**Fix:** Use the renamed folder `C:\api-security`

### Issue: Git errors with paths

**Cause:** Git has issues with spaces in Windows paths

**Fix:** 
```powershell
# Use quotes when necessary
cd "C:\api-security"

# Or use the short path name
cd C:\api-security
```

### Issue: Wrangler/Node can't find files

**Cause:** Working directory not set correctly

**Fix:**
```powershell
# Always navigate first
cd C:\api-security\cf-worker

# Then run commands
wrangler deploy
```

### Issue: PowerShell execution policy

**Fix:**
```powershell
# Check current policy
Get-ExecutionPolicy

# Set to RemoteSigned (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 📋 Windows-Specific Notes

### Path Separators
- Windows uses backslashes (`\`)
- But forward slashes (`/`) also work in PowerShell
- Always quote paths with spaces: `"C:\My Folder\file.txt"`

### Line Endings (CRLF vs LF)
Git may warn about line endings on Windows. This is normal and harmless.

To configure:
```powershell
git config --global core.autocrlf true
```

### File Permissions
Windows doesn't use Unix-style permissions. Ignore `chmod` commands from Linux/Mac guides.

### Terminal Recommendations
1. **Windows Terminal** (Microsoft Store) - Best option
2. **PowerShell** - Built-in, works well
3. **Git Bash** - If you prefer Unix commands
4. **CMD** - Avoid, outdated

---

## 🎯 Quick Reference Card

| Task | Command |
|------|---------|
| Open project | `cd C:\api-security` |
| Deploy worker | `cd C:\api-security\cf-worker; wrangler deploy` |
| Run dashboard | `cd C:\api-security\cf-dashboard; npm run dev` |
| Check DB | `cd C:\api-security\cf-worker; wrangler d1 list` |
| Git status | `cd C:\api-security; git status` |
| Install deps | `cd C:\api-security\cf-worker; npm install` |

---

## ✅ Verification Checklist

- [ ] Folder is at `C:\api-security` (no spaces)
- [ ] Can navigate: `cd C:\api-security` works
- [ ] Git works: `git status` shows clean
- [ ] Wrangler works: `wrangler --version` shows version
- [ ] Node works: `node --version` shows version
- [ ] Worker deploys: `wrangler deploy` succeeds
- [ ] Dashboard builds: `npm run build` succeeds

---

## 🔗 Related Documentation

- [SETUP-GUIDE.md](./SETUP-GUIDE.md) - Full setup instructions
- [QUICK-START.md](./QUICK-START.md) - Daily commands
- [README.md](./README.md) - Project overview

---

## 🆘 Need Help?

If you encounter Windows-specific issues:

1. Check you're in `C:\api-security` (not `C:\API Security`)
2. Use PowerShell, not CMD
3. Run commands from the correct subdirectory
4. Use `Get-Location` to verify your current directory

**Good luck with your deployment!** 🚀
