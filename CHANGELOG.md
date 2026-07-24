## 1.0.3

- Add pub.dev automated publishing workflow (GitHub Actions OIDC)

## 1.0.2

- Add GitHub Actions workflow to deploy web demo to GitHub Pages
- Update web/index.html title and meta description
- Update web/manifest.json with app name and theme colors
- Update README live demo link to GitHub Pages URL

## 1.0.1

- Fix for-loop lint warnings in `lattice.dart` (static analysis 50/50)
- Add dartdoc to `OrbPainter`
- Add `example/` app (documentation 20/20)
- Fix package name in library doc comment
- Add `AGENTS.md` for contributor/onboarding reference

## 1.0.0

- Initial release of thinking_orbs Flutter package
- Six hand-tuned animated states: working, searching, solving, listening, composing, shaping
- Two size presets: large (64px) for chat avatars, small (20px) for inline text
- Auto dark/light theme detection from ambient ThemeData
- Accessibility support with per-state semantics labels
- Reduced motion support (static frame when system animations are disabled)
- Plain Canvas.drawCircle rendering: no filters, no shaders, identical across all platforms
