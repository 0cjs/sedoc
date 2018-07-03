PyYAML
=====

[PyYaml][] ([GitHub]) is a complete [YAML] 1.1 parser and emitter,
providing both a low-level event-based API (like SAX) and a high-level
API for serializaing and deserializing native Python objects. It
supports all types from the [YAML types repository], has an extension
API for additional types, and can construct arbitrary Python objects
(which is not safe unless you trust what you're loading). It's written
in pure Python, but can also use the [LibYAML] C library if installed.

Versions:
- The commonly used release is 3.12, the latest on PyPI.
- [3.13][] (currently at 3.13b1) is required for Python 3.7. It has no
  functionality changes from 3.12.
- A [4.1] release was attempted in 2018-06 but then retracted; 4.2
  will be released once the issues causing that have been fixed.


API
---

The only documentation seems to be the [PyYAML Documentation] page on
the old Wiki, though it claims to be historical.

Functions in `yaml` module:

- `load(stream)`, Parses first document in a stream, throwing
  `ComposerError` if there is more than one document.
- `load_all(stream)`: Parses all documents in a stream.
- `safe_load(stream)`, `safe_load_all()`: As with `load()` but parses
  only basic YAML.
- `dump(data, stream=None)`, `dump_all`, `safe_dump`, `safe_dump_all`:
  Returns an `str` or writes the dumped data to the given stream.
  Parameters include:
  - `explicit_start`
  - `width`
  - `indent`
  - `canonical`: default `False`
  - `default_flow_style`: default `True`



[3.13]: https://github.com/yaml/pyyaml/blob/release/3.13/announcement.msg
[4.1]: https://github.com/yaml/pyyaml/blob/master/announcement.msg
[GitHub]: https://github.com/yaml/pyyaml
[LibYAML]: https://github.com/yaml/libyaml
[PyYAML Documentation]: https://pyyaml.org/wiki/PyYAMLDocumentation
[PyYaml]: https://pyyaml.org/
[YAML types repository]: http://yaml.org/type/
[YAML]: https://en.wikipedia.org/wiki/YAML
