# Authoring Documentation

This guide covers advanced Markdown features and best practices for creating beautiful, functional documentation.

## Markdown Conventions

### Headers

Use clear, descriptive headers with proper hierarchy:

```markdown
# Page Title (H1)
## Main Section (H2)
### Subsection (H3)
#### Detail Section (H4)
```

### Code Blocks

Always specify the language for syntax highlighting:

```python
def hello_world():
    print("Hello, world!")
    return True
```

```javascript
function greet(name) {
    console.log(`Hello, ${name}!`);
    return name;
}
```

```bash
# Install dependencies
pip install -r requirements.txt

# Start development server
docker compose up
```

## Admonitions

Use admonitions to highlight important information:

!!! note "Information"
    This is a note with additional context or explanations.

!!! tip "Pro Tip"
    Use tips to share helpful shortcuts or best practices.

!!! warning "Important Warning"
    Warnings help users avoid common mistakes or issues.

!!! danger "Critical Alert"
    Use danger for critical information that could cause problems.

!!! info "Additional Info"
    Info blocks provide supplementary details without interrupting flow.

!!! success "Success Message"
    Use success blocks to confirm positive outcomes.

!!! question "Common Question"
    Address frequently asked questions with question blocks.

!!! example "Example Usage"
    Provide concrete examples to illustrate concepts.

### Collapsible Admonitions

??? note "Click to expand"
    This content is hidden by default and can be expanded by clicking.

??? tip "Advanced Configuration"
    ```yaml
    theme:
      features:
        - navigation.instant
        - navigation.tracking
        - navigation.tabs
    ```

## Tabs

Organize related content using tabs:

=== "Python"

    ```python
    import requests

    response = requests.get('https://api.example.com/data')
    data = response.json()
    print(data)
    ```

=== "JavaScript"

    ```javascript
    fetch('https://api.example.com/data')
        .then(response => response.json())
        .then(data => console.log(data));
    ```

=== "cURL"

    ```bash
    curl -X GET https://api.example.com/data \
         -H "Accept: application/json"
    ```

## Task Lists

Create interactive task lists for procedures:

- [x] Set up development environment
- [x] Install required extensions
- [x] Create first documentation page
- [ ] Add diagrams to documentation
- [ ] Configure custom theme
- [ ] Deploy to production

## Tables

Create clear, well-formatted tables:

| Feature | Description | Status |
|---------|-------------|---------|
| Mermaid | Flowcharts and diagrams | ✅ Enabled |
| PlantUML | UML diagrams | ✅ Enabled |
| Search | Full-text search | ✅ Enabled |
| Tabs | Organized content | ✅ Enabled |
| Dark Mode | Theme switching | ✅ Enabled |

## Links and References

### Internal Links

Link to other pages in your documentation:

- [Getting Started](../getting-started.md)
- [Mermaid Examples](../diagrams/mermaid.md)
- [PlantUML Examples](../diagrams/plantuml.md)

### External Links

Link to external resources:

- [MkDocs Material Documentation](https://squidfunk.github.io/mkdocs-material/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Kroki Documentation](https://kroki.io/)

### Reference-style Links

For cleaner markup, use reference-style links:

Check out the [Material theme][material] and [Kroki service][kroki] for more information.

[material]: https://squidfunk.github.io/mkdocs-material/
[kroki]: https://kroki.io/

## Code Annotations

Add explanatory annotations to code blocks:

```python hl_lines="2 4"
def process_data(data):
    cleaned = clean_data(data)  # (1)
    
    validated = validate_data(cleaned)  # (2)
    
    return validated
```

1. Clean the raw data by removing invalid entries
2. Validate the cleaned data against our schema

## Content Blocks

### Definition Lists

Term 1
:   Definition for term 1

Term 2
:   Definition for term 2 with multiple lines
    and additional context

### Abbreviations

The HTML specification is maintained by the W3C.

*[HTML]: HyperText Markup Language
*[W3C]: World Wide Web Consortium

## Keyboard Keys

Use keyboard key styling for shortcuts:

++ctrl+shift+p++ - Open VS Code command palette

++ctrl+c++ - Copy

++ctrl+v++ - Paste

## Mathematical Expressions

For mathematical content, use KaTeX syntax:

Inline math: $E = mc^2$

Block math:

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$

## Best Practices

### Writing Style

1. **Be Clear and Concise** - Use simple, direct language
2. **Use Active Voice** - "Click the button" vs "The button should be clicked"
3. **Include Examples** - Show don't just tell
4. **Test Your Instructions** - Verify that steps actually work

### Organization

1. **Logical Structure** - Organize content in a logical flow
2. **Consistent Formatting** - Use consistent styles throughout
3. **Cross-references** - Link related content together
4. **Regular Updates** - Keep documentation current

### Technical Content

1. **Code Formatting** - Always use proper syntax highlighting
2. **Complete Examples** - Provide working, copy-paste examples
3. **Error Handling** - Document common errors and solutions
4. **Version Information** - Specify version requirements when relevant

## Troubleshooting

### Common Issues

**Diagrams not rendering?**
: Ensure the Kroki server is running on port 8000

**Images not loading?**
: Check that image paths are relative to the markdown file

**Navigation issues?**
: Verify your file structure matches the navigation configuration

**Build failures?**
: Check for syntax errors in YAML frontmatter or configuration files

### Getting Help

- Check the [MkDocs Material documentation](https://squidfunk.github.io/mkdocs-material/)
- Review [Markdown syntax guide](https://www.markdownguide.org/basic-syntax/)
- Examine working examples in this documentation
- Ask questions in project issues or discussions