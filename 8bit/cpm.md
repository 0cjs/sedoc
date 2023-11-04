CP/M Notes
==========

### Compressor and Archiver File Extensions

Where the extension is a pattern `.?X?`, this indicates an individual file
compresion format where the middle letter of the extension is changed to
indicate the compressed version, e.g., `FOO.TXT` → `FOO.TQT` for Squeeze.

- `.LBR`: Library; no compression.
  - Extract: `NULU` `DELBR`
  - Create: `NULU` or `LAR`

- `.?Q?`: Squeeze.
  - Extract:`UNSQUEEZE` (name varies)
  - Create:`SQUEEZE` (name varies)

- `.?Z?`: Crunch.
  - Extract: `UNCR`, `UNCRUNCH` (various revisions)
  - Create: `CR`, `CRUNCH` (various revisions).

- `.?Y?`: LZH-Crunch.
  - Extract: `UNCRLZH20`
  - Create: `CRLZH20`

- `.ARC`: Cross-platform archiver (DOS, Unix, etc.; CP/M uses `.ARK` extension).

- `.ZIP`: Cross-platform archiver.
  - Extract: `UNZIP` (various versions; older ZIP files only)
  - Create: not available under CP/M.

- `.LZH`
  - Extract: `LHARC` (no LH5 decompression)
  - Create: `LHARD` (no LH5 compression)

- `.ARJ`
  - Extract: `UNARJ` (older versions of the format only).

- `.PMA`: CP/M only; best compression under CP/M.
  - `PMAUTOAE.COM` is a self-extracting file with the tools. Extractor can
    also extract LH5 LZH archives. Creator can create self-extracting
    archives.
