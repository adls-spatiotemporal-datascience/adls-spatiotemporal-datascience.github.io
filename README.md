# ADLS Spatiotemporal Data Science

Quarto website for the Spatiotemporal Data Science course.

## Project structure

The project is a single Quarto **website** (`project.type: website` in `_quarto.yml`).

- `index.qmd`, `syllabus.qmd`, `submission.qmd`, `slides.qmd` — regular HTML pages (navbar)
- Lecture `.qmd` files — rendered as RevealJS slides (the project default)
- Task/description `.qmd` files — rendered as HTML pages (`format: html` in front matter)

## Git Workflow

This repository uses **tags** to mark the state of the course materials at the end of each semester.

### Semester Tags

| Tag   | Semester               |
|-------|------------------------|
| FS25  | Frühlingssemester 2025 |

### Working with Tags

```bash
# View all semester versions
git tag

# Check out a specific semester
git checkout FS25

# Compare changes between semesters
git diff FS25..FS26

# Create a new semester tag (at end of semester)
git tag -a FS26 -m "Frühlingssemester 2026"
git push origin FS26
```
