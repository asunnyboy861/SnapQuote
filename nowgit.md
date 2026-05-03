# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | SnapQuote |
| **Git URL** | git@github.com:asunnyboy861/SnapQuote.git |
| **Repo URL** | https://github.com/asunnyboy861/SnapQuote |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | Enabled (from /docs folder) |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/SnapQuote/ | Active |
| Support | https://asunnyboy861.github.io/SnapQuote/support.html | Active |
| Privacy Policy | https://asunnyboy861.github.io/SnapQuote/privacy.html | Active |
| Terms of Use | https://asunnyboy861.github.io/SnapQuote/terms.html | Active |

## Repository Structure

```
SnapQuote/
├── SnapQuote/                      # iOS App Source Code
│   ├── SnapQuote.xcodeproj/        # Xcode Project
│   ├── SnapQuote/                  # Swift Source Files
│   │   ├── Views/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── Components/
│   │   └── Extensions/
│   ├── docs/                       # Policy Pages (GitHub Pages)
│   │   ├── index.html
│   │   ├── support.html
│   │   ├── privacy.html
│   │   └── terms.html
│   └── .github/workflows/
│       └── deploy.yml              # GitHub Pages deployment
├── us.md                           # English Development Guide
├── keytext.md                      # App Store Metadata
├── capabilities.md                 # Capabilities Configuration
├── icon.md                         # App Icon Details
├── price.md                        # Pricing Configuration
└── nowgit.md                       # This File
```
