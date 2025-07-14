# Specification Example

This example demonstrates how a pattern definition in `specs/` maps to detected code.

**YAML snippet**
```yaml
- name: "Singleton"
  category: "creational"
  hints:
    - "private constructor"
    - "static instance"
    - "getInstance()"
```

**Code snippet** (`examples/sample_repo/singleton.py`)
```python
class Singleton:
    _instance = None
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance


def getInstance():
    return Singleton()
```

Running `python scripts/run_scan.py specs/design-patterns-spec.yaml examples/sample_repo` matches the pattern because the code contains `getInstance()`. The JSON report lists the file, line number, pattern name, and hint used for the match.
