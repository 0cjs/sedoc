Garbage Collection (GC) Notes
=============================

Structure of a LISP system using two-level storage
--------------------------------------------------

Daniel G. Bobrow and Daniel L. Murphy. 1967. Structure of a LISP
system using two-level storage. Commun. ACM 10, 3 (March 1967),
155–159. [bobrow-DOI] [bobrow-acmdl]

[bobrow-DOI]: https://doi.org/10.1145/363162.363185
[bobrow-acmdl]: https://dl.acm.org/doi/10.1145/363162.363185

Some of this could possibly apply to a system with code and several
(per-type) heaps in separate banks of memory.

Swapping design for a LISP system as used on a PDP-1 with 17-bit
(128 KW) address space (other half used for smallints), 16 KW of core
(5 μs) and 88 KW of drum (17 ms).

- 4 KW system code. Core not swapped. Overlays for major system
  segments (interpter and compiled code runner, I/O and formatting,
  tape package, GC, initilization package).
- 4 KW compiled code. Programs compiled from sexprs stored in
  relocatable form on drum and loaded into 3.4 KW ring buffer on
  demand, with in-core hash table mapping names to in-core addresses.
  (Calls contain atom/symbol naming the function.) When load required,
  data written into ring buffer and overwritten functions removed from
  hash table.
- 8 KW heap, 256 word pages; paged in the usual way. Types determined
  by area of memory in which they're stored, to avoid having to
  examine the memory itself.

Linearization:
- Cons attempts to allocate new cell for car in same page as cdr or,
  if cdr is an atom, on same page as car. (Separate free storage list
  is used for each page.)
- GC does not compact to avoid thrashing.

Performance:
- Loses a factor of 2 vs. entirely in-core version due to
  software-based page mapping.
- One test paged on only 2.5% of references, about 10% of run time
  waiting for the drum.


Deutsch/Bobrow Transaction File Collector
-----------------------------------------

Described in L. Peter Deutsch and Daniel G. Bobrow, "An efficient,
incremental, automatic garbage collector" (CACM 19, 9; September
1976). [dbtf-DOI] [dbtf-acmdl]. See also Minsky, "A LISP Garbage
Collector Algorithm Using Serial Secondary Storage." [AIM-058]

[dbtf-doi]: https://doi.org/10.1145/360336.360345
[dbtf-acmdl]: https://dl.acm.org/doi/10.1145/360336.360345
[aim-058]: https://dspace.mit.edu/handle/1721.1/6080

Assumes core storage is at a premium, disk accesses expensive (if
paging out objects), but computation is relatively cheap. Oriented
towards systems that page out objects.

Also points out that it might be useful to send the generated events
to another processor that, if it has access to main memory, could also
do the GC.

#### Refcount System

Structure:
- Reference counts are not stored with the objs themselves.
- Two hash tables, keyed by pointer value:
  - MRT (multireference table): ref count, only for ref count ≥2.
  - ZCT (zero count table): objs ref'd only from stack or not at all.
- Track only 1. allocation, 2. creation of a pointer to an obj, and 3.
  desctruction of a pointer to an obj.
- Above events go to a transaction file which is later (at GC time)
  played back to update in-core info.

Procedures:
- Allocate: add entry to ZCT
- Create pointer:
  - If immediately following allocate for that obj, ignore.
  - If obj in ZCT, remove it.
  - If in MRT, increment MRT count (if not at max).
  - If not in MRT, enter in MRT with count=2.
- Destroy pointer:
  - If in MRT, remove if count=2, else decrement count.
  - If not in MRT, enter in ZCT.

Once tables have been updated, reclaim entries that are in ZCT and not
referenced by stack. This can be done by creating a VRT (variable
reference table) of all pointers referenced from the stack and then
scanning the ZCT, freeing all objects not in the VRT.

Freeing an object requires decrementing ref counts of objects to which
it points. Skip transaction log for this, since tables are in memory
anyway. New entries created in the ZCT due to this must be checked
against the VRT.

Optimizations:
- For the current log block in memory, immediately drop an adjacent
  allocate-create sequence. Non-adjacent can be easily detected by
  maintaining a hash index of the in-memory blocks of the transaction
  log.

### Tracing Collection

Needed to find unreferenced circular structures. Run infrequently.
Main function is compaction and reorganization to produce more linear
lists, as opposed to dynamic reclamation of abandoned data above.

Uses algorithm similar to Minsky's above; see paper for details. Also
provides for incremental linearization (of only part of the heap).
