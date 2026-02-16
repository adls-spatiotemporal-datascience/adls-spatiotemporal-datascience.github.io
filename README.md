# ADLS Spatiotemporal Data Science

Quarto book for the Spatiotemporal Data Science course.

## Quarto book + slides

This set of qmd source files produce a web book layout (as a reference) as well as slides (for presentation in course). Add the following to add a link to the slides from the book.

```{.markdown}
[]{.lts .content-hidden unless-profile="book"}
``` 


## Publishing book + slides

Rather than using classic `quarto publish` commands, I created a Makefile to simplify the publishing pipeline. 

```bash
make publish   # render book + slides, deploy to GitHub Pages
```

Look at the makefile to see the exact commands run.




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
