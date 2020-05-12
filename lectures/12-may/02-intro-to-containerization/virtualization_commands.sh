### Commands from the Virtualization lecture of the Montreal BrainHack School are listed here

##### intro #####

git clone https://github.com/neurodatascience/course-materials-2020

cd course-materials-2020/lectures/12-may/02-intro-to-containerization

python fancy_DTI_analyzes.py


##### virtualization using venv #####


mkdir /path/to/galaxy 

mkdir /path/to/galaxy/tatooine 

mkdir /path/to/galaxy/tatooine/moisture_farm 

cd /path/to/galaxy/tatooine/moisture_farm 

python -m venv c3po

ls c3po 

source c3po/bin/activate

deactivate

mv path/to/fancy_DTI_analyzes.py /path/to/galaxy

source c3po/bin/activate

python ../../fancy_DTI_analyzes.py

which python

deactivate	

which python

echo $PATH

source c3po/bin/activate

echo $PATH

pip install dipy

pip freeze

pip freeze > requirements.txt

cat requirements.txt

python ../../fancy_DTI_analyzes.py

pip install fury

python ../../fancy_DTI_analyzes.py

pip install matplotlib

python ../../fancy_DTI_analyzes.py

ls

pip freeze > requirements.txt

cat requirements.txt


##### virtualization using conda #####


mkdir /path/to/galaxy/tatooine/mos_eisley

cd /path/to/galaxy/tatooine/mos_eisley

conda create -y -n r2d2  python=3.7 dipy matplotlib

ls

conda activate r2d2

conda info --envs

conda list

conda env export > r2d2.yml

python ../../fancy_DTI_analyzes.py

pip install fury

python ../../fancy_DTI_analyzes.py


##### Docker 101 - a new hope #####

docker

docker run hello-world

docker pull ubuntu

docker images

docker run ubuntu

docker run ubuntu echo “hello from within your container”

docker run -it ubuntu

ls

exit

docker ps

docker ps -a

docker run -it --rm ubuntu

docker run -it --rm ubuntu

mkdir defeat_unreproducibility_empire

mkdir /path/to/galaxy/hoth

docker run -it --rm -v /path/to/galaxy/hoth:/rebel_base ubuntu

touch /rebel_base/death_star_plans.png

exit

docker run -it --rm -v /path/to/galaxy/hoth:/rebel_base:ro ubuntu

rm /rebel_base/death_star_plans.png

exit

docker run -it --rm  \
-v /path/to/galaxy/hoth:/rebel_base:ro \
-v /path/to/galaxy/dagobah:/x-wing \
ubuntu

exit

docker run -it --rm \
-v /path/to/galaxy/:/rebel_base:ro
ubuntu

python /rebel_base/fancy_DTI_analyzes.py

exit


##### Docker 101 - The build strikes back #####


cd /path/to/galaxy/hoth

touch Dockerfile

FROM ubuntu

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
LC_ALL="en_US.UTF-8" \
ND_ENTRYPOINT="/docker/startup.sh"

docker build -t millennium_falcon .

docker images

RUN export ND_ENTRYPOINT="/docker/startup.sh" \
&& apt-get update -qq \
&& apt-get install -y -q --no-install-recommends \
       apt-utils bzip2 \   
       ca-certificates curl \
       git \
       locales nano unzip \


docker build -t millennium_falcon .

docker images

docker pull kaczmarj/neurodocker:0.4.3

docker run kaczmarj/neurodocker:0.4.3 \
generate docker --base=ubuntu \

docker run kaczmarj/neurodocker:0.4.3 \
generate docker --base=ubuntu \
--pkg-manager=apt --install git nano unzip

docker run kaczmarj/neurodocker:0.4.3 \
generate docker --base=ubuntu \
--pkg-manager=apt --install apt-utils bzip2 \
ca-certificates curl git locales nano unzip \
> Dockerfile

docker build -t millennium_falcon .

docker run kaczmarj/neurodocker:0.4.3 \
generate docker --base=ubuntu \
--pkg-manager=apt --install apt-utils bzip2 \
ca-certificates curl git locales nano unzip \
--miniconda conda_install="python=3.7 dipy" \
pip_install="fury" create_env="r2d2" activate=true \
> Dockerfile

docker build -t millennium_falcon .

docker run -it --rm \
-v /path/to/galaxy/:/rebel_base:ro\
millennium_falcon

python /rebel_base/fancy_DTI_analyzes.py

exit

docker run kaczmarj/neurodocker:0.4.3 \
generate docker --base=ubuntu \
--pkg-manager=apt --install apt-utils bzip2 \
ca-certificates curl git locales nano unzip libgl1-mesa-glx \
libsm6 \
--miniconda conda_install="python=3.7 dipy" \
pip_install="fury" create_env="r2d2" activate=true \
> Dockerfile

docker build -t millennium_falcon .

docker run -it --rm \
-v /path/to/galaxy/:/rebel_base:ro\
millennium_falcon

python /rebel_base/fancy_DTI_analyzes.py

exit

from xvfbwrapper import Xvfb
vdisplay = Xvfb(width=1920, height=1080)
vdisplay.start()

docker run kaczmarj/neurodocker:0.4.3 \
generate docker --base=ubuntu \
--pkg-manager=apt --install apt-utils bzip2 \
ca-certificates curl git locales nano unzip libgl1-mesa-glx \
libsm6 xvfb\
--miniconda conda_install="python=3.7 dipy" \
pip_install="fury xvfbwrapper" create_env="r2d2" activate=true \
> Dockerfile

docker build -t millennium_falcon .

docker run -it --rm \
-v /path/to/galaxy/:/rebel_base:ro\
millennium_falcon

python /rebel_base/fancy_DTI_analyzes.py

ls

docker tag millennium_falcon docker_id/millennium_falcon:kessel-run

docker images

docker push docker_id/millennium_falcon:kessel-run

docker images -a


##### Docker 101 - the return of advanced concepts #####


docker run -it --rm \
-v /path/to/galaxy/:/rebel_base:ro\
millennium_falcon python

exit()

exit

--add-to-entrypoint "python"

docker run kaczmarj/neurodocker:0.4.3 \
generate docker \
--base=ubuntu \
--pkg-manager=apt \
--install apt-utils bzip2 \
ca-certificates curl git locales nano unzip \
libgl1-mesa-glx libsm6 xvfb \
--miniconda conda_install="python=3.7 dipy" \
pip_install="fury xvfbwrapper" create_env="r2d2" \
activate=true \
--add-to-entrypoint "python" \
> Dockerfile

docker build -t millennium_falcon .

docker run -it --rm \
-v /path/to/galaxy/:/rebel_base:ro\
millennium_falcon

exit()

exit

docker run kaczmarj/neurodocker:0.4.3 \
generate docker \
--base=ubuntu \
--pkg-manager=apt \
--install apt-utils bzip2 \
ca-certificates curl git locales nano unzip \
libgl1-mesa-glx libsm6 xvfb \
--miniconda conda_install="python=3.7 dipy" \
pip_install="fury xvfbwrapper" create_env="r2d2" \
activate=true \
--add-to-entrypoint "python /rebel_base/ewoks_attack.py" \
> Dockerfile

docker build -t millennium_falcon .

docker run -it --rm \
-v /path/to/galaxy/fancy_DTI_analysis.py: \
/rebel_base/ewoks_attack.py:ro\
millennium_falcon