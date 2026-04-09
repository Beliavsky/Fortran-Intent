# fortran-intent

`fortran-intent` is a small static-analysis and source-rewrite tool for improving dummy-argument `INTENT` annotations in Fortran code.

It is designed to work conservatively:
- suggest missing `intent(in)`
- optionally suggest/apply `intent(out)`
- warn about dummy arguments still missing `intent` or `value`
- warn about declared `intent(out)` arguments that may be returned unset

This repository is intended as a focused snapshot of the tool. Active development may continue in a broader `pure-fortran` project, which may contain a newer or more advanced version.

## Main script

The main entry point is:

- `xintent.py`

It depends on a few lightweight support modules from the same project:

- `fortran_scan.py`
- `fortran_build.py`
- `cli_paths.py`

## What it does

The tool scans Fortran source files, finds procedures and dummy arguments, and uses conservative rules to infer likely argument intent.

Typical use cases:

- add `intent(in)` to dummies that are only read
- suggest `intent(out)` for dummies that are only written
- report procedures whose dummies still lack `intent`
- report `intent(out)` dummies that are not wholly assigned before return

The warnings for unset `intent(out)` dummies can include useful detail, for example:

- scalar dummy never set
- rank-1 array: `element 2 not set`
- rank-1 array: `only section 1:2 is definitely set; other elements may be unset`
- rank-2 array: `only column 1 may be set; other elements may be unset`
- rank-2 array: `whole array may be set conditionally`

## Examples

Suggest likely `intent(in)`:

```cmd
python xintent.py mycode.f90
```

Suggest likely `intent(in)` and `intent(out)`:

```cmd
python xintent.py mycode.f90 --suggest-intent-out
```

Apply safe edits in place:

```cmd
python xintent.py mycode.f90 --fix
```

Iterate until no more changes are found:

```cmd
python xintent.py mycode.f90 --fix --iterate
```

Warn about missing `intent`:

```cmd
python xintent.py mycode.f90 --warn-missing-intent
```

Warn about unset `intent(out)` variables:

```cmd
python xintent.py mycode.f90 --warn-unset-intent-out
```

Use conservative interprocedural call analysis:

```cmd
python xintent.py mycode.f90 --interproc
```

## Current warning style

Warnings are printed one variable per line. For example:

```text
Summary of 0 functions and 4 subroutines with declared intent(out) arguments not wholly set in 1 source file:
foo.f90 subroutine sub:a [only element 1 may be set; other elements may be unset]
foo.f90 subroutine sub:b [only section 1:2 is definitely set; other elements may be unset]
foo.f90 subroutine sub:y
foo.f90 subroutine sub:z [indices 2:3 not set]
```

## Limitations

The analysis is intentionally conservative and does not try to prove full program correctness.

Known limitations include:

- complex control flow is only partially modeled
- block `if` handling is conservative
- loop reasoning is limited
- multidimensional unset warnings are descriptive, not exhaustive
- aliasing through calls is only partly approximated
- vector subscripts and runtime-dependent bounds are difficult to characterize exactly

So warnings should be read as:

- “definitely safe” suggestions for simple `intent(in)` cases
- “likely” or “may be unset” diagnostics for more complex `intent(out)` cases

