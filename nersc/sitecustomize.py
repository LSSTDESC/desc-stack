import os
if "DESC_STACK_KEEP_MPI" not in os.environ:
    if "SLURM_JOB_ID" not in os.environ:
        import sys
        sys.modules["mpi4py"] = None


