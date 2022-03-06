# CH0K0T0FF

Portable and easy build tool for your libs and dependencies


## Global picture

We rely on the widespread `make` tool to handle the different dependencies.
Each lib's recipe is defined in the `lib.mak` file.

First, you can use the `tar-list.sh` file to obtain the different tars
For each cluster, you have to create an `cluster.arch` file.
If you need to specify the version you want. Failing to specify a version implies that the lib will not be built

You should **always** submit a job to build the libraries as the compute nodes are usually different from the login nodes.
Simply submit in the queue a file like:

```bash
CLUSTER=cluster make all
```


## Usage

```bash
# get the list of modules to load
CLUSTER=cluster make module

# get the general information about what is going to happen
CLUSTER=cluster make info

# get the needed tar
CLUSTER=cluster make tar

# submit the job and install everything
CLUSTER=cluster make submit
# or just install everything
CLUSTER=cluster make install
```

### add your architecture

Each `cluster` has a corresponding `make_arch/cluster.arch` file.
In this file you should to specify

**general parameters**:

- `FC`, `CC`, and `CXX` as the non-mpi compilers to use
- `BUILD_DIR` the location where the temporary (and unique) build directory will be created
- `TAR_DIR` where the find the tar, obtained using `tar-list.sh`
- `PREFIX` where the libs will be installed

**module information**:

To centralize the module information, use the definition of the variable `MODULE_LIST`:

```makefile
define MODULE_LIST
module-name-1 \
module-name-2
endef
```

Nothing will be done with that information expect displaying it to the user if requested by `make module`

**Library dependent parameters**

For each library you must specify the 
- `UCX_VER` - ucx
- `OFI_VER` - ofi/libfabric
- `OMPI_VER` - openmpi
- `HDF5_VER` - hdf5
- `FFTW_VER` - fftw
- `OBLAS_VER` - openblas
- `P4EST_VER` - p4est


**OpenMPI specificities**

OpenMPI relies on other libs to handle the actual implementation over the network (`ofi` and/or `ucx`), and other part of the implemenation (`pmix` etc)
If you choose to use another version of those libs (i.e. not installed through this makefile) you must declare variables to indicate where to find the lib

- `OMPI_UCX_DEP` will be `--with-ucx=no` unless you specify it otherwise
- `OMPI_OFI_DEP` will be `--with-ofi=no` unless you specify it otherwise
- `OMPI_MISC_DEP` might be used to specify the use of `pmix`, `hwloc` etc.
