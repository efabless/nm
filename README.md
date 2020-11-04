# nm

# Prerequisites
[git-lfs](https://git-lfs.github.com/): You must download and install git-lfs from [here](https://git-lfs.github.com/), then set it up once per user account by running the following command:

```bash
git lfs install
```

# Setup instructions:
**To Be Filled**

# How to Run:
After cloning the repository and entering its directory, run the following:
```bash
export PDK_ROOT=<place where pdk resides>
export OpenLANE_ROOT=<place where openlane resides>
docker run -it -v $OpenLANE_ROOT:/openLANE_flow -v $(pwd):/project -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) openlane:rc4 
```
Once you're inside the docker, run the following commands:
```bash
cd /project/openlane 
make nm
```
