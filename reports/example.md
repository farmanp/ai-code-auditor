# Example Scan Output

The `run_scan.py` script scans a repository using hints from a spec file.
Running it on the sample repository included in this project produces the following JSON:

```json
{
  "matches": [
    {
      "file": "examples/sample_repo/singleton.py",
      "line": 10,
      "pattern": "Singleton",
      "hint": "getInstance()"
    }
  ]
}
```
